import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/timeline_item.dart';

part 'timeline_repository.g.dart';

@riverpod
TimelineRepository timelineRepository(TimelineRepositoryRef ref) {
  return TimelineRepository(Supabase.instance.client);
}

@riverpod
Stream<List<TimelineItem>> timeline(TimelineRef ref, String memoryId) {
  return ref.watch(timelineRepositoryProvider).watchTimelineItems(memoryId);
}

class TimelineRepository {
  final SupabaseClient _client;
  TimelineRepository(this._client);

  Stream<List<TimelineItem>> watchTimelineItems(String memoryId) {
    return _client
        .from('timeline_items')
        .stream(primaryKey: ['id'])
        .eq('memory_id', memoryId)
        .order('date', ascending: true)
        .map(
          (data) => data.map((json) => TimelineItem.fromJson(json)).toList(),
        );
  }

  Future<void> addTimelineItem({
    required String memoryId,
    required DateTime date,
    required String title,
    String? description,
    File? image,
    String? icon,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    String? imageUrl;
    if (image != null) {
      final bytes = await image.readAsBytes();
      final fileExt = image.path.split('.').last;
      final fileName = 'timeline/${const Uuid().v4()}.$fileExt';

      await _client.storage
          .from('memories')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      imageUrl = _client.storage.from('memories').getPublicUrl(fileName);
    }

    await _client.from('timeline_items').insert({
      'memory_id': memoryId,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'icon': icon,
    });
  }

  Future<void> deleteTimelineItem(String id) async {
    await _client.from('timeline_items').delete().eq('id', id);
  }
}
