import 'api_service.dart';

/// Razorpay/Cashfree wrapper (PDF §2). Production me razorpay_flutter
/// uncomment karke key daalo: _razorpay.open({'key':'rzp_live_xxx', 'amount': amount*100})
class PaymentService {
  final ApiService _api = ApiService();

  Future<bool> pay({required double amount, required String description,
                    String? orderId, String? subscriptionId}) async {
    await _api.createPaymentOrder(amount: amount, orderId: orderId, subscriptionId: subscriptionId);
    if (ApiService.mockMode) {
      await Future.delayed(const Duration(milliseconds: 1200));
      return true; // simulated success
    }
    // TODO: Razorpay checkout open karo, result handle karo
    return false;
  }
}