import '../models/menu_item_model.dart';
import '../models/festival_menu_model.dart';

/// Demo menu — Veg 🥦 / Non-Veg 🍗 / Jain 🙏 teeno me items
class MockData {
  static final List<MenuItemModel> todayMenu = [
    // ═══════════ BREAKFAST ═══════════
    MenuItemModel(id: 'b1', name: 'Poha Jalebi', category: 'breakfast', basePrice: 60,
        dietType: 'veg', emoji: '🥣', description: 'Indori poha + garam jalebi'),
    MenuItemModel(id: 'b2', name: 'Aloo Paratha (2)', category: 'breakfast', basePrice: 70,
        dietType: 'veg', emoji: '🫓', description: 'Dahi, achar aur makhan ke saath'),
    MenuItemModel(id: 'b5', name: 'Idli Sambhar (4)', category: 'breakfast', basePrice: 55,
        dietType: 'veg', emoji: '🍥', description: 'Chutney + sambhar ke saath'),
    MenuItemModel(id: 'b6', name: 'Puri Bhaji', category: 'breakfast', basePrice: 65,
        dietType: 'veg', emoji: '🥔', description: '3 puri + aloo bhaji'),
    MenuItemModel(id: 'b3', name: 'Egg Bhurji + Paratha', category: 'breakfast', basePrice: 85,
        dietType: 'nonveg', emoji: '🍳', description: 'Masaledar bhurji, 2 paratha + chai'),
    MenuItemModel(id: 'b7', name: 'Chicken Keema Pav', category: 'breakfast', basePrice: 95,
        dietType: 'nonveg', emoji: '🍖', description: 'Spicy keema, 2 pav ke saath'),
    MenuItemModel(id: 'b4', name: 'Jain Poha', category: 'breakfast', basePrice: 60,
        dietType: 'jain', emoji: '🥜', description: 'Bina pyaaz poha + sev, Jain style'),
    MenuItemModel(id: 'b8', name: 'Jain Sabudana Khichdi', category: 'breakfast', basePrice: 65,
        dietType: 'jain', emoji: '🌾', description: 'Vrati style, no onion-garlic'),

    // ═══════════ LUNCH ═══════════
    MenuItemModel(id: 'l1', name: 'Dal Tadka Thali', category: 'lunch', basePrice: 110,
        dietType: 'veg', emoji: '🍛', description: 'Dal, 3 roti, rice, sabzi, papad'),
    MenuItemModel(id: 'l2', name: 'Paneer Butter Masala', category: 'lunch', basePrice: 140,
        dietType: 'veg', emoji: '🥘', description: 'Makhani gravy + jeera rice + 2 roti'),
    MenuItemModel(id: 'l6', name: 'Rajma Chawal', category: 'lunch', basePrice: 100,
        dietType: 'veg', emoji: '🍲', description: 'Pahadi rajma, ghee rice ke saath'),
    MenuItemModel(id: 'l7', name: 'Dal Makhani + Naan', category: 'lunch', basePrice: 150,
        dietType: 'veg', emoji: '🧈', description: 'Slow-cooked dal makhani, 2 naan'),
    MenuItemModel(id: 'l8', name: 'Veg Biryani + Raita', category: 'lunch', basePrice: 130,
        dietType: 'veg', emoji: '🍚', description: 'Dum veg biryani + raita + salan'),
    MenuItemModel(id: 'l3', name: 'Butter Chicken + Naan', category: 'lunch', basePrice: 190,
        dietType: 'nonveg', emoji: '🍗', description: 'Creamy butter chicken, 2 butter naan'),
    MenuItemModel(id: 'l4', name: 'Chicken Biryani', category: 'lunch', basePrice: 170,
        dietType: 'nonveg', emoji: '🍛', description: 'Hyderabadi dum biryani + raita'),
    MenuItemModel(id: 'l9', name: 'Mutton Curry + Roti', category: 'lunch', basePrice: 220,
        dietType: 'nonveg', emoji: '🥩', description: 'Home-style mutton curry, 3 roti'),
    MenuItemModel(id: 'l10', name: 'Fish Curry + Rice', category: 'lunch', basePrice: 200,
        dietType: 'nonveg', emoji: '🐟', description: 'Tangy fish curry, steamed rice'),
    MenuItemModel(id: 'l5', name: 'Jain Dal Fry + Roti', category: 'lunch', basePrice: 105,
        dietType: 'jain', emoji: '🙏', description: 'Bina pyaaz-lehsun dal, 3 phulka'),
    MenuItemModel(id: 'l11', name: 'Jain Paneer Butter Masala', category: 'lunch', basePrice: 145,
        dietType: 'jain', emoji: '🧀', description: 'No onion-garlic makhani paneer'),
    MenuItemModel(id: 'l12', name: 'Jain Curd Rice', category: 'lunch', basePrice: 90,
        dietType: 'jain', emoji: '🍚', description: 'Dahi chawal + papad, Jain style'),

    // ═══════════ DINNER ═══════════
    MenuItemModel(id: 'd1', name: 'Bhindi Masala + Roti', category: 'dinner', basePrice: 105,
        dietType: 'veg', emoji: '🥬', description: 'Kurkuri bhindi, 3 phulka'),
    MenuItemModel(id: 'd2', name: 'Chole Bhature', category: 'dinner', basePrice: 120,
        dietType: 'veg', emoji: '🫓', description: 'Amritsari chole, 2 bhature'),
    MenuItemModel(id: 'd5', name: 'Palak Paneer + Roti', category: 'dinner', basePrice: 140,
        dietType: 'veg', emoji: '🍃', description: 'Palak paneer, 3 phulka + salad'),
    MenuItemModel(id: 'd6', name: 'Mix Veg + Roti', category: 'dinner', basePrice: 110,
        dietType: 'veg', emoji: '🥗', description: 'Seasonal mix veg, 3 roti'),
    MenuItemModel(id: 'd3', name: 'Egg Curry + Rice', category: 'dinner', basePrice: 130,
        dietType: 'nonveg', emoji: '🥚', description: 'Anda curry, steamed rice + salad'),
    MenuItemModel(id: 'd7', name: 'Chicken Shawarma Roll', category: 'dinner', basePrice: 120,
        dietType: 'nonveg', emoji: '🌯', description: 'Grilled chicken roll + garlic mayo'),
    MenuItemModel(id: 'd8', name: 'Prawn Masala + Rice', category: 'dinner', basePrice: 230,
        dietType: 'nonveg', emoji: '🦐', description: 'Coastal prawn masala, rice'),
    MenuItemModel(id: 'd4', name: 'Jain Khichdi + Kadhi', category: 'dinner', basePrice: 95,
        dietType: 'jain', emoji: '🍲', description: 'Moong khichdi + kadhi, no onion-garlic'),
    MenuItemModel(id: 'd9', name: 'Jain Malai Kofta + Roti', category: 'dinner', basePrice: 140,
        dietType: 'jain', emoji: '🧆', description: 'Paneer kofta, creamy gravy, 3 roti'),
    MenuItemModel(id: 'd10', name: 'Jain Dal Baati', category: 'dinner', basePrice: 115,
        dietType: 'jain', emoji: '🫓', description: 'Dal + baati, Jain style, no onion'),
  ];

  static final List<FestivalMenuModel> festivalMenus = [
    FestivalMenuModel(id: 'f1', emoji: '🇮🇳', title: 'Independence Day Special Thali',
        description: 'Tricolor salad, chana dal, jeera rice, gulab jamun + sweet box',
        price: 199,
        availableFrom: DateTime(2026, 8, 13), availableTo: DateTime(2026, 8, 16, 23, 59)),
    FestivalMenuModel(id: 'f2', emoji: '🪢', title: 'Raksha Bandhan Mithai Box',
        description: 'Motichoor laddoo, kaju katli, dry fruits + rakhi',
        price: 349,
        availableFrom: DateTime(2026, 8, 25), availableTo: DateTime(2026, 8, 29, 23, 59)),
  ];
}