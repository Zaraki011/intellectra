import 'package:flutter/material.dart';
import '../../models/category.dart';
// import 'constants.dart';

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  final Categorie category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(category.img)),
          Text(
            category.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            category.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w200,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
