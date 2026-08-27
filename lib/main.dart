import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/files_screen.dart';
import 'screens/languages_screen.dart';
import 'screens/output_screen.dart';
import 'screens/web_preview_screen.dart';
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
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vorxy Code Editor',
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: HomeScreen(
        onThemeChanged: (isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/settings': (context) => const SettingsScreen(currentLanguage: 'ru', onThemeChanged: null),
        '/editor': (context) => const EditorScreen(currentLanguage: 'ru'),
        '/files': (context) => const FilesScreen(currentLanguage: 'ru'),
        '/languages': (context) => const LanguagesScreen(currentLanguage: 'ru'),
        '/output': (context) => const OutputScreen(currentLanguage: 'ru'),
        '/web_preview': (context) => const WebPreviewScreen(
              htmlCode: '',
              cssCode: '',
              jsCode: '',
              currentLanguage: 'ru',
            ),
      },
    );
  }
}
