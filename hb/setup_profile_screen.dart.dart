// ═══ FILE: lib/features/auth/setup_profile_screen.dart ═══
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/tiffin_logo.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});
  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  final _name = TextEditingController();
  bool _busy = false;

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apna naam zaroor likho 🙂')));
      return;
    }
    setState(() => _busy = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    ref.read(authProvider.notifier).setName(name);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() { _name.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Center(child: TiffinLogo()),
              const SizedBox(height: 46),
              Text('Bas ek step baaki hai! 🎉',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text('Apna naam batao, taaki profile me dikhe',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 28),
              TextField(
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: AppColors.masala),
                  labelText: 'Aapka naam',
                  hintText: 'e.g., Rahul Sharma',
                ),
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Save karo aur aage badho',
                icon: Icons.arrow_forward_rounded,
                loading: _busy,
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}