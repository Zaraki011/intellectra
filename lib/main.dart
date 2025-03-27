import 'package:flutter/material.dart';
import 'package:intellectra/views/splash_screen/splash_screen.dart';
import 'package:intellectra/views/profile/profile_screen.dart';

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
      },
    );
  }
}