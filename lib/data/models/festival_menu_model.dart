class FestivalMenuModel {
  final String id, title, description, emoji;
  final double price;
  final DateTime availableFrom, availableTo;
  final bool isActive;

  FestivalMenuModel({required this.id, required this.title, required this.description,
                     required this.price, required this.availableFrom,
                     required this.availableTo, this.isActive = true, this.emoji = '🎉'});

  factory FestivalMenuModel.fromJson(Map<String, dynamic> j) => FestivalMenuModel(
        id: j['id'].toString(), title: j['title'], description: j['description'],
        price: (j['price'] as num?)?.toDouble() ?? 199,
        availableFrom: DateTime.parse(j['available_from']),
        availableTo: DateTime.parse(j['available_to']),
        isActive: j['is_active'] ?? true, emoji: j['emoji'] ?? '🎉');
}