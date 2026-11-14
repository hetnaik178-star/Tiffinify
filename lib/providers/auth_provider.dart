import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/api_service.dart';

final apiProvider = Provider((ref) => ApiService());
final authRepoProvider = Provider((ref) => AuthRepository(ref.watch(apiProvider)));

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repo;
  AuthNotifier(this._repo) : super(const AsyncData(null));

  UserModel? get user => state.value;

  Future<bool> sendOtp(String phone) async {
    await _repo.sendOtp(phone);
    return true;
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      state = const AsyncLoading();
      final user = await _repo.verifyOtp(phone, otp);
      state = AsyncData(user);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  /// ⭐ User ka naam update karta hai — profile me dikhega
  void setName(String name) {
    final cur = state.value;
    if (cur == null) return;
    state = AsyncData(UserModel(
        id: cur.id, name: name, phone: cur.phone, email: cur.email,
        dietaryPref: cur.dietaryPref, photoUrl: cur.photoUrl, address: cur.address,
        walletBalance: cur.walletBalance));
  }

  /// 🌐 Real Google Sign-In
  Future<UserModel?> signInWithGoogle() async {
    try {
      state = const AsyncLoading();
      final user = await _repo.signInWithGoogle();
      state = AsyncData(user);
      return user;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repo.signOut();
    state = const AsyncData(null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>(
    (ref) => AuthNotifier(ref.watch(authRepoProvider)));