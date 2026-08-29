import 'dart:io';
import 'package:flutter/material.dart';
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
  bool _isSelectionMode = false;
  Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    _loadSavedFiles();
  }

  Future<void> _loadSavedFiles() async {
    setState(() {
      _isLoading = true;
      _isSelectionMode = false;
      _selectedIndices.clear();
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

  Future<void> _refreshFiles() async {
    await _loadSavedFiles();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedIndices.clear();
    });
  }

  void _selectFile(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  Future<void> _deleteFile(File file, int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTranslation('delete_file')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_getTranslation('delete_confirm')}: ${file.path.split('/').last}?'),
            const SizedBox(height: 8),
            Text(
              _getTranslation('delete_note'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
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
      try {
        await file.delete();
        setState(() {
          _files.removeAt(index);
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
  }

  Future<void> _deleteSelectedFiles() async {
    final count = _selectedIndices.length;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTranslation('delete_files')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${_getTranslation('delete_files_confirm')} ($count)?'),
            const SizedBox(height: 8),
            Text(
              _getTranslation('delete_note'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
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
      try {
        final filesToDelete = _selectedIndices.toList()..sort((a, b) => b.compareTo(a));
        for (var index in filesToDelete) {
          await _files[index].delete();
          _files.removeAt(index);
        }
        setState(() {
          _selectedIndices.clear();
          _isSelectionMode = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_getTranslation('file_deleted')}: $count ${_getTranslation('file')}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_getTranslation('error')}: $e')),
        );
      }
    }
  }

  Future<void> _deleteAllFiles() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTranslation('delete_all')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getTranslation('delete_all_confirm') + '?'),
            const SizedBox(height: 8),
            Text(
              _getTranslation('delete_all_note'),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
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
      try {
        for (var file in _files) {
          await file.delete();
        }
        setState(() {
          _files.clear();
          _selectedIndices.clear();
          _isSelectionMode = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_getTranslation('file_deleted') + ': ${_getTranslation('all')}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_getTranslation('error')}: $e')),
        );
      }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslation('files')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.accentGold),
            onPressed: _refreshFiles,
            tooltip: _getTranslation('refresh'),
          ),
          IconButton(
            icon: Icon(
              _isSelectionMode ? Icons.checklist : Icons.checklist,
              color: AppTheme.accentGold,
            ),
            onPressed: _toggleSelectionMode,
            tooltip: _getTranslation('select_files'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.red),
            onPressed: _files.isEmpty ? null : _deleteAllFiles,
            tooltip: _getTranslation('delete_all'),
          ),
        ],
        bottom: _isSelectionMode && _selectedIndices.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_getTranslation('delete_selected')} (${_selectedIndices.length})',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: _toggleSelectionMode,
                            child: Text(
                              _getTranslation('cancel'),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _deleteSelectedFiles,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(_getTranslation('delete_selected')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : null,
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

                    return ListTile(
                      leading: _isSelectionMode
                          ? Checkbox(
                              value: _selectedIndices.contains(index),
                              onChanged: (value) => _selectFile(index),
                              activeColor: AppTheme.accentGold,
                            )
                          : const Icon(Icons.insert_drive_file, color: Colors.grey),
                      title: Text(name),
                      subtitle: Text(sizeStr),
                      onTap: _isSelectionMode
                          ? () => _selectFile(index)
                          : () => _deleteFile(file, index),
                      onLongPress: () {
                        if (!_isSelectionMode) {
                          _toggleSelectionMode();
                          _selectFile(index);
                        }
                      },
                    );
                  },
                ),
    );
  }
}
