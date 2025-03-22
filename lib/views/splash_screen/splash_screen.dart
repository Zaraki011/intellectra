import 'dart:math';
import 'package:intellectra/views/login/login_screen.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:intellectra/components/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  navigateToHome(context) async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushAndRemoveUntil(
      context, 
      CupertinoPageRoute(builder: (context) => const LoginScreen()),
      (route) => false
    );
  }

  @override
  void initState() {
    super.initState();
    navigateToHome(context);
  }

  List welcomingText = [
    'Welcome to Intellectra',
    'Bienvenue sur Intellectra',
    'Bienvenido a Intellectra',
    'Willkommen bei Intellectra',
    'Benvenuto su Intellectra',
    'インテレクトラへようこそ',
    '인텔렉트라에 오신 것을 환영합니다',
    'مرحبًا بك في إنتلكترا',
    'Bem-vindo à Intellectra',
    'Piyali Intellectra',
    'Intellectra-man allin hamusqa kanki',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                welcomingText[Random().nextInt(welcomingText.length)],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: fontFamilies[Random().nextInt(fontFamilies.length)],
                ),
              ),
              const SizedBox(height: 8),
              Image.asset('assets/images/logo.png', width: 400, height: 100),
              const SizedBox(height: 20),
              LottieBuilder.asset(
                "assets/images/Animation.json",
                height: 80,
                repeat: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}