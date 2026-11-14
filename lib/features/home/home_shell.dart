import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/notification_provider.dart';
import 'home_screen.dart';
import '../festival_special/festival_screen.dart';
import '../subscription/subscription_screen.dart';
import '../cart_checkout/cart_screen.dart';
import '../profile/profile_screen.dart';
import '../notifications/notifications_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _tab = 0;

  final _pages = const [
    HomeScreen(), FestivalScreen(), SubscriptionScreen(), CartScreen(), ProfileScreen(),
  ];

  final _tabs = const [
    (Icons.restaurant_menu_rounded, 'Menu'),
    (Icons.celebration_rounded, 'Festival'),
    (Icons.subscriptions_rounded, 'Plan'),
    (Icons.shopping_basket_rounded, 'Cart'),
    (Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartProvider).itemCount;
    final unread = ref.watch(notificationsProvider).where((n) => !n.isRead).length;

    return Scaffold(
      body: IndexedStack(index: _tab, children: _pages),
      appBar: AppBar(
        title: const Text('Tiffinify',
            style: TextStyle(color: AppColors.masala, fontWeight: FontWeight.w800)),
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, size: 26),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),
            if (unread > 0)
              Positioned(right: 8, top: 10,
                child: Container(width: 9, height: 9,
                  decoration: const BoxDecoration(color: AppColors.masala,
                      shape: BoxShape.circle))),
          ]),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.08),
              blurRadius: 16, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final active = _tab == i;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _tab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: active ? AppColors.masala : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_tabs[i].$1, size: 23,
                            color: active ? Colors.white : AppColors.ink60),
                        const SizedBox(height: 3),
                        Text(_tabs[i].$2,
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700,
                                color: active ? Colors.white : AppColors.ink60)),
                      ]),
                      if (i == 3 && cartCount > 0)
                        Positioned(top: 0, right: 14,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppColors.turmeric,
                                shape: BoxShape.circle),
                            child: Text('$cartCount', style: const TextStyle(
                                fontSize: 9, fontWeight: FontWeight.w800)),
                          )),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}