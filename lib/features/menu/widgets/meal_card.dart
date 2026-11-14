import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/menu_item_model.dart';
import '../../customization/customization_screen.dart';

class MealCard extends ConsumerWidget {
  final MenuItemModel item;
  const MealCard({super.key, required this.item});

  static const _tileGradient = {
    'breakfast': [Color(0xFFFFE0B2), Color(0xFFFFCC80)],
    'lunch':     [Color(0xFFDCEDC8), Color(0xFFAED581)],
    'dinner':    [Color(0xFFD1C4E9), Color(0xFFB39DDB)],
    'festival':  [Color(0xFFFFCDD2), Color(0xFFEF9A9A)],
  };

  static const Color _jainColor = Color(0xFFD98A1F);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final g = _tileGradient[item.category] ?? _tileGradient['lunch']!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line, width: 1.2),
        boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.05),
            blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 88, height: 88,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: g,
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 40))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dietTag(item.dietType),
                  const SizedBox(height: 5),
                  Text(item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(item.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 9),
                  Row(children: [
                    Text(Helpers.price(item.basePrice),
                        style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800,
                            color: AppColors.ink)),
                    const Spacer(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CustomizationScreen(item: item))),
                      child: const Text('Customize +'),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _dietTag(String diet) {
    Color c; String label;
    switch (diet) {
      case 'nonveg': c = AppColors.masala; label = 'NON-VEG'; break;
      case 'jain':   c = _jainColor;       label = 'JAIN';    break;
      default:       c = AppColors.leaf;   label = 'VEG';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withOpacity(0.55), width: 1)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 7, height: 7,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
            color: c, letterSpacing: 0.4)),
      ]),
    );
  }
}