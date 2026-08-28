import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _code = 'print("Hello, Vorxy Code Editor!")\n\nfor i in range(5):\n    print(i)';
  String _language = 'Python';
  String _currentFile = 'main.py';
  String _currentFilePath = '';

  @override
  void initState() {
    super.initState();
    _loadLastFile();
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
            _currentFilePath = path;
            _currentFile = path.split('/').last;
          });
        }
      }
    } catch (e) {}
  }

  Future<void> _saveFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = _currentFilePath.isNotEmpty
          ? _currentFilePath
          : '${dir.path}/${_currentFile}';
      final file = File(filePath);
      await file.writeAsString(_code);
      setState(() {
        _currentFilePath = filePath;
        _currentFile = filePath.split('/').last;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastFilePath', filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Файл сохранён')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    }
  }

  Future<void> _createNewFile() async {
    final fileName = await _showFileNameDialog('Новый файл');
    if (fileName == null || fileName.isEmpty) return;
    setState(() {
      _currentFile = fileName;
      _code = '';
      _currentFilePath = '';
    });
  }

  Future<void> _openFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final files = dir.listSync();
      if (files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Нет файлов для открытия')),
        );
        return;
      }
      final selected = await _showFilePicker(files);
      if (selected != null) {
        final content = await selected.readAsString();
        setState(() {
          _code = content;
          _currentFile = selected.path.split('/').last;
          _currentFilePath = selected.path;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lastFilePath', selected.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка открытия: $e')),
      );
    }
  }

  Future<String?> _showFileNameDialog(String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardPurple,
        title: Text(title, style: const TextStyle(color: AppTheme.accentGold)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'main.dart',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  Future<File?> _showFilePicker(List<FileSystemEntity> files) async {
    return showDialog<File>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardPurple,
        title: const Text('Выберите файл', style: TextStyle(color: AppTheme.accentGold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              if (file is File) {
                return ListTile(
                  title: Text(
                    file.path.split('/').last,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context, file),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentFile),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open, color: AppTheme.accentGold),
            onPressed: _openFile,
            tooltip: 'Открыть файл',
          ),
          IconButton(
            icon: const Icon(Icons.save, color: AppTheme.accentGold),
            onPressed: _saveFile,
            tooltip: 'Сохранить',
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
                      if (_language == 'HTML') {
                        _code = '<!DOCTYPE html>\n<html>\n<head>\n    <title>My Page</title>\n</head>\n<body>\n    <h1>Hello, World!</h1>\n</body>\n</html>';
                      }
                    });
                  },
                ),
                const Spacer(),
                Text(
                  'Строк: ${_code.split('\n').length}',
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
