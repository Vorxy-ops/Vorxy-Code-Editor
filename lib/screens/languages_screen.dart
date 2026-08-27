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
          itemCount: 10,
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
                        language['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentGold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        language['description'],
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
}

const List<Map<String, String>> languages = [
  {'name': 'Python', 'description': 'AI, веб, наука о данных'},
  {'name': 'C', 'description': 'Операционные системы и железо'},
  {'name': 'C++', 'description': 'Игры и высоконагруженные системы'},
  {'name': 'Java', 'description': 'Корпоративная разработка и Android'},
  {'name': 'C#', 'description': 'Windows-приложения и Unity'},
  {'name': 'JavaScript', 'description': 'Веб-разработка и серверы'},
  {'name': 'Visual Basic', 'description': 'Классические Windows-приложения'},
  {'name': 'SQL', 'description': 'Работа с базами данных'},
  {'name': 'R', 'description': 'Статистика и научные исследования'},
  {'name': 'Rust', 'description': 'Безопасные высоконагруженные системы'},
];
