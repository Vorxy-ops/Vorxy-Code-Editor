import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(bool) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.currentLanguage,
    required this.onThemeChanged,
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

  Future<void> _toggleTheme(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    widget.onThemeChanged(value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
    setState(() {
      _currentLanguage = langCode;
    });
    widget.onThemeChanged(_isDarkMode);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getTranslation('language_changed')} ${langCode == 'ru' ? 'Русский' : 'English'}'),
        ),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
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

  Future<void> _sendEmail() async {
    try {
      final email = Uri(
        scheme: 'mailto',
        path: AppConstants.supportEmail,
        query: 'subject=${Uri.encodeComponent(_getTranslation('bug_report_subject'))}&body=${Uri.encodeComponent(_getTranslation('bug_report_body'))}',
      );
      
      if (await canLaunchUrl(email)) {
        await launchUrl(
          email,
          mode: LaunchMode.platformDefault,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getTranslation('email_error')),
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
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: _getTranslation('dark_theme'),
            value: _isDarkMode,
            onChanged: _toggleTheme,
          ),
          _buildLanguageTile(),
          _buildSectionHeader(_getTranslation('about_app')),
          _buildAboutTile(),
          _buildIconTile(
            icon: Icons.telegram,
            title: _getTranslation('telegram_channel'),
            onTap: () => _launchUrl(AppConstants.telegramChannel),
          ),
          _buildIconTile(
            icon: Icons.chat,
            title: _getTranslation('telegram_chat'),
            onTap: () => _launchUrl(AppConstants.telegramChat),
          ),
          _buildIconTile(
            icon: Icons.code,
            title: _getTranslation('github'),
            onTap: () => _launchUrl(AppConstants.githubRepo),
          ),
          _buildSectionHeader(_getTranslation('support')),
          _buildIconTile(
            icon: Icons.email,
            title: _getTranslation('email'),
            onTap: _sendEmail,
          ),
          _buildSectionHeader(_getTranslation('legal')),
          _buildIconTile(
            icon: Icons.gavel,
            title: _getTranslation('terms'),
            onTap: () => _showLegalDialog(
              _getTranslation('terms_title'),
              AppConstants.getTerms(_currentLanguage),
            ),
          ),
          _buildIconTile(
            icon: Icons.privacy_tip,
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.accentGold),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      leading: const Icon(Icons.language, color: AppTheme.accentGold),
      title: Text(_getTranslation('language')),
      subtitle: Text(
        _currentLanguage == 'ru' ? 'Русский' : 'English',
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
              leading: const Text('🇷🇺'),
              title: const Text('Русский'),
              onTap: () {
                Navigator.pop(context);
                _changeLanguage('ru');
              },
            ),
            ListTile(
              leading: const Text('🇬🇧'),
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
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
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
