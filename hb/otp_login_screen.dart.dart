// ═══ FILE: lib/features/auth/otp_login_screen.dart ═══
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/tiffin_logo.dart';

class OtpLoginScreen extends ConsumerStatefulWidget {
  const OtpLoginScreen({super.key});
  @override
  ConsumerState<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends ConsumerState<OtpLoginScreen> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _otpSent = false, _busy = false;

  Future<void> _sendOtp() async {
    if (_phone.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('10 digit mobile number daalo')));
      return;
    }
    setState(() => _busy = true);
    await ref.read(authProvider.notifier).sendOtp('+91${_phone.text}');
    setState(() { _otpSent = true; _busy = false; });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('OTP bhej diya! Demo mode me OTP hai: ${AppConstants.demoOtp}')));
  }

  Future<void> _verify() async {
    if (_otp.text.length != 4) return;
    setState(() => _busy = true);
    final ok = await ref.read(authProvider.notifier)
        .verifyOtp('+91${_phone.text}', _otp.text);
    setState(() => _busy = false);
    if (!mounted) return;

    if (ok) {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('user_name');
      if (!mounted) return;

      if (savedName != null && savedName.isNotEmpty) {
        ref.read(authProvider.notifier).setName(savedName);
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/setup-profile');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Galat OTP — demo me 1234 use karo')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 26),
              const Center(child: TiffinLogo()),
              const SizedBox(height: 42),
              Text(_otpSent ? 'OTP check karo 📩' : 'Login karo',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(_otpSent
                  ? '+91 ${_phone.text} pe OTP bheja gaya hai'
                  : 'Apna mobile number daalo, OTP se login hoga',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 28),

              if (!_otpSent) ...[
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16, right: 8),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('🇮🇳', style: TextStyle(fontSize: 18)),
                        SizedBox(width: 6),
                        Text('+91', style: TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    hintText: '98765 43210',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'OTP bhejo', loading: _busy,
                    icon: Icons.send_rounded, onTap: _sendOtp),
              ] else ...[
                AnimatedBuilder(
                  animation: _otp,
                  builder: (_, __) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (i) {
                      final filled = _otp.text.length > i;
                      return Container(
                        width: 62, height: 68,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(width: 2,
                              color: filled ? AppColors.masala : AppColors.line),
                        ),
                        child: Text(filled ? _otp.text[i] : '',
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      );
                    }),
                  ),
                ),
                TextField(
                  controller: _otp,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '••••  (demo OTP: 1234)', counterText: '',
                    border: InputBorder.none, enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent, filled: true,
                  ),
                  onChanged: (v) => setState(() {}),
                  onSubmitted: (_) => _verify(),
                ),
                const SizedBox(height: 14),
                PrimaryButton(label: 'Verify & Login', loading: _busy,
                    icon: Icons.verified_rounded, onTap: _verify),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() { _otpSent = false; _otp.clear(); }),
                    child: const Text('Number badlo'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}