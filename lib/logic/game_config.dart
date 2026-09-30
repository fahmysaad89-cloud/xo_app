import 'game_controller.dart';

enum Difficulty { easy, medium, hard }

class GameConfig {
  const GameConfig({
    this.vsComputer = true,
    this.human = Player.x,
    this.difficulty = Difficulty.medium,
  });

  final bool vsComputer;
  final Player human;
  final Difficulty difficulty;
}
