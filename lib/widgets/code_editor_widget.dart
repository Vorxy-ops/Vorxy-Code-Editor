import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/vs.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class CodeEditorWidget extends StatefulWidget {
  final String code;
  final String language;
  final String currentLanguage;
  final ValueChanged<String> onCodeChanged;

  const CodeEditorWidget({
    super.key,
    required this.code,
    required this.language,
    required this.currentLanguage,
    required this.onCodeChanged,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = '';
  int _currentSearchIndex = -1;
  List<int> _searchMatches = [];
  bool _showSearchBar = false;
  bool _replaceMode = false;
  String _replaceText = '';

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.code);
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      _controller.text = widget.code;
    }
  }

  void _formatCode() {
    String text = _controller.text;
    String formatted = _formatByLanguage(text, widget.language);
    if (formatted != text) {
      _controller.text = formatted;
      widget.onCodeChanged(formatted);
      _showSnackbar('Код отформатирован');
    } else {
      _showSnackbar('Форматирование не требуется');
    }
  }

  String _formatByLanguage(String text, String language) {
    String result = text;
    switch (language.toLowerCase()) {
      case 'python':
        result = _formatPython(text);
        break;
      case 'javascript':
      case 'java':
      case 'c':
      case 'cpp':
      case 'c#':
        result = _formatCStyle(text);
        break;
      default:
        result = _formatGeneric(text);
    }
    return result;
  }

  String _formatPython(String text) {
    List<String> lines = text.split('\n');
    List<String> formatted = [];
    int indentLevel = 0;
    for (String line in lines) {
      String trimmed = line.trim();
      if (trimmed.isEmpty) {
        formatted.add('');
        continue;
      }
      if (trimmed.startsWith('return') || trimmed.startsWith('break') || trimmed.startsWith('continue')) {
        formatted.add('  ' * indentLevel + trimmed);
        continue;
      }
      if (trimmed.endsWith(':')) {
        formatted.add('  ' * indentLevel + trimmed);
        indentLevel++;
        continue;
      }
      if (trimmed.startsWith('elif') || trimmed.startsWith('else') || trimmed.startsWith('except')) {
        indentLevel--;
        formatted.add('  ' * indentLevel + trimmed);
        indentLevel++;
        continue;
      }
      formatted.add('  ' * indentLevel + trimmed);
    }
    return formatted.join('\n');
  }

  String _formatCStyle(String text) {
    List<String> lines = text.split('\n');
    List<String> formatted = [];
    int indentLevel = 0;
    for (String line in lines) {
      String trimmed = line.trim();
      if (trimmed.isEmpty) {
        formatted.add('');
        continue;
      }
      if (trimmed.endsWith('{')) {
        formatted.add('  ' * indentLevel + trimmed);
        indentLevel++;
        continue;
      }
      if (trimmed.startsWith('}')) {
        indentLevel--;
        formatted.add('  ' * indentLevel + trimmed);
        continue;
      }
      formatted.add('  ' * indentLevel + trimmed);
    }
    return formatted.join('\n');
  }

  String _formatGeneric(String text) {
    return text;
  }

  void _showSearchBarDialog() {
    _searchQuery = '';
    _replaceText = '';
    _searchMatches = [];
    _currentSearchIndex = -1;
    _showSearchBar = true;
    _replaceMode = false;
    _showSearchDialog();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: AppTheme.cardPurple,
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    _replaceMode ? _getTranslation('find_replace') : _getTranslation('search'),
                    style: const TextStyle(color: AppTheme.accentGold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    _showSearchBar = false;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: _getTranslation('find_hint'),
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setStateDialog(() {
                      _searchQuery = value;
                      _findMatches();
                    });
                  },
                ),
                if (_replaceMode) ...[
                  const SizedBox(height: 8),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: _getTranslation('replace_hint'),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setStateDialog(() {
                        _replaceText = value;
                      });
                    },
                  ),
                ],
                if (_searchQuery.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_searchMatches.length} ${_getTranslation('matches_found')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setStateDialog(() {
                    _replaceMode = !_replaceMode;
                  });
                },
                child: Text(
                  _replaceMode ? _getTranslation('cancel_replace') : _getTranslation('replace'),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              if (_searchMatches.isNotEmpty && !_replaceMode)
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: AppTheme.accentGold),
                  onPressed: () => _navigateSearch(-1),
                ),
              if (_searchMatches.isNotEmpty && !_replaceMode)
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: AppTheme.accentGold),
                  onPressed: () => _navigateSearch(1),
                ),
              if (_replaceMode && _searchMatches.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    _replaceCurrent();
                    setStateDialog(() {});
                  },
                  child: Text(_getTranslation('replace_one')),
                ),
              if (_replaceMode && _searchMatches.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    _replaceAll();
                    setStateDialog(() {});
                  },
                  child: Text(_getTranslation('replace_all_btn')),
                ),
              TextButton(
                onPressed: () {
                  _showSearchBar = false;
                  Navigator.pop(context);
                },
                child: Text(_getTranslation('done'), style: const TextStyle(color: Colors.grey)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _findMatches() {
    if (_searchQuery.isEmpty) {
      _searchMatches = [];
      _currentSearchIndex = -1;
      return;
    }
    String text = _controller.text;
    List<int> matches = [];
    int index = text.indexOf(_searchQuery);
    while (index != -1) {
      matches.add(index);
      index = text.indexOf(_searchQuery, index + 1);
    }
    setState(() {
      _searchMatches = matches;
      _currentSearchIndex = matches.isEmpty ? -1 : 0;
    });
  }

  void _navigateSearch(int direction) {
    if (_searchMatches.isEmpty) return;
    setState(() {
      _currentSearchIndex = (_currentSearchIndex + direction) % _searchMatches.length;
      if (_currentSearchIndex < 0) _currentSearchIndex = _searchMatches.length - 1;
    });
    _showSnackbar('${_getTranslation('search')} ${_currentSearchIndex + 1}/${_searchMatches.length}');
  }

  void _replaceCurrent() {
    if (_searchMatches.isEmpty || _currentSearchIndex < 0) return;
    String text = _controller.text;
    int start = _searchMatches[_currentSearchIndex];
    String before = text.substring(0, start);
    String after = text.substring(start + _searchQuery.length);
    _controller.text = before + _replaceText + after;
    widget.onCodeChanged(_controller.text);
    _findMatches();
    _showSnackbar(_getTranslation('replace_one'));
  }

  void _replaceAll() {
    if (_searchMatches.isEmpty) return;
    String text = _controller.text;
    String newText = text.replaceAll(_searchQuery, _replaceText);
    _controller.text = newText;
    widget.onCodeChanged(newText);
    _findMatches();
    _showSnackbar('${_getTranslation('replace_all_btn')} (${_searchMatches.length})');
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_getTranslation('language_label')} ${widget.language}',
              style: const TextStyle(
                color: AppTheme.accentGold,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.format_align_left, size: 20, color: AppTheme.accentGold),
                  onPressed: _formatCode,
                  tooltip: _getTranslation('format'),
                ),
                IconButton(
                  icon: const Icon(Icons.search, size: 20, color: AppTheme.accentGold),
                  onPressed: _showSearchBarDialog,
                  tooltip: _getTranslation('search'),
                ),
                IconButton(
                  icon: const Icon(Icons.undo, size: 20, color: AppTheme.accentGold),
                  onPressed: () {
                    _showSnackbar(_getTranslation('undo_hint'));
                  },
                  tooltip: _getTranslation('undo_hint'),
                ),
                IconButton(
                  icon: const Icon(Icons.redo, size: 20, color: AppTheme.accentGold),
                  onPressed: () {
                    _showSnackbar(_getTranslation('redo_hint'));
                  },
                  tooltip: _getTranslation('redo_hint'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 8),
                  const Text(
                    'Ln 1, Col 1',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_controller.text.split('\n').length} ${_getTranslation('line')}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const Divider(height: 1, color: Colors.grey),
              HighlightView(
                _controller.text.isEmpty ? ' ' : _controller.text,
                language: widget.language.toLowerCase(),
                theme: AppTheme.codeTheme,
                padding: const EdgeInsets.all(12),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          maxLines: null,
          minLines: 10,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
          decoration: InputDecoration(
            hintText: _getTranslation('code_ready'),
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.accentGold),
            ),
            filled: true,
            fillColor: Colors.black26,
          ),
          onChanged: (value) {
            widget.onCodeChanged(value);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
