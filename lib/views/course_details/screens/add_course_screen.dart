import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

// Models
import '../models/quiz.dart';

// Services
import '../services/api_service.dart';

// Components
import 'components/text_field_component.dart';
import 'components/category_selector_component.dart';
import 'components/quiz_input_component.dart';
import 'components/course_form_buttons.dart'; // Import for primaryColor
import 'package:intellectra/components/auth_build.dart'; // Import for buildButton

// Import the success screen
import 'course_success_screen.dart';

class AddCourseScreen extends StatefulWidget {
  final int professorId; // <-- Replace with actual professor ID

  const AddCourseScreen({super.key, required this.professorId});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controllers for text fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _ratingController = TextEditingController();

  // State variables for selected files
  File? _pdfFile;
  File? _videoFile;
  File? _imageFile;

  // State variable for selected category ID
  int? _selectedCategoryId;

  // State variable for list of quizzes
  // Use a Map to easily update quizzes by index
  final Map<int, Quiz> _quizzesMap = {};
  int _nextQuizKey = 0; // To assign unique keys for adding/removing

  // State variables for loading and errors
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _addQuiz() {
    setState(() {
      // Add an empty placeholder; QuizInputComponent will handle the actual Quiz object creation
      // The key doesn't necessarily map 1:1 to the final list index
      _quizzesMap[_nextQuizKey] = Quiz(
        question: '',
        answers: ['', ''],
        correctAnswerIndex: 0,
      ); // Initial empty state
      _nextQuizKey++;
    });
  }

  void _removeQuiz(int key) {
    setState(() {
      _quizzesMap.remove(key);
    });
  }

