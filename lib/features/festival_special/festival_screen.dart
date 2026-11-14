import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/menu_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../../widgets/countdown_timer.dart';

/// PDF §4.6 — limited-time festival menus + pre-order window
class FestivalScreen extends ConsumerWidget {
  const FestivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivals = ref.watch(festivalMenuProvider);

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text('Festival Specials 🎊', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 4),
        Text('Limited-time menus — pehle pre-order karo, pehle pao!',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),

        festivals.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (list) => Column(children: list.map((f) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF7A1E12), AppColors.masalaDk],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.masala.withOpacity(0.25),
                    blurRadius: 16, offset: const Offset(0, 6))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(f.emoji, style: const TextStyle(fontSize: 44)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(f.title, style: const TextStyle(color: Colors.white,
                        fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(f.description, maxLines: 2,
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                  ])),
                ]),
                const SizedBox(height: 14),
                Row(children: [
                  const Text('⏳ Window closes in  ', style: TextStyle(
                      color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
                  CountdownTimer(target: f.availableTo),
                ]),
                const SizedBox(height: 14),
                Row(children: [
                  Text(Helpers.price(f.price), style: const TextStyle(
                      color: AppColors.turmeric, fontSize: 22, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.turmeric,
                        foregroundColor: AppColors.ink),
                    onPressed: () {
                      ref.read(cartProvider.notifier).add(CartLine(
                            item: MenuItemModel(id: f.id, name: f.title,
                                category: 'festival', basePrice: f.price, emoji: f.emoji,
                                description: f.description)));
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${f.title} cart me add! 🎉')));
                    },
                    child: const Text('Pre-order'),
                  ),
                ]),
              ]),
            );
          }).toList()),
        ),
      ],
    );
  }
}