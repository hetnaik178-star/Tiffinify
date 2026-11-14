import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String emoji, title, subtitle;
  final Widget? action;
  const EmptyState({super.key, required this.emoji, required this.title,
                    required this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 18), action!],
        ]),
      ),
    );
  }
}