import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../widgets/payment_modal.dart';
import '../../widgets/primary_button.dart';

/// PDF §4.2 — plans, pause/resume, skip-a-day, auto-renew
class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});
  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  String _plan = 'monthly';
  int _meals = 1;
  String _diet = 'veg';
  bool _busy = false;

  static const _prices = {'weekly': 499, 'monthly': 1799};

  @override
  Widget build(BuildContext context) {
    final sub = ref.watch(subscriptionProvider).value;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text('Subscription Plan', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 4),
        Text('Roz ka khana, ek baar subscribe — auto-renewal ke saath',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 22),

        if (sub != null) ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.leaf, Color(0xFF14603C)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Text('✅ Active Plan', style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w800, fontSize: 16)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(sub.status.toUpperCase(), style: const TextStyle(
                      color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800))),
              ]),
              const SizedBox(height: 12),
              Text('${sub.planLabel} • ${sub.mealsPerDay}x meal/day',
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(height: 14),
              ClipRRect(borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: sub.totalDays == 0 ? 0 : sub.daysLeft / sub.totalDays,
                  minHeight: 9, backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor: const AlwaysStoppedAnimation(AppColors.turmeric))),
              const SizedBox(height: 8),
              Text('${sub.daysLeft} din baaki',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12.5)),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: SizedBox(width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white, foregroundColor: AppColors.leaf,
                        side: BorderSide.none),
                    onPressed: () => ref.read(subscriptionProvider.notifier).togglePause(),
                    child: Text(sub.status == 'active' ? '⏸ Pause' : '▶ Resume')))),
                const SizedBox(width: 10),
                Expanded(child: SizedBox(width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent, foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white)),
                    onPressed: () async {
                      await ref.read(subscriptionProvider.notifier).skipToday();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Aaj ka meal skip — refund wallet me aayega 💰')));
                      }
                    },
                    child: const Text('⏭ Skip today')))),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
        ],

        ...['weekly', 'monthly'].map((p) {
          final active = _plan == p;
          final price = _prices[p]!;
          return GestureDetector(
            onTap: () => setState(() => _plan = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: active ? 2.2 : 1.3,
                    color: active ? AppColors.masala : AppColors.line)),
              child: Row(children: [
                Icon(active ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: active ? AppColors.masala : AppColors.ink60),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p == 'weekly' ? 'Weekly Plan' : 'Monthly Plan',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(p == 'weekly' ? '7 din • har din fresh' : '30 din • best value',
                      style: Theme.of(context).textTheme.bodyMedium),
                ]),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(Helpers.price(price), style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  if (p == 'monthly')
                    Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.turmeric,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('SAVE 10%', style: TextStyle(fontSize: 9,
                          fontWeight: FontWeight.w800))),
                ]),
              ]),
            ),
          );
        }),
        const SizedBox(height: 18),

        Text('Meals per day', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Row(children: [1, 2].map((m) {
          final active = _meals == m;
          return Expanded(child: GestureDetector(
            onTap: () => setState(() => _meals = m),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: active ? AppColors.ink : Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: active ? AppColors.ink : AppColors.line, width: 1.5)),
              child: Center(child: Text(m == 1 ? '1x meal' : '2x meals',
                  style: TextStyle(fontWeight: FontWeight.w800,
                      color: active ? Colors.white : AppColors.ink60))),
            ),
          ));
        }).toList()),
        const SizedBox(height: 18),

        Text('Diet preference', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Row(children: ['veg', 'nonveg', 'jain'].map((d) {
          final active = _diet == d;
          final label = d == 'veg' ? '🥦 Veg' : d == 'nonveg' ? '🍗 Non-Veg' : '🙏 Jain';
          return Expanded(child: GestureDetector(
            onTap: () => setState(() => _diet = d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: active ? AppColors.masala : Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: active ? AppColors.masala : AppColors.line, width: 1.5)),
              child: Center(child: Text(label, style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 12.5,
                  color: active ? Colors.white : AppColors.ink60))),
            ),
          ));
        }).toList()),
        const SizedBox(height: 26),

        PrimaryButton(
          label: 'Subscribe — ${Helpers.price(_prices[_plan]! * _meals)}',
          icon: Icons.workspace_premium_rounded,
          loading: _busy,
          onTap: () async {
            final amt = (_prices[_plan]! * _meals).toDouble();
            final user = ref.read(authProvider).value;
            final payResult = await PaymentModal.show(
              context: context,
              amount: amt,
              title: 'Tiffinify $_plan Subscription (${_meals}x meal/day)',
              walletBalance: user?.walletBalance ?? 120.0,
            );

            if (payResult == null || payResult['success'] != true) return;
            if (!mounted) return;

            setState(() => _busy = true);
            await ref.read(subscriptionProvider.notifier).subscribe(_plan, _meals);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Subscription active via ${payResult['method']}! Kal se delivery shuru 🎉')));
            }
            setState(() => _busy = false);
          },
        ),
      ],
    );
  }
}