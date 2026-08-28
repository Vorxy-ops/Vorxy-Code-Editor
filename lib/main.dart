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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/settings': (context) => const SettingsScreen(currentLanguage: 'ru'),
        '/editor': (context) => const EditorScreen(currentLanguage: 'ru'),
        '/files': (context) => const FilesScreen(currentLanguage: 'ru'),
        '/languages': (context) => const LanguagesScreen(currentLanguage: 'ru'),
      },
    );
  }
}
