class Course {
  final int id;
  final String title;
  final String professor;
  final String description;
  final String image;
  final String duration;
  final String category;
  final double rating;


  Course({
    required this.id,
    required this.title,
    required this.professor,
    required this.description,
    required this.image,
    required this.duration,
    required this.category,
    required this.rating,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      professor: json['professor'],
      description: json['description'],
      image: json['image'],
      duration: json['duration'],
      category: json['category'],
      rating: json['rating'],
    );
  }
}
