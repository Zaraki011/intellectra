import 'package:flutter/material.dart';
import 'package:intellectra/models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            //Blast l'image
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(course.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              course.title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Expanded(
          //   child: Text(
          //     course.category,
          //     style: TextStyle(
          //       color: Colors.black54,
          //       fontSize: 10,
          //       fontWeight: FontWeight.w400,
          //     ),
          //     maxLines: 1,
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
          // Expanded(
          //   child: Text(
          //     course.prof,
          //     style: TextStyle(
          //       color: Colors.black54,
          //       fontSize: 10,
          //       fontWeight: FontWeight.w400,
          //     ),
          //     maxLines: 1,
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
          Row(
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.black54, size: 16),
                    Text(
                      course.duration,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(width: 10),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Text(
                      course.rating.toString(),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}