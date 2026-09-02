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
  late CodeAutocompleteController _autocompleteController;
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
    _autocompleteController = CodeAutocompleteController();
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

  List<CodeAutocompleteOption> _getAutocompleteOptions(String text) {
    final keywords = {
      'python': [
        'def', 'if', 'else', 'elif', 'for', 'while', 'return', 'import', 'from',
        'class', 'try', 'except', 'finally', 'with', 'as', 'lambda', 'yield',
        'global', 'nonlocal', 'True', 'False', 'None', 'and', 'or', 'not', 'in',
        'is', 'pass', 'break', 'continue'
      ],
      'javascript': [
        'function', 'if', 'else', 'for', 'while', 'return', 'import', 'export',
        'class', 'try', 'catch', 'finally', 'throw', 'new', 'this', 'super',
        'const', 'let', 'var', 'async', 'await', 'true', 'false', 'null',
        'undefined', 'break', 'continue', 'switch', 'case', 'default'
      ],
      'c': [
        'int', 'char', 'float', 'double', 'void', 'if', 'else', 'for', 'while',
        'do', 'return', 'switch', 'case', 'default', 'break', 'continue',
        'struct', 'union', 'enum', 'typedef', 'sizeof', 'static', 'const',
        'volatile', 'extern', 'register', 'goto', 'long', 'short', 'signed',
        'unsigned'
      ],
      'cpp': [
        'int', 'char', 'float', 'double', 'void', 'bool', 'if', 'else', 'for',
        'while', 'do', 'return', 'switch', 'case', 'default', 'break', 'continue',
        'class', 'struct', 'union', 'enum', 'typedef', 'namespace', 'using',
        'public', 'private', 'protected', 'virtual', 'override', 'final',
        'constexpr', 'nullptr', 'auto', 'decltype', 'noexcept', 'template',
        'typename', 'static_cast', 'dynamic_cast', 'const_cast', 'reinterpret_cast'
      ],
      'java': [
        'public', 'private', 'protected', 'static', 'final', 'abstract', 'class',
        'interface', 'extends', 'implements', 'new', 'return', 'void', 'int',
        'char', 'float', 'double', 'boolean', 'long', 'short', 'byte', 'if',
        'else', 'for', 'while', 'do', 'switch', 'case', 'default', 'break',
        'continue', 'try', 'catch', 'finally', 'throw', 'throws', 'import',
        'package', 'super', 'this', 'true', 'false', 'null', 'enum', 'record'
      ],
      'csharp': [
        'public', 'private', 'protected', 'internal', 'static', 'readonly',
        'const', 'abstract', 'sealed', 'class', 'interface', 'struct', 'enum',
        'new', 'return', 'void', 'int', 'char', 'float', 'double', 'bool',
        'string', 'object', 'if', 'else', 'for', 'while', 'do', 'switch',
        'case', 'default', 'break', 'continue', 'try', 'catch', 'finally',
        'throw', 'using', 'namespace', 'var', 'dynamic', 'true', 'false', 'null'
      ],
      'vb': [
        'Public', 'Private', 'Friend', 'Protected', 'Dim', 'Const', 'Static',
        'Shared', 'ReadOnly', 'WriteOnly', 'Class', 'Module', 'Interface',
        'Structure', 'Enum', 'Function', 'Sub', 'Return', 'If', 'Else',
        'ElseIf', 'Select', 'Case', 'For', 'While', 'Do', 'Loop', 'Try',
        'Catch', 'Finally', 'Throw', 'New', 'Imports', 'Namespace', 'True',
        'False', 'Nothing', 'Inherits', 'Implements', 'Overrides', 'NotOverridable',
        'MustOverride', 'Overloads', 'Shadows', 'Default', 'WithEvents'
      ],
      'sql': [
        'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'ALTER', 'DROP',
        'TABLE', 'VIEW', 'INDEX', 'TRIGGER', 'PROCEDURE', 'FUNCTION', 'FROM',
        'WHERE', 'JOIN', 'INNER', 'LEFT', 'RIGHT', 'FULL', 'GROUP', 'BY',
        'HAVING', 'ORDER', 'ASC', 'DESC', 'DISTINCT', 'COUNT', 'SUM', 'AVG',
        'MAX', 'MIN', 'AS', 'IN', 'BETWEEN', 'LIKE', 'IS', 'NULL', 'NOT',
        'AND', 'OR', 'UNION', 'ALL', 'EXISTS', 'CASE', 'WHEN', 'THEN', 'ELSE'
      ],
      'r': [
        'function', 'if', 'else', 'for', 'while', 'repeat', 'break', 'next',
        'return', 'library', 'require', 'source', 'setwd', 'getwd', 'list',
        'data.frame', 'matrix', 'array', 'factor', 'c', 'sum', 'mean', 'sd',
        'var', 'cor', 'lm', 'glm', 'plot', 'hist', 'boxplot', 'ggplot', 'aes',
        'geom', 'stat', 'theme', 'scale', 'filter', 'mutate', 'select', 'arrange',
        'summarise', 'group_by', 'ungroup', 'inner_join', 'left_join', 'right_join'
      ],
      'rust': [
        'fn', 'let', 'mut', 'if', 'else', 'for', 'while', 'loop', 'match',
        'return', 'break', 'continue', 'struct', 'enum', 'trait', 'impl',
        'pub', 'crate', 'mod', 'use', 'extern', 'unsafe', 'async', 'await',
        'move', 'ref', 'static', 'const', 'type', 'dyn', 'self', 'super',
        'true', 'false', 'Some', 'None', 'Ok', 'Err', 'Result', 'Option',
        'Vec', 'String', 'println', 'format', 'assert', 'panic'
      ],
      'html': [
        '<!DOCTYPE', '<html>', '</html>', '<head>', '</head>', '<body>',
        '</body>', '<title>', '</title>', '<h1>', '</h1>', '<h2>', '</h2>',
        '<h3>', '</h3>', '<p>', '</p>', '<br>', '<hr>', '<a>', '</a>',
        '<img>', '<div>', '</div>', '<span>', '</span>', '<ul>', '</ul>',
        '<ol>', '</ol>', '<li>', '</li>', '<table>', '</table>', '<tr>',
        '</tr>', '<td>', '</td>', '<th>', '</th>', '<form>', '</form>',
        '<input>', '<button>', '</button>', '<select>', '</select>',
        '<option>', '</option>', '<textarea>', '</textarea>', '<script>',
        '</script>', '<style>', '</style>', '<link>', '<meta>', '<nav>',
        '</nav>', '<header>', '</header>', '<footer>', '</footer>',
        '<section>', '</section>', '<article>', '</article>', '<aside>',
        '</aside>', '<main>', '</main>', '<figure>', '</figure>', '<figcaption>',
        '</figcaption>'
      ],
    };

    final languageKeywords = keywords[_getLanguageMode(widget.language)] ?? [];
    final lowerText = text.toLowerCase();
    return languageKeywords
        .where((keyword) => keyword.toLowerCase().startsWith(lowerText))
        .map((keyword) => CodeAutocompleteOption(
              text: keyword,
              score: keyword.length,
            ))
        .toList();
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
                    autocompleteController: _autocompleteController,
                    focusNode: _focusNode,
                    padding: const EdgeInsets.all(12),
                    autocompleteBuilder: (context, controller, value, options) {
                      if (options.isEmpty) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(top: 4),
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade900 : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options[index];
                            return ListTile(
                              title: Text(
                                option.text,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              onTap: () {
                                _autocompleteController.complete(option);
                              },
                            );
                          },
                        ),
                      );
                    },
                    autocompleteOptionsBuilder: (controller, text) {
                      final prefix = text.substring(0, _controller.selection.start);
                      final match = RegExp(r'[a-zA-Z_<>/]+$').firstMatch(prefix);
                      if (match == null) return [];
                      final word = match.group(0) ?? '';
                      if (word.length < 1) return [];
                      return _getAutocompleteOptions(word);
                    },
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
    _autocompleteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
