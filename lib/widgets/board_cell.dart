import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/app_colors.dart';
import '../logic/game_controller.dart';
import 'marks.dart';

class BoardCell extends StatelessWidget {
  const BoardCell({
    super.key,
    required this.player,
    required this.highlight,
    required this.onTap,
  });

  final Player? player;
  final bool highlight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final glow = player == Player.o ? AppColors.pink : AppColors.blue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: highlight ? glow : AppColors.border, width: highlight ? 2 : 1),
          boxShadow: highlight
              ? [BoxShadow(color: glow.withValues(alpha: 0.5), blurRadius: 16)]
              : null,
        ),
        child: LayoutBuilder(
          builder: (_, box) {
            final s = box.maxWidth * 0.62;
            if (player == null) return const SizedBox.shrink();
            final mark = player == Player.x ? XMark(size: s) : OMark(size: s);
            return Center(
              child: mark.animate().scale(
                    begin: const Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeOutBack,
                  ),
            );
          },
        ),
      ),
    );
  }
}
