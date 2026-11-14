import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Cartoon delivery animation — pure CustomPainter, no assets needed.
/// [t] : 0 → 1 master progress (6.8s controller)
class DeliverySplashPainter extends CustomPainter {
  DeliverySplashPainter({required this.t});
  final double t;

  static double ph(double a, double b, double v) =>
      v <= a ? 0 : v >= b ? 1 : (v - a) / (b - a);
  static double lerp(double a, double b, double p) => a + (b - a) * p;
  static double backOut(double p) {
    const c = 1.70158; p -= 1;
    return 1 + p * p * ((c + 1) * p + c);
  }

  double get _speed => (t > 0.12 && t < 0.46) || (t > 0.76 && t < 0.94) ? 1 : 0;

  double _bikeX(double w) {
    const start = -0.22, stop = 0.46, end = 1.35;
    if (t < 0.10) return start * w;
    if (t <= 0.48) return lerp(start, stop, Curves.easeInOut.transform(ph(0.10, 0.48, t))) * w;
    if (t <= 0.74) return stop * w;
    return lerp(stop, end, Curves.easeIn.transform(ph(0.74, 0.94, t))) * w;
  }

  double get _wheelAngle => ph(0.10, 0.48, t) * 24 + ph(0.74, 0.94, t) * 18;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final s = w / 420;
    final groundY = h * 0.78;

