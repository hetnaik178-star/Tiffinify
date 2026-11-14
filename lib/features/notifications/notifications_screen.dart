import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: list.map((n) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: n.isRead ? Colors.white : const Color(0xFFFFF1E0),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.line)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (!n.isRead)
                Container(width: 8, height: 8,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  decoration: const BoxDecoration(color: AppColors.masala,
                      shape: BoxShape.circle)),
              Expanded(
                child: GestureDetector(
                  onTap: () => ref.read(notificationsProvider.notifier).markRead(n.id),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(n.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(n.body, style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                ),
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }
}