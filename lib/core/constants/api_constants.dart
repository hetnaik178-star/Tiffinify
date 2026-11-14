/// PDF §6 "Key API Endpoints" — exact mapping
class ApiConstants {
  static const String baseUrl = 'https://api.tiffinexpress.in/v1';
  static const String socketUrl = 'https://api.tiffinexpress.in';

  static const String sendOtp        = '/auth/otp/send';
  static const String verifyOtp      = '/auth/otp/verify';
  static const String menuToday      = '/menu/today';
  static const String menuFestival   = '/menu/festival';
  static const String subscriptions  = '/subscriptions';
  static const String orders         = '/orders';
  static const String paymentCreate  = '/payments/create-order';
  static const String paymentWebhook = '/payments/webhook';
  static const String custTemplate   = '/users/me/customization-template';
  static const String registerDevice = '/notifications/register-device';
}