class Categorie {
  final String img;
  final String title;
  final String description;

  Categorie({
    required this.img,
    required this.title,
    required this.description,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      img: json['categoryImage'],
      title: json['categoryName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryImage': img,
      'categoryName': title,
      'description': description,
    };
  }
  
}
