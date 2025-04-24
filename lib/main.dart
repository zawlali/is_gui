import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scholar_jim/screens/splash_screen.dart';
import 'package:scholar_jim/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scholar Jim',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: const SplashScreen(),
    );
  }
}
