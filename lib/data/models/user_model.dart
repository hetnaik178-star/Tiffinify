class UserModel {
  final String id, name, phone, email, dietaryPref, photoUrl;
  final Map<String, dynamic> address;
  final double walletBalance;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.dietaryPref = 'veg',
    this.photoUrl = '',
    this.address = const {},
    this.walletBalance = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: j['id']?.toString() ?? '',
        name: j['name'] ?? '',
        phone: j['phone'] ?? '',
        email: j['email'] ?? '',
        dietaryPref: j['dietary_pref'] ?? 'veg',
        photoUrl: j['photo_url'] ?? '',
        address: Map<String, dynamic>.from(j['address_json'] ?? {}),
        walletBalance: (j['wallet_balance'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'dietary_pref': dietaryPref,
        'photo_url': photoUrl,
        'address_json': address,
        'wallet_balance': walletBalance,
      };
}