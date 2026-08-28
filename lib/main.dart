import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/files_screen.dart';
import 'screens/languages_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const VorxyCodeEditor());
}

class VorxyCodeEditor extends StatelessWidget {
  const VorxyCodeEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vorxy Code Editor',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(currentLanguage: 'ru'),
        '/editor': (context) => const EditorScreen(currentLanguage: 'ru'),
        '/files': (context) => const FilesScreen(currentLanguage: 'ru'),
        '/languages': (context) => const LanguagesScreen(currentLanguage: 'ru'),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: Center(
        child: Text(
          'Vorxy Code Editor',
          style: TextStyle(
            color: const Color(0xFFFFEB3B),
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'sans-serif',
          ),
        ),
      ),
    );
  }
}
