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