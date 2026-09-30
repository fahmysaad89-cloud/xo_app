import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../logic/game_controller.dart';
import 'marks.dart';
import 'menu_button.dart';

Future<void> showResultDialog(
  BuildContext context, {
  required Player? winner,
  required String title,
  required String subtitle,
  required VoidCallback onPlayAgain,
  required VoidCallback onHome,
}) =>
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => ResultDialog(
        winner: winner,
        title: title,
        subtitle: subtitle,
        onPlayAgain: onPlayAgain,
        onHome: onHome,
      ),
    );

class ResultDialog extends StatefulWidget {
  const ResultDialog({
    super.key,
    required this.winner,
    required this.title,
    required this.subtitle,
    required this.onPlayAgain,
    required this.onHome,
  });

  final Player? winner;
  final String title, subtitle;
  final VoidCallback onPlayAgain, onHome;

  @override
  State<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    if (widget.winner != null) _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.winner;
    final title = widget.title;
    final subtitle = widget.subtitle;
    final color = w == null
        ? Colors.white
        : w == Player.x
            ? AppColors.cyan
            : AppColors.pink;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ),
                if (w == Player.x) const XMark(size: 80),
                if (w == Player.o) const OMark(size: 80),
                if (w == null)
                  const Icon(Icons.handshake_rounded, size: 72, color: Colors.white70),
                const SizedBox(height: 12),
                Text(title, style: AppTheme.title(30, color: color)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textDim)),
                const SizedBox(height: 24),
                MenuButton(
                  label: 'Play Again',
                  icon: Icons.refresh_rounded,
                  type: MenuButtonType.accent,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onPlayAgain();
                  },
                ),
                const SizedBox(height: 12),
                MenuButton(
                  label: 'Home',
                  icon: Icons.home_rounded,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onHome();
                  },
                ),
              ],
            ),
          ),
          ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 18,
            gravity: 0.25,
            colors: const [AppColors.pink, AppColors.blue, AppColors.cyan],
          ),
        ],
      ),
    );
  }
}
