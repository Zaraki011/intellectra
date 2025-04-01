import 'package:flutter/material.dart';

Widget buildMenuItem(String title, Function onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      width: double.infinity,  // Prend toute la largeur
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[300],  // Couleur de fond gris clair
        borderRadius: BorderRadius.circular(10),  // Coins arrondis
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 18),
        ],
      ),
    ),
  );
}
