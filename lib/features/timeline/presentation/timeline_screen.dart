import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../data/timeline_repository.dart';
import '../domain/timeline_item.dart';
import '../../memories/domain/memory.dart';
import 'widgets/add_timeline_item_dialog.dart';

class TimelineScreen extends ConsumerWidget {
  final String memoryId;
  final Memory? memory; // Optional, passed for transition

  const TimelineScreen({super.key, required this.memoryId, this.memory});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineProvider(memoryId));

    return Scaffold(
      backgroundColor: const Color(
        0xFFFFFBF8,
      ), // Light beige background from design
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          memory?.title ?? 'Línea de Tiempo',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AddTimelineItemDialog(memoryId: memoryId),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: timelineAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                '¡Añade tu primer momento!',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return TimelineItemCard(
                item: item,
                isLast: index == items.length - 1,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class TimelineItemCard extends StatelessWidget {
  final TimelineItem item;
  final bool isLast;

  const TimelineItemCard({super.key, required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final date = item.date;
    final month = DateFormat('MMM').format(date).toUpperCase();
    final day = DateFormat('d').format(date);
    final year = DateFormat('yyyy').format(date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date Column
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  year,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 2,
                      color: isLast ? Colors.transparent : Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: item.imageUrl != null
                  ? _buildPhotoCard(context)
                  : _buildEventCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context) {
    // 1. Calculate time ago logic
    final diff = DateTime.now().difference(item.date);
    final days = diff.inDays.abs();

    String valueText;
    String labelText;

    if (days == 0) {
      valueText = 'Hoy';
      labelText = '';
    } else if (days <= 30) {
      valueText = '$days';
      labelText = 'días\natrás';
    } else {
      // Simple month approximation
      final months = (days / 30).floor();
      if (months < 12) {
        valueText = '$months';
        labelText = months == 1 ? 'mes\natrás' : 'meses\natrás';
      } else {
        final years = (days / 365).floor();
        valueText = '$years';
        labelText = years == 1 ? 'año\natrás' : 'años\natrás';
      }
    }

    // 2. Icon determination
    IconData iconData = Icons.flight; // Default
    switch (item.icon) {
      case 'restaurant':
        iconData = Icons.restaurant;
        break;
      case 'event':
        iconData = Icons.event;
        break;
      case 'favorite':
        iconData = Icons.favorite;
        break;
      case 'star':
        iconData = Icons.star;
        break;
      case 'home':
        iconData = Icons.home;
        break;
      case 'pets':
        iconData = Icons.pets;
        break;
      case 'cake':
        iconData = Icons.cake;
        break;
      default:
        iconData = Icons.flight;
    }

    // 3. Pastel Color
    const cardColor = Color(0xFFFFF5E6); // Soft Pastel Orange/Cream

    // 4. Primary Color for text
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                valueText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: primaryColor, // Using theme primary color (Orange)
                ),
              ),
              if (labelText.isNotEmpty)
                Text(
                  labelText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.8), // Lighter orange
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
