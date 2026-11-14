/// FCM stub (PDF §4.9). Production me:
///   await Firebase.initializeApp();
///   final token = await FirebaseMessaging.instance.getToken();
///   await ApiService().registerDevice(token!);
class NotificationService {
  Future<void> init() async {
    // firebase_messaging setup yahan aayega
  }
}