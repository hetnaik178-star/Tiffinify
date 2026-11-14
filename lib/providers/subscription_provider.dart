import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/subscription_model.dart';
import '../data/repositories/subscription_repository.dart';
import 'auth_provider.dart';

final subRepoProvider = Provider((ref) => SubscriptionRepository(ref.watch(apiProvider)));

class SubscriptionNotifier extends StateNotifier<AsyncValue<SubscriptionModel?>> {
  final SubscriptionRepository _repo;
  SubscriptionNotifier(this._repo) : super(const AsyncData(null));

  Future<SubscriptionModel> subscribe(String plan, int mealsPerDay) async {
    state = const AsyncLoading();
    final sub = await _repo.subscribe(plan, mealsPerDay);
    state = AsyncData(sub);
    return sub;
  }

  Future<void> togglePause() async {
    final cur = state.value;
    if (cur == null) return;
    final pausing = cur.status == 'active';
    await _repo.pause(cur.id, pausing);
    state = AsyncData(SubscriptionModel(
        id: cur.id, userId: cur.userId, planType: cur.planType,
        mealsPerDay: cur.mealsPerDay, startDate: cur.startDate,
        endDate: cur.endDate, status: pausing ? 'paused' : 'active'));
  }

  /// PDF §4.2 — skip-a-day
  Future<void> skipToday() async {
    final cur = state.value;
    if (cur == null) return;
    await _repo.skipDay(cur.id, DateTime.now().toIso8601String().split('T').first);
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<SubscriptionModel?>>(
        (ref) => SubscriptionNotifier(ref.watch(subRepoProvider)));