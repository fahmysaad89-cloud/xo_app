import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'marks.dart';

class XoLogo extends StatelessWidget {
  const XoLogo({super.key, this.size = 220});
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size * 0.85,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                XMark(size: size * 0.48),
                SizedBox(width: size * 0.02),
                OMark(size: size * 0.48),
              ],
            ),
          ],
        ),
      );
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()
      ..color = AppColors.blue.withValues(alpha: 0.55)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final x in [0.3, 0.7]) {
      c.drawLine(Offset(s.width * x, 0), Offset(s.width * x, s.height), p);
    }
    for (final y in [0.25, 0.75]) {
      c.drawLine(Offset(0, s.height * y), Offset(s.width, s.height * y), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
