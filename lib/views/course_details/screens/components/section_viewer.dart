// lib/screens/course_detail/components/section_viewer.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellectra/components/constants.dart';
// import 'package:intellectra/views/course/models/course_models.dart'; // Remove old import
import '../../models/course.dart'; // Add correct import

class SectionViewer extends StatelessWidget {
  final Course course;
  final int currentIndex;
  final PageController pageController;
  final Function(int) onPageChanged;

  const SectionViewer({
    super.key,
    required this.course,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Add a null check before accessing sections
    final section =
        course.pdfInternalData?.sections != null &&
                course.pdfInternalData!.sections.length > currentIndex
            ? course.pdfInternalData!.sections[currentIndex]
            : null; // Handle case where section might not exist (though logic should prevent this)

    if (section == null) {
      // Handle the case where the section is unexpectedly null
      return Center(child: Text("Error: Section data not found."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            section.title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: primaryColor, // Use your primary color
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10), // Space before content
          // Section Content
          Text(
            section.content,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
