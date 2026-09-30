import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class SelectorOption extends StatelessWidget {
  const SelectorOption({
    super.key,
    required this.child,
    required this.selected,
    required this.onTap,
    this.color = AppColors.blue,
  });

  final Widget child;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? color : AppColors.border,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 14)]
            : null,
      ),
      child: Opacity(opacity: selected ? 1 : 0.6, child: child),
    ),
  );
}
