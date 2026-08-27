import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class GitService {
  static bool _isGitInstalled = false;

  static Future<bool> checkGitInstalled() async {
    try {
      final result = await Process.run('git', ['--version']);
      _isGitInstalled = result.exitCode == 0;
      return _isGitInstalled;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> cloneRepository(String url, String projectName) async {
    if (!_isGitInstalled) {
      return {'success': false, 'error': 'Git не установлен на устройстве'};
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      final projectDir = path.join(dir.path, 'git_projects', projectName);
      final dirObj = Directory(projectDir);

      if (!dirObj.existsSync()) {
        dirObj.createSync(recursive: true);
      }

      final result = await Process.run('git', ['clone', url, projectDir]);
      return {
        'success': result.exitCode == 0,
        'path': projectDir,
        'output': result.stdout.toString(),
        'error': result.stderr.toString(),
      };
    } catch (e) {
      return {'success': false, 'error': 'Ошибка клонирования: $e'};
    }
  }

  static Future<Map<String, dynamic>> commit(String repoPath, String message) async {
    if (!_isGitInstalled) {
      return {'success': false, 'error': 'Git не установлен'};
    }

    try {
      await Process.run('git', ['add', '.'], workingDirectory: repoPath);
      final result = await Process.run('git', ['commit', '-m', message], workingDirectory: repoPath);
      return {
        'success': result.exitCode == 0,
        'output': result.stdout.toString(),
        'error': result.stderr.toString(),
      };
    } catch (e) {
      return {'success': false, 'error': 'Ошибка коммита: $e'};
    }
  }

  static Future<Map<String, dynamic>> push(String repoPath, String remote, String branch) async {
    if (!_isGitInstalled) {
      return {'success': false, 'error': 'Git не установлен'};
    }

    try {
      final result = await Process.run('git', ['push', remote, branch], workingDirectory: repoPath);
      return {
        'success': result.exitCode == 0,
        'output': result.stdout.toString(),
        'error': result.stderr.toString(),
      };
    } catch (e) {
      return {'success': false, 'error': 'Ошибка пуша: $e'};
    }
  }

  static Future<Map<String, dynamic>> pull(String repoPath, String remote, String branch) async {
    if (!_isGitInstalled) {
      return {'success': false, 'error': 'Git не установлен'};
    }

    try {
      final result = await Process.run('git', ['pull', remote, branch], workingDirectory: repoPath);
      return {
        'success': result.exitCode == 0,
        'output': result.stdout.toString(),
        'error': result.stderr.toString(),
      };
    } catch (e) {
      return {'success': false, 'error': 'Ошибка пула: $e'};
    }
  }
}
