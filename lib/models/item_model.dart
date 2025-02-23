class ItemModel {
  final int id;
  final String name;
  final String description;
  final String imageLink;

  ItemModel({
    required this.id, // id must remain required for consistency
    this.name = "Unknown Ingredient",
    this.description = "Unknown Description",
    this.imageLink = "",
  });

  ItemModel copyWith({
    int? id,
    String? name,
    String? description,
    String? imageLink,

  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageLink: imageLink ?? this.imageLink,
    );
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as int? ?? 0, // Provide default value if null
      name: json['name'] as String? ?? "Unknown Ingredient",
      description: json['description'] as String? ?? "Unknown Description",
      imageLink: json['image_link'] as String? ?? "",

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_link': imageLink,
    };
  }
}
