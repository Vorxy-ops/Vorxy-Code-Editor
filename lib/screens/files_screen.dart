import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class FilesScreen extends StatelessWidget {
  final String currentLanguage;

  const FilesScreen({super.key, required this.currentLanguage});

  String _getTranslation(String key) {
    final translations = AppConstants.translations[currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('files')),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder, color: AppTheme.accentGold),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_getTranslation('create_folder')} ${_getTranslation('in_development')}')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.note_add, color: AppTheme.accentGold),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${_getTranslation('create_file')} ${_getTranslation('in_development')}')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFolderItem('Проекты', [
              _buildFileItem('main.py'),
              _buildFileItem('app.js'),
              _buildFileItem('index.html'),
            ]),
            _buildFolderItem('Утилиты', [
              _buildFileItem('test.java'),
              _buildFileItem('helper.c'),
            ]),
            _buildFileItem('README.md'),
            _buildFileItem('config.json'),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderItem(String name, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          name,
          style: const TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.folder, color: AppTheme.accentGold),
        children: children,
      ),
    );
  }

  Widget _buildFileItem(String name) {
    return ListTile(
      leading: const Icon(Icons.insert_drive_file, color: Colors.grey),
      title: Text(name),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.grey),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_getTranslation('file_actions')} $name ${_getTranslation('in_development')}')),
          );
        },
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_getTranslation('opening')} $name ${_getTranslation('in_development')}')),
        );
      },
    );
  }
}
