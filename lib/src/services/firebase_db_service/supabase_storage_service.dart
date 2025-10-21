
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseStorageService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> uploadAvatar(String uid, File file) async {
    final filePath = 'profile/$uid.jpg';

    try {
      final uploadResponse = await _client.storage
          .from('chat_media')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      print('Upload response: $uploadResponse');

      final publicUrl = _client.storage.from('chat_media').getPublicUrl(filePath);
      print('Public URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('Supabase upload error: $e');
      return null;
    }
  }





}
