import 'package:flutter/material.dart';
import 'package:grocery_trak_web/models/recipe_item.dart';
import '../services/item_api_service.dart';

class ItemDetailsModel extends ChangeNotifier {
  ItemModel _item;
  bool isLoading = true;

  ItemDetailsModel({required ItemModel item}) : _item = item {
    print("Fetch Item");
    // Fetch updated details from the API as soon as the model is created.
    fetchDetails();
  }

  // Getters for the item properties.
  ItemModel get item => _item;
  int get id => _item.id;
  String get name => _item.name;
  String get description => _item.description;

  /// Fetches updated item details from the backend API.
  Future<void> fetchDetails() async {
    try {
      final updatedItem = await ItemApiService.fetchItemById(_item.id);

      // Use copyWith to update the current _item with the new values.
      _item = _item.copyWith(
        name: updatedItem.name,
        description: updatedItem.description,
      );
    } catch (e) {
      print("Error fetching item details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