  void _updateQuiz(int key, Quiz quiz) {
    // Update the quiz in the map
    // No setState needed here if QuizInputComponent handles its own state
    // and _submitForm reads directly from the map
    _quizzesMap[key] = quiz;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Additional validation for non-FormField widgets
      bool isQuizDataValid = true;
      if (_quizzesMap.isEmpty) {
        // Optional: require at least one quiz?
      } else {
        // Validate each quiz in the map
        for (var quiz in _quizzesMap.values) {
          if (quiz.question.isEmpty ||
              quiz.answers.length < 2 ||
              quiz.answers.any((a) => a.isEmpty) ||
              quiz.correctAnswerIndex < 0 ||
              quiz.correctAnswerIndex >= quiz.answers.length) {
            isQuizDataValid = false;
            break;
          }
        }
      }

      if (_selectedCategoryId == null) {
        setState(() {
          _errorMessage = 'Please select a category.';
        });
        return;
      }
      if (!isQuizDataValid) {
        setState(() {
          _errorMessage =
              'Please ensure all quiz fields are filled correctly and each quiz has a selected correct answer.';
        });
        return;
      }
      // At least one file (PDF or Video) should be selected
      if (_pdfFile == null && _videoFile == null) {
        setState(() {
          _errorMessage =
              'Please select either a PDF document or a Video file.';
        });
        return;
      }
      // Image is optional based on your model, but if required, add check here
      // if (_imageFile == null) {
      //     setState(() {
      //        _errorMessage = 'Please select a course image.';
      //     });
      //     return;
      // }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final List<Quiz> quizzesList = _quizzesMap.values.toList();
        final double initialRating =
            double.tryParse(_ratingController.text) ?? 0.0; // Parse rating

        final createdCourse = await _apiService.createCourse(
          _titleController.text,
          _descriptionController.text,
          _durationController.text,
          initialRating, // <-- Pass parsed rating
          _selectedCategoryId!, // We already validated it's not null
          widget.professorId, // Use the professorId from the widget
          quizzesList,
          pdfFile: _pdfFile,
          videoFile: _videoFile,
          imageFile: _imageFile,
        );

        setState(() {
          _isLoading = false;
        });

        // Navigate to the success screen, removing the AddCourseScreen from the stack
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    AddCourseSuccessScreen(professorId: widget.professorId),
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to create course: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Course',
          style: TextStyle(color: Colors.red), // Make AppBar title red
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // --- Basic Course Info ---
              TextFieldComponent(
                controller: _titleController,
                labelText: 'Course Title',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a title'
                            : null,
              ),
              TextFieldComponent(
                controller: _descriptionController,
                labelText: 'Description',
                maxLines: 4,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a description'
                            : null,
              ),
              TextFieldComponent(
                controller: _durationController,
                labelText: 'Duration (e.g., 2h 30m)',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter the duration'
                            : null,
              ),
              TextFieldComponent(
                controller: _ratingController,
                labelText: 'Initial Rating (0.0 - 5.0)',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an initial rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null) {
                    return 'Please enter a valid number';
                  }
                  if (rating < 0.0 || rating > 5.0) {
                    return 'Rating must be between 0.0 and 5.0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- File Pickers ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildCourseActionButton(
                            text: "Choose PDF",
                            icon: Icons.picture_as_pdf,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );
                              if (result != null &&
                                  result.files.single.path != null) {
                                setState(
                                  () =>
                                      _pdfFile = File(
                                        result.files.single.path!,
                                      ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _pdfFile != null
                                ? p.basename(_pdfFile!.path)
                                : 'No file selected',
                            style: TextStyle(
                              fontStyle:
                                  _pdfFile == null
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                              color: _pdfFile == null ? Colors.grey : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildCourseActionButton(
                            text: "Choose Video",
                            icon: Icons.video_collection,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.video);
                              if (result != null &&
                                  result.files.single.path != null) {
                                setState(
                                  () =>
                                      _videoFile = File(
                                        result.files.single.path!,
                                      ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _videoFile != null
                                ? p.basename(_videoFile!.path)
                                : 'No file selected',
                            style: TextStyle(
                              fontStyle:
                                  _videoFile == null
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                              color: _videoFile == null ? Colors.grey : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildCourseActionButton(
                            text: "Choose Image",
                            icon: Icons.image,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null &&
                                  result.files.single.path != null) {
                                setState(
                                  () =>
                                      _imageFile = File(
                                        result.files.single.path!,
                                      ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _imageFile != null
                                ? p.basename(_imageFile!.path)
                                : 'No file selected',
                            style: TextStyle(
                              fontStyle:
                                  _imageFile == null
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                              color: _imageFile == null ? Colors.grey : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Category Selector ---
              CategorySelectorComponent(
                onCategorySelected: (categoryId) {
                  // Need setState only if using the value directly in build,
                  // but it's good practice to keep state updated.
                  setState(() {
                    _selectedCategoryId = categoryId;
                  });
                },
                // initialCategoryId: null, // Set if editing
              ),
              const SizedBox(height: 24),

              // --- Quizzes Section ---
              Text(
                "Quizzes",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red, // Make title red
                ),
              ),
              const Divider(),
              if (_quizzesMap.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      "No quizzes added yet. Click 'Add Quiz' below.",
                    ),
                  ),
                ),
              ..._quizzesMap.entries.map((entry) {
                int key = entry.key;
                // Pass initialQuiz only if needed for editing, not for new ones
                // Quiz initialData = entry.value;
                return QuizInputComponent(
                  key: ValueKey(key), // Important for list state management
                  quizIndex: _quizzesMap.keys.toList().indexOf(
                    key,
                  ), // Display index
                  // initialQuiz: initialData, // Pass if supporting editing existing quiz
                  onQuizChanged: (quiz) => _updateQuiz(key, quiz),
                  onRemove: () => _removeQuiz(key),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: buildCourseActionButton(
                  text: "Add Quiz",
                  icon: Icons.add_circle_outline,
                  onPressed: _addQuiz,
                  minWidth: double.infinity,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
              ),

              const SizedBox(height: 32),
              // --- Submit Button (Use auth_build style) ---
              buildButton(
                'Create Course',
                _isLoading
                    ? () {}
                    : _submitForm, // Disable via empty function when loading
                // TODO: Maybe add a loading indicator inside buildButton?
              ),
            ],
          ),
        ),
      ),
    );
  }
}
