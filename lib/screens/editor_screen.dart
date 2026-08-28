import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/code_editor_widget.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class EditorScreen extends StatefulWidget {
  final String currentLanguage;

  const EditorScreen({super.key, required this.currentLanguage});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String _code = '';
  String _language = 'Python';
  String _currentFile = 'main.py';

  @override
  void initState() {
    super.initState();
    _loadLastFile();
  }

  String _getExtension(String language) {
    switch (language) {
      case 'Python': return '.py';
      case 'JavaScript': return '.js';
      case 'C': return '.c';
      case 'C++': return '.cpp';
      case 'Java': return '.java';
      case 'C#': return '.cs';
      case 'Visual Basic': return '.vb';
      case 'SQL': return '.sql';
      case 'R': return '.r';
      case 'Rust': return '.rs';
      case 'HTML': return '.html';
      default: return '.txt';
    }
  }

  Future<void> _loadLastFile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('lastFilePath');
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          final content = await file.readAsString();
          setState(() {
            _code = content;
            _currentFile = path.split('/').last;
          });
        }
      }
    } catch (e) {}
  }

  Future<void> _saveFile() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return;
      final fileName = _currentFile.isEmpty ? 'main${_getExtension(_language)}' : _currentFile;
      final filePath = '$selectedDirectory/$fileName';
      final file = File(filePath);
      await file.writeAsString(_code);
      setState(() {
        _currentFile = fileName;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastFilePath', filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('file_saved')}: $fileName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('error')}: $e')),
      );
    }
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentFile.isEmpty ? '${_getTranslation('editor')} (${_getTranslation('code_ready')})' : _currentFile),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: AppTheme.accentGold),
            onPressed: _saveFile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Язык: ', style: TextStyle(color: Colors.grey)),
                DropdownButton<String>(
                  value: _language,
                  dropdownColor: AppTheme.cardPurple,
                  style: const TextStyle(color: AppTheme.accentGold),
                  underline: Container(height: 1, color: AppTheme.accentGold),
                  items: const [
                    DropdownMenuItem(value: 'Python', child: Text('Python')),
                    DropdownMenuItem(value: 'JavaScript', child: Text('JavaScript')),
                    DropdownMenuItem(value: 'C', child: Text('C')),
                    DropdownMenuItem(value: 'C++', child: Text('C++')),
                    DropdownMenuItem(value: 'Java', child: Text('Java')),
                    DropdownMenuItem(value: 'C#', child: Text('C#')),
                    DropdownMenuItem(value: 'R', child: Text('R')),
                    DropdownMenuItem(value: 'Rust', child: Text('Rust')),
                    DropdownMenuItem(value: 'SQL', child: Text('SQL')),
                    DropdownMenuItem(value: 'Visual Basic', child: Text('Visual Basic')),
                    DropdownMenuItem(value: 'HTML', child: Text('HTML')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _language = value!;
                      if (_language == 'HTML' && _code.isEmpty) {
                        _code = '<!DOCTYPE html>\n<html>\n<head>\n    <title>My Page</title>\n</head>\n<body>\n    <h1>Hello, World!</h1>\n</body>\n</html>';
                      }
                      _currentFile = 'main${_getExtension(_language)}';
                    });
                  },
                ),
                const Spacer(),
                Text(
                  '${_code.split('\n').length} ${_getTranslation('line')}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CodeEditorWidget(
                code: _code,
                language: _language,
                currentLanguage: widget.currentLanguage,
                onCodeChanged: (newCode) {
                  setState(() {
                    _code = newCode;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
