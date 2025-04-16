import 'package:flutter/material.dart';
import 'package:intellectra/views/course_details/models/course.dart';

// Placeholder for fetching finished courses - replace with actual logic
Future<List<Course>> getFinishedCourses() async {
  // Example: Replace with API call or local data retrieval
  await Future.delayed(Duration(seconds: 1));
  // Return a dummy list for now using the correct constructor
  return [
    Course(
      id: 1,
      title: 'Completed Course 1',
      description: 'Description for course 1',
      duration: '2h',
      rating: 4.5,
      categoryId: 1, // Example category ID
      professorId: 10, // Example professor ID
      quizzes: [], // Example empty quizzes list
      image: 'assets/images/course_placeholder.png', // Example image path
    ),
    Course(
      id: 2,
      title: 'Completed Course 2',
      description: 'Description for course 2',
      duration: '3h 30m',
      rating: 4.0,
      categoryId: 2,
      professorId: 12,
      quizzes: [],
      image: 'assets/images/course_placeholder.png',
    ),
  ];
}

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  _CertificateScreenState createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  late Future<List<Course>> _finishedCoursesFuture;

  @override
  void initState() {
    super.initState();
    _finishedCoursesFuture = getFinishedCourses(); // Fetch courses on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(62, 158, 158, 158),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.chevron_left_outlined,
                color: Color(0xFF126E64),
              ),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF126E64)),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Certificate',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(62, 158, 158, 158),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.info_rounded, color: Color(0xFF126E64)),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: _finishedCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('You have not completed any courses yet!'),
            );
          }

          final finishedCourses = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.only(top: 12),
            itemCount: finishedCourses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final course = finishedCourses[index];
              return ListTile(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Navigate to detail for ${course.title}'),
                    ),
                  );
                },
                leading:
                    course.image != null && course.image!.isNotEmpty
                        ? Image.asset(
                          course.image!,
                          height: 100,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Icon(Icons.broken_image, size: 60),
                        )
                        : Icon(Icons.school, size: 60),
                title: Text(course.title),
                trailing: const Icon(Icons.chevron_right_outlined),
              );
            },
          );
        },
      ),
    );
  }
}
