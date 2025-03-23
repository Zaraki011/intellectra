import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intellectra/components/constants.dart';
import 'package:intellectra/components/auth_build.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;

  Future<void> signUp() async {
    final url = Uri.parse('http://127.0.0.1:8000/users/api/register/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );
    if (response.statusCode == 201 && _acceptTerms && passwordController.text == confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred, please try again'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              'Create an account',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Let's help you set up your account, \nit's just a few steps away",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 60),
            buildTextField('Username', usernameController, false),
            const SizedBox(height: 20),
            buildTextField('Email', emailController, false),
            const SizedBox(height: 20),
            buildTextField('Password', passwordController, true),
            const SizedBox(height: 20),
            buildTextField('Confirm Password', confirmPasswordController, true),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  activeColor: accessColor,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                ),
                Text(
                  'Accept terms & conditions',
                  style: GoogleFonts.poppins(fontSize: 14, color: accessColor),
                ),
              ],
            ),
            const SizedBox(height: 50),
            buildButton('Sign Up', signUp),
          ],
        ),
      ),
    );
  }
}
