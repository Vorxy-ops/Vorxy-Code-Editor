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

  @override
  void initState() {
    super.initState();
    _loadThemeAndPermission();
  }

  Future<void> _loadThemeAndPermission() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? true;
    });
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      await _requestPermissions();
    }
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vorxy Code Editor',
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: SplashScreen(onThemeChanged: _toggleTheme),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomeScreen(onThemeChanged: _toggleTheme),
        '/settings': (context) => SettingsScreen(
              currentLanguage: 'ru',
              onThemeChanged: _toggleTheme,
            ),
        '/editor': (context) => const EditorScreen(currentLanguage: 'ru'),
        '/files': (context) => const FilesScreen(currentLanguage: 'ru'),
        '/languages': (context) => const LanguagesScreen(currentLanguage: 'ru'),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SplashScreen({super.key, required this.onThemeChanged});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissionsAndNavigate();
  }

  Future<void> _checkPermissionsAndNavigate() async {
    final status = await Permission.manageExternalStorage.status;
    if (status.isGranted) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      final newStatus = await Permission.manageExternalStorage.request();
      if (newStatus.isGranted) {
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _checkPermissionsAndNavigate();
      }
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
