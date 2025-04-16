import 'package:flutter/material.dart';
import '../../models/quiz.dart'; // Corrected import path

class QuizInputComponent extends StatefulWidget {
  final Quiz? initialQuiz;
  final Function(Quiz) onQuizChanged;
  final VoidCallback onRemove; // Callback to remove this quiz instance
  final int quizIndex; // To display like "Quiz 1", "Quiz 2"

  const QuizInputComponent({
    super.key,
    this.initialQuiz,
    required this.onQuizChanged,
    required this.onRemove,
    required this.quizIndex,
  });

  @override
  _QuizInputComponentState createState() => _QuizInputComponentState();
}

class _QuizInputComponentState extends State<QuizInputComponent> {
  late TextEditingController _questionController;
  late List<TextEditingController> _answerControllers;
  int? _correctAnswerIndex;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(
      text: widget.initialQuiz?.question ?? '',
    );
    _answerControllers =
        widget.initialQuiz?.answers
            .map((answer) => TextEditingController(text: answer))
            .toList() ??
        [
          TextEditingController(), // Start with 2 empty answer fields
          TextEditingController(),
        ];
    _correctAnswerIndex = widget.initialQuiz?.correctAnswerIndex;

    // Add listeners to controllers to notify parent of changes
    _questionController.addListener(_notifyParent);
    for (var controller in _answerControllers) {
      controller.addListener(_notifyParent);
    }
  }

  @override
  void dispose() {
    _questionController.removeListener(_notifyParent);
    _questionController.dispose();
    for (var controller in _answerControllers) {
      controller.removeListener(_notifyParent);
      controller.dispose();
    }
    super.dispose();
  }

  void _notifyParent() {
    // Create a Quiz object from the current state and pass it up
    final answers = _answerControllers.map((c) => c.text.trim()).toList();
    // Basic validation: ensure question, answers, and index are valid
    if (_questionController.text.trim().isNotEmpty &&
        answers.length >= 2 &&
        answers.every((a) => a.isNotEmpty) &&
        _correctAnswerIndex != null &&
        _correctAnswerIndex! >= 0 &&
        _correctAnswerIndex! < answers.length) {
      final currentQuiz = Quiz(
        question: _questionController.text.trim(),
        answers: answers,
        correctAnswerIndex: _correctAnswerIndex!,
      );
      widget.onQuizChanged(currentQuiz);
    } else {
      // Optionally handle incomplete state, maybe pass null or a specific marker?
      // For now, we only call onQuizChanged when valid.
    }
  }

  void _addAnswerField() {
    setState(() {
      final newController = TextEditingController();
      newController.addListener(_notifyParent);
      _answerControllers.add(newController);
    });
    _notifyParent(); // Notify after adding
  }

  void _removeAnswerField(int index) {
    if (_answerControllers.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A quiz must have at least 2 answers.')),
      );
      return;
    }
    setState(() {
      // Adjust correct answer index if necessary
      if (_correctAnswerIndex == index) {
        _correctAnswerIndex = null; // Reset selection
      } else if (_correctAnswerIndex != null && _correctAnswerIndex! > index) {
        _correctAnswerIndex = _correctAnswerIndex! - 1;
      }
      // Remove listener and dispose controller before removing from list
      _answerControllers[index].removeListener(_notifyParent);
      _answerControllers[index].dispose();
      _answerControllers.removeAt(index);
    });
    _notifyParent(); // Notify after removing
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quiz ${widget.quizIndex + 1}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Remove Quiz',
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Question Field
            TextFormField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Please enter a question'
                          : null,
            ),
            const SizedBox(height: 16),
            // Answers Section
            Text(
              'Answers (Select correct one):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling within the list
              itemCount: _answerControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      // Radio button for correct answer selection
                      Radio<int?>(
                        value: index,
                        groupValue: _correctAnswerIndex,
                        onChanged: (int? value) {
                          setState(() {
                            _correctAnswerIndex = value;
                          });
                          _notifyParent(); // Notify parent about the change
                        },
                      ),
                      // Answer Text Field
                      Expanded(
                        child: TextFormField(
                          controller: _answerControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Answer ${index + 1}',
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please enter an answer'
                                      : null,
                        ),
                      ),
                      // Remove Answer Button
                      if (_answerControllers.length >
                          2) // Only show remove if more than 2 answers
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 20,
                          ),
                          tooltip: 'Remove Answer',
                          onPressed: () => _removeAnswerField(index),
                          visualDensity: VisualDensity.compact,
                        ),
                      if (_answerControllers.length <= 2)
                        const SizedBox(
                          width: 40,
                        ), // Placeholder to maintain alignment
                    ],
                  ),
                );
              },
            ),
            // Add Answer Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Answer'),
                onPressed: _addAnswerField,
              ),
            ),
            // Validation hint for correct answer selection
            if (_correctAnswerIndex ==
                null) // Show only if no answer is selected
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Please select the correct answer.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
