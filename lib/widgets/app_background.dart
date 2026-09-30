import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'marks.dart';

/// خلفية متدرجة + علامات X و O باهتة زي التصميم
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});
  final Widget child;

  Widget _deco(Widget w, double angle) =>
      Opacity(opacity: 0.07, child: Transform.rotate(angle: angle, child: w));

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bg],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 70, left: -25, child: _deco(const XMark(size: 90), -0.3)),
            Positioned(top: 90, right: -30, child: _deco(const OMark(size: 100), 0)),
            Positioned(bottom: 70, left: -20, child: _deco(const OMark(size: 90), 0)),
            Positioned(bottom: 40, right: -20, child: _deco(const XMark(size: 90), 0.4)),
            child,
          ],
        ),
      );
}
