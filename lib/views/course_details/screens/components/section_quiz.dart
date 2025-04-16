import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Make sure these paths are correct for your project structure
import 'package:intellectra/components/constants.dart'; // Assuming you have this for primaryColor
import '../../models/course.dart';

class SectionQuiz extends StatefulWidget {
  final Course course; // The course data containing quizzes
  final VoidCallback onFinish; // Callback when the quiz/course is finished
  final PageController
  pageController; // Controller for the main PageView in CourseDetailPage

  const SectionQuiz({
    super.key,
    required this.course,
    required this.onFinish,
    required this.pageController,
  });

  @override
  _SectionQuizState createState() => _SectionQuizState();
}

class _SectionQuizState extends State<SectionQuiz> {
  int _currentQuestionIndex = 0; // Tracks the current question being displayed
  int _correctAnswers = 0; // Counter for correctly answered questions
  bool _showResultPage = false; // Flag to control showing the results view
  List<int?> _selectedAnswers =
      []; // Stores the selected answer index for each question (null if not answered)

  @override
  void initState() {
    super.initState();
    // Initialize the selectedAnswers list with nulls for each quiz question
    final totalQuestions = widget.course.quizzes.length;
    _selectedAnswers = List.generate(totalQuestions, (_) => null);
  }

  // Handles selecting an answer for the current question
  void _selectAnswer(int selectedIndex) {
    // Allow users to change their answer before moving to the next question
    final correct =
        widget.course.quizzes[_currentQuestionIndex].correctAnswerIndex;
    final previouslySelected = _selectedAnswers[_currentQuestionIndex];
    final wasCorrect =
        previouslySelected != null && previouslySelected == correct;
    final isCorrect = selectedIndex == correct;

    // Update state to reflect the new selection and potentially adjust the score
    setState(() {
      // If changing answer, adjust score accordingly
      if (previouslySelected != null && previouslySelected != selectedIndex) {
        if (wasCorrect && !isCorrect) {
          _correctAnswers--; // Was correct, now wrong
        }
        if (!wasCorrect && isCorrect) {
          _correctAnswers++; // Was wrong, now correct
        }
      } else if (previouslySelected == null && isCorrect) {
        // First time answering this question correctly
        _correctAnswers++;
      }
      // Store the newly selected answer index
      _selectedAnswers[_currentQuestionIndex] = selectedIndex;
    });
  }

  // Moves to the next question if available, otherwise shows results
  void _nextQuestion() {
    final totalQuestions = widget.course.quizzes.length;
    if (_currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // If it's the last question, show the results
      setState(() {
        _showResultPage = true;
      });
    }
  }

  // *** REMOVED _previousQuestion() as it's no longer needed ***

