import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/course_card.dart';
import '../../models/wishlist/wishlist_viewmodel.dart';
import '../../models/course.dart';
import 'package:intellectra/views/course/detail_course_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    var wishlistProvider = Provider.of<WishlistViewModel>(context);
    List<Course>? wishlist = wishlistProvider.wishlishedCourse;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Wishlist Course',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wishlist?.length ?? 0,
        itemBuilder: (context, index) {
          final course = wishlist![index];

          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                wishlist.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${course.title} removed')),
              );
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CourseDetailScreen(courseId: course.id),
                  ),
                );
              },
              child: CourseCard(course: course),
            ),
          );
        },
      ),
    );
  }
}
