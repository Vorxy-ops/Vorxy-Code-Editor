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
                  icon: const Icon(Icons.undo, size: 20, color: AppTheme.accentGold),
                  onPressed: () {
                    _controller.text = widget.code;
                    widget.onCodeChanged(widget.code);
                  },
                  tooltip: _getTranslation('undo_hint'),
                ),
                IconButton(
                  icon: const Icon(Icons.redo, size: 20, color: AppTheme.accentGold),
                  onPressed: () {},
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
