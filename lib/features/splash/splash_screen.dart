import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/tiffin_logo.dart';
import 'delivery_splash_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 6800));
    _ctrl.forward();
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) _enterApp(); // ✅ auto transition
    });
  }

  Future<void> _enterApp() async {
    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboarded') ?? false;
    final savedName = prefs.getString('user_name');
    if (!mounted) return;
    if (savedName != null && savedName.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed(onboarded ? '/login' : '/onboarding');
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final t = _ctrl.value;
          final logoP = DeliverySplashPainter.ph(0.86, 0.95, t);
          final loadFade = 1 - DeliverySplashPainter.ph(0.84, 0.92, t);
          return Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: DeliverySplashPainter(t: t))),

              Positioned(
                top: MediaQuery.of(context).padding.top + 12, right: 16,
                child: Opacity(
                  opacity: 1 - logoP,
                  child: TextButton(
                    onPressed: _enterApp,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.75),
                      foregroundColor: AppColors.ink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Skip  ›', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),

              Positioned(
                top: h * 0.16, left: 0, right: 0,
                child: Opacity(
                  opacity: logoP,
                  child: Transform.scale(
                    scale: 0.8 + 0.2 * logoP,
                    child: const Column(children: [TiffinLogo(size: 62)]),
                  ),
                ),
              ),

              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 26, left: 0, right: 0,
                child: Opacity(
                  opacity: loadFade,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Garam-garam khana deliver ho raha hai',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 4),
                      ...List.generate(3, (i) {
                        final dotOp = (math.sin(t * 26 + i * 2.1) + 1) / 2;
                        return Container(
                          width: 5, height: 5,
                          margin: const EdgeInsets.only(left: 3),
                          decoration: BoxDecoration(
                            color: AppColors.masala.withOpacity(0.35 + 0.65 * dotOp),
                            shape: BoxShape.circle),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}