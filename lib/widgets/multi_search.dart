import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';
import 'package:grocery_trak_web/services/userItem_api_service.dart';

class MultiSelectSearchBar extends StatefulWidget {
  final Function(String) onSelectionDone;
  const MultiSelectSearchBar({Key? key, required this.onSelectionDone}) : super(key: key);

  @override
  _MultiSelectSearchBarState createState() => _MultiSelectSearchBarState();
}

class _MultiSelectSearchBarState extends State<MultiSelectSearchBar> {
  List<String> options = [];
  List<String> selectedOptions = [];
  bool isLoading = true;
  List<UserItemModel> detectedItems = UserItemApiService.sessionDetectedItems;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  // Call the API to retrieve options.
  Future<void> _loadOptions() async {
    try {
      List<UserItemModel> response = await UserItemApiService.retrieveUserItems();
      // Convert each item's model into a string like "ItemName (id)"
      List<String> items = response
          .map((r) => '${r.item.name} (${r.itemId})')
          .toList();

      // Prepare a set of detected item IDs for this session
      Set<int> detectedIds = UserItemApiService.sessionDetectedItems
          .map((item) => item.itemId)
          .toSet();

      // Find all options whose itemId is in the detected set
      List<String> autoSelected = response
          .where((r) => detectedIds.contains(r.itemId))
          .map((r) => '${r.item.name} (${r.itemId})')
          .toList();

      setState(() {
        options = items;
        selectedOptions = autoSelected;
        isLoading = false;
      });

      // Trigger selection callback with detected ingredients
      if (autoSelected.isNotEmpty) {
        List<String> ingredientIds = autoSelected.map((option) {
          final regex = RegExp(r'\((.*?)\)');
          final match = regex.firstMatch(option);
          return match != null ? match.group(1)!.trim() : '';
        }).where((id) => id.isNotEmpty).toList();

        String query = "&ingredients=" + ingredientIds.join(',');
        widget.onSelectionDone(query);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching options: $e");
    }
  }

  // Opens a dialog to let the user select multiple options.
  void _openMultiSelectDialog() async {
    List<String> tempSelected = List.from(selectedOptions);

    final results = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Options"),
          content: SizedBox(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return ListView(
                  shrinkWrap: true,
                  children: options.map((option) {
                    final isSelected = tempSelected.contains(option);
                    return CheckboxListTile(
                      title: Text(option),
                      value: isSelected,
                      onChanged: (value) {
                        setStateDialog(() {
                          if (value == true) {
                            tempSelected.add(option);
                          } else {
                            tempSelected.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(tempSelected);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );

    if (results != null) {
      setState(() {
        selectedOptions = results;
      });
      // Extract ids from selected options (assuming each option is like "Name (id)")
      List<String> ingredientIds = selectedOptions.map((option) {
        final regex = RegExp(r'\((.*?)\)');
        final match = regex.firstMatch(option);
        return match != null ? match.group(1)!.trim() : '';
      }).where((id) => id.isNotEmpty).toList();
      String query = "&ingredients=" + ingredientIds.join(',');
      // Call the callback function passed from parent to update recipes.
      widget.onSelectionDone(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0,
        ),
      ]),
      child: TextField(
        readOnly: true,
        onTap: isLoading ? null : _openMultiSelectDialog,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
          hintText: isLoading
              ? 'Loading options...'
              : selectedOptions.isEmpty
                  ? 'Search Recipe'
                  : selectedOptions.join(', '),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
