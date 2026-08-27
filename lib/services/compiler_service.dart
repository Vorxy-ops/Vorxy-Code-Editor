import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CompilerService {
  static const String _pistonApiUrl = 'https://emkc.org/api/v2/piston';

  Future<Map<String, dynamic>> runCode(String code, String language) async {
    final langMap = _getLanguageConfig(language);
    if (langMap['local'] == true) {
      return await _runLocal(code, language);
    } else {
      return await _runCloud(code, language);
    }
  }

  Map<String, dynamic> _getLanguageConfig(String language) {
    final Map<String, dynamic> configs = {
      'python': {'local': true, 'extension': 'py', 'command': 'python3'},
      'javascript': {'local': true, 'extension': 'js', 'command': 'node'},
      'c': {'local': true, 'extension': 'c', 'command': 'gcc'},
      'cpp': {'local': true, 'extension': 'cpp', 'command': 'g++'},
      'java': {'local': true, 'extension': 'java', 'command': 'javac'},
      'html': {'local': true, 'extension': 'html', 'command': ''},
      'c#': {'local': false, 'extension': 'cs', 'command': 'dotnet'},
      'visual basic': {'local': false, 'extension': 'vb', 'command': 'vbc'},
      'sql': {'local': false, 'extension': 'sql', 'command': 'sqlite3'},
      'r': {'local': false, 'extension': 'r', 'command': 'Rscript'},
      'rust': {'local': false, 'extension': 'rs', 'command': 'rustc'},
    };
    return configs[language.toLowerCase()] ?? {'local': false, 'extension': 'txt', 'command': ''};
  }

  Future<Map<String, dynamic>> _runLocal(String code, String language) async {
    try {
      if (language.toLowerCase() == 'html') {
        return {
          'success': true,
          'output': 'HTML код готов к просмотру в Web Preview',
          'error': '',
          'exitCode': 0,
        };
      }
      final dir = await getTemporaryDirectory();
      final langConfig = _getLanguageConfig(language);
      final fileName = 'temp.${langConfig['extension']}';
      final filePath = path.join(dir.path, fileName);
      final file = File(filePath);
      await file.writeAsString(code);

      final result = await Process.run(langConfig['command'], [filePath]);
      final output = result.stdout.toString();
      final error = result.stderr.toString();

      await file.delete();

      return {
        'success': result.exitCode == 0,
        'output': output.isNotEmpty ? output : 'Программа выполнена успешно',
        'error': error,
        'exitCode': result.exitCode,
      };
    } catch (e) {
      return {
        'success': false,
        'output': '',
        'error': 'Ошибка выполнения: $e',
        'exitCode': 1,
      };
    }
  }

  Future<Map<String, dynamic>> _runCloud(String code, String language) async {
    try {
      final response = await http.post(
        Uri.parse('$_pistonApiUrl/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'language': language.toLowerCase(),
          'source': code,
          'stdin': '',
        }),
        timeout: const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'output': data['run']['stdout'] ?? 'Выполнено',
          'error': data['run']['stderr'] ?? '',
          'exitCode': data['run']['code'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'output': '',
          'error': 'Ошибка сервера: ${response.statusCode}',
          'exitCode': 1,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'output': '',
        'error': 'Ошибка подключения: $e',
        'exitCode': 1,
      };
    }
  }
}
