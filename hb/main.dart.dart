// ═══ FILE: lib/main.dart ═══
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/otp_login_screen.dart';
import 'features/auth/setup_profile_screen.dart';
import 'features/home/home_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: TiffinExpressApp()));
}

class TiffinExpressApp extends StatelessWidget {
  const TiffinExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiffinExpress',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/':              (_) => const SplashScreen(),
        '/onboarding':    (_) => const OnboardingScreen(),
        '/login':         (_) => const OtpLoginScreen(),
        '/setup-profile': (_) => const SetupProfileScreen(),
        '/home':          (_) => const HomeShell(),
      },
    );
  }
}