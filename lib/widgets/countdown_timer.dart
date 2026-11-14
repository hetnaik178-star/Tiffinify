import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime target;
  const CountdownTimer({super.key, required this.target});
  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final diff = widget.target.difference(DateTime.now());
    if (diff.isNegative) {
      return Text('Window closed', style: Theme.of(context).textTheme.bodyMedium);
    }
    final d = diff.inDays, hr = diff.inHours % 24, mn = diff.inMinutes % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return Row(mainAxisSize: MainAxisSize.min,
        children: [_chip('${two(d)}d'), _chip('${two(hr)}h'), _chip('${two(mn)}m')]);
  }

  Widget _chip(String v) => Container(
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(6)),
        child: Text(v, style: const TextStyle(color: Colors.white,
            fontWeight: FontWeight.w800, fontSize: 12)),
      );
}