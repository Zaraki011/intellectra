import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p; // For basename

class FilePickerComponent extends StatelessWidget {
  final String labelText;
  final FileType fileType;
  final List<String>? allowedExtensions;
  final Function(File?) onFileSelected;
  final File? selectedFile; // To display the selected file name

  const FilePickerComponent({
    super.key,
    required this.labelText,
    required this.onFileSelected,
    this.fileType = FileType.any,
    this.allowedExtensions,
    this.selectedFile,
  });

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        // Consider adding withData: false if you don't need the file bytes immediately
        // Especially for large files like videos
      );

      if (result != null && result.files.single.path != null) {
        onFileSelected(File(result.files.single.path!));
      } else {
        // User canceled the picker
        onFileSelected(null);
      }
    } catch (e) {
      // Handle potential errors during file picking
      print("Error picking file: $e");
      onFileSelected(null); // Indicate error or no selection
      // Optionally show a snackbar or dialog to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: Text('Choose File'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  selectedFile != null
                      ? p.basename(selectedFile!.path)
                      : 'No file selected',
                  style: TextStyle(
                    fontStyle:
                        selectedFile == null
                            ? FontStyle.italic
                            : FontStyle.normal,
                    color: selectedFile == null ? Colors.grey : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Optional: Add validation display if needed, e.g., using a FormField wrapper
          // or showing an error text below based on parent state.
        ],
      ),
    );
  }
}
