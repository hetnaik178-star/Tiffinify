import '../models/subscription_model.dart';
import '../services/api_service.dart';

class SubscriptionRepository {
  final ApiService _api;
  SubscriptionRepository(this._api);
  SubscriptionModel? active;

  Future<SubscriptionModel> subscribe(String planType, int mealsPerDay) async {
    active = await _api.createSubscription(planType: planType, mealsPerDay: mealsPerDay);
    return active!;
  }

  Future<void> pause(String id, bool pause) => _api.pauseSubscription(id, pause: pause);
  Future<void> skipDay(String id, String date) => _api.skipDay(id, date);
}