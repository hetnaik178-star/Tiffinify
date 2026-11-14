import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/menu_item_model.dart';

class CartLine {
  final MenuItemModel item;
  int qty;
  final Map<String, String> customization;
  final String specialRequest;
  final double extraPrice; // price delta (PDF §4.3)

  CartLine({required this.item, this.qty = 1, this.customization = const {},
            this.specialRequest = '', this.extraPrice = 0});

  double get unitTotal => item.basePrice + extraPrice;
}

class CartState {
  final List<CartLine> lines;
  const CartState({this.lines = const []});

  double get subtotal => lines.fold(0, (sum, l) => sum + l.unitTotal * l.qty);
  int get itemCount => lines.fold(0, (sum, l) => sum + l.qty);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void add(CartLine line) => state = CartState(lines: [...state.lines, line]);

  void removeAt(int i) {
    final l = [...state.lines]..removeAt(i);
    state = CartState(lines: l);
  }

  void setQty(int i, int qty) {
    if (qty <= 0) return removeAt(i);
    final l = [...state.lines];
    l[i] = CartLine(item: l[i].item, qty: qty, customization: l[i].customization,
        specialRequest: l[i].specialRequest, extraPrice: l[i].extraPrice);
    state = CartState(lines: l);
  }

  void clear() => state = const CartState();
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());