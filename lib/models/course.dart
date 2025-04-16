class Course {
  final int id;
  final String title;
  final String professor;
  final String description;
  final String image;
  final String duration;
  final String category;
  final double rating;
  final List<String> reviews;
  final String about;

  Course({
    required this.id,
    required this.title,
    required this.professor,
    required this.description,
    required this.image,
    required this.duration,
    required this.category,
    required this.rating,
    this.reviews = const [],
    this.about = '',
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
      rating: json['rating'].toDouble(),
      reviews:
          json['reviews'] != null ? List<String>.from(json['reviews']) : [],
      about: json['about'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'category': category,
      'description': description,
      'professor': professor,
      'duration': duration,
      'rating': rating,
      'reviews': reviews,
      'about': about,
      // 'sections': sections?.map((e) => e.toJson()).toList(),
      // 'tools': tools?.map((e) => e.toJson()).toList(),
    };
  }
}
