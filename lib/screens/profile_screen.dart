import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key}); // Added key parameter
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedSkinTone;
  List<String> selectedOccasions = [];
  String? selectedStyle;
  final List<String> skinTones = ['Fair', 'Light', 'Medium', 'Olive', 'Brown', 'Dark'];
  final List<String> occasions = ['Work', 'Party', 'Travel', 'Casual', 'Other'];
  final List<String> styles = ['Minimalist', 'Streetwear', 'Boho', 'Casual', 'Formal'];

  Future<void> _saveProfile() async {
    if (selectedSkinTone == null || selectedOccasions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select skin tone and at least one occasion')),
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

      await DatabaseService().saveUserProfile(
        userId: userId,
        skinTone: selectedSkinTone!,
        occasions: selectedOccasions,
        style: selectedStyle,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved!')),
        );
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
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Skin Tone',
                border: OutlineInputBorder(),
              ),
              value: selectedSkinTone,
              onChanged: (value) => setState(() => selectedSkinTone = value),
              items: skinTones
                  .map((tone) => DropdownMenuItem(value: tone, child: Text(tone)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Preferred Occasions', style: Theme.of(context).textTheme.titleMedium),
            ...occasions.map((occasion) => CheckboxListTile(
                  title: Text(occasion),
                  value: selectedOccasions.contains(occasion),
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        selectedOccasions.add(occasion);
                      } else {
                        selectedOccasions.remove(occasion);
                      }
                    });
                  },
                )),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Style (Optional)',
                border: OutlineInputBorder(),
              ),
              value: selectedStyle,
              onChanged: (value) => setState(() => selectedStyle = value),
              items: styles
                  .map((style) => DropdownMenuItem(value: style, child: Text(style)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}