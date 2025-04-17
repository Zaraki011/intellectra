import 'package:flutter/material.dart';
import 'package:intellectra/views/course_details/screens/professor_courses_screen.dart';
import 'package:intellectra/views/splash_screen/splash_screen.dart';
import 'package:intellectra/views/profile/profile_screen.dart';
import 'package:intellectra/views/course/course_screen.dart';
import 'package:intellectra/views/wishlist/wishlist_screen.dart';
import 'package:intellectra/views/course/course_overview_screen.dart';
import 'package:intellectra/views/course_details/screens/courses_detail_page.dart';
import 'views/homescreen/home.dart';
import 'views/profile/faq/faq_screen.dart';
import 'package:intellectra/views/professor/professor_profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intellectra',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomeScreen(),
        '/professor':
            (context) => ProfessorCoursesScreen(
              professorId: ModalRoute.of(context)!.settings.arguments as int,
            ),
        '/professor_profile': (context) => ProfessorProfileScreen(),
        '/course': (context) => CourseScreen(),
        '/wishlist': (context) => WishlistScreen(),
        '/faq': (context) => const FAQScreen(),
        '/course_overview': (context) => const CourseOverviewScreen(),
        '/course_detail':
            (context) => CourseDetailPage(
              courseId: ModalRoute.of(context)!.settings.arguments as int,
            ),
      },
    );
  }
}

extension AppTheme on ThemeData {
  //light text color
  Color get lightTextColor =>
      brightness == Brightness.dark ? Colors.white70 : Colors.black54;

  //button color
  Color get buttonColor =>
      brightness == Brightness.dark ? Colors.cyan.withOpacity(.5) : Colors.blue;
}
