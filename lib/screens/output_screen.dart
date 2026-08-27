import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class OutputScreen extends StatelessWidget {
  final String currentLanguage;

  const OutputScreen({super.key, required this.currentLanguage});

  String _getTranslation(String key) {
    final translations = AppConstants.translations[currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('output')),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: AppTheme.accentGold),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_getTranslation('copying'))),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear, color: AppTheme.accentGold),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_getTranslation('clearing'))),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: AppTheme.accentGold,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.accentGold,
              tabs: [
                Tab(text: _getTranslation('output')),
                Tab(text: _getTranslation('errors')),
                Tab(text: _getTranslation('terminal')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOutputTab(_getTranslation('execution_success'), Colors.greenAccent),
                  _buildOutputTab(_getTranslation('execution_error'), Colors.redAccent),
                  _buildOutputTab(_getTranslation('terminal'), Colors.blueAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputTab(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryPurple,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.terminal,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: AppTheme.cardPurple,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentGold, width: 1),
              ),
              child: const Text(
                '> Результат выполнения кода будет здесь',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
