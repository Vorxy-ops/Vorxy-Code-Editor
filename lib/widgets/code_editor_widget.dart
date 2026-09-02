import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/re_highlight.dart';
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
  late CodeLineEditingController _controller;
  late CodeFindController _findController;
  final FocusNode _focusNode = FocusNode();
  String _displayCode = '';
  int _cursorPosition = 0;
  bool _showFindBar = false;

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _controller = CodeLineEditingController(
      text: widget.code,
      language: _getLanguageMode(widget.language),
    );
    _findController = CodeFindController();
    _displayCode = widget.code;
    _controller.addListener(() {
      setState(() {
        _cursorPosition = _controller.selection.baseOffset;
        _displayCode = _controller.text;
      });
      widget.onCodeChanged(_controller.text);
    });
    _findController.addListener(() {
      setState(() {
        _showFindBar = _findController.isShowing;
      });
    });
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      final currentSelection = _controller.selection;
      _controller.text = widget.code;
      _displayCode = widget.code;
      if (currentSelection.isValid) {
        _controller.selection = currentSelection;
      }
      _cursorPosition = _controller.selection.baseOffset;
    }
    if (oldWidget.language != widget.language) {
      _controller.language = _getLanguageMode(widget.language);
    }
  }

  String _getLineAndColumn(String text, int position) {
    if (position < 0) position = 0;
    if (position > text.length) position = text.length;
    final String beforeCursor = text.substring(0, position);
    final int line = beforeCursor.split('\n').length;
    final int lastNewLine = beforeCursor.lastIndexOf('\n');
    final int column = lastNewLine == -1 ? beforeCursor.length + 1 : beforeCursor.length - lastNewLine;
    return 'Ln $line, Col $column';
  }

  String _getStats(String text) {
    final lines = text.split('\n').length;
    final chars = text.replaceAll(' ', '').replaceAll('\n', '').length;
    return '$lines ${_getTranslation('line')}, $chars ${_getTranslation('chars')}';
  }

  String _getLanguageMode(String language) {
    switch (language) {
      case 'Python': return 'python';
      case 'JavaScript': return 'javascript';
      case 'C': return 'c';
      case 'C++': return 'cpp';
      case 'Java': return 'java';
      case 'C#': return 'csharp';
      case 'Visual Basic': return 'vb';
      case 'SQL': return 'sql';
      case 'R': return 'r';
      case 'Rust': return 'rust';
      case 'HTML': return 'html';
      default: return 'python';
    }
  }

  void _toggleFindBar() {
    if (_findController.isShowing) {
      _findController.close();
    } else {
      _findController.find(
        mode: CodeFindMode.search,
        input: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineAndCol = _getLineAndColumn(_displayCode, _cursorPosition);
    final stats = _getStats(_displayCode);

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
                  icon: Icon(
                    Icons.search,
                    color: AppTheme.accentGold,
                    size: 20,
                  ),
                  onPressed: _toggleFindBar,
                  tooltip: _getTranslation('search'),
                ),
                const SizedBox(width: 4),
                Text(
                  lineAndCol,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                stats,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade600,
                  fontSize: _getFontSize(stats),
                ),
                overflow: TextOverflow.visible,
                softWrap: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade400),
            ),
            child: Column(
              children: [
                if (_showFindBar)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                      border: Border(
                        bottom: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: _getTranslation('search_hint'),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            ),
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 13,
                            ),
                            onChanged: (value) {
                              _findController.find(
                                mode: CodeFindMode.search,
                                input: value,
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _findController.close();
                            setState(() {
                              _showFindBar = false;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: CodeEditor(
                    controller: _controller,
                    findController: _findController,
                    focusNode: _focusNode,
                    padding: const EdgeInsets.all(12),
                    indicatorBuilder: (context, controller, index) {
                      return CodeEditorIndicator(
                        controller: controller,
                        index: index,
                        activeLineColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                        lineNumberStyle: TextStyle(
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade700,
                          fontSize: 12,
                        ),
                        width: 40,
                      );
                    },
                    theme: CodeEditorTheme(
                      backgroundColor: isDark ? Colors.black : Colors.white,
                      textStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                    language: _getLanguageMode(widget.language),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getFontSize(String text) {
    final length = text.length;
    if (length <= 15) return 12;
    if (length <= 25) return 11;
    if (length <= 35) return 10;
    if (length <= 50) return 9;
    return 8;
  }

  @override
  void dispose() {
    _controller.dispose();
    _findController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
