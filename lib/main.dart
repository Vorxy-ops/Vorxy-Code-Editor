import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/files_screen.dart';
import 'screens/languages_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const VorxyCodeEditor());
}

class VorxyCodeEditor extends StatefulWidget {
  const VorxyCodeEditor({super.key});

  @override
  State<VorxyCodeEditor> createState() => _VorxyCodeEditorState();
}

class _VorxyCodeEditorState extends State<VorxyCodeEditor> {
  bool _isDarkMode = true;
  String _currentLanguage = 'ru';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? true;
      _currentLanguage = prefs.getString('language') ?? 'ru';
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _changeLanguage(String langCode) {
    setState(() {
      _currentLanguage = langCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vorxy Code Editor',
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: SplashScreen(
        onThemeChanged: _toggleTheme,
        onLanguageChanged: _changeLanguage,
        currentLanguage: _currentLanguage,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomeScreen(
              onThemeChanged: _toggleTheme,
              onLanguageChanged: _changeLanguage,
              currentLanguage: _currentLanguage,
            ),
        '/settings': (context) => SettingsScreen(
              currentLanguage: _currentLanguage,
              onThemeChanged: _toggleTheme,
              onLanguageChanged: _changeLanguage,
            ),
        '/editor': (context) => EditorScreen(
              currentLanguage: _currentLanguage,
            ),
        '/files': (context) => FilesScreen(
              currentLanguage: _currentLanguage,
            ),
        '/languages': (context) => LanguagesScreen(
              currentLanguage: _currentLanguage,
            ),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;
  final String currentLanguage;

  const SplashScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.currentLanguage,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Vorxy Code Editor',
              style: const TextStyle(
                color: Color(0xFFFFEB3B),
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'sans-serif',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'developed by GOSTOWN Co.',
              style: const TextStyle(
                color: Color(0xFFFFEB3B),
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
