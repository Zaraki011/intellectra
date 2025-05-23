// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intellectra/providers/api/fetch_data_api.dart';
import 'package:intellectra/chatbot/screen/feature/chatbot_feature.dart';

import 'package:intellectra/components/carousel.dart';
import '../../components/category_card.dart';
import '../../components/course_card.dart';
import '../../components/bottom_navigation.dart';
import '../../models/course.dart';
import '../../components/constants.dart';
import 'package:intellectra/models/category.dart';
import 'package:intellectra/chatbot/helper/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String baseUrl = "http://127.0.0.1:8000/";

  late Future<List<Categorie>> _categoriesFuture;
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories(baseUrl);
    _coursesFuture = fetchCourses(baseUrl);
  }

  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.sizeOf(context);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigation(
        context,
        0,
        ModalRoute.of(context)!.settings.arguments as int,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/logo.png', height: 40),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotFeature()),
          );
        },
        backgroundColor: primaryColor,
        tooltip: 'Chat Assistant',
        child: const Icon(Icons.chat, color: Colors.white),
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
              future: _categoriesFuture,
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
                    return GestureDetector(
                      onTap: () {
                        // Naviguer vers l'écran de détail
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailCourseScreen(
                        //       courseId: courses[index].id,
                        //     ),
                        //   ),
                        // );
                      },
                      child: CategoryCard(category: categories[index]),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // Courses Section
            const Text(
              'Top Courses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            FutureBuilder<List<Course>>(
              future: _coursesFuture,
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
                      onTap: () {
                        // Naviguer vers l'écran de détail
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailCourseScreen(
                        //       courseId: courses[index].id,
                        //     ),
                        //   ),
                        // );
                      },
                      child: CourseCard(course: courses[index]),
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
