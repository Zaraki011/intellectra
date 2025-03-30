import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intellectra/components/carousel.dart';
import '../../components/category_card.dart';
import '../../components/course_card.dart';
import '../../models/course.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String baseUrl = "http://127.0.0.1:8000/"; // Change to your API

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/courses/categories/"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load categories");
    }
  }

  Future<List<dynamic>> fetchCourses() async {
    final response = await http.get(Uri.parse("$baseUrl/courses/"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load courses");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Carousel(),
            const SizedBox(height: 8),

            // Categories Section
            const Text(
              'Explore Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            FutureBuilder<List<dynamic>>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final categories = snapshot.data!;
                return GridView.builder(
                  itemCount: categories.length >= 4 ? 4 : categories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      img: categories[index]['categoryImage'] ?? '',
                      title: categories[index]['categoryName'] ?? '',
                      description: categories[index]['description'] ?? '',
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // Courses Section
            const Text(
              'Top Course',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            FutureBuilder<List<dynamic>>(
              future: fetchCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final courses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courses.length >= 3 ? 3 : courses.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => DetailCourseScreen(
                      //         courseId: courses[index]['id'],
                      //       ),
                      //     ),
                      //   );
                      // },
                      child: CourseCard(
                        courseImage: courses[index]['courseImage'] ?? '',
                        courseName: courses[index]['courseName'] ?? '',
                        rating: (courses[index]['totalRating'] as num?)?.toDouble() ?? 0.0,
                        totalTime: courses[index]['totalTime'] ?? '-',
                        // totalVideo: courses[index]['totalVideo']?.toString() ?? '-',
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
