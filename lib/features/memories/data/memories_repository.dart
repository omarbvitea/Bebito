import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/memory.dart';

part 'memories_repository.g.dart';

@riverpod
MemoriesRepository memoriesRepository(MemoriesRepositoryRef ref) {
  return MemoriesRepository(Supabase.instance.client);
}

class MemoriesRepository {
  final SupabaseClient _client;
  MemoriesRepository(this._client);

  Stream<List<Memory>> watchMemories() {
    return _client
        .from('memories')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Memory.fromJson(json)).toList());
  }

  Future<void> createMemory(String title, File? coverImage) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    String? imageUrl;
    if (coverImage != null) {
      final bytes = await coverImage.readAsBytes();
      final fileExt = coverImage.path.split('.').last;
      final fileName = '${const Uuid().v4()}.$fileExt';
      final filePath = '$fileName';

      await _client.storage
          .from('memories')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      imageUrl = _client.storage.from('memories').getPublicUrl(filePath);
    }

    final memoryData = await _client
        .from('memories')
        .insert({'title': title, 'cover_image': imageUrl})
        .select()
        .single();

    // Link creator to memory
    await _client.from('memory_members').insert({
      'memory_id': memoryData['id'],
      'user_id': user.id,
      'role': 'owner',
    });
  }

  Future<void> deleteMemory(String id) async {
    await _client.from('memories').delete().eq('id', id);
  }
}

@riverpod
Stream<List<Memory>> memories(MemoriesRef ref) {
  return ref.watch(memoriesRepositoryProvider).watchMemories();
}
