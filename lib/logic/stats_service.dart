import 'package:hive_flutter/hive_flutter.dart';

/// كل الإحصائيات والسكور محفوظة في Hive.
class StatsService {
  late final Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('stats');
  }

  int get matches => _box.get('matches', defaultValue: 0) as int;
  int get wins => _box.get('wins', defaultValue: 0) as int;
  int get losses => _box.get('losses', defaultValue: 0) as int;

  Future<void> record({bool? won}) async {
    await _box.put('matches', matches + 1);
    if (won == true) await _box.put('wins', wins + 1);
    if (won == false) await _box.put('losses', losses + 1);
  }

  int scoreA(String key) => _box.get('score_${key}_a', defaultValue: 0) as int;
  int scoreB(String key) => _box.get('score_${key}_b', defaultValue: 0) as int;

  Future<void> saveScores(String key, int a, int b) async {
    await _box.put('score_${key}_a', a);
    await _box.put('score_${key}_b', b);
  }
}
