import 'package:flutter/material.dart';
import 'package:grocery_trak_web/home.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';
import 'package:grocery_trak_web/screens/add_item.dart';
import 'package:grocery_trak_web/screens/profile.dart';
import 'package:grocery_trak_web/services/userItem_api_service.dart';
import 'package:grocery_trak_web/widgets/bottom_nav_bar.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({Key? key}) : super(key: key);

  @override
  _GroceryPageState createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  List<UserItemModel> _groceryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroceryItems();
  }

  Future<void> _loadGroceryItems() async {
    try {
      final items = await UserItemApiService.retrieveUserItems();
      setState(() {
        _groceryItems = items.where((item) => item.itemId != null).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading grocery items: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading grocery items: $e')),
      );
    }
  }

  Future<void> _refreshItems() async {
    setState(() {
      _isLoading = true;
    });
    await _loadGroceryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery'),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddItemPage()),
              ).then((_) => _refreshItems());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshItems,
              child: _groceryItems.isEmpty
                  ? const Center(
                      child: Text(
                        'No items in your grocery list',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _groceryItems.length,
                      itemBuilder: (context, index) {
                        final item = _groceryItems[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Text(
                              item.item.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                          title: Text(item.item.name),
                          subtitle: Text('${item.quantity} ${item.unit}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              if (item.itemId == null) return;
                              try {
                                await UserItemApiService.deleteUserItem(item.itemId!);
                                setState(() {
                                  _groceryItems.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item deleted successfully'),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting item: $e'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1, // Grocery is the second tab
        onItemTapped: (index) {
          // Handle navigation based on index
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage(title: 'GroceryTrak')),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }
} 