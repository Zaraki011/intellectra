import 'package:flutter/material.dart';
import 'package:intellectra/views/splash_screen/splash_screen.dart';
import 'package:intellectra/views/profile/profile_screen.dart';
import 'views/professor/main_prof_screen.dart';
import 'views/homescreen/home.dart';
import 'views/profile/faq/faq_screen.dart';

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
        '/professor': (context) => PofessorScreen(),
        '/faq': (context) => const FAQScreen(),
      },
    );
  }
}