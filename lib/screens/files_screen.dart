import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class FilesScreen extends StatefulWidget {
  final String currentLanguage;

  const FilesScreen({super.key, required this.currentLanguage});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  List<FileSystemEntity> _files = [];
  String _currentPath = '';

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      Directory dir;
      if (_currentPath.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final lastPath = prefs.getString('lastFilePath');
        if (lastPath != null) {
          final file = File(lastPath);
          if (await file.exists()) {
            dir = file.parent;
          } else {
            dir = await getApplicationDocumentsDirectory();
          }
        } else {
          dir = await getApplicationDocumentsDirectory();
        }
      } else {
        dir = Directory(_currentPath);
      }
      
      _currentPath = dir.path;
      final List<FileSystemEntity> entities = await dir.list().toList();
      entities.sort((a, b) {
        if (a is Directory && b is File) return -1;
        if (a is File && b is Directory) return 1;
        return a.path.compareTo(b.path);
      });
      
      setState(() {
        _files = entities;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('error')}: $e')),
      );
    }
  }

  String _getTranslation(String key) {
    final translations = AppConstants.translations[widget.currentLanguage] ?? AppConstants.translations['ru']!;
    return translations[key] ?? key;
  }

  Future<void> _openFile(File file) async {
    try {
      final content = await file.readAsString();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastFilePath', file.path);
      Navigator.pushNamed(
        context,
        '/editor',
        arguments: {'code': content, 'filePath': file.path},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('error')}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('files')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.accentGold),
            onPressed: _loadFiles,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _currentPath.isEmpty ? '/' : _currentPath,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_currentPath.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.arrow_upward, color: AppTheme.accentGold),
                    onPressed: () {
                      final parent = Directory(_currentPath).parent;
                      setState(() {
                        _currentPath = parent.path;
                      });
                      _loadFiles();
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final entity = _files[index];
                final isDirectory = entity is Directory;
                final name = entity.path.split('/').last;
                final isFile = entity is File;
                
                return ListTile(
                  leading: Icon(
                    isDirectory ? Icons.folder : Icons.insert_drive_file,
                    color: isDirectory ? AppTheme.accentGold : Colors.grey,
                  ),
                  title: Text(name),
                  subtitle: isFile ? Text('${(entity as File).lengthSync()} bytes') : null,
                  onTap: () {
                    if (isDirectory) {
                      setState(() {
                        _currentPath = entity.path;
                      });
                      _loadFiles();
                    } else if (isFile) {
                      _openFile(entity as File);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
