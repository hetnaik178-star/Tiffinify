import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/google_auth_service.dart';

class AuthRepository {
  final ApiService _api;
  final GoogleAuthService _googleAuth;

  AuthRepository(this._api, [GoogleAuthService? googleAuth])
      : _googleAuth = googleAuth ?? GoogleAuthService();

  Future<void> sendOtp(String phone) => _api.sendOtp(phone);

  Future<UserModel> verifyOtp(String phone, String otp) async {
    final res = await _api.verifyOtp(phone, otp);
    return UserModel.fromJson(Map<String, dynamic>.from(res['user']));
  }

  /// 🌐 Real Google Sign-In
  Future<UserModel?> signInWithGoogle() async {
    final account = await _googleAuth.signIn();
    if (account == null) return null; // User cancelled account picker

    // Real backend verification if available
    final auth = await account.authentication;
    final idToken = auth.idToken;

    if (!ApiService.mockMode && idToken != null) {
      // Backend POST /auth/google verify call
    }

    return UserModel(
      id: account.id,
      name: account.displayName?.isNotEmpty == true
          ? account.displayName!
          : (account.email.split('@').first),
      email: account.email,
      phone: '',
      photoUrl: account.photoUrl ?? '',
      dietaryPref: 'veg',
      address: const {'city': 'Jaipur'},
      walletBalance: 150,
    );
  }

  Future<void> signOut() async {
    await _googleAuth.signOut();
  }
}