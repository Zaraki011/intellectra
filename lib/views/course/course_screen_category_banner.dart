import 'package:flutter/material.dart';
import 'package:intellectra/providers/api/fetch_data_api.dart';
import 'package:intellectra/models/category.dart';
import 'package:intellectra/components/category_card.dart';


final baseUrl = "http://127.0.0.1:8000/";
late Future<List<Categorie>> categories;

void initState() {
  categories = fetchCategories(baseUrl);
}

Widget categoryBanner({required Categorie category}) {
  return Container(
    margin: const EdgeInsets.only(right: 8.0),
    child: CategoryCard(category: category),
  );
}

Widget builder() {
  return FutureBuilder<List<Categorie>>(
    future: categories,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: snapshot.data!.map((category) {
              return categoryBanner(category: category);
            }).toList(),
          ),
        );
      } else {
        return Center(child: Text('No categories available'));
      }
    },
  );
}
