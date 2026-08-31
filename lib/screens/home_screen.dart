import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'editor_screen.dart';
import 'files_screen.dart';
import 'languages_screen.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;
  final String currentLanguage;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.currentLanguage,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.currentLanguage;
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLanguage != widget.currentLanguage) {
      setState(() {
        _currentLanguage = widget.currentLanguage;
      });
    }
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[_currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LanguagesScreen(currentLanguage: _currentLanguage),
      EditorScreen(currentLanguage: _currentLanguage),
      FilesScreen(currentLanguage: _currentLanguage),
      SettingsScreen(
        currentLanguage: _currentLanguage,
        onThemeChanged: widget.onThemeChanged,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.description),
            label: _getTranslation('languages'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.code),
            label: _getTranslation('editor'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder),
            label: _getTranslation('files'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: _getTranslation('settings'),
          ),
        ],
      ),
    );
  }
}
