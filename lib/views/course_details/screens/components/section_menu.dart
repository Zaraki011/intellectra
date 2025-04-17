// lib/screens/course_detail/components/section_menu.dart
import 'package:flutter/material.dart';
// import 'package:intellectra/views/course/models/course_models.dart'; // Remove old import
import '../../models/course.dart'; // Add correct import
import 'package:intellectra/components/constants.dart'; // Assuming you use this for primaryColor

class SectionMenu {
  static void show(
    BuildContext context,
    Course course,
    int currentVisiblePageIndex, // Pass the current index of the PageView
    PageController pageController,
    Function(int)
    onPageSelected, // Callback accepting the target PageView index
  ) {
    // Use the sections list as the primary source for menu items
    final sections = course.pdfInternalData!.sections;
    // Check if the course actually has quizzes
    final bool hasQuizzes = course.quizzes.isNotEmpty;

    // Total items in the menu = number of sections + 1 for Quiz (if it exists)
    final int totalMenuItems = sections.length + (hasQuizzes ? 1 : 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow modal to take more height if needed
      shape: const RoundedRectangleBorder(
        // Optional: Add rounded top corners
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          // Set a max height to prevent covering the whole screen
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Make column height adapt to content
            children: [
              // --- Menu Header ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Course Content', // Or course.title
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1), // Visual separator
              // --- Scrollable Menu Items ---
              Flexible(
                // Use Flexible + shrinkWrap for ListView in Column
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: totalMenuItems,
                  itemBuilder: (BuildContext context, int index) {
                    String title;
                    bool isSelected = (index == currentVisiblePageIndex);
                    int targetPageIndex = index;

                    if (index < sections.length) {
                      title = sections[index].title; // Section title
                    } else if (hasQuizzes) {
                      title = 'Quizzes'; // Title for the quiz section
                      targetPageIndex =
                          sections.length; // Set target to quiz page
                    } else {
                      return const SizedBox.shrink(); // Render nothing if index is unexpected
                    }

                    return ListTile(
                      title: Text(
                        title,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? primaryColor : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      selected: isSelected,
                      onTap: () {
                        pageController.animateToPage(
                          targetPageIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        onPageSelected(targetPageIndex);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
