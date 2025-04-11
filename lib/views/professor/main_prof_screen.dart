import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PofessorScreen extends StatefulWidget {
  const PofessorScreen({super.key});

  @override
  PofessorScreenState createState() => PofessorScreenState();
}

class PofessorScreenState extends State<PofessorScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  String? _selectedType = 'pdf';
  File? _pickedFile;
  File? _pickedImage;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() => _pickedFile = File(result.files.single.path!));
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _submitCourse() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/courses/api/add-course/'),
    );

    final String token = ModalRoute.of(context)!.settings.arguments as String;

    request.headers['Authorization'] = token; // Auth prof

    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['file_type'] = _selectedType!;
    request.fields['duration'] = _durationController.text; // ou via champ

    if (_pickedFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', _pickedFile!.path));
    }
    if (_pickedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _pickedImage!.path));
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cours ajouté !')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un cours')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Titre')),
          TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
          DropdownButton<String>(
            value: _selectedType,
            items: ['pdf', 'video'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) => setState(() => _selectedType = value),
          ),
          ElevatedButton(onPressed: _pickFile, child: Text('Choisir un fichier')),
          ElevatedButton(onPressed: _pickImage, child: Text('Choisir une image')),
          SizedBox(height: 16),
          ElevatedButton(onPressed: _submitCourse, child: Text('Ajouter le cours')),
        ]),
      ),
    );
  }
}
