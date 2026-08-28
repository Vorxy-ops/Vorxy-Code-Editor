import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class LanguagesScreen extends StatelessWidget {
  final String currentLanguage;

  const LanguagesScreen({super.key, required this.currentLanguage});

  String _getTranslation(String key) {
    final translations = AppConstants.translations[currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final languages = _getLocalizedLanguages(currentLanguage);
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('languages')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final language = languages[index];
            return Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        language['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        language['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, String>> _getLocalizedLanguages(String langCode) {
    final translations = AppConstants.languageDescriptions[langCode] ?? AppConstants.languageDescriptions['ru']!;
    return const [
      {'name': 'Python', 'key': 'python'},
      {'name': 'C', 'key': 'c'},
      {'name': 'C++', 'key': 'cpp'},
      {'name': 'Java', 'key': 'java'},
      {'name': 'C#', 'key': 'csharp'},
      {'name': 'JavaScript', 'key': 'js'},
      {'name': 'Visual Basic', 'key': 'vb'},
      {'name': 'SQL', 'key': 'sql'},
      {'name': 'R', 'key': 'r'},
      {'name': 'Rust', 'key': 'rust'},
    ].map((lang) {
      return {
        'name': lang['name']!,
        'description': translations[lang['key']] ?? lang['name']!,
      };
    }).toList();
  }
}
