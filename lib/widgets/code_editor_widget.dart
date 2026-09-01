import 'package:flutter/material.dart';
import 'package:lite_code_editor/lite_code_editor.dart';
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
  late CodeController _controller;
  final FocusNode _focusNode = FocusNode();
  String _displayCode = '';
  bool _isProcessing = false;
  int _cursorPosition = 0;

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _controller = CodeController(text: widget.code);
    _displayCode = widget.code;
    _controller.addListener(() {
      setState(() {
        _cursorPosition = _controller.selection.baseOffset;
        _displayCode = _controller.text;
      });
    });
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      _controller.text = widget.code;
      _displayCode = widget.code;
    }
  }

  void _onCodeChanged(String value) {
    if (_isProcessing) return;
    _isProcessing = true;
    setState(() {
      _displayCode = value;
      _cursorPosition = _controller.selection.baseOffset;
    });
    widget.onCodeChanged(value);
    Future.delayed(const Duration(milliseconds: 50), () {
      _isProcessing = false;
    });
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

  String _getLanguageCode(String language) {
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
            const Spacer(),
            Text(
              lineAndCol,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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
            child: LiteCodeEditor(
              controller: _controller,
              language: _getLanguageCode(widget.language),
              theme: isDark ? EditorTheme.dark() : EditorTheme.light(),
              onChanged: _onCodeChanged,
              enableGutter: true,
              readOnly: false,
              wrap: false,
              maxLines: null,
              padding: const EdgeInsets.all(12),
              autocomplete: true,
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
    _focusNode.dispose();
    super.dispose();
  }
}
