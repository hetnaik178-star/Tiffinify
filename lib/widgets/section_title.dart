import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (action != null)
          GestureDetector(onTap: onAction,
            child: Text(action!, style: const TextStyle(
                color: AppColors.masala, fontWeight: FontWeight.w700, fontSize: 13))),
      ],
    );
  }
}