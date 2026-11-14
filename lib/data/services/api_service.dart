import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../models/menu_item_model.dart';
import '../models/festival_menu_model.dart';
import '../models/subscription_model.dart';
import '../models/order_model.dart';
import 'mock_data.dart';

class ApiService {
  /// 🔧 Backend ready → [mockMode] = false karo. Tab tak demo data se chalta hai.
  static const bool mockMode = true;

  final Dio _dio = DioClient.dio;

  Future<T> _delay<T>(T value, [int ms = 500]) =>
      Future.delayed(Duration(milliseconds: ms), () => value);

  // ── AUTH (POST /auth/otp/send, /auth/otp/verify) ──
  Future<void> sendOtp(String phone) async {
    if (mockMode) return _delay(null);
    await _dio.post(ApiConstants.sendOtp, data: {'phone': phone});
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    if (mockMode) {
      return _delay({
        'token': 'mock-jwt-token',
        'user': {'id': '1', 'name': '', 'phone': phone,   // ⭐ name khali
                 'dietary_pref': 'veg', 'wallet_balance': 120,
                 'address_json': {'home': '42, Gandhi Nagar, Jaipur'}},
      });
    }
    final r = await _dio.post(ApiConstants.verifyOtp, data: {'phone': phone, 'otp': otp});
    return Map<String, dynamic>.from(r.data);
  }

  // ── MENU (GET /menu/today, /menu/festival) ──
  Future<List<MenuItemModel>> getTodayMenu() async {
    if (mockMode) return _delay(MockData.todayMenu, 700);
    final r = await _dio.get(ApiConstants.menuToday);
    return (r.data as List).map((e) => MenuItemModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<FestivalMenuModel>> getFestivalMenus() async {
    if (mockMode) return _delay(MockData.festivalMenus, 600);
    final r = await _dio.get(ApiConstants.menuFestival);
    return (r.data as List).map((e) => FestivalMenuModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // ── SUBSCRIPTION (POST /subscriptions, PATCH pause, skip-a-day) ──
  Future<SubscriptionModel> createSubscription({required String planType, required int mealsPerDay}) async {
    if (mockMode) {
      final now = DateTime.now();
      return _delay(SubscriptionModel(
          id: 'SUB${now.millisecondsSinceEpoch}', userId: '1', planType: planType,
          mealsPerDay: mealsPerDay, startDate: now,
          endDate: now.add(Duration(days: planType == 'weekly' ? 7 : 30))), 900);
    }
    final r = await _dio.post(ApiConstants.subscriptions,
        data: {'plan_type': planType, 'meals_per_day': mealsPerDay});
    return SubscriptionModel.fromJson(Map<String, dynamic>.from(r.data));
  }

  Future<void> pauseSubscription(String id, {required bool pause}) async {
    if (mockMode) return _delay(null, 600);
    await _dio.patch('${ApiConstants.subscriptions}/$id/${pause ? 'pause' : 'resume'}');
  }

  /// PDF §4.2 — skip-a-day (refund wallet me jata hai)
  Future<void> skipDay(String subscriptionId, String date) async {
    if (mockMode) return _delay(null, 500);
    await _dio.post('${ApiConstants.subscriptions}/$subscriptionId/skip', data: {'date': date});
  }

  // ── ORDERS (POST /orders, PATCH /orders/:id/customize) ──
  Future<OrderModel> placeOrder(List<OrderItemModel> items, double total) async {
    if (mockMode) {
      return _delay(OrderModel(
          id: 'ORD${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
          userId: '1', status: 'Placed',
          deliveryDate: DateTime.now().toIso8601String().split('T').first,
          totalAmount: total, items: items), 1000);
    }
    final r = await _dio.post(ApiConstants.orders,
        data: {'items': items.map((i) => i.toJson()).toList()});
    return OrderModel.fromJson(Map<String, dynamic>.from(r.data));
  }

  Future<void> customizeOrder(String orderId, List<OrderItemModel> items) async {
    if (mockMode) return _delay(null, 500);
    await _dio.patch('${ApiConstants.orders}/$orderId/customize',
        data: {'items': items.map((i) => i.toJson()).toList()});
  }

  // ── CUSTOMIZATION TEMPLATE (GET/POST /users/me/customization-template) ──
  Future<Map<String, String>> getCustomizationTemplate() async {
    if (mockMode) return _delay({'spice': 'medium', 'oil': 'normal'}, 400);
    final r = await _dio.get(ApiConstants.custTemplate);
    return Map<String, String>.from(r.data);
  }

  Future<void> saveCustomizationTemplate(Map<String, String> template) async {
    if (mockMode) return _delay(null, 400);
    await _dio.post(ApiConstants.custTemplate, data: template);
  }

  // ── PAYMENTS (POST /payments/create-order) ──
  Future<Map<String, dynamic>> createPaymentOrder({required double amount, String? orderId, String? subscriptionId}) async {
    if (mockMode) return _delay({'order_id': 'pay_mock_1', 'amount': amount});
    final r = await _dio.post(ApiConstants.paymentCreate,
        data: {'amount': amount, 'order_id': orderId, 'subscription_id': subscriptionId});
    return Map<String, dynamic>.from(r.data);
  }

  // ── NOTIFICATIONS (POST /notifications/register-device) ──
  Future<void> registerDevice(String fcmToken) async {
    if (mockMode) return _delay(null, 300);
    await _dio.post(ApiConstants.registerDevice,
        data: {'token': fcmToken, 'platform': 'android'});
  }
}