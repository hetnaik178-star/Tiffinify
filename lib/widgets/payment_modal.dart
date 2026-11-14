import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/helpers.dart';

enum PaymentMethod { razorpay, cod, wallet }

class PaymentModal {
  static Future<Map<String, dynamic>?> show({
    required BuildContext context,
    required double amount,
    required String title,
    double walletBalance = 120.0,
  }) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PaymentModalContent(
        amount: amount,
        title: title,
        walletBalance: walletBalance,
      ),
    );
  }
}

class _PaymentModalContent extends StatefulWidget {
  final double amount;
  final String title;
  final double walletBalance;

  const _PaymentModalContent({
    required this.amount,
    required this.title,
    required this.walletBalance,
  });

  @override
  State<_PaymentModalContent> createState() => _PaymentModalContentState();
}

class _PaymentModalContentState extends State<_PaymentModalContent> {
  PaymentMethod _selected = PaymentMethod.razorpay;
  String _upiOption = 'GPay';
  bool _isProcessing = false;
  bool _showRazorpayGateway = false;
  String? _paymentId;

  @override
  Widget build(BuildContext context) {
    if (_showRazorpayGateway) {
      return _buildRazorpayGatewayUI();
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('💳 Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(Helpers.price(widget.amount), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.masala)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Order: ${widget.title}', style: const TextStyle(fontSize: 12.5, color: AppColors.ink60)),
          const SizedBox(height: 20),

          // ── OPTION 1: RAZORPAY ──
          _methodTile(
            method: PaymentMethod.razorpay,
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF0C2340),
            title: 'Razorpay Online Payment',
            subtitle: 'UPI (GPay/PhonePe), Card, Netbanking',
            badge: 'RECOMMENDED',
            badgeColor: AppColors.leaf,
          ),

          // ── OPTION 2: CASH ON DELIVERY ──
          _methodTile(
            method: PaymentMethod.cod,
            icon: Icons.payments_rounded,
            iconColor: Colors.amber.shade800,
            title: 'Cash on Delivery (COD)',
            subtitle: 'Pay cash to delivery partner when food arrives',
          ),

          // ── OPTION 3: WALLET ──
          _methodTile(
            method: PaymentMethod.wallet,
            icon: Icons.account_balance_rounded,
            iconColor: AppColors.turmeric,
            title: 'Tiffinify Wallet',
            subtitle: 'Available balance: ${Helpers.price(widget.walletBalance)}',
            disabled: widget.walletBalance < widget.amount,
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.masala,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                if (_selected == PaymentMethod.razorpay) {
                  setState(() => _showRazorpayGateway = true);
                } else if (_selected == PaymentMethod.cod) {
                  Navigator.pop(context, {'success': true, 'method': 'COD', 'paymentId': 'COD_${DateTime.now().millisecondsSinceEpoch}'});
                } else if (_selected == PaymentMethod.wallet) {
                  if (widget.walletBalance >= widget.amount) {
                    Navigator.pop(context, {'success': true, 'method': 'Wallet', 'paymentId': 'WAL_${DateTime.now().millisecondsSinceEpoch}'});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wallet balance kam hai, dusra option select karein')),
                    );
                  }
                }
              },
              child: Text(
                _selected == PaymentMethod.razorpay
                    ? 'Pay ${Helpers.price(widget.amount)} via Razorpay 💳'
                    : 'Confirm Order — ${Helpers.price(widget.amount)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _methodTile({
    required PaymentMethod method,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    Color? badgeColor,
    bool disabled = false,
  }) {
    final active = _selected == method;
    return GestureDetector(
      onTap: disabled ? null : () => setState(() => _selected = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade100 : (active ? AppColors.cream : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: active ? 2 : 1.2,
            color: active ? AppColors.masala : AppColors.line,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: disabled ? Colors.grey : AppColors.ink)),
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: badgeColor ?? AppColors.masala, borderRadius: BorderRadius.circular(5)),
                          child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11.5, color: disabled ? Colors.grey : AppColors.ink60)),
                ],
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selected,
              activeColor: AppColors.masala,
              onChanged: disabled ? null : (v) => setState(() => _selected = v!),
            ),
          ],
        ),
      ),
    );
  }

  // ── MOCK RAZORPAY GATEWAY UI ──
  Widget _buildRazorpayGatewayUI() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0C2340), // Official Razorpay Dark Theme
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Razorpay Header Bar
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF072654), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Text('💳 ', style: TextStyle(fontSize: 14)),
                    Text('Razorpay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => setState(() => _showRazorpayGateway = false),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Merchant & Order Amount
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF132F56), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tiffinify Meals', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
                const Spacer(),
                Text(Helpers.price(widget.amount), style: const TextStyle(color: Color(0xFF38EF7D), fontWeight: FontWeight.w900, fontSize: 22)),
              ],
            ),
          ),
          const SizedBox(height: 18),

          if (_isProcessing)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Color(0xFF38EF7D)),
                    const SizedBox(height: 18),
                    Text(
                      _paymentId == null ? 'Contacting Razorpay Gateway…' : 'Payment Success! Finalizing… 🎉',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    if (_paymentId != null) ...[
                      const SizedBox(height: 6),
                      Text('Payment ID: $_paymentId', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ],
                ),
              ),
            )
          else ...[
            const Text('SELECT PAYMENT OPTION', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
            const SizedBox(height: 10),

            // UPI Option Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _upiChip('GPay 🟢'),
                  _upiChip('PhonePe 🟣'),
                  _upiChip('Paytm 🔵'),
                  _upiChip('BHIM 🟠'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Credit / Debit Card Quick Mock Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF132F56), borderRadius: BorderRadius.circular(14)),
              child: const Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.white70),
                  SizedBox(width: 10),
                  Text('Card / Netbanking / Wallet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Razorpay Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B84EA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _processRazorpayPayment,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, size: 18),
                    const SizedBox(width: 8),
                    Text('PAY ${Helpers.price(widget.amount)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text('🔒 256-bit SSL Encrypted • Razorpay Mock API', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _upiChip(String label) {
    final active = _upiOption == label;
    return GestureDetector(
      onTap: () => setState(() => _upiOption = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2B84EA) : const Color(0xFF132F56),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? Colors.white : Colors.transparent, width: 1.5),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5)),
      ),
    );
  }

  Future<void> _processRazorpayPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    final pid = 'pay_rzp_mock_${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    setState(() => _paymentId = pid);
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      Navigator.pop(context, {
        'success': true,
        'method': 'Razorpay (${_upiOption.split(' ')[0]})',
        'paymentId': pid,
      });
    }
  }
}
