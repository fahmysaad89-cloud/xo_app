import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../logic/game_config.dart';
import '../logic/game_controller.dart';
import '../logic/stats_service.dart';
import '../widgets/app_background.dart';
import '../widgets/marks.dart';
import '../widgets/menu_button.dart';
import '../widgets/selector_option.dart';
import 'game_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool _vsComputer = true;
  Player _human = Player.x;
  Difficulty _difficulty = Difficulty.medium;

  void _start() {
    final stats = context.read<StatsService>();
    final config = GameConfig(
      vsComputer: _vsComputer,
      human: _human,
      difficulty: _difficulty,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => GameController(stats, config),
          child: const GameScreen(),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 10),
        child: Text(t, style: const TextStyle(color: AppColors.textDim, fontSize: 14)),
      );

  Widget _text(String t) => Text(t,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.chevron_left, size: 30),
                          ),
                          const Spacer(),
                          Text('New Game', style: AppTheme.title(32)),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
                      _label('Mode'),
                      Row(children: [
                        Expanded(
                          child: SelectorOption(
                            selected: !_vsComputer,
                            onTap: () => setState(() => _vsComputer = false),
                            child: _text('2 Players'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SelectorOption(
                            selected: _vsComputer,
                            onTap: () => setState(() => _vsComputer = true),
                            child: _text('vs Computer'),
                          ),
                        ),
                      ]),
                      if (_vsComputer) ...[
                        _label('Choose your side'),
                        Row(children: [
                          Expanded(
                            child: SelectorOption(
                              selected: _human == Player.x,
                              onTap: () => setState(() => _human = Player.x),
                              child: const XMark(size: 34),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SelectorOption(
                              selected: _human == Player.o,
                              color: AppColors.pink,
                              onTap: () => setState(() => _human = Player.o),
                              child: const OMark(size: 34),
                            ),
                          ),
                        ]),
                        _label('Difficulty'),
                        Row(
                          children: [
                            for (final d in Difficulty.values) ...[
                              Expanded(
                                child: SelectorOption(
                                  selected: _difficulty == d,
                                  onTap: () => setState(() => _difficulty = d),
                                  child: _text(switch (d) {
                                    Difficulty.easy => 'Easy',
                                    Difficulty.medium => 'Medium',
                                    Difficulty.hard => 'Hard',
                                  }),
                                ),
                              ),
                              if (d != Difficulty.hard) const SizedBox(width: 10),
                            ],
                          ],
                        ),
                      ],
                      const SizedBox(height: 40),
                      MenuButton(
                        label: 'Start',
                        icon: Icons.play_arrow_rounded,
                        type: MenuButtonType.primary,
                        onTap: _start,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