  // Navigates the main PageView back to the last content section
  void _previousSection() {
    widget.pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizzes = widget.course.quizzes;
    final totalQuestions = quizzes.length;

    // --- 1. Result Page View ---
    if (_showResultPage) {
      return _buildResultPage(totalQuestions);
    }

    // --- 2. No Quiz Available View ---
    if (totalQuestions == 0) {
      return _buildNoQuizPage();
    }

    // --- 3. Quiz Question View ---
    // Safety check for index bounds
    if (_currentQuestionIndex >= totalQuestions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_showResultPage) {
          setState(() => _showResultPage = true);
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    // Get current quiz data and answer state
    final quiz = quizzes[_currentQuestionIndex];
    final selectedIndex = _selectedAnswers[_currentQuestionIndex];
    final isAnswered = selectedIndex != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0), // Main padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- Top part: Question info and answers (Scrollable) ---
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Text
                  Text(
                    'Question ${_currentQuestionIndex + 1} of $totalQuestions',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Question Text
                  Text(
                    quiz.question,
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Answer Buttons
                  _buildAnswerButtons(quiz, selectedIndex, isAnswered),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // --- Bottom Navigation Row ---
          _buildNavigationButtons(totalQuestions, isAnswered),
        ],
      ),
    );
  }

  // Helper Widget: Builds the Answer Buttons
  Widget _buildAnswerButtons(quiz, int? selectedIndex, bool isAnswered) {
    // ... (This function remains exactly the same as the previous version) ...
    return Column(
      children: List.generate(quiz.answers.length, (i) {
        bool isCorrectAnswer = i == quiz.correctAnswerIndex;
        bool isSelected = i == selectedIndex;
        bool isSelectedWrong = isAnswered && isSelected && !isCorrectAnswer;

        // Determine button styling based on answer state
        Color buttonColor = Colors.white;
        Color textColor = Colors.black87;
        BorderSide borderSide = BorderSide(
          color: Colors.grey.shade300,
          width: 1.5,
        );
        Icon? trailingIcon;

        if (isAnswered) {
          if (isCorrectAnswer) {
            buttonColor = Colors.green.shade50;
            textColor = Colors.green.shade800;
            borderSide = BorderSide(color: Colors.green.shade400, width: 1.5);
            if (isSelected) {
              borderSide = BorderSide(color: Colors.green.shade600, width: 2.0);
              trailingIcon = Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: 20,
              );
            }
          } else if (isSelectedWrong) {
            buttonColor = Colors.red.shade50;
            textColor = Colors.red.shade800;
            borderSide = BorderSide(color: Colors.red.shade400, width: 2.0);
            trailingIcon = Icon(
              Icons.cancel,
              color: Colors.red.shade700,
              size: 20,
            );
          } else {
            // Other non-selected, non-correct answers after answering
            buttonColor = Colors.grey.shade100;
            textColor = Colors.black45;
            borderSide = BorderSide(color: Colors.grey.shade300, width: 1);
          }
        }

        return Container(
          width: double.infinity, // Make button take full width
          margin: const EdgeInsets.only(bottom: 12),
          child: OutlinedButton(
            onPressed: () => _selectAnswer(i),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              side: borderSide,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  // Ensure text wraps if needed
                  child: Text(
                    quiz.answers[i],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (trailingIcon != null) // Show icon if available
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: trailingIcon,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Helper Widget: Builds the Bottom Navigation Buttons (SIMPLIFIED)
  Widget _buildNavigationButtons(int totalQuestions, bool isAnswered) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Pushes buttons apart
        children: [
          // --- Previous Button Logic (SIMPLIFIED) ---
          // Show button ONLY on the first question (index 0)
          if (_currentQuestionIndex == 0)
            _buildNavButton(
              label: 'Previous Section',
              iconData: Icons.arrow_back_ios,
              onPressed: _previousSection, // Navigate main PageView
              isLeading: true,
            )
          else
            // On ALL other questions (index >= 1), show an empty space
            // This keeps the "Next" button aligned to the right.
            const SizedBox(
              width: 120,
            ), // Adjust width to balance visually or use Spacer()
          // --- Next / Show Result Button Logic (Unchanged) ---
          if (_currentQuestionIndex < totalQuestions - 1)
            // Not the last question: Show "Next" button
            _buildNavButton(
              label: 'Next',
              iconData: Icons.arrow_forward_ios,
              onPressed:
                  isAnswered ? _nextQuestion : null, // Enabled only if answered
              isLeading: false,
            )
          else
            // Last question: Show "Show Result" button
            ElevatedButton(
              onPressed:
                  isAnswered
                      ? () => setState(() {
                        _showResultPage = true;
                      })
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Show Result"),
            ),
        ],
      ),
    );
  }

  // Helper Widget: Builds common TextButton structure for navigation
  Widget _buildNavButton({
    required String label,
    required IconData iconData,
    required VoidCallback? onPressed,
    required bool
    isLeading, // True if it's a 'previous' button, false for 'next'
  }) {
    // ... (This function remains exactly the same as the previous version) ...
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: onPressed != null ? primaryColor : Colors.grey,
        size: 18,
      ),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: onPressed != null ? primaryColor : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ), // Consistent padding
      ),
    );
  }

  // Helper Widget: Builds the Result Page View
  Widget _buildResultPage(int totalQuestions) {
    // ... (This function remains exactly the same as the previous version) ...
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Quiz Results',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          // Score Percentage
          Text(
            totalQuestions > 0
                ? '${((_correctAnswers / totalQuestions) * 100).toStringAsFixed(1)}%'
                : 'N/A', // Handle case with no questions
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 15),
          // Score Summary Text
          Text(
            'You answered $_correctAnswers out of $totalQuestions questions correctly.',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          // Finish Button
          ElevatedButton.icon(
            onPressed:
                widget.onFinish, // Trigger the callback passed from parent
            icon: const Icon(Icons.check_circle_outline),
            label: const Text("Finish Course"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Builds the View for when no quizzes are available
  Widget _buildNoQuizPage() {
    // ... (This function remains exactly the same as the previous version) ...
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              "No quizzes available for this course.",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: widget.onFinish, // Still allow finishing
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text("Finish Course"),
            ),
          ],
        ),
      ),
    );
  }
}
