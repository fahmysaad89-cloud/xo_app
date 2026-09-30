import 'dart:math';

import 'package:flutter/foundation.dart';

import 'game_config.dart';
import 'stats_service.dart';

enum Player { x, o }

class GameController extends ChangeNotifier {
  GameController(this._stats, this.config) {
    final a = _stats.scoreA(_key), b = _stats.scoreB(_key);
    xScore = _aIsX ? a : b;
    oScore = _aIsX ? b : a;
    if (_cpuStarts) _computerMove();
  }

  final StatsService _stats;
  final GameConfig config;
  final _rng = Random();

  static const _lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  List<Player?> board = List.filled(9, null);
  Player current = Player.x;
  Player? winner;
  bool isDraw = false;
  bool thinking = false;
  List<int> winLine = [];
  late int xScore;
  late int oScore;

  int _token = 0;
  bool _disposed = false;

  String get _key => config.vsComputer ? 'cpu' : 'pvp';
  bool get _aIsX => !config.vsComputer || config.human == Player.x;
  Player get cpu => config.human == Player.x ? Player.o : Player.x;
  bool get _cpuStarts => config.vsComputer && config.human == Player.o;
  bool get isOver => winner != null || isDraw;
  bool get isComputerTurn => config.vsComputer && !isOver && current == cpu;

  void play(int i) {
    if (board[i] != null || isOver || isComputerTurn || thinking) return;
    _place(i);
    if (isComputerTurn) _computerMove();
  }

  void _place(int i) {
    board[i] = current;
    _check();
    if (!isOver) current = current == Player.x ? Player.o : Player.x;
    notifyListeners();
  }

  Future<void> _computerMove() async {
    final token = _token;
    thinking = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 650));
    if (_disposed || token != _token || isOver) return;
    thinking = false;
    _place(_pickMove());
  }

  void _check() {
    final line = _lineOf(board);
    if (line != null) {
      winner = board[line[0]];
      winLine = line;
      winner == Player.x ? xScore++ : oScore++;
      _stats.saveScores(_key, _aIsX ? xScore : oScore, _aIsX ? oScore : xScore);
      _stats.record(
        won: config.vsComputer ? winner == config.human : winner == Player.x,
      );
    } else if (board.every((c) => c != null)) {
      isDraw = true;
      _stats.record();
    }
  }

  int _pickMove() {
    final empty = [
      for (var i = 0; i < 9; i++)
        if (board[i] == null) i,
    ];
    final human = config.human;
    switch (config.difficulty) {
      case Difficulty.easy:
        return empty[_rng.nextInt(empty.length)];
      case Difficulty.medium:
        return _findWin(cpu) ??
            _findWin(human) ??
            empty[_rng.nextInt(empty.length)];
      case Difficulty.hard:
        if (empty.length == 9) return [0, 2, 6, 8][_rng.nextInt(4)];
        var best = -100, move = empty.first;
        for (final i in empty) {
          board[i] = cpu;
          final s = _minimax(board, human, 1);
          board[i] = null;
          if (s > best) {
            best = s;
            move = i;
          }
        }
        return move;
    }
  }

  int? _findWin(Player p) {
    for (var i = 0; i < 9; i++) {
      if (board[i] != null) continue;
      board[i] = p;
      final win = _lineOf(board) != null;
      board[i] = null;
      if (win) return i;
    }
    return null;
  }

  int _minimax(List<Player?> b, Player turn, int depth) {
    final line = _lineOf(b);
    if (line != null) return b[line[0]] == cpu ? 10 - depth : depth - 10;
    if (b.every((c) => c != null)) return 0;
    final next = turn == Player.x ? Player.o : Player.x;
    var best = turn == cpu ? -100 : 100;
    for (var i = 0; i < 9; i++) {
      if (b[i] != null) continue;
      b[i] = turn;
      final s = _minimax(b, next, depth + 1);
      b[i] = null;
      best = turn == cpu ? max(best, s) : min(best, s);
    }
    return best;
  }

  List<int>? _lineOf(List<Player?> b) {
    for (final l in _lines) {
      final a = b[l[0]];
      if (a != null && a == b[l[1]] && a == b[l[2]]) return l;
    }
    return null;
  }

  void resetRound() {
    _token++;
    thinking = false;
    board = List.filled(9, null);
    current = Player.x;
    winner = null;
    isDraw = false;
    winLine = [];
    notifyListeners();
    if (_cpuStarts) _computerMove();
  }

  void resetAll() {
    xScore = 0;
    oScore = 0;
    _stats.saveScores(_key, 0, 0);
    resetRound();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
