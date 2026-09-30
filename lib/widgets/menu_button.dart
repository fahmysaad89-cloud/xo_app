import 'package:flutter/material.dart';

import '../core/app_colors.dart';

enum MenuButtonType { primary, accent, outline }

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.type = MenuButtonType.outline,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final MenuButtonType type;

  @override
  Widget build(BuildContext context) {
    final gradient = switch (type) {
      MenuButtonType.primary => const [AppColors.cyan, AppColors.blue],
      MenuButtonType.accent => const [Color(0xFFFF5C9F), AppColors.pinkDark],
      MenuButtonType.outline => null,
    };
    final glowColor = type == MenuButtonType.accent ? AppColors.pink : AppColors.blue;

    return Container(
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: gradient == null ? null : LinearGradient(colors: gradient),
        color: gradient == null ? AppColors.surface : null,
        border: gradient == null ? Border.all(color: AppColors.border) : null,
        boxShadow: gradient == null
            ? null
            : [BoxShadow(color: glowColor.withValues(alpha: 0.45), blurRadius: 18)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
