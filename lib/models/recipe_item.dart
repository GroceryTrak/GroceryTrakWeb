class ItemModel {
  final int id;
  final String name;
  final String description;

  ItemModel({
    required this.id, // id must remain required for consistency
    this.name = "Unknown Ingredient",
    this.description = "Unknown Description",
  });

  ItemModel copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int? ?? 0, // Provide default value if null
      name: json['name'] as String? ?? "Unknown Ingredient",
      description: json['description'] as String? ?? "Unknown Description",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
