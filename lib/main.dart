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
    if (!status
