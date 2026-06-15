import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/timer_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const FocusTimerApp());
}

class FocusTimerApp extends StatelessWidget {
  const FocusTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Timer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const TimerScreen(),
    );
  }
}