    _sky(canvas, size);
    _sun(canvas, w, h, s);
    _clouds(canvas, w, h, s);
    _hills(canvas, w, groundY, s);
    _road(canvas, size, groundY, s, ph(0, 0.10, t));
    _house(canvas, w, groundY, s, ph(0.02, 0.16, t));
    _dust(canvas, w, groundY, s);
    _speedLines(canvas, w, groundY, s);
    _exhaust(canvas, w, groundY, s);
    _rider(canvas, w, groundY, s);
    _tiffinFlight(canvas, w, groundY, s);
    _sparkles(canvas, w, groundY, s);
    _heart(canvas, w, groundY, s);
  }

  void _sky(Canvas c, Size size) {
    c.drawRect(Offset.zero & size, Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFFB9E3FB), Color(0xFFE3F4FD), Color(0xFFFFF0CE)],
        stops: [0, 0.55, 1],
      ).createShader(Offset.zero & size));
  }

  void _sun(Canvas c, double w, double h, double s) {
    final cx = w * 0.13, cy = h * 0.12;
    final pulse = 1 + math.sin(t * 10) * 0.04;
    c.drawCircle(Offset(cx, cy), 58 * s, Paint()
      ..shader = RadialGradient(colors: [const Color(0x88FFD449), Colors.transparent])
          .createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 58 * s)));
    c.save();
    c.translate(cx, cy);
    c.rotate(t * 1.4);
    final ray = Paint()..color = const Color(0xFFF2B705)..strokeWidth = 4 * s..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      c.drawLine(Offset(math.cos(a) * 33 * s * pulse, math.sin(a) * 33 * s * pulse),
                 Offset(math.cos(a) * 45 * s * pulse, math.sin(a) * 45 * s * pulse), ray);
    }
    c.restore();
    c.drawCircle(Offset(cx, cy), 25 * s * pulse, Paint()..color = const Color(0xFFFFD449));
    c.drawCircle(Offset(cx, cy), 25 * s * pulse, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 3 * s..color = const Color(0xFFF2B705));
    final eye = Paint()..color = const Color(0xFF8A6100);
    c.drawCircle(Offset(cx - 8 * s, cy - 4 * s), 2.4 * s, eye);
    c.drawCircle(Offset(cx + 8 * s, cy - 4 * s), 2.4 * s, eye);
    c.drawArc(Rect.fromLTWH(cx - 9 * s, cy - 4 * s, 18 * s, 14 * s),
        0.25 * math.pi, 0.5 * math.pi, false,
        Paint()..color = const Color(0xFF8A6100)..strokeWidth = 2.4 * s..strokeCap = StrokeCap.round);
  }

  void _cloud(Canvas c, double x, double y, double s, double o) {
    final p = Paint()..color = Colors.white.withOpacity(o);
    c.drawCircle(Offset(x, y), 14 * s, p);
    c.drawCircle(Offset(x + 16 * s, y + 3 * s), 11 * s, p);
    c.drawCircle(Offset(x - 16 * s, y + 4 * s), 10 * s, p);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x - 24 * s, y, 48 * s, 12 * s),
        Radius.circular(6 * s)), p);
  }

  void _clouds(Canvas c, double w, double h, double s) {
    final drift = t * w * 0.05;
    _cloud(c, (w * 0.45 - drift) % (w + 140 * s), h * 0.10, s, 0.95);
    _cloud(c, (w * 0.85 - drift * 0.7) % (w + 140 * s), h * 0.20, s * 0.8, 0.8);
    _cloud(c, (w * 0.65 - drift * 0.5) % (w + 140 * s), h * 0.05, s * 0.65, 0.7);
  }

  void _hills(Canvas c, double w, double groundY, double s) {
    c.drawOval(Rect.fromCenter(center: Offset(w * 0.12, groundY + 34 * s),
        width: w * 0.95, height: 130 * s), Paint()..color = const Color(0xFFCFE8AF));
    c.drawOval(Rect.fromCenter(center: Offset(w * 0.92, groundY + 44 * s),
        width: w * 0.85, height: 150 * s), Paint()..color = const Color(0xFFBFE09C));
  }

  void _road(Canvas c, Size size, double groundY, double s, double p) {
    c.save();
    c.translate(0, (1 - p) * 90 * s);
    c.drawRect(Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
        Paint()..color = const Color(0xFFE9D6AE));
    c.drawRect(Rect.fromLTWH(0, groundY, size.width, 56 * s),
        Paint()..color = const Color(0xFF4C4B57));
    c.drawRect(Rect.fromLTWH(0, groundY, size.width, 5 * s),
        Paint()..color = const Color(0xFF6E6D7A));
    final dash = Paint()..color = const Color(0xE6F4E9D0);
    for (double x = -10 * s; x < size.width + 30 * s; x += 52 * s) {
      c.drawRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(x, groundY + 26 * s, 28 * s, 5 * s), Radius.circular(2.5 * s)), dash);
    }
    c.restore();
  }

  void _house(Canvas c, double w, double groundY, double s, double pop) {
    final cx = w * 0.78;
    final doorP = ph(0.58, 0.64, t);
    c.save();
    c.translate(cx, groundY);
    final sc = 0.55 + 0.45 * backOut(pop);
    c.scale(sc, sc);
    c.translate(-cx, -groundY);

    final left = w * 0.615, right = w * 0.945, top = groundY - 150 * s;

    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(left, top, right, groundY),
        Radius.circular(5 * s)), Paint()..color = const Color(0xFFFFE9C7));
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(left, top, right, groundY),
        Radius.circular(5 * s)), Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 3 * s..color = const Color(0xFFE9BE8C));

    final roof = Path()
      ..moveTo(left - 16 * s, top + 3 * s)
      ..lineTo((left + right) / 2, top - 58 * s)
      ..lineTo(right + 16 * s, top + 3 * s)
      ..close();
    c.drawPath(roof, Paint()..color = const Color(0xFFD14B3F));
    c.drawPath(roof, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 4 * s
      ..strokeJoin = StrokeJoin.round..color = const Color(0xFFA93226));

    final wx = w * 0.872, wy = groundY - 112 * s, ws = 34 * s;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(wx - ws / 2, wy, ws, ws),
        Radius.circular(4 * s)), Paint()..color = Colors.white);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(wx - ws / 2 + 4 * s, wy + 4 * s,
        ws - 8 * s, ws - 8 * s), Radius.circular(2 * s)), Paint()..color = const Color(0xFFBDE3F2));
    final frame = Paint()..color = Colors.white..strokeWidth = 3 * s;
    c.drawLine(Offset(wx, wy + 4 * s), Offset(wx, wy + ws - 4 * s), frame);
    c.drawLine(Offset(wx - ws / 2 + 4 * s, wy + ws / 2), Offset(wx + ws / 2 - 4 * s, wy + ws / 2), frame);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(wx - ws / 2 - 3 * s, wy + ws,
        ws + 6 * s, 7 * s), Radius.circular(3 * s)), Paint()..color = const Color(0xFF8B5A3C));
    const flowers = [Color(0xFFE23B2E), Color(0xFFF2A93B), Color(0xFFE86FA4)];
    for (var i = 0; i < 3; i++) {
      c.drawCircle(Offset(wx - 10 * s + i * 10 * s, wy + ws - 2 * s), 3.4 * s,
          Paint()..color = flowers[i]);
    }

    final dw = 38 * s, dh = 64 * s;
    final dx = w * 0.745 - dw / 2, dyTop = groundY - dh;
    final doorRect = RRect.fromRectAndCorners(Rect.fromLTWH(dx, dyTop, dw, dh),
        topLeft: Radius.circular(9 * s), topRight: Radius.circular(9 * s));
    c.drawRRect(doorRect, Paint()..color = const Color(0xFF4A2E1D));

    if (doorP > 0.45) {
      final hx = dx + dw * 0.62, hy = dyTop + 24 * s;
      c.drawCircle(Offset(hx, hy), 8 * s, Paint()..color = const Color(0xFFE8A06A));
      c.drawArc(Rect.fromLTWH(hx - 8 * s, hy - 8 * s, 16 * s, 12 * s), math.pi, math.pi,
          false, Paint()..color = const Color(0xFF3A2415));
      final e = Paint()..color = const Color(0xFF33221A);
      c.drawCircle(Offset(hx - 2.6 * s, hy - 0.5 * s), 1.1 * s, e);
      c.drawCircle(Offset(hx + 2.6 * s, hy - 0.5 * s), 1.1 * s, e);
      c.drawArc(Rect.fromLTWH(hx - 3.4 * s, hy + 0.5 * s, 6.8 * s, 5 * s),
          0.15 * math.pi, 0.7 * math.pi, false,
          Paint()..color = const Color(0xFF33221A)..strokeWidth = 1.4 * s..strokeCap = StrokeCap.round);
      final wave = math.sin(t * 42) * 3 * s;
      c.drawCircle(Offset(hx - 13 * s, hy + 10 * s + wave), 3 * s,
          Paint()..color = const Color(0xFFE8A06A));
    }

    final panelW = dw * (1 - 0.82 * doorP);
    final panel = RRect.fromRectAndCorners(Rect.fromLTWH(dx, dyTop, panelW, dh),
        topLeft: Radius.circular(9 * s), topRight: Radius.circular(4 * s));
    c.drawRRect(panel, Paint()..color = const Color(0xFF8B5A3C));
    c.drawRRect(panel, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..color = const Color(0xFF6E4227));
    c.drawCircle(Offset(dx + panelW - 6 * s, dyTop + dh / 2), 2.2 * s,
        Paint()..color = const Color(0xFFF2A93B));

    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(dx - 9 * s, groundY - 5 * s,
        dw + 18 * s, 6 * s), Radius.circular(3 * s)), Paint()..color = const Color(0xFFD9B98C));

    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(dx + dw + 8 * s, dyTop + 10 * s,
        16 * s, 11 * s), Radius.circular(3 * s)), Paint()..color = Colors.white);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(dx + dw + 8 * s, dyTop + 10 * s,
        16 * s, 11 * s), Radius.circular(3 * s)), Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 1.5 * s..color = const Color(0xFFE9BE8C));

    final bush = Paint()..color = const Color(0xFF5FA463);
    c.drawCircle(Offset(left + 10 * s, groundY - 9 * s), 13 * s, bush);
    c.drawCircle(Offset(left + 26 * s, groundY - 6 * s), 9 * s,
        Paint()..color = const Color(0xFF74B878));
    c.drawCircle(Offset(right - 12 * s, groundY - 8 * s), 11 * s, bush);

    c.restore();
  }

  void _rider(Canvas c, double w, double groundY, double s) {
    final bx = _bikeX(w);
    final bounce = math.sin(t * 260) * 2.4 * s * _speed;
    final pitch = math.sin(ph(0.48, 0.56, t) * math.pi) * -0.055 +
                  math.sin(ph(0.74, 0.80, t) * math.pi) * 0.05;

    c.save();
    c.translate(bx, groundY + bounce);
    c.rotate(pitch);

    c.drawOval(Rect.fromCenter(center: Offset(0, 3 * s), width: 100 * s, height: 12 * s),
        Paint()..color = const Color(0x22000000));

    _wheel(c, Offset(-30 * s, -17 * s), 17 * s);
    _wheel(c, Offset(30 * s, -17 * s), 17 * s);

    final red = Paint()..color = const Color(0xFFE23B2E);
    final dark = Paint()..color = const Color(0xFF2E2E38);

    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-50 * s, -40 * s, 44 * s, 24 * s),
        Radius.circular(10 * s)), red);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-44 * s, -47 * s, 38 * s, 9 * s),
        Radius.circular(4.5 * s)), dark);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-10 * s, -14 * s, 30 * s, 7 * s),
        Radius.circular(3.5 * s)), dark);
    c.drawLine(Offset(18 * s, -10 * s), Offset(11 * s, -52 * s),
        Paint()..color = const Color(0xFFE23B2E)..strokeWidth = 8 * s..strokeCap = StrokeCap.round);
    c.drawArc(Rect.fromCircle(center: Offset(30 * s, -17 * s), radius: 21 * s),
        -2.4, 1.1, false,
        Paint()..color = const Color(0xFFE23B2E)..strokeWidth = 6 * s..strokeCap = StrokeCap.round);
    c.drawLine(Offset(11 * s, -52 * s), Offset(1 * s, -54 * s),
        Paint()..color = const Color(0xFF2E2E38)..strokeWidth = 5.5 * s..strokeCap = StrokeCap.round);
    c.drawLine(Offset(13 * s, -53 * s), Offset(19 * s, -62 * s),
        Paint()..color = const Color(0xFF2E2E38)..strokeWidth = 2.5 * s);
    c.drawCircle(Offset(20 * s, -64 * s), 3 * s,
        Paint()..color = const Color(0xFFBDE3F2)..strokeWidth = 2 * s);
    c.drawCircle(Offset(17 * s, -44 * s), 4 * s, Paint()..color = const Color(0xFFFFE08A));
    c.drawCircle(Offset(17 * s, -44 * s), 4 * s, Paint()
      ..style = PaintingStyle.stroke..strokeWidth = 1.6 * s..color = const Color(0xFFF2B705));
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-66 * s, -45 * s, 20 * s, 5 * s),
        Radius.circular(2.5 * s)), Paint()..color = const Color(0xFF8A8F98));

    final kurta = Paint()..color = const Color(0xFF1F8A70)..strokeCap = StrokeCap.round;
    c.drawLine(Offset(-14 * s, -72 * s), Offset(2 * s, -55 * s),
        Paint()..color = const Color(0xFF177057)..strokeWidth = 6.5 * s..strokeCap = StrokeCap.round);
    c.drawCircle(Offset(2 * s, -55 * s), 3 * s, Paint()..color = const Color(0xFFE8A06A));
    c.drawLine(Offset(-24 * s, -48 * s), Offset(-12 * s, -78 * s), kurta..strokeWidth = 15 * s);

    final leg = Path()
      ..moveTo(-22 * s, -46 * s)
      ..lineTo(-6 * s, -30 * s)
      ..lineTo(5 * s, -15 * s);
    c.drawPath(leg, Paint()..color = const Color(0xFF35476B)..strokeWidth = 8 * s
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(1 * s, -16 * s, 13 * s, 6 * s),
        Radius.circular(3 * s)), dark);

    final waveP = ph(0.56, 0.74, t);
    if (waveP > 0 && waveP < 1) {
      final wob = math.sin(t * 46) * 4 * s;
      c.drawLine(Offset(-13 * s, -74 * s), Offset(-26 * s, -96 * s + wob),
          kurta..strokeWidth = 7 * s);
      c.drawCircle(Offset(-26 * s, -96 * s + wob), 3.4 * s,
          Paint()..color = const Color(0xFFE8A06A));
    } else {
      c.drawLine(Offset(-13 * s, -74 * s), Offset(4 * s, -54 * s), kurta..strokeWidth = 7 * s);
      c.drawCircle(Offset(4 * s, -54 * s), 3.2 * s, Paint()..color = const Color(0xFFE8A06A));
    }

    c.drawCircle(Offset(-6 * s, -90 * s), 9 * s, Paint()..color = const Color(0xFFE8A06A));
    c.drawArc(Rect.fromCircle(center: Offset(-6 * s, -91 * s), radius: 11 * s),
        math.pi * 0.95, math.pi * 1.1, true, Paint()..color = const Color(0xFFF2B705));
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-17 * s, -92 * s, 22 * s, 4 * s),
        Radius.circular(2 * s)), Paint()..color = const Color(0xFFD89B1E));
    c.drawCircle(Offset(-1 * s, -89 * s), 1.3 * s, Paint()..color = const Color(0xFF33221A));

    if (t < 0.56) _tiffinBox(c, -56 * s, -45 * s, s);

    c.restore();
  }

  void _wheel(Canvas c, Offset o, double r) {
    c.drawCircle(o, r, Paint()..color = const Color(0xFF2E2E38));
    c.drawCircle(o, r * 0.58, Paint()..color = const Color(0xFFE9EDF3));
    final spoke = Paint()..color = const Color(0xFF9AA3AF)
      ..strokeWidth = r * 0.14..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final a = _wheelAngle + i * math.pi / 1.5;
      c.drawLine(o - Offset(math.cos(a), math.sin(a)) * r * 0.5,
                 o + Offset(math.cos(a), math.sin(a)) * r * 0.5, spoke);
    }
    c.drawCircle(o, r * 0.16, Paint()..color = const Color(0xFF2E2E38));
  }

  void _tiffinBox(Canvas c, double cx, double cy, double s,
      {double rot = 0, double squash = 1}) {
    c.save();
    c.translate(cx, cy);
    c.rotate(rot);
    c.scale(1 + (1 - squash) * 0.7, squash);
    const tiers = [Color(0xFF1F8A57), Color(0xFFF2A93B), Color(0xFFE23B2E)];
    for (var i = 0; i < 3; i++) {
      final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(-10 * s, -(i + 1) * 8.5 * s, 20 * s, 8 * s), Radius.circular(3 * s));
      c.drawRRect(r, Paint()..color = tiers[i]);
      c.drawRRect(r, Paint()
        ..style = PaintingStyle.stroke..strokeWidth = 1.4 * s..color = const Color(0x5533221A));
    }
    c.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(-11 * s, -3 * 8.5 * s - 4.5 * s, 22 * s, 4.5 * s),
        Radius.circular(2 * s)), Paint()..color = const Color(0xFFC9CED6));
    c.drawArc(Rect.fromLTWH(-4 * s, -3 * 8.5 * s - 12 * s, 8 * s, 9 * s),
        math.pi, math.pi, false,
        Paint()..color = const Color(0xFF2E2E38)..strokeWidth = 2.2 * s);
    c.restore();
  }

  void _tiffinFlight(Canvas c, double w, double groundY, double s) {
    if (t < 0.56) return;
    final sx = 0.46 * w - 56 * s, sy = groundY - 45 * s;
    final ex = w * 0.745, ey = groundY - 8 * s;
    final p = Curves.easeInOut.transform(ph(0.56, 0.68, t));
    if (p < 1) {
      final x = lerp(sx, ex, p);
      final y = lerp(sy, ey, p) - math.sin(p * math.pi) * 82 * s;
      _tiffinBox(c, x, y, s, rot: math.sin(p * math.pi) * 0.55 - p * 0.15);
    } else {
      final squash = 1 - math.sin(ph(0.68, 0.75, t) * math.pi) * 0.22;
      _tiffinBox(c, ex, ey, s, squash: squash);
    }
  }

  void _dust(Canvas c, double w, double groundY, double s) {
    final dp = ph(0.48, 0.60, t);
    if (dp <= 0 || dp >= 1) return;
    final stopX = 0.46 * w;
    for (var i = 0; i < 4; i++) {
      c.drawCircle(Offset(stopX + (i - 1.5) * 15 * s, groundY - 4 * s),
          (5 + dp * 15) * s * (1 + i * 0.18),
          Paint()..color = const Color(0xFFC9B08A).withOpacity((1 - dp) * 0.4));
    }
  }

  void _speedLines(Canvas c, double w, double groundY, double s) {
    if (_speed == 0) return;
    final bx = _bikeX(w);
    final p = Paint()..color = const Color(0x55FFFFFF)..strokeWidth = 3 * s..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final y = groundY - (18 + i * 15) * s;
      c.drawLine(Offset(bx - 62 * s - i * 12 * s, y), Offset(bx - 78 * s - i * 12 * s, y), p);
    }
  }

  void _exhaust(Canvas c, double w, double groundY, double s) {
    if (_speed == 0) return;
    final bx = _bikeX(w);
    for (var i = 0; i < 3; i++) {
      final shift = (t * 900 * s) % (16 * s);
      c.drawCircle(Offset(bx - 68 * s - i * 15 * s - shift, groundY - 12 * s - i * 5 * s),
          (4.5 + i * 2.6) * s,
          Paint()..color = const Color(0xFFD7DBE0).withOpacity(0.42 - i * 0.11));
    }
  }

  void _sparkles(Canvas c, double w, double groundY, double s) {
    final sp = ph(0.66, 0.86, t);
    if (sp <= 0 || sp >= 1) return;
    final center = Offset(w * 0.745, groundY - 70 * s);
    const colors = [Color(0xFFFFD449), Color(0xFFE23B2E), Color(0xFF1F8A57), Color(0xFFFF8A3D)];
    for (var i = 0; i < 12; i++) {
      final a = i * (2 * math.pi / 12) + 0.45;
      final dist = (26 + (i % 3) * 15) * s * Curves.easeOut.transform(sp);
      final p = center + Offset(math.cos(a) * dist, math.sin(a) * dist * 0.85 - sp * 22 * s);
      final r = (3.6 - sp * 2.6) * s;
      final paint = Paint()
        ..color = colors[i % 4].withOpacity(1 - sp)
        ..strokeWidth = r * 0.55..strokeCap = StrokeCap.round;
      c.drawLine(p - Offset(r, 0), p + Offset(r, 0), paint);
      c.drawLine(p - Offset(0, r), p + Offset(0, r), paint);
    }
  }

  void _heart(Canvas c, double w, double groundY, double s) {
    final popP = ph(0.70, 0.78, t);
    final fade = 1 - ph(0.86, 0.94, t);
    if (popP <= 0 || fade <= 0) return;
    c.save();
    c.translate(w * 0.745, groundY - 138 * s - popP * 8 * s);
    c.scale(backOut(popP) * 1.15);
    final r = 11 * s;
    final heart = Path()
      ..moveTo(0, r * 0.38)
      ..cubicTo(-r, -r * 0.28, -r * 0.5, -r, 0, -r * 0.38)
      ..cubicTo(r * 0.5, -r, r, -r * 0.28, 0, r * 0.38);
    c.drawPath(heart, Paint()..color = const Color(0xFFE23B2E).withOpacity(fade));
    c.restore();
  }

  @override
  bool shouldRepaint(covariant DeliverySplashPainter old) => old.t != t;
}