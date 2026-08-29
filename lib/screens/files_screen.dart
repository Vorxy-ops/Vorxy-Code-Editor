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
  List<File> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedFiles();
  }

  Future<void> _loadSavedFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastPath = prefs.getString('lastFilePath');

      if (lastPath != null) {
        final dir = File(lastPath).parent;
        if (await dir.exists()) {
          final List<FileSystemEntity> entities = await dir.list().toList();
          final List<File> savedFiles = [];
          for (var entity in entities) {
            if (entity is File) {
              final name = entity.path.split('/').last;
              final ext = name.split('.').last.toLowerCase();
              if (['py', 'js', 'c', 'cpp', 'java', 'cs', 'vb', 'sql', 'r', 'rs', 'html', 'txt'].contains(ext)) {
                savedFiles.add(entity);
              }
            }
          }
          setState(() {
            _files = savedFiles;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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

  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      setState(() {
        _files.remove(file);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_getTranslation('file_deleted')}: ${file.path.split('/').last}')),
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        _getTranslation('no_files'),
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getTranslation('save_files_to_view'),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _files.length,
                  itemBuilder: (context, index) {
                    final file = _files[index];
                    final name = file.path.split('/').last;
                    final size = file.lengthSync();
                    String sizeStr;
                    if (size < 1024) {
                      sizeStr = '$size B';
                    } else if (size < 1048576) {
                      sizeStr = '${(size / 1024).toStringAsFixed(1)} KB';
                    } else {
                      sizeStr = '${(size / 1048576).toStringAsFixed(1)} MB';
                    }

                    return Dismissible(
                      key: Key(file.path),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) => _deleteFile(file),
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file, color: Colors.grey),
                        title: Text(name),
                        subtitle: Text(sizeStr),
                        onTap: () => _openFile(file),
                      ),
                    );
                  },
                ),
    );
  }
}
