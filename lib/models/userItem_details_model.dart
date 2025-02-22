import 'package:flutter/material.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';
import 'package:grocery_trak_web/services/userItem_api_service.dart';

class UserItemDetailModel extends ChangeNotifier {
  UserItemModel _userItem;
  bool isLoading = true;

  UserItemDetailModel({required UserItemModel userItem})
      : _userItem = userItem {
    // Fetch updated details from the API as soon as the model is created.
    fetchDetails();
  }

  // Getters for the user item properties.
  UserItemModel get userItem => _userItem;
  int get userId => _userItem.userId;
  int get itemId => _userItem.itemId;
  int get quantity => _userItem.quantity;
  String get unit => _userItem.unit;

  // Getters for the nested item details.
  int get id => _userItem.item.id;
  String get name => _userItem.item.name;
  String get description => _userItem.item.description;

  /// Fetches updated user item details from the backend API.
  Future<void> fetchDetails() async {
    try {
      final updatedUserItem = await UserItemApiService.fetchUserItemById(_userItem.itemId);
      _userItem = updatedUserItem;
    } catch (e) {
      print("Error fetching user item details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Methods to update the user item details.
  void updateQuantity(int newQuantity) {
    _userItem = UserItemModel(
      userId: _userItem.userId,
      itemId: _userItem.itemId,
      item: _userItem.item,
      quantity: newQuantity,
      unit: _userItem.unit,
    );
    notifyListeners();
  }

  void updateUnit(String newUnit) {
    _userItem = UserItemModel(
      userId: _userItem.userId,
      itemId: _userItem.itemId,
      item: _userItem.item,
      quantity: _userItem.quantity,
      unit: newUnit,
    );
    notifyListeners();
  }

  /// Simulates saving changes to the backend or local storage.
  Future<void> saveChanges() async {
    await Future.delayed(const Duration(seconds: 1));
    // Here you could integrate an API call to persist changes.
    notifyListeners();
  }
}
