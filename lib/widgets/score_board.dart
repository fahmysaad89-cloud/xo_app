import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../logic/game_controller.dart';
import 'marks.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.xScore,
    required this.oScore,
    required this.current,
    this.xLabel = 'Player X',
    this.oLabel = 'Player O',
  });

  final String xLabel, oLabel;
  final int xScore, oScore;
  final Player current;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: _Side(
                mark: const XMark(size: 24),
                label: xLabel,
                score: xScore,
                active: current == Player.x,
              ),
            ),
            Container(width: 1, height: 38, color: AppColors.border),
            Expanded(
              child: _Side(
                mark: const OMark(size: 24),
                label: oLabel,
                score: oScore,
                active: current == Player.o,
              ),
            ),
          ],
        ),
      );
}

class _Side extends StatelessWidget {
  const _Side({
    required this.mark,
    required this.label,
    required this.score,
    required this.active,
  });

  final Widget mark;
  final String label;
  final int score;
  final bool active;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: active ? 1 : 0.55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mark,
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: AppColors.textDim, fontSize: 12)),
                Text('$score',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      );
}
