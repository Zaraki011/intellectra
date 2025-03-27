class Course {
  final int id;
  final String title;
  final String description;
  final String image;
  final String duration;
  final double rating;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.duration,
    required this.rating,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      duration: json['duration'],
      rating: json['rating'],
    );
  }
}
