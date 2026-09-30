import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../logic/game_controller.dart';
import '../widgets/app_background.dart';
import '../widgets/game_board.dart';
import '../widgets/result_dialog.dart';
import '../widgets/score_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _game;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _game = context.read<GameController>();
    _game.addListener(_onChange);
  }

  @override
  void dispose() {
    _game.removeListener(_onChange);
    super.dispose();
  }

  Future<void> _onChange() async {
    if (!_game.isOver || _dialogShown) return;
    _dialogShown = true;
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted || !_game.isOver) {
      _dialogShown = false;
      return;
    }
    final w = _game.winner;
    final cfg = _game.config;
    late final String title, sub;
    if (w == null) {
      title = "It's a Draw!";
      sub = 'Well played!';
    } else if (cfg.vsComputer) {
      final won = w == cfg.human;
      title = won ? 'You Win!' : 'Computer Wins!';
      sub = won ? 'Great job!' : 'Better luck next time!';
    } else {
      title = 'Player ${w == Player.x ? 'X' : 'O'} Wins!';
      sub = 'Great job!';
    }
    showResultDialog(
      context,
      winner: w,
      title: title,
      subtitle: sub,
      onPlayAgain: _game.resetRound,
      onHome: () => Navigator.of(context).popUntil((r) => r.isFirst),
    ).then((_) => _dialogShown = false);
  }

  @override
  Widget build(BuildContext context) {
    final g = context.watch<GameController>();
    final cfg = g.config;
    final youX = cfg.human == Player.x;
    final xLabel = cfg.vsComputer ? (youX ? 'You' : 'Computer') : 'Player X';
    final oLabel = cfg.vsComputer ? (youX ? 'Computer' : 'You') : 'Player O';
    final turnText = cfg.vsComputer
        ? (g.thinking ? 'Computer is thinking...' : 'Your Turn')
        : "Player ${g.current == Player.x ? 'X' : 'O'}'s Turn";

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.chevron_left, size: 30),
                        ),
                        Text('Tic Tac Toe', style: AppTheme.title(28)),
                        IconButton(
                          onPressed: g.resetAll,
                          icon: const Icon(Icons.replay),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ScoreBoard(
                      xScore: g.xScore,
                      oScore: g.oScore,
                      current: g.current,
                      xLabel: xLabel,
                      oLabel: oLabel,
                    ),
                    const SizedBox(height: 36),
                    const GameBoard(),
                    const SizedBox(height: 28),
                    Text(
                      turnText,
                      style: const TextStyle(
                        color: AppColors.textDim,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
