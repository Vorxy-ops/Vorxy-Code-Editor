    import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentFile),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: AppTheme.accentGold),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Файл сохранён')),
              );
            },
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
