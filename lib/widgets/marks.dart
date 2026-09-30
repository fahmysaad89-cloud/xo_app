import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class XMark extends StatelessWidget {
  const XMark({super.key, this.size = 48});
  final double size;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: CustomPaint(painter: _XPainter()));
}

class OMark extends StatelessWidget {
  const OMark({super.key, this.size = 48});
  final double size;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: CustomPaint(painter: _OPainter()));
}

Paint _base(Size s, List<Color> colors, double w) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeWidth = w
  ..shader = LinearGradient(
    colors: colors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(Offset.zero & s);

Paint _glow(Color c, double w) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeWidth = w
  ..color = c.withValues(alpha: 0.45)
  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

class _XPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final w = s.width * 0.22;
    final m = s.width * 0.16;
    final a = [Offset(m, m), Offset(s.width - m, s.height - m)];
    final b = [Offset(s.width - m, m), Offset(m, s.height - m)];
    final glow = _glow(AppColors.blue, w);
    final p = _base(s, [AppColors.cyan, AppColors.blue], w);
    for (final l in [a, b]) {
      c.drawLine(l[0], l[1], glow);
      c.drawLine(l[0], l[1], p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _OPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final w = s.width * 0.2;
    final center = s.center(Offset.zero);
    final r = s.width / 2 - w / 2 - s.width * 0.06;
    c.drawCircle(center, r, _glow(AppColors.pink, w));
    c.drawCircle(center, r, _base(s, [const Color(0xFFFF6FA8), AppColors.pinkDark], w));
  }

  @override
  bool shouldRepaint(_) => false;
}
