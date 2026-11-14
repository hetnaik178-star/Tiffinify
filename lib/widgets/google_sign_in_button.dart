import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = 'Google se Continue karo',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _GoogleIcon(size: 22),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  final double size;
  const _GoogleIcon({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Google 'G' colors
    final blue = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    final green = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.fill;
    final yellow = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.fill;
    final red = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.fill;

    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Draw stylized multi-color G
    // Blue bar & bottom right arc
    final bluePath = Path()
      ..moveTo(w * 0.95, h * 0.5)
      ..lineTo(w * 0.5, h * 0.5)
      ..lineTo(w * 0.5, h * 0.68)
      ..lineTo(w * 0.77, h * 0.68)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        0.2,
        0.7,
        false,
      )
      ..lineTo(w * 0.5, h * 0.5)
      ..close();
    canvas.drawPath(bluePath, blue);

    // Green bottom arc
    final greenPath = Path()
      ..moveTo(w * 0.5, h)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        0.78,
        0.8,
        false,
      )
      ..lineTo(w * 0.5, h * 0.5)
      ..close();
    canvas.drawPath(greenPath, green);

    // Yellow left arc
    final yellowPath = Path()
      ..moveTo(0, h * 0.5)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        2.35,
        0.8,
        false,
      )
      ..lineTo(w * 0.5, h * 0.5)
      ..close();
    canvas.drawPath(yellowPath, yellow);

    // Red top arc
    final redPath = Path()
      ..moveTo(w * 0.5, 0)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        3.92,
        0.8,
        false,
      )
      ..lineTo(w * 0.5, h * 0.5)
      ..close();
    canvas.drawPath(redPath, red);

    // Inner circle cutout
    final innerClear = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.55, innerClear);

    // Blue horizontal arm
    final armPath = Path()
      ..moveTo(w * 0.45, h * 0.38)
      ..lineTo(w * 0.95, h * 0.38)
      ..lineTo(w * 0.95, h * 0.62)
      ..lineTo(w * 0.45, h * 0.62)
      ..close();
    canvas.drawPath(armPath, blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
