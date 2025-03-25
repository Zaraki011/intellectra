import 'package:flutter/material.dart'; 

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  String img;
  String title;
  String description;

  CategoryCard({Key? key, required this.img, required this.title, required this.description}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(img),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w200,
              color: Colors.white54
            ),
          ),
        ],
      ),
    );
  }
}