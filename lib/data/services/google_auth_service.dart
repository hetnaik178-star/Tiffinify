import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
    serverClientId: AppConstants.googleServerClientId.trim().isNotEmpty
        ? AppConstants.googleServerClientId.trim()
        : null,
  );

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google Sign-Out Error: $e');
    }
  }
}
