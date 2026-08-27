import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class WebPreviewScreen extends StatefulWidget {
  final String htmlCode;
  final String cssCode;
  final String jsCode;
  final String currentLanguage;

  const WebPreviewScreen({
    super.key,
    required this.htmlCode,
    required this.cssCode,
    required this.jsCode,
    required this.currentLanguage,
  });

  @override
  State<WebPreviewScreen> createState() => _WebPreviewScreenState();
}

class _WebPreviewScreenState extends State<WebPreviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      );
    _loadCode();
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  void _loadCode() {
    final String html = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>${widget.cssCode}</style>
</head>
<body>
  ${widget.htmlCode}
  <script>${widget.jsCode}</script>
</body>
</html>
''';
    _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('web_preview')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.accentGold),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadCode();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppTheme.accentGold),
            ),
        ],
      ),
    );
  }
}
