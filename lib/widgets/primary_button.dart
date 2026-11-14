import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool loading;
  final IconData? icon;
  const PrimaryButton({super.key, required this.label, this.onTap,
                       this.loading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        child: loading
            ? const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (icon != null) ...[Icon(icon, size: 19), const SizedBox(width: 8)],
                Text(label),
              ]),
      ),
    );
  }
}