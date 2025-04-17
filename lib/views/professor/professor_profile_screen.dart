import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intellectra/components/constants.dart';
import 'package:intellectra/components/menu_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessorProfileScreen extends StatefulWidget {
  const ProfessorProfileScreen({super.key});

  @override
  State<ProfessorProfileScreen> createState() => ProfessorProfileScreenState();
}

class ProfessorProfileScreenState extends State<ProfessorProfileScreen> {
  late Future<Map<String, dynamic>> professorData;

  Future<Map<String, dynamic>> fetchProfessorData(int professorId) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/professors/$professorId/'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load professor data');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final int professorId = ModalRoute.of(context)!.settings.arguments as int;
      setState(() {
        professorData = fetchProfessorData(professorId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Professor Profile"),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Profile tab selected
        onTap: (index) {
          final professorId = ModalRoute.of(context)!.settings.arguments as int;
          if (index == 0) {
            // Navigate to professor courses screen
            Navigator.pushReplacementNamed(
              context,
              '/professor',
              arguments: professorId,
            );
          }
          // If index is 1, we're already on the profile screen
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: professorData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          final professor = snapshot.data!;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          // Edit profile functionality
                        },
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          professor['avatar'] != null
                              ? CachedNetworkImageProvider(professor['avatar'])
                              : const AssetImage('assets/images/avatar.jpg')
                                  as ImageProvider,
                      onBackgroundImageError: (_, __) {
                        debugPrint(
                          'Error loading avatar: ${professor['avatar']}',
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      professor['username'] ?? 'Unknown Professor',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      professor['email'] ?? 'Unknown Email',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      professor['specialization'] ?? 'Teacher',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    buildMenuItem('My Courses', () {
                      final professorId =
                          ModalRoute.of(context)!.settings.arguments as int;
                      Navigator.pushReplacementNamed(
                        context,
                        '/professor',
                        arguments: professorId,
                      );
                    }),
                    buildMenuItem('Add New Course', () {
                      // Navigate to add course screen
                    }),
                    buildMenuItem('Course Analytics', () {
                      // Show course analytics
                    }),
                    buildMenuItem('Student Submissions', () {
                      // Show student submissions
                    }),
                    buildMenuItem('FAQ', () {
                      Navigator.pushNamed(context, '/faq');
                    }),
                    buildMenuItem('Email Support', () {
                      String? encodeQueryParameters(
                        Map<String, String> params,
                      ) {
                        return params.entries
                            .map(
                              (e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                            )
                            .join('&');
                      }

                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'support@intellectra.com',
                        query: encodeQueryParameters(<String, String>{
                          'subject': 'Professor Support Request',
                        }),
                      );

                      launchUrl(emailLaunchUri);
                    }),
                    buildMenuItem('About Us', () {
                      // Show about us page
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
