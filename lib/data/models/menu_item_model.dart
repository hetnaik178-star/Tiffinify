class MenuItemModel {
  final String id, name, category, emoji, description, imageUrl, availableDate;

  /// 'veg' | 'nonveg' | 'jain'  ← diet filter isi se chalega
  final String dietType;
  final double basePrice;

  MenuItemModel({required this.id, required this.name, required this.category,
                 required this.basePrice, this.dietType = 'veg', this.emoji = '🍛',
                 this.description = '', this.imageUrl = '', this.availableDate = ''});

  bool get isVeg => dietType != 'nonveg';

  factory MenuItemModel.fromJson(Map<String, dynamic> j) => MenuItemModel(
        id: j['id'].toString(), name: j['name'], category: j['category'],
        basePrice: (j['base_price'] as num).toDouble(),
        dietType: j['diet_type'] ?? ((j['is_veg'] == false) ? 'nonveg' : 'veg'),
        emoji: j['emoji'] ?? '🍛', description: j['description'] ?? '',
        imageUrl: j['image_url'] ?? '', availableDate: j['available_date'] ?? '');

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'category': category,
        'base_price': basePrice, 'diet_type': dietType, 'is_veg': isVeg,
        'emoji': emoji, 'description': description, 'image_url': imageUrl,
        'available_date': availableDate};
}