import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/primary_button.dart';
import '../order_status/order_tracking_screen.dart';

import '../../widgets/payment_modal.dart';

/// PDF §4.5 — cart + cutoff + add-ons
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    if (cart.lines.isEmpty) {
      return const EmptyState(
        emoji: '🍽️', title: 'Cart khali hai!',
        subtitle: 'Menu se apna pasandida khana customize karke add karo.',
      );
    }

    final deliveryFee = cart.subtotal >= 300 ? 0 : 25;
    final total = cart.subtotal + deliveryFee;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text('Your Cart', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 16),

        ...List.generate(cart.lines.length, (i) {
          final l = cart.lines[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(l.item.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.item.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Wrap(spacing: 5, runSpacing: 4, children: [
                    ...l.customization.entries.map((e) => _chip(_label(e.key, e.value))),
                    if (l.specialRequest.isNotEmpty) _chip('📝 ${l.specialRequest}'),
                  ]),
                ])),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.masala),
                  onPressed: () => ref.read(cartProvider.notifier).removeAt(i)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text(Helpers.price(l.unitTotal * l.qty),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
                const Spacer(),
                GestureDetector(
                  onTap: () => ref.read(cartProvider.notifier).setQty(i, l.qty - 1),
                  child: _qtyBtn(Icons.remove_rounded)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('${l.qty}', style: const TextStyle(fontWeight: FontWeight.w800))),
                GestureDetector(
                  onTap: () => ref.read(cartProvider.notifier).setQty(i, l.qty + 1),
                  child: _qtyBtn(Icons.add_rounded)),
              ]),
            ]),
          );
        }),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line)),
          child: Column(children: [
            _billRow('Item total', Helpers.price(cart.subtotal)),
            const SizedBox(height: 8),
            _billRow('Delivery fee', deliveryFee == 0 ? 'FREE 🎉' : Helpers.price(deliveryFee)),
            const Divider(height: 22),
            _billRow('To pay', Helpers.price(total), big: true),
          ]),
        ),
        const SizedBox(height: 20),

        PrimaryButton(
          label: 'Place order — ${Helpers.price(total)}',
          icon: Icons.two_wheeler_rounded,
          onTap: () => _placeOrder(context, ref, cart, total),
        ),
      ],
    );
  }

  String _label(String k, String v) {
    switch (k) {
      case 'spice': return '🌶️ ${v[0].toUpperCase()}${v.substring(1)}';
      case 'oil': return '🫗 ${v[0].toUpperCase()}${v.substring(1)} oil';
      case 'no_onion_garlic': return '🚫 No onion-garlic';
      case 'no_sugar': return '🍬 No sugar';
      case 'extra_roti': return '🫓 +$v roti';
      default: return '$k: $v';
    }
  }

  Widget _chip(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
        decoration: BoxDecoration(color: AppColors.cream,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: AppColors.line)),
        child: Text(t, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
      );

  Widget _qtyBtn(IconData i) => Container(
        width: 30, height: 30,
        decoration: BoxDecoration(color: AppColors.cream,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.line, width: 1.5)),
        child: Icon(i, size: 16, color: AppColors.masala));

  Widget _billRow(String k, String v, {bool big = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: TextStyle(fontWeight: big ? FontWeight.w800 : FontWeight.w500,
              fontSize: big ? 16 : 13.5, color: big ? AppColors.ink : AppColors.ink60)),
          Text(v, style: TextStyle(fontWeight: FontWeight.w800, fontSize: big ? 18 : 13.5)),
        ],
      );

  Future<void> _placeOrder(BuildContext context, WidgetRef ref,
      CartState cart, double total) async {
    final user = ref.read(authProvider).value;
    final payResult = await PaymentModal.show(
      context: context,
      amount: total,
      title: '${cart.lines.length} Food Items',
      walletBalance: user?.walletBalance ?? 120.0,
    );

    if (payResult == null || payResult['success'] != true) return;
    if (!context.mounted) return;

    showDialog(
      context: context, barrierDismissible: false,
      builder: (_) => const Center(child: Card(
        child: Padding(padding: EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(color: AppColors.masala),
            SizedBox(height: 14),
            Text('Order place ho raha hai…'),
          ])),
      )),
    );

    final repo = OrderRepository(ref.read(apiProvider));
    final order = await repo.placeOrder(
      cart.lines.map((l) => OrderItemModel(
          menuItemId: l.item.id, name: l.item.name, emoji: l.item.emoji,
          quantity: l.qty, customization: l.customization,
          specialRequest: l.specialRequest, unitPrice: l.unitTotal)).toList(),
      total,
    );

    ref.read(cartProvider.notifier).clear();
    if (!context.mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Payment via ${payResult['method']} successful! 🎉 ID: ${payResult['paymentId']}'),
    ));
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)));
  }
}