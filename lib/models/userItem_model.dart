import 'package:grocery_trak_web/models/item_model.dart';

class UserItemModel {
  final int userId;
  final int itemId;
  final ItemModel item;
  final int quantity;
  final String unit;

  UserItemModel({
    required this.userId,
    required this.itemId,
    required this.item,
    required this.quantity,
    required this.unit,
  });

  factory UserItemModel.fromJson(Map<String, dynamic> json) {
    return UserItemModel(
      userId: json['user_id'] as int,
      itemId: json['item_id'] as int,
      item: ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'item_id': itemId,
      'item': item.toJson(),
      'quantity': quantity,
      'unit': unit,
    };
  }
}
