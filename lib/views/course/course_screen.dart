import 'package:flutter/material.dart';
import 'package:intellectra/providers/api/fetch_data_api.dart';
import 'package:intellectra/models/course.dart';
import 'package:intellectra/components/bottom_navigation.dart';
import 'package:intellectra/components/course_card.dart';

import '../../components/constants.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  static const String baseUrl = "http://127.0.0.1:8000/";
  late Future<List<Course>> _coursesFuture;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _coursesFuture = fetchCourses(baseUrl);
  }

  Future<void> _loadUserId() async {
    // final prefs = await SharedPreferences.getInstance();
    setState(() {
      // _userId = ModalRoute.of(context)!.settings.arguments as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigation(context, 1, ModalRoute.of(context)!.settings.arguments as int),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Liste des cours',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Course>>(
          future: _coursesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final course = snapshot.data![index];
                  return CourseCard(course: course);
                },
              );
            } else {
              return const Center(child: Text('No courses available'));
            }
          },
        ),
      ),
    );
  }
}
