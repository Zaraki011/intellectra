import 'package:flutter/material.dart';

Widget bottomNavigation(BuildContext context) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Course',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Wishlist',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    onTap: (int index) {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/course');
          break;
        case 2:
          Navigator.pushNamed(context, '/wishlist');
          break;
        case 3:
          Navigator.pushNamed(context, '/profile');
          break;
      }
    },
  );
}