import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../services/database_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final picker = ImagePicker();
  String? selectedType, selectedColor, selectedSeason, selectedStyle, selectedOccasion;
  final List<String> types = ['Shirt', 'Jeans', 'Dress', 'Jacket', 'Other'];
  final List<String> colors = ['Red', 'Blue', 'Green', 'Black', 'White', 'Other'];
  final List<String> seasons = ['Summer', 'Winter', 'Spring', 'Fall'];
  final List<String> styles = ['Casual', 'Formal', 'Streetwear', 'Boho', 'Minimalist'];
  final List<String> occasions = ['Work', 'Party', 'Travel', 'Casual', 'Other'];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveClothingItem() async {
    if (_image == null ||
        selectedType == null ||
        selectedColor == null ||
        selectedSeason == null ||
        selectedStyle == null ||
        selectedOccasion == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')),
        );
      }
      return;
    }

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in')),
          );
        }
        return;
      }

      final imageUrl = await DatabaseService().uploadImage(_image!, userId);
      await DatabaseService().saveClothingItem(
        userId: userId,
        imageUrl: imageUrl,
        type: selectedType!,
        color: selectedColor!,
        season: selectedSeason!,
        style: selectedStyle!,
        occasion: selectedOccasion!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item saved!')),
        );
        setState(() {
          _image = null;
          selectedType = selectedColor = selectedSeason = selectedStyle = selectedOccasion = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Clothing'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _image == null
                    ? const Text('No image selected.', textAlign: TextAlign.center)
                    : Image.file(_image!, height: 200, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              value: selectedType,
              onChanged: (value) => setState(() => selectedType = value),
              items: types
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
              value: selectedColor,
              onChanged: (value) => setState(() => selectedColor = value),
              items: colors
                  .map((color) => DropdownMenuItem(value: color, child: Text(color)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Season',
                border: OutlineInputBorder(),
              ),
              value: selectedSeason,
              onChanged: (value) => setState(() => selectedSeason = value),
              items: seasons
                  .map((season) => DropdownMenuItem(value: season, child: Text(season)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Style',
                border: OutlineInputBorder(),
              ),
              value: selectedStyle,
              onChanged: (value) => setState(() => selectedStyle = value),
              items: styles
                  .map((style) => DropdownMenuItem(value: style, child: Text(style)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Occasion',
                border: OutlineInputBorder(),
              ),
              value: selectedOccasion,
              onChanged: (value) => setState(() => selectedOccasion = value),
              items: occasions
                  .map((occasion) => DropdownMenuItem(value: occasion, child: Text(occasion)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveClothingItem,
              child: const Text('Save Item'),
            ),
          ],
        ),
      ),
    );
  }
}