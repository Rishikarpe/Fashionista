import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class DatabaseService {
  final SupabaseClient client = Supabase.instance.client;

  Future<String> uploadImage(File image, String userId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
    final path = '$userId/$fileName';
    await client.storage.from('clothing-images').upload(path, image);
    final imageUrl = client.storage.from('clothing-images').getPublicUrl(path);
    return imageUrl;
  }

  Future<void> saveClothingItem({
    required String userId,
    required String imageUrl,
    required String type,
    required String color,
    required String season,
    required String style,
    required String occasion,
  }) async {
    await client.from('clothing_items').insert({
      'user_id': userId,
      'image_url': imageUrl,
      'type': type,
      'color': color,
      'season': season,
      'style': style,
      'occasion': occasion,
    });
  }

  Future<void> saveUserProfile({
    required String userId,
    required String skinTone,
    required List<String> occasions,
    String? style,
  }) async {
    await client.from('users').upsert({
      'id': userId,
      'skin_tone': skinTone,
      'preferred_occasions': occasions,
      'preferred_style': style,
    });
  }

  Future<List<Map<String, dynamic>>> getClothingItems(String userId) async {
    final response = await client.from('clothing_items').select().eq('user_id', userId);
    return response;
  }
}