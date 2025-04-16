import 'package:flutter/material.dart';
import 'dart:io'; // Needed for potential image file in add category
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../../models/category.dart';
import '../../services/api_service.dart'; // Assuming ApiService is here

class CategorySelectorComponent extends StatefulWidget {
  final Function(int?) onCategorySelected;
  final int? initialCategoryId; // Optional initial value
  // Add professorId if needed by createCategory API
  // final int professorId;

  const CategorySelectorComponent({
    super.key,
    required this.onCategorySelected,
    this.initialCategoryId,
    // required this.professorId,
  });

  @override
  _CategorySelectorComponentState createState() =>
      _CategorySelectorComponentState();
}

class _CategorySelectorComponentState extends State<CategorySelectorComponent> {
  final ApiService _apiService = ApiService(); // Instantiate your service
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = true;
  String? _error;
  File? _categoryImageFile; // Declare the variable here

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final categories = await _apiService.fetchCategories();
      setState(() {
        _categories = categories;
        // Find the initial category after fetching
        Category? initialSelection;
        if (widget.initialCategoryId != null) {
          try {
            initialSelection = _categories.firstWhere(
              (cat) => cat.id == widget.initialCategoryId,
            );
          } catch (e) {
            print(
              "Initial category ID ${widget.initialCategoryId} not found in fetched list.",
            );
            initialSelection =
                null; // Or handle as needed, maybe default to first?
          }
        }
        // Assign the found category (or null) to the state
        _selectedCategory = initialSelection;
        // Call the callback with the initial ID (or null)
        widget.onCategorySelected(_selectedCategory?.id);

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load categories: $e";
        _isLoading = false;
      });
    }
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder to manage state within the dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Category'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Category Name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    // --- Add Image Picker UI ---
                    Text(
                      "Category Image (Optional)",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.image_search),
                          label: const Text("Select Image"),
                          onPressed: () async {
                            try {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null &&
                                  result.files.single.path != null) {
                                // Update the state within the dialog
                                setDialogState(() {
                                  _categoryImageFile = File(
                                    result.files.single.path!,
                                  );
                                });
                              }
                            } catch (e) {
                              // print("Error picking category image: $e");
                              // Check mount status
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error picking image: $e'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _categoryImageFile != null
                                ? p.basename(_categoryImageFile!.path)
                                : 'No image selected',
                            style: TextStyle(
                              fontStyle:
                                  _categoryImageFile == null
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                              color:
                                  _categoryImageFile == null
                                      ? Colors.grey
                                      : null,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // -------------------------
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final description = descriptionController.text.trim();

                    if (name.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Name and description cannot be empty.',
                          ),
                        ),
                      );
                      return;
                    }
                    if (_categories.any(
                      (cat) =>
                          cat.categoryName.toLowerCase() == name.toLowerCase(),
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Category "$name" already exists.'),
                        ),
                      );
                      return;
                    }
                    try {
                      // Pass the image file to the API
                      final newCategory = await _apiService.createCategory(
                        name,
                        description,
                        imageFile: _categoryImageFile, // Pass the file
                      );
                      // Check mount status before using context
                      if (!mounted) return;
                      Navigator.pop(context); // Close dialog
                      _fetchCategories(); // Refresh list
                      setState(() {
                        // Update main widget state
                        _selectedCategory = newCategory;
                      });
                      widget.onCategorySelected(newCategory.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Category "${newCategory.categoryName}" created.',
                          ),
                        ),
                      );
                    } catch (e) {
                      // Check mount status before using context
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to create category: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red))
          else
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Category>(
                    value: _selectedCategory,
                    hint: const Text('Select a category'),
                    items:
                        _categories.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.categoryName),
                          );
                        }).toList(),
                    onChanged: (Category? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                      widget.onCategorySelected(newValue?.id);
                    },
                    validator:
                        (value) =>
                            value == null ? 'Please select a category' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add New Category',
                  onPressed: _showAddCategoryDialog,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
