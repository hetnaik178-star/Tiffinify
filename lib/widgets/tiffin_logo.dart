import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class TiffinLogo extends StatelessWidget {
  final double size;
  const TiffinLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            color: Colors.white, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.masala.withOpacity(0.25),
                blurRadius: 18, offset: const Offset(0, 6))]),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.jpeg',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: size * 0.34, height: size * 0.1,
                          decoration: BoxDecoration(color: AppColors.turmeric,
                              borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 2),
                      Container(width: size * 0.44, height: size * 0.12,
                          decoration: BoxDecoration(color: AppColors.masala,
                              borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 2),
                      Container(width: size * 0.44, height: size * 0.12,
                          decoration: BoxDecoration(color: AppColors.leaf,
                              borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Tiffinify',
            style: Theme.of(context).textTheme.displayMedium
                ?.copyWith(color: AppColors.masala, fontSize: size * 0.5)),
        Text('Ghar ka khana, time pe!', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}