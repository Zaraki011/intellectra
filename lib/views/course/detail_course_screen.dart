import 'package:flutter/material.dart';

import 'package:intellectra/models/course.dart';
import '../../providers/api/fetch_data_api.dart';

class CourseDetailScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Future<Course> _futureCourse;
  final String apiUrl = "http://127.0.0.1:8000/";

  @override
  void initState() {
    super.initState();
    _futureCourse = fetchCourseById(apiUrl, widget.courseId);
  }

  // Placeholder function - replace with actual logic
  void subscribeToCourse() {
    // Implement course subscription logic here
    print('Subscribe button pressed for course ID: ${widget.courseId}');
    if (mounted) {
      // Check if widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscription feature not implemented yet.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: FutureBuilder<Course>(
        future: _futureCourse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    snapshot.data!.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Ensure snapshot.data!.reviews is not null and is iterable
                  ...snapshot.data!.reviews.map(
                    (review) => ListTile(
                      leading: const Icon(Icons.account_circle),
                      // Assuming review is a String, adjust if it's a Review object
                      title: Text(
                        review is String ? review : review.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(snapshot.data!.about),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.email),
                      label: const Text('Email Course'),
                      onPressed: subscribeToCourse, // Use the defined method
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
