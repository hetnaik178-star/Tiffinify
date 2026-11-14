import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _i = 0;

  static const _slides = [
    {'emoji': '🍱', 'title': 'Ghar jaisa khana',
     'sub': 'Roz ka fresh menu — spice, oil, no onion-garlic, sab apne hisaab se customize karo!',
     'bg': AppColors.turmeric},
    {'emoji': '🛵', 'title': 'Bilkul time pe',
     'sub': 'Live order status aur punctual delivery — lunch kabhi late nahi hoga.',
     'bg': AppColors.leaf},
    {'emoji': '🎉', 'title': 'Festival specials',
     'sub': 'Rakhi, Diwali, Independence Day — har tyohaar pe special thali aur mithai.',
     'bg': AppColors.masala},
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_i];
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: slide['bg'] as Color,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Skip ›', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _page,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _i = i),
                  itemBuilder: (_, i) {
                    final s = _slides[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 34),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: Text(s['emoji'] as String,
                                key: ValueKey(i), style: const TextStyle(fontSize: 110)),
                          ),
                          const SizedBox(height: 30),
                          Text(s['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 30,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 14),
                          Text(s['sub'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white.withOpacity(0.92),
                                  fontSize: 15, height: 1.5)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _i == i ? 22 : 8, height: 8,
                      decoration: BoxDecoration(
                        color: _i == i ? Colors.white : Colors.white.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(4)),
                    )),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: slide['bg'] as Color),
                    onPressed: () {
                      if (_i < 2) {
                        _page.animateToPage(_i + 1,
                            duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
                      } else { _finish(); }
                    },
                    child: Text(_i < 2 ? 'Next' : 'Shuru karte hain! 🚀'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}