import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/menu_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/primary_button.dart';

/// PDF §4.4 — Customization Engine
class CustomizationScreen extends ConsumerStatefulWidget {
  final MenuItemModel item;
  const CustomizationScreen({super.key, required this.item});
  @override
  ConsumerState<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends ConsumerState<CustomizationScreen> {
  String _spice = 'medium';
  String _oil = 'normal';
  bool _noOnionGarlic = false;
  bool _noSugar = false;
  int _extraRoti = 0;
  int _qty = 1;
  bool _saveTemplate = false;
  final _request = TextEditingController();

  double get _extra => _extraRoti * 5.0; // price delta (PDF §4.3)

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line)),
            child: Row(children: [
              Text(item.emoji, style: const TextStyle(fontSize: 46)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 3),
                Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
              ])),
            ]),
          ),
          const SizedBox(height: 20),

          _section('🌶️ Spice level',
            children: _chips(['mild', 'medium', 'hot'],
                ['Mild 😌', 'Medium 🙂', 'Hot 🔥'], _spice,
                (v) => setState(() => _spice = v))),
          _section('🫗 Oil level',
            children: _chips(['low', 'normal', 'extra'],
                ['Low', 'Normal', 'Extra'], _oil,
                (v) => setState(() => _oil = v))),

          _switchRow('🧅 No onion / no garlic (Jain)', _noOnionGarlic,
              (v) => setState(() => _noOnionGarlic = v)),
          _switchRow('🍬 No sugar / less sweet', _noSugar,
              (v) => setState(() => _noSugar = v)),

          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line)),
            child: Row(children: [
              const Text('🫓 Extra roti', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text('(+${Helpers.price(5)}/roti)', style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              _stepperBtn(Icons.remove_rounded,
                  () => setState(() => _extraRoti = (_extraRoti - 1).clamp(0, 6))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('$_extraRoti',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
              _stepperBtn(Icons.add_rounded,
                  () => setState(() => _extraRoti = (_extraRoti + 1).clamp(0, 6))),
            ]),
          ),

          TextField(
            controller: _request, maxLines: 2,
            decoration: const InputDecoration(
                hintText: 'Special request… (e.g., "custom sweet bana dena")'),
          ),
          const SizedBox(height: 10),

          _switchRow('💾 Isko meri default template banao', _saveTemplate,
              (v) => setState(() => _saveTemplate = v)),
          const SizedBox(height: 10),

          Row(children: [
            const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w700)),
            const Spacer(),
            _stepperBtn(Icons.remove_rounded, () => setState(() => _qty = (_qty - 1).clamp(1, 8))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('$_qty', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
            _stepperBtn(Icons.add_rounded, () => setState(() => _qty = (_qty + 1).clamp(1, 8))),
          ]),
          const SizedBox(height: 26),

          PrimaryButton(
            label: 'Add to cart — ${Helpers.price((item.basePrice + _extra) * _qty)}',
            icon: Icons.shopping_basket_rounded,
            onTap: () {
              ref.read(cartProvider.notifier).add(CartLine(
                    item: item, qty: _qty, extraPrice: _extra,
                    specialRequest: _request.text,
                    customization: {
                      'spice': _spice, 'oil': _oil,
                      if (_noOnionGarlic) 'no_onion_garlic': 'yes',
                      if (_noSugar) 'no_sugar': 'yes',
                      if (_extraRoti > 0) 'extra_roti': '$_extraRoti',
                    }));
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} cart me add ho gaya ✅')));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _section(String title, {required List<Widget> children}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10), ...children, const SizedBox(height: 16),
        ],
      );

  List<Widget> _chips(List<String> values, List<String> labels, String selected,
          ValueChanged<String> onPick) =>
      [Wrap(spacing: 10, children: List.generate(values.length, (i) {
        final active = values[i] == selected;
        return GestureDetector(
          onTap: () => onPick(values[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.masala : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: active ? AppColors.masala : AppColors.line, width: 1.5)),
            child: Text(labels[i], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13,
                color: active ? Colors.white : AppColors.ink)),
          ),
        );
      }))];

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line)),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          value: value, onChanged: onChanged,
          activeColor: Colors.white, activeTrackColor: AppColors.leaf,
        ),
      );

  Widget _stepperBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34, height: 34,
          decoration: BoxDecoration(color: AppColors.cream,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.line, width: 1.5)),
          child: Icon(icon, size: 18, color: AppColors.masala)),
      );
}