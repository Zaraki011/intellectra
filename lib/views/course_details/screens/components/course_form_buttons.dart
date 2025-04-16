import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intellectra/components/constants.dart'; // Assuming primaryColor is here

// Reusable button for actions within the course form
Widget buildCourseActionButton({
  required String text,
  required IconData icon,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? foregroundColor,
  double? minWidth, // Optional minimum width
}) {
  return ElevatedButton.icon(
    icon: Icon(icon, size: 20), // Icon before text
    label: Text(
      text,
      style: GoogleFonts.poppins(
        // color: Colors.white, // Button foreground color is usually handled by theme
        fontSize: 15,
        fontWeight: FontWeight.w500, // Slightly less bold than auth button
      ),
    ),
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor:
          backgroundColor ??
          primaryColor.withOpacity(0.9), // Default or provided
      foregroundColor: foregroundColor ?? Colors.white, // Default or provided
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ), // Slightly less rounded
      elevation: 2,
      minimumSize:
          minWidth != null
              ? Size(minWidth, 36)
              : null, // Apply min width if provided
    ),
  );
}
