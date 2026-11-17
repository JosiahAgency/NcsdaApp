import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

double _lerp(double a, double b, double t) => a + (b - a) * t;

/// Painted dusk over the Nairobi horizon: sky gradient, sun, two ridges and
/// flat-topped acacias. [progress] 0..1 moves from morning to sunset;
/// [night] shows the afterglow and stars (Sabbath hours).
class SkyPainter extends CustomPainter {
  const SkyPainter({required this.progress, required this.night});

  final double progress;
  final bool night;

  static double _nearY(double x, Size s) {
    final u = x / s.width * math.pi * 2;
    return s.height * 0.88 - 9 * math.sin(u * 1.3 + 1.0) - 4 * math.sin(u * 3.1);
  }

  static double _farY(double x, Size s) {
    final u = x / s.width * math.pi * 2;
    return s.height * 0.79 - 14 * math.sin(u * 0.9 + 2.2) - 5 * math.sin(u * 2.3 + 0.4);
  }

  static Path _hill(Size s, double Function(double, Size) y) {
    final path = Path()
      ..moveTo(0, s.height)
      ..lineTo(0, y(0, s));
    for (double x = 4; x <= s.width; x += 4) {
      path.lineTo(x, y(x, s));
    }
    path
      ..lineTo(s.width, s.height)
      ..close();
    return path;
  }

  static void _acacia(Canvas c, Offset base, double k, Paint paint) {
    c.save();
    c.translate(base.dx, base.dy + 2);
    c.scale(k);
    final trunk = Path()
      ..moveTo(-2, 0)
      ..quadraticBezierTo(-4, -18, 2, -32)
      ..lineTo(6, -32)
      ..quadraticBezierTo(1, -16, 3, 0)
      ..close();
    c.drawPath(trunk, paint);
    c.drawOval(Rect.fromCenter(center: const Offset(4, -36), width: 66, height: 12), paint);
    c.drawOval(Rect.fromCenter(center: const Offset(-8, -31), width: 34, height: 9), paint);
    c.drawOval(Rect.fromCenter(center: const Offset(22, -32), width: 32, height: 8), paint);
    c.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = night ? 1.0 : progress;
    final rect = Offset.zero & size;

    final top = Color.lerp(const Color(0xFF2F5C9E), const Color(0xFF0E2A57), p)!;
    final mid = Color.lerp(const Color(0xFF8FB4DE), const Color(0xFF6B4E7A), p)!;
    final low = Color.lerp(const Color(0xFFF2E3BF), const Color(0xFFE8A55B), p)!;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, mid, low],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    if (night) {
      final rnd = math.Random(7);
      for (var i = 0; i < 30; i++) {
        final o = Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height * 0.55);
        final star = Paint()..color = Colors.white.withValues(alpha: 0.35 + rnd.nextDouble() * 0.5);
        canvas.drawCircle(o, 0.6 + rnd.nextDouble() * 1.1, star);
      }
    }

    final horizon = size.height * 0.80;
    const r = 24.0;
    final cx = size.width * 0.8;
    final cy = night
        ? horizon + r * 1.4
        : _lerp(size.height * 0.2, horizon - r * 0.3, math.pow(p, 1.4).toDouble());
    final center = Offset(cx, cy);

    canvas.drawCircle(
      center,
      140,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFD27A).withValues(alpha: night ? 0.35 : 0.6),
            const Color(0x00FFD27A),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: 140)),
    );
    if (!night) canvas.drawCircle(center, r, Paint()..color = const Color(0xFFFFEBB8));

    canvas.drawPath(
      _hill(size, _farY),
      Paint()..color = Color.lerp(const Color(0xFF7C8FB3), const Color(0xFF3A3F6B), p)!,
    );
    final nearPaint = Paint()
      ..color = Color.lerp(const Color(0xFF1F3B63), const Color(0xFF081A38), p)!;
    canvas.drawPath(_hill(size, _nearY), nearPaint);

    final x1 = size.width * 0.13;
    final x2 = size.width * 0.9;
    _acacia(canvas, Offset(x1, _nearY(x1, size)), 1.0, nearPaint);
    _acacia(canvas, Offset(x2, _nearY(x2, size)), 0.6, nearPaint);
  }

  @override
  bool shouldRepaint(SkyPainter old) => old.progress != progress || old.night != night;
}
