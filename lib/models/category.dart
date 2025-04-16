class Categorie {
  final int? id;
  final String categoryImage;
  final String categoryName;
  final String description;

  Categorie({
    this.id,
    required this.categoryImage,
    required this.categoryName,
    required this.description,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      categoryImage: json['categoryImage'],
      categoryName: json['categoryName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    // Only include non-null fields needed for creation
    final Map<String, dynamic> data = {
      'categoryName': categoryName,
      'description': description,
    };
    return data;
  }
}
