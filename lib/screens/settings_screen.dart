import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

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
  bool _darkMode = true;
  double _fontSize = 16;
  int _tabSize = 4;
  bool _autoSave = true;
  String _currentLanguage = 'ru';
  String _currentLanguageName = 'Русский';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[_currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? true;
      _fontSize = prefs.getDouble('fontSize') ?? 16;
      _tabSize = prefs.getInt('tabSize') ?? 4;
      _autoSave = prefs.getBool('autoSave') ?? true;
      _currentLanguage = prefs.getString('language') ?? 'ru';
      _currentLanguageName = AppConstants.supportedLanguages.firstWhere(
        (l) => l['code'] == _currentLanguage,
        orElse: () => {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      )['name']!;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setInt('tabSize', _tabSize);
    await prefs.setBool('autoSave', _autoSave);
    await prefs.setString('language', _currentLanguage);
    widget.onThemeChanged(_darkMode);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardPurple,
        title: const Text(
          'Выберите язык / Select language',
          style: TextStyle(color: AppTheme.accentGold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = AppConstants.supportedLanguages[index];
              final isSelected = _currentLanguage == lang['code'];
              return ListTile(
                leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                title: Text(
                  lang['name']!,
                  style: TextStyle(
                    color: isSelected ? AppTheme.accentGold : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppTheme.accentGold)
                    : null,
                onTap: () {
                  setState(() {
                    _currentLanguage = lang['code']!;
                    _currentLanguageName = lang['name']!;
                  });
                  _saveSettings();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_getTranslation('language_changed')} ${lang['name']}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_getTranslation('close'), style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(_getTranslation('general'), [
            SwitchListTile(
              title: Row(
                children: [
                  Icon(
                    _darkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: _darkMode ? AppTheme.accentGold : Colors.orange,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(_darkMode ? _getTranslation('dark_theme') : _getTranslation('light_theme')),
                ],
              ),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                  _saveSettings();
                });
              },
              activeColor: AppTheme.accentGold,
            ),
            SwitchListTile(
              title: Text(_getTranslation('auto_save')),
              value: _autoSave,
              onChanged: (value) => setState(() => _autoSave = value),
              activeColor: AppTheme.accentGold,
            ),
            ListTile(
              leading: const Icon(Icons.language, color: AppTheme.accentGold),
              title: Text(_getTranslation('language')),
              subtitle: Text('$_currentLanguageName (${_currentLanguage.toUpperCase()})'),
              onTap: _showLanguageDialog,
            ),
          ]),
          _buildSection(_getTranslation('editor'), [
            ListTile(
              title: Text(_getTranslation('font_size')),
              subtitle: Slider(
                value: _fontSize,
                min: 12,
                max: 24,
                divisions: 6,
                activeColor: AppTheme.accentGold,
                label: _fontSize.toStringAsFixed(0),
                onChanged: (value) => setState(() => _fontSize = value),
              ),
            ),
            ListTile(
              title: Text(_getTranslation('tabulation')),
              subtitle: Row(
                children: [
                  ChoiceChip(
                    label: const Text('2'),
                    selected: _tabSize == 2,
                    onSelected: (_) => setState(() => _tabSize = 2),
                    selectedColor: AppTheme.accentGold,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('4'),
                    selected: _tabSize == 4,
                    onSelected: (_) => setState(() => _tabSize = 4),
                    selectedColor: AppTheme.accentGold,
                  ),
                ],
              ),
            ),
          ]),
          _buildSection(_getTranslation('support'), [
            _buildActionTile(_getTranslation('telegram_channel'), Icons.telegram, () => _launchUrl(AppConstants.telegramChannel)),
            _buildActionTile(_getTranslation('telegram_chat'), Icons.telegram, () => _launchUrl(AppConstants.telegramChat)),
            _buildActionTile(_getTranslation('report_bug'), Icons.email, _sendEmail),
          ]),
          _buildSection(_getTranslation('legal'), [
            _buildActionTile(
              _getTranslation('privacy_policy'),
              Icons.privacy_tip,
              () => _showLegal(
                context,
                _getTranslation('privacy_policy'),
                AppConstants.getPrivacyPolicy(_currentLanguage)
              )
            ),
            _buildActionTile(
              _getTranslation('terms'),
              Icons.gavel,
              () => _showLegal(
                context,
                _getTranslation('terms'),
                AppConstants.getTerms(_currentLanguage)
              )
            ),
          ]),
          _buildSection(_getTranslation('about_app'), [
            ListTile(
              title: const Text('Описание / Description'),
              subtitle: Text(_getTranslation('description')),
            ),
            ListTile(
              title: Text(_getTranslation('features')),
              subtitle: Text(_getTranslation('features_list')),
            ),
            ListTile(
              title: Text(_getTranslation('system_requirements')),
              subtitle: Text(_getTranslation('system_requirements_list')),
            ),
            const Divider(color: AppTheme.accentGold),
            ListTile(
              title: Text(_getTranslation('name')),
              subtitle: Text(AppConstants.appName),
            ),
            ListTile(
              title: Text(_getTranslation('version')),
              subtitle: Text(AppConstants.version),
            ),
            ListTile(
              title: Text(_getTranslation('developer')),
              subtitle: Text(AppConstants.developer),
            ),
            ListTile(
              title: const Text('Авторские права / Copyright'),
              subtitle: const Text('© 2026 GOSTOWN Co. All rights reserved.'),
            ),
            _buildActionTile(_getTranslation('exit'), Icons.exit_to_app, () => Navigator.of(context).popUntil((route) => route.isFirst)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentGold,
            ),
          ),
        ),
        ...children,
        const Divider(color: AppTheme.accentGold),
      ],
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentGold),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getTranslation('error'))),
      );
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: AppConstants.supportEmail,
      query: 'subject=Сообщение об ошибке Vorxy Code Editor',
    );
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getTranslation('error'))),
      );
    }
  }

  void _showLegal(BuildContext context, String title, String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardPurple,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.accentGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(_getTranslation('close')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
