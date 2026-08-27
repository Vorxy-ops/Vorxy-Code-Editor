import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/code_editor_widget.dart';
import '../services/compiler_service.dart';
import '../services/git_service.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import 'web_preview_screen.dart';

class EditorScreen extends StatefulWidget {
  final String currentLanguage;

  const EditorScreen({super.key, required this.currentLanguage});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String _code = 'print("Hello, Vorxy Code Editor!")\n\nfor i in range(5):\n    print(i)';
  String _language = 'Python';
  String _output = '';
  String _error = '';
  bool _isRunning = false;
  String _currentFile = 'main.py';
  bool _isGitAvailable = false;

  final CompilerService _compiler = CompilerService();
  final TextEditingController _gitUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkGit();
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  Future<void> _checkGit() async {
    final available = await GitService.checkGitInstalled();
    setState(() {
      _isGitAvailable = available;
    });
  }

  void _runCode() async {
    setState(() {
      _isRunning = true;
      _output = '';
      _error = '';
    });

    final result = await _compiler.runCode(_code, _language);
    setState(() {
      _isRunning = false;
      if (result['success']) {
        _output = result['output'] ?? '';
      } else {
        _error = result['error'] ?? _getTranslation('unknown_error');
      }
    });
  }

  void _showGitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardPurple,
        title: Text(_getTranslation('git'), style: const TextStyle(color: AppTheme.accentGold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _gitUrlController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'URL репозитория (https://...)',
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _cloneRepository();
                      Navigator.pop(context);
                    },
                    child: Text(_getTranslation('clone')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _commitPush();
                      Navigator.pop(context);
                    },
                    child: Text(_getTranslation('commit_push')),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_getTranslation('close'), style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<void> _cloneRepository() async {
    if (_gitUrlController.text.isEmpty) return;
    final result = await GitService.cloneRepository(_gitUrlController.text, 'project_${DateTime.now().millisecondsSinceEpoch}');
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getTranslation('clone_success'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('clone_error')}: ${result['error']}')),
      );
    }
  }

  Future<void> _commitPush() async {
    final repoPath = await _getRepoPath();
    if (repoPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getTranslation('clone_first'))),
      );
      return;
    }
    final commitResult = await GitService.commit(repoPath, _getTranslation('file_saved_msg'));
    if (!commitResult['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('commit_error')}: ${commitResult['error']}')),
      );
      return;
    }
    final pushResult = await GitService.push(repoPath, 'origin', 'main');
    if (pushResult['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getTranslation('push_success'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('push_error')}: ${pushResult['error']}')),
      );
    }
  }

  Future<String> _getRepoPath() async {
    return '';
  }

  void _openWebPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebPreviewScreen(
          htmlCode: _code,
          cssCode: '',
          jsCode: '',
          currentLanguage: widget.currentLanguage,
        ),
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
            icon: const Icon(Icons.save, color: AppTheme.accentGold),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_getTranslation('file_saved'))),
              );
            },
          ),
          if (_language == 'HTML')
            IconButton(
              icon: const Icon(Icons.preview, color: AppTheme.accentGold),
              onPressed: _openWebPreview,
            ),
          if (_isGitAvailable)
            IconButton(
              icon: const Icon(Icons.git, color: AppTheme.accentGold),
              onPressed: _showGitDialog,
            ),
          IconButton(
            icon: _isRunning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accentGold),
                  )
                : const Icon(Icons.play_arrow, color: AppTheme.accentGold),
            onPressed: _isRunning ? null : _runCode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text('${_getTranslation('language_label')} ', style: const TextStyle(color: Colors.grey)),
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
                  '${_getTranslation('line')}: ${_code.split('\n').length}',
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
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade800),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_getTranslation('output_label')} ', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(
                    height: 80,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_output.isNotEmpty)
                            Text(_output, style: const TextStyle(color: Colors.greenAccent, fontSize: 13)),
                          if (_error.isNotEmpty)
                            Text(_error, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                          if (_output.isEmpty && _error.isEmpty && !_isRunning)
                            Text(_getTranslation('code_ready'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          if (_isRunning)
                            Text(_getTranslation('executing_code'), style: const TextStyle(color: Colors.blueAccent, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
