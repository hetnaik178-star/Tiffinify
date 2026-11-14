// ═══ FILE: lib/features/home/home_screen.dart ═══
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../providers/menu_provider.dart';
import '../menu/widgets/meal_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String _slot;
  String _diet = 'all'; // 'all' | 'veg' | 'nonveg' | 'jain'

  final _slots = const ['breakfast', 'lunch', 'dinner'];
  final _slotMeta = const {
    'breakfast': ('🌅', 'Breakfast'),
    'lunch': ('☀️', 'Lunch'),
    'dinner': ('🌙', 'Dinner'),
  };

  static const Color _jainColor = Color(0xFFD98A1F);

  @override
  void initState() { super.initState(); _slot = Helpers.mealSlot(); }

  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(todayMenuProvider);
    final open = Helpers.customizationOpen();

    return RefreshIndicator(
      onRefresh: () => ref.refresh(todayMenuProvider.future),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.masala, AppColors.masalaDk],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [BoxShadow(color: AppColors.masala.withOpacity(0.3),
                  blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.place_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 4),
                Text('42, Gandhi Nagar, Jaipur',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12.5)),
              ]),
              const SizedBox(height: 10),
              const Text('Aaj kya khana hai? 😋',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(Helpers.todayLabel(),
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.5)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: open ? AppColors.turmeric : const Color(0xFF7A1E12),
                  borderRadius: BorderRadius.circular(10)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(open ? Icons.timer_rounded : Icons.lock_clock_rounded,
                      size: 15, color: open ? AppColors.ink : Colors.white),
                  const SizedBox(width: 6),
                  Text(open
                      ? 'Customize before 8 PM for tomorrow'
                      : 'Window closed — kal ka menu customize karo',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700,
                          color: open ? AppColors.ink : Colors.white)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 22),

          // ── Meal tabs ──
          Row(
            children: _slots.map((sl) {
              final active = sl == _slot;
              final meta = _slotMeta[sl]!;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _slot = sl),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: active ? AppColors.ink : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: active ? AppColors.ink : AppColors.line, width: 1.5),
                    ),
                    child: Column(children: [
                      Text(meta.$1, style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 2),
                      Text(meta.$2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                          color: active ? Colors.white : AppColors.ink60)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // ── ⭐ DIET FILTER CHIPS ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _dietChip('all',    '🍽️ All',     AppColors.ink),
              _dietChip('veg',    '🥦 Veg',     AppColors.leaf),
              _dietChip('nonveg', '🍗 Non-Veg', AppColors.masala),
              _dietChip('jain',   '🙏 Jain',    _jainColor),
            ]),
          ),
          const SizedBox(height: 18),

          // ── Menu list (diet filter ke saath) ──
          menu.when(
            loading: () => Column(children: List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Shimmer.fromColors(
                    baseColor: AppColors.line, highlightColor: Colors.white,
                    child: Container(height: 108,
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(18))),
                  )))),
            error: (e, _) => Center(child: Text('Menu load nahi hua: $e')),
            data: (items) {
              final filtered = items.where((i) {
                final slotMatch = i.category == _slot;
                final dietMatch = _diet == 'all' || i.dietType == _diet;
                return slotMatch && dietMatch;
              }).toList();

              if (filtered.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Column(children: [
                      const Text('🍽️', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 10),
                      Text('Is slot me ${_dietLabel()} items nahi hain',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('Dusra filter ya meal slot try karo',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ]),
                  ),
                );
              }
              return Column(children: [
                ...filtered.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: MealCard(item: item))),
              ]);
            },
          ),
        ],
      ),
    );
  }

  Widget _dietChip(String value, String label, Color activeColor) {
    final active = _diet == value;
    return GestureDetector(
      onTap: () => setState(() => _diet = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? activeColor : AppColors.line, width: 1.5),
          boxShadow: active
              ? [BoxShadow(color: activeColor.withOpacity(0.3),
                  blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Text(label, style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 12.5,
            color: active ? Colors.white : AppColors.ink60)),
      ),
    );
  }

  String _dietLabel() {
    switch (_diet) {
      case 'veg': return 'Veg';
      case 'nonveg': return 'Non-Veg';
      case 'jain': return 'Jain';
      default: return '';
    }
  }
}