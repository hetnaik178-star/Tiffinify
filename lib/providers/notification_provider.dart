import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/notification_model.dart';

class NotificationsNotifier extends StateNotifier<List<AppNotificationModel>> {
  NotificationsNotifier() : super([
    AppNotificationModel(id: 'n1', title: '🎉 Festival menu live!',
        body: 'Independence Day Special Thali ab pre-order kar sakte ho.', type: 'festival'),
    AppNotificationModel(id: 'n2', title: '⏰ Cutoff reminder',
        body: 'Aaj ke lunch customization ka window 8 PM pe band hoga.',
        type: 'reminder', isRead: true),
  ]);

  void markRead(String id) {
    state = state.map((n) => n.id == id ? (n..isRead = true) : n).toList();
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotificationModel>>(
        (ref) => NotificationsNotifier());