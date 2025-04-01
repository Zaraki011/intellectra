import 'package:flutter/material.dart';
import '../components/constants.dart';

Widget bottomNavigation(BuildContext context, int currentIndex, dynamic arg) {
  return BottomNavigationBar(
    currentIndex: currentIndex, // Définit l'onglet actif
    showSelectedLabels: true,
    showUnselectedLabels: true,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book_rounded),
        label: 'Course',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bookmark_rounded),
        label: 'Wishlist',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_rounded),
        label: 'Profile',
      ),
    ],
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    onTap: (int index) {
      if (index != currentIndex) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home', arguments: arg);
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/course', arguments: arg);
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/wishlist', arguments: arg);
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile', arguments: arg);
            break;
        }
      }
    },
  );
}
