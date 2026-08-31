import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.currentLanguage,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true;
  late String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.currentLanguage;
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? true;
    });
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[_currentLanguage] ??
        AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    widget.onThemeChanged(_isDarkMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
  }

  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
    setState(() {
      _currentLanguage = langCode;
    });
    widget.onLanguageChanged(langCode);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getTranslation('language_changed')} ${langCode == 'ru' ? 'RUS' : 'ENG'}'),
        ),
      );
    }
  }

  Future<void> _openLink(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getTranslation('cannot_open_link')} $url'),
              backgroundColor: Colors.orange,
            ),
          );
        }
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
    }
  }

  Future<void> _openTelegramChannel() async {
    final List<Uri> uris = [
      Uri.parse('tg://resolve?domain=VorxyCodeEditor'),
      Uri.parse('https://t.me/VorxyCodeEditor'),
    ];
    for (final uri in uris) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getTranslation('cannot_open_link')} ${AppConstants.telegramChannel}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _openTelegramChat() async {
    final List<Uri> uris = [
      Uri.parse('tg://resolve?domain=VorxyCodeEditorChat'),
      Uri.parse('https://t.me/VorxyCodeEditorChat'),
    ];
    for (final uri in uris) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getTranslation('cannot_open_link')} ${AppConstants.telegramChat}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _exitApp() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTranslation('exit_app')),
        content: Text(_getTranslation('exit_app_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_getTranslation('no')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_getTranslation('yes')),
          ),
        ],
      ),
    );
    if (result == true) {
      await Future.delayed(const Duration(milliseconds: 300));
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('settings')),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(_getTranslation('general')),
          _buildThemeTile(),
          _buildLanguageTile(),
          _buildSectionHeader(_getTranslation('about_app')),
          _buildAboutTile(),
          _buildSectionHeader(_getTranslation('where_to_download')),
          _buildDownloadTile(
            icon: Icons.store,
            title: 'RuStore',
            onTap: () => _openLink('https://www.rustore.ru/'),
          ),
          _buildDownloadTile(
            icon: Icons.code,
            title: 'GitHub',
            onTap: () => _openLink('https://github.com/Vorxy-ops/Vorxy-Code-Editor'),
          ),
          _buildDownloadTile(
            icon: Icons.gamepad,
            title: 'itch.io',
            onTap: () => _openLink('https://vorxy-ops.itch.io/vorxy-code-editor'),
          ),
          _buildSectionHeader(_getTranslation('contacts')),
          _buildIconTile(
            icon: Icons.telegram,
            title: _getTranslation('telegram_channel'),
            onTap: _openTelegramChannel,
          ),
          _buildIconTile(
            icon: Icons.chat,
            title: _getTranslation('telegram_chat'),
            onTap: _openTelegramChat,
          ),
          _buildSectionHeader(_getTranslation('legal')),
          _buildIconTile(
            icon: Icons.article,
            title: _getTranslation('terms'),
            onTap: () => _showLegalDialog(
              _getTranslation('terms_title'),
              AppConstants.getTerms(_currentLanguage),
            ),
          ),
          _buildIconTile(
            icon: Icons.shield,
            title: _getTranslation('privacy_policy'),
            onTap: () => _showLegalDialog(
              _getTranslation('privacy_title'),
              AppConstants.getPrivacyPolicy(_currentLanguage),
            ),
          ),
          _buildIconTile(
            icon: Icons.exit_to_app,
            title: _getTranslation('exit'),
            onTap: _exitApp,
          ),
          _buildSectionHeader(''),
          _buildInfoTile(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    if (title.isEmpty) return const SizedBox(height: 8);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppTheme.accentGold,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeTile() {
    return ListTile(
      leading: const Icon(Icons.palette, color: AppTheme.accentGold),
      title: Text(_getTranslation('theme')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (_isDarkMode) return;
              _toggleTheme();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isDarkMode ? AppTheme.accentGold : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isDarkMode ? AppTheme.accentGold : Colors.grey,
                ),
              ),
              child: Icon(
                Icons.nightlight_round,
                color: _isDarkMode ? Colors.black : Colors.grey,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              if (!_isDarkMode) return;
              _toggleTheme();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: !_isDarkMode ? AppTheme.accentGold : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: !_isDarkMode ? AppTheme.accentGold : Colors.grey,
                ),
              ),
              child: Icon(
                Icons.wb_sunny,
                color: !_isDarkMode ? Colors.black : Colors.grey,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      leading: const Icon(Icons.language, color: AppTheme.accentGold),
      title: Text(_getTranslation('language')),
      subtitle: Text(
        _currentLanguage == 'ru' ? 'RUS' : 'ENG',
        style: TextStyle(
          color: AppTheme.accentGold,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showLanguageDialog(),
    );
  }

  Widget _buildIconTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentGold),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDownloadTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentGold),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildAboutTile() {
    return ListTile(
      leading: const Icon(Icons.info_outline, color: AppTheme.accentGold),
      title: Text(_getTranslation('about_app')),
      subtitle: Text(
        '${AppConstants.appName} v${AppConstants.version}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showAboutDialog(),
    );
  }

  Widget _buildInfoTile() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_getTranslation('name')}: ${AppConstants.appName}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '${_getTranslation('version')}: ${AppConstants.version}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '${_getTranslation('developer')}: ${AppConstants.developer}',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            _getTranslation('all_rights_reserved'),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTranslation('select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Text(
                'RUS',
                style: TextStyle(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: const Text('Русский'),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage('ru');
              },
            ),
            ListTile(
              leading: Text(
                'ENG',
                style: TextStyle(
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: const Text('English'),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage('en');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_getTranslation('close')),
          ),
        ],
      ),
    );
  }

  void _showLegalDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildLegalContent(content),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_getTranslation('close')),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLegalContent(String content) {
    final List<Widget> widgets = [];
    final lines = content.split('\n');
    
    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }
      
      if (line.trim() == 'Telegram-канал' ||
          line.trim() == 'Чат Telegram' ||
          line.trim() == 'Telegram Channel' ||
          line.trim() == 'Telegram Chat') {
        String url = '';
        if (line.trim() == 'Telegram-канал' || line.trim() == 'Telegram Channel') {
          url = AppConstants.telegramChannel;
        } else if (line.trim() == 'Чат Telegram' || line.trim() == 'Telegram Chat') {
          url = AppConstants.telegramChat;
        }
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () => _openLink(url),
              child: Text(
                line.trim(),
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
        continue;
      }
      
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            line,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      );
    }
    
    return widgets;
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info, color: AppTheme.accentGold),
            const SizedBox(width: 8),
            Text(_getTranslation('about_app')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppConstants.appName} v${AppConstants.version}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _getTranslation('about_full_text'),
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 16),
              Text(
                _getTranslation('all_rights_reserved'),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_getTranslation('close')),
          ),
        ],
      ),
    );
  }
}
