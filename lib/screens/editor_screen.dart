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
  String _fileName = 'main';
  bool _isLoading = false;
  bool _isSaving = false;

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

  String _getLanguageFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case '.py': return 'Python';
      case '.js': return 'JavaScript';
      case '.c': return 'C';
      case '.cpp': return 'C++';
      case '.java': return 'Java';
      case '.cs': return 'C#';
      case '.vb': return 'Visual Basic';
      case '.sql': return 'SQL';
      case '.r': return 'R';
      case '.rs': return 'Rust';
      case '.html': return 'HTML';
      default: return '';
    }
  }

  Future<void> _loadLastFile() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('lastFilePath');
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          final content = await file.readAsString();
          final ext = path.split('.').last;
          final lang = _getLanguageFromExtension('.$ext');
          setState(() {
            _code = content;
            _fileName = path.split('/').last.split('.').first;
            if (lang.isNotEmpty) {
              _language = lang;
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getTranslation('error_loading_file')} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openFile() async {
    if (_isLoading) return;
    
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['py', 'js', 'c', 'cpp', 'java', 'cs', 'vb', 'sql', 'r', 'rs', 'html'],
      );

      if (result == null) return;

      final filePath = result.files.single.path;
      if (filePath == null) return;

      setState(() {
        _isLoading = true;
      });

      final file = File(filePath);
      final content = await file.readAsString();
      final ext = filePath.split('.').last;
      final lang = _getLanguageFromExtension('.$ext');

      if (lang.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getTranslation('unsupported_extension')),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _code = content;
        _fileName = filePath.split('/').last.split('.').first;
        _language = lang;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastFilePath', filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getTranslation('file_loaded')}: ${filePath.split('/').last}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getTranslation('error')}: ${_getTranslation('error_loading_file')} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveFile() async {
    if (_isSaving) return;
    
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) return;

      final TextEditingController nameController = TextEditingController(text: _fileName);
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_getTranslation('save_file')),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: _getTranslation('enter_file_name'),
              suffixText: _getExtension(_language),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_getTranslation('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, nameController.text),
              child: Text(_getTranslation('save')),
            ),
          ],
        ),
      );

      if (result == null || result.isEmpty) return;

      setState(() {
        _isSaving = true;
      });

      final fileName = result + _getExtension(_language);
      final filePath = '$selectedDirectory/$fileName';

      if (await File(filePath).exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getTranslation('file_exists')),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() {
          _isSaving = false;
        });
        return;
      }

      final file = File(filePath);
      await file.writeAsString(_code);

      setState(() {
        _fileName = result;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastFilePath', filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getTranslation('file_saved')}: $fileName'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getTranslation('error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
        title: Text(_getTranslation('editor')),
        actions: [
          IconButton(
            icon: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.folder_open, color: AppTheme.accentGold),
            onPressed: _isLoading ? null : _openFile,
          ),
          IconButton(
            icon: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.save, color: AppTheme.accentGold),
            onPressed: _isSaving ? null : _saveFile,
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
                  icon: const Icon(Icons.arrow_drop_down, color: AppTheme.accentGold),
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
                    });
                  },
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          CodeEditorWidget(
                            code: _code,
                            language: _language,
                            currentLanguage: widget.currentLanguage,
                            onCodeChanged: (newCode) {
                              setState(() {
                                _code = newCode;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
