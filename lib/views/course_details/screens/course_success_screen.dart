import 'package:flutter/material.dart';
// Import the ProfessorCoursesScreen
import 'professor_courses_screen.dart';

class AddCourseSuccessScreen extends StatelessWidget {
  final int professorId;

  const AddCourseSuccessScreen({super.key, required this.professorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Hide back button as we will replace the navigation stack
        automaticallyImplyLeading: false,
        title: const Text('Success'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100.0,
              ),
              const SizedBox(height: 24.0),
              Text(
                'Course Created Successfully!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text('Finish'),
                onPressed: () {
                  // Navigate to ProfessorCoursesScreen, replacing the current stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ProfessorCoursesScreen(professorId: professorId),
                    ),
                    (Route<dynamic> route) => false, // Remove all routes below
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
