import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intellectra/components/bottom_navigation.dart';
import 'package:intellectra/components/constants.dart';
import 'package:intellectra/components/menu_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> userData;

  Future<Map<String, dynamic>> fetchUserData(int num) async {
    final response = await http.get(
      Uri.parse('https://127.0.0.1:8000/users/$num/'),
    ); //API dyal user

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de chargement des données');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final int userId = ModalRoute.of(context)!.settings.arguments as int;
      setState(() {
        userData = fetchUserData(userId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigation(context),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Aucune donnée trouvée"));
          }

          final userData = snapshot.data!;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
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
                          //Edit profile Screen
                          Navigator.pushNamed(context, '/edit-profile');
                        },
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          userData['avatar'] != null
                              ? CachedNetworkImageProvider(userData['avatar'])
                              : const AssetImage('assets/images/avatar.png')
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['username'] ?? 'Username Inconnu',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData['email'] ?? 'Email Inconnu',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    buildMenuItem('Mes courses', () {}),
                    buildMenuItem('Certificate', () {}),
                    buildMenuItem('Data repport', () {}),
                    buildMenuItem('FAQ', () {}),
                    buildMenuItem('Email support', () {}),
                    buildMenuItem('About us', () {}),
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
