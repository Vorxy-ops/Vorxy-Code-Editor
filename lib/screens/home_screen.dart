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

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _currentLanguage = 'ru';
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('language') ?? 'ru';
      _pages = [
        LanguagesScreen(currentLanguage: _currentLanguage),
        EditorScreen(currentLanguage: _currentLanguage),
        FilesScreen(currentLanguage: _currentLanguage),
        SettingsScreen(
          currentLanguage: _currentLanguage,
          onThemeChanged: widget.onThemeChanged,
        ),
      ];
    });
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[_currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.isNotEmpty ? _pages[_selectedIndex] : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.code), label: _getTranslation('languages')),
          BottomNavigationBarItem(icon: const Icon(Icons.edit), label: _getTranslation('editor')),
          BottomNavigationBarItem(icon: const Icon(Icons.folder), label: _getTranslation('files')),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: _getTranslation('settings')),
        ],
      ),
    );
  }
}
