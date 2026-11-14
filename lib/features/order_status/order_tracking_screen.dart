import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/order_model.dart';
import '../../data/services/api_service.dart';

/// PDF §4.7 — Placed → Preparing → Ready → Delivered
class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});
  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  Timer? _timer;
  late final AnimationController _pulse;

  static const _meta = [
    ('🧾', 'Order placed', 'Kitchen ko order mil gaya'),
    ('👨‍🍳', 'Preparing', 'Chef bhaiya khana bana rahe hain'),
    ('🍱', 'Ready', 'Tiffin pack ho gaya, rider ko diya'),
    ('✅', 'Delivered', 'Enjoy your meal! 😋'),
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _pulse.repeat(reverse: true);

    if (ApiService.mockMode) {
      // Demo: har 5 sec me status aage badhega.
      // Production: SocketService().connect(order.id) + stream listen.
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (_step < 3) { setState(() => _step++); } else { _timer?.cancel(); }
      });
    }
  }

  @override
  void dispose() { _timer?.cancel(); _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final delivered = _step == 3;
    return Scaffold(
      appBar: AppBar(title: Text('Order ${widget.order.id}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: delivered
                    ? [AppColors.leaf, const Color(0xFF14603C)]
                    : [AppColors.masala, AppColors.masalaDk],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(22)),
            child: Column(children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Transform.scale(
                  scale: delivered ? 1 : 1 + _pulse.value * 0.08,
                  child: Text(_meta[_step].$1, style: const TextStyle(fontSize: 58))),
              ),
              const SizedBox(height: 10),
              Text(_meta[_step].$2, style: const TextStyle(color: Colors.white,
                  fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(_meta[_step].$3, style: TextStyle(
                  color: Colors.white.withOpacity(0.9), fontSize: 13)),
              if (!delivered) ...[
                const SizedBox(height: 12),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(9)),
                  child: const Text('⏱ ETA: 25-30 min', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5))),
              ],
            ]),
          ),
          const SizedBox(height: 26),

          ...List.generate(4, (i) {
            final done = i < _step, current = i == _step;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done || current ? AppColors.leaf : Colors.white,
                        border: Border.all(color: done || current
                            ? AppColors.leaf : AppColors.line, width: 2)),
                      child: Center(child: done
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                          : Text(_meta[i].$1, style: const TextStyle(fontSize: 15))),
                    ),
                    if (i < 3)
                      Expanded(child: Container(width: 2.5,
                          color: done ? AppColors.leaf : AppColors.line)),
                  ]),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(_meta[i].$2, style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15,
                            color: done || current ? AppColors.ink : AppColors.ink60)),
                        const SizedBox(height: 3),
                        Text(_meta[i].$3, style: Theme.of(context).textTheme.bodyMedium),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }),

          if (delivered)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Wapas menu pe chalo'),
              ),
            ),
        ],
      ),
    );
  }
}