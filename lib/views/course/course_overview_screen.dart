import 'package:flutter/material.dart';
import 'package:intellectra/components/constants.dart';
import 'package:intellectra/models/course.dart';
import 'package:intellectra/components/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intellectra/providers/api/fetch_data_api.dart'; // Import the API functions

class CourseOverviewScreen extends StatefulWidget {
  const CourseOverviewScreen({super.key});

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  int? _userId;
  int? _courseId;
  late Future<Course> _courseFuture;
  static const String baseUrl = "http://127.0.0.1:8000/"; // Base URL for API

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the course ID from the route arguments
    _courseId = ModalRoute.of(context)!.settings.arguments as int;
    // Fetch the course details from the API
    _courseFuture = fetchCourseById(baseUrl, _courseId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Overview"), centerTitle: true),
      bottomNavigationBar:
          _userId == null ? null : bottomNavigation(context, 1, _userId!),
      backgroundColor: backgroundColor,
      body: FutureBuilder<Course>(
        future: _courseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Course not found.'));
          }

          final course = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course header
                Stack(
                  children: [
                    Image.network(
                      course.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                            ),
                          ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                course.professor,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                course.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Course details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course info
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "About This Course",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(course.description),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildInfoItem(
                                    Icons.category,
                                    course.category,
                                  ),
                                  _buildInfoItem(
                                    Icons.access_time,
                                    course.duration,
                                  ),
                                  _buildInfoItem(Icons.people, "24 Students"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Reviews section
                      const Text(
                        "Student Reviews",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      course.reviews.isEmpty
                          ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("No reviews yet for this course."),
                            ),
                          )
                          : Column(
                            children:
                                course.reviews.map((review) {
                                  // For now, assuming review is a String containing the review text
                                  // You might need to adjust depending on your actual API response
                                  return _buildReviewCard(
                                    "Student", // You may need to adjust this when you have user info
                                    course
                                        .rating, // Using the course rating as a placeholder
                                    review,
                                    "Recent", // Placeholder for time
                                  );
                                }).toList(),
                          ),

                      const SizedBox(height: 24),

                      // Start Course and Wishlist buttons
                      Row(
                        children: [
                          // Start Course button
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the detailed course screen
                                Navigator.pushNamed(
                                  context,
                                  '/course_detail',
                                  arguments: course.id,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: primaryColor,
                              ),
                              child: const Text(
                                "Start Course",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Wishlist button
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Add to wishlist functionality
                                final snackBar = SnackBar(
                                  content: const Text('Added to wishlist!'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'View',
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/wishlist');
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
                                // Here you would call your API to add the course to the user's wishlist
                                // For example: await addToWishlist(userId, course.id);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.white,
                                side: BorderSide(color: primaryColor),
                              ),
                              child: Icon(
                                Icons.bookmark_border,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildReviewCard(
    String name,
    double rating,
    String comment,
    String time,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.person, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
