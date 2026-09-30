import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'logic/stats_service.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final stats = StatsService();
  await stats.init();
  runApp(Provider<StatsService>.value(value: stats, child: const XoApp()));
}

class XoApp extends StatelessWidget {
  const XoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tic Tac Toe',
        theme: AppTheme.dark,
        home: const SplashScreen(),
      );
}
