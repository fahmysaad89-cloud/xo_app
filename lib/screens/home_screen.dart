import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/app_theme.dart';
import '../widgets/app_background.dart';
import '../widgets/menu_button.dart';
import '../widgets/xo_logo.dart';
import 'setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _play(BuildContext context) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SetupScreen()));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const XoLogo(size: 220),
                      const SizedBox(height: 8),
                      Text('Tic Tac Toe', style: AppTheme.title(42)),
                      const SizedBox(height: 40),
                      MenuButton(
                        label: 'Play Game',
                        icon: Icons.play_arrow_rounded,
                        type: MenuButtonType.primary,
                        onTap: () => _play(context),
                      ),
                      const SizedBox(height: 14),
                      MenuButton(
                        label: 'Settings',
                        icon: Icons.settings,
                        onTap: () {}, // TODO: شاشة الإعدادات
                      ),
                      const SizedBox(height: 14),
                      MenuButton(
                        label: 'About',
                        icon: Icons.info,
                        onTap: () => showAboutDialog(
                          context: context,
                          applicationName: 'Tic Tac Toe',
                          applicationVersion: '1.0.0',
                        ),
                      ),
                    ].animate(interval: 90.ms).fadeIn(duration: 400.ms),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
