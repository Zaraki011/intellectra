class Category {
  final int? id; // Nullable if fetched, not present when creating
  final String categoryName;
  final String description;
  final String? categoryImage; // Assuming image URL or path

  Category({
    this.id,
    required this.categoryName,
    required this.description,
    this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      categoryImage: json['categoryImage'],
    );
  }

  Map<String, dynamic> toJson() {
    // Only include non-null fields needed for creation
    final Map<String, dynamic> data = {
      'categoryName': categoryName,
      'description': description,
    };
    if (categoryImage != null) {
      // Assuming categoryImage path might be sent during creation,
      // but typically images are handled via multipart upload, not JSON.
      // Adjust based on your API's expectation for category creation with image.
      // For now, let's omit it from toJson for simplicity, assuming image upload
      // might be a separate step or handled differently.
      // data['categoryImage'] = categoryImage;
    }
    return data;
  }
}
