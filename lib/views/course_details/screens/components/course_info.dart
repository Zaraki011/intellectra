// lib/screens/course_detail/components/course_info.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellectra/views/course_details/models/course_models.dart';

class CourseInfo extends StatelessWidget {
  final Course course;

  const CourseInfo({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              course.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //const SizedBox(height: 10),
          //ClipRRect(
            //borderRadius: BorderRadius.circular(10),
            //child: Image.network(course.image ?? ''),
            //),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              course.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}