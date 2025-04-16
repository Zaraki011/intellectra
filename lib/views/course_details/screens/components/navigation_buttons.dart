import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellectra/components/constants.dart';

class NavigationButtons extends StatelessWidget {
  final int currentIndex;
  final int totalSections;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isFinished;

  const NavigationButtons({
    super.key,
    required this.currentIndex,
    required this.totalSections,
    required this.onNext,
    required this.onPrevious,
    required this.isFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentIndex > 0)
            TextButton(
              onPressed: onPrevious,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_ios, color: primaryColor),
                  Text(
                    'Previous',
                    style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox.shrink(),

          if (currentIndex < totalSections - 1)
            TextButton(
              onPressed: onNext,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next',
                    style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, color: primaryColor),
                ],
              ),
            )
          else
            ElevatedButton(
              onPressed: () {
                if (isFinished) {
                  // Handle course completion
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Congratulations!'),
                        content: Text('You have completed the course.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                              Navigator.of(
                                context,
                              ).pop(); // Go back to previous screen
                            },
                            child: Text('Finish'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please complete all quizzes before finishing the course.',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('Finish Course'), Icon(Icons.check_circle)],
              ),
            ),
        ],
      ),
    );
  }
}
