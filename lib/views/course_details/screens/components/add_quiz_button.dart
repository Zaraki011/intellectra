import 'package:flutter/material.dart';

class AddQuizButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddQuizButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Add Quiz'),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48), // Make button wider
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
