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
  String _displayCode = '';
  bool _isProcessing = false;
  ScrollController _scrollController = ScrollController();
  ScrollController _lineScrollController = ScrollController();
  int _cursorPosition = 0;

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.code);
    _displayCode = widget.code;
    
    _scrollController.addListener(() {
      if (_lineScrollController.hasClients) {
        _lineScrollController.jumpTo(_scrollController.offset);
      }
    });

    _controller.addListener(() {
      setState(() {
        _cursorPosition = _controller.selection.baseOffset;
      });
    });
  }

  @override
  void didUpdateWidget(CodeEditorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      _controller.text = widget.code;
      _displayCode = widget.code;
      _cursorPosition = _controller.selection.baseOffset;
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

  List<String> _getLines(String text) {
    if (text.isEmpty) return [''];
    return text.split('\n');
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lines = _getLines(_displayCode);
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
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _getLineNumberWidth(lines.length),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: ListView.builder(
                    controller: _lineScrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lines.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 22,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: _getNumberFontSize(lines.length),
                            fontFamily: 'monospace',
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: HighlightView(
                      _displayCode.isEmpty ? ' ' : _displayCode,
                      language: widget.language.toLowerCase(),
                      theme: isDark ? _getDarkTheme() : _getLightTheme(),
                      padding: const EdgeInsets.all(12),
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: null,
            minLines: 10,
            expands: true,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
            decoration: InputDecoration(
              hintText: _getTranslation('code_ready'),
              hintStyle: TextStyle(
                color: isDark ? Colors.grey : Colors.grey.shade600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey : Colors.grey.shade400,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey : Colors.grey.shade400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.accentGold),
              ),
              filled: true,
              fillColor: isDark ? Colors.black : Colors.white,
            ),
            onChanged: _onCodeChanged,
            onTap: () {
              setState(() {
                _cursorPosition = _controller.selection.baseOffset;
              });
            },
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

  double _getNumberFontSize(int count) {
    if (count <= 99) return 13;
    if (count <= 999) return 12;
    if (count <= 9999) return 11;
    return 10;
  }

  double _getLineNumberWidth(int count) {
    if (count <= 9) return 30;
    if (count <= 99) return 35;
    if (count <= 999) return 40;
    if (count <= 9999) return 45;
    return 50;
  }

  Map<String, TextStyle> _getDarkTheme() {
    return {
      'root': TextStyle(
        backgroundColor: Colors.black,
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'monospace',
      ),
      'keyword': TextStyle(color: Colors.purple.shade300),
      'string': TextStyle(color: Colors.green.shade300),
      'comment': TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
      'number': TextStyle(color: Colors.blue.shade300),
      'function': TextStyle(color: Colors.yellow.shade300),
      'class': TextStyle(color: Colors.orange.shade300),
      'variable': TextStyle(color: Colors.cyan.shade300),
      'operator': TextStyle(color: Colors.red.shade300),
      'built_in': TextStyle(color: Colors.teal.shade300),
    };
  }

  Map<String, TextStyle> _getLightTheme() {
    return {
      'root': TextStyle(
        backgroundColor: Colors.white,
        color: Colors.black,
        fontSize: 14,
        fontFamily: 'monospace',
      ),
      'keyword': TextStyle(color: Colors.purple.shade700),
      'string': TextStyle(color: Colors.green.shade700),
      'comment': TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
      'number': TextStyle(color: Colors.blue.shade700),
      'function': TextStyle(color: Colors.orange.shade700),
      'class': TextStyle(color: Colors.deepPurple.shade700),
      'variable': TextStyle(color: Colors.cyan.shade700),
      'operator': TextStyle(color: Colors.red.shade700),
      'built_in': TextStyle(color: Colors.teal.shade700),
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _lineScrollController.dispose();
    super.dispose();
  }
}
