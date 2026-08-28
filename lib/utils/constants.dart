class AppConstants {
  static const String appName = 'Vorxy Code Editor';
  static const String version = '3.2.0';
  static const String developer = 'GOSTOWN Co.';
  static const String telegramChannel = 'https://t.me/VorxyCodeEditor';
  static const String telegramChat = 'https://t.me/VorxyCodeEditorChat';
  static const String supportEmail = 'vorxygtn@mail.ru';

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
  ];

  static const Map<String, Map<String, String>> translations = {
    'ru': {
      'app_name': 'Vorxy Code Editor',
      'settings': 'Настройки',
      'languages': 'Языки программирования',
      'editor': 'Редактор',
      'files': 'Файлы',
      'dark_theme': 'Тёмная тема',
      'light_theme': 'Светлая тема',
      'auto_save': 'Автосохранение',
      'support': 'Поддержка',
      'telegram_channel': 'Telegram-канал',
      'telegram_chat': 'Чат Telegram',
      'report_bug': 'Сообщить об ошибке',
      'legal': 'Юридическая информация',
      'privacy_policy': 'Политика конфиденциальности',
      'terms': 'Пользовательское соглашение',
      'about': 'О приложении',
      'name': 'Название',
      'version': 'Версия',
      'developer': 'Разработчик',
      'exit': 'Выйти',
      'language': 'Язык интерфейса',
      'save': 'Сохранить',
      'done': 'Готово',
      'select_language': 'Выберите язык',
      'language_changed': 'Язык изменён на',
      'file_saved': 'Файл сохранён',
      'file_saved_msg': 'Файл сохранён',
      'error': 'Ошибка',
      'close': 'Закрыть',
      'general': 'Общие',
      'about_app': 'О приложении',
      // НОВЫЙ ПОЛНЫЙ ТЕКСТ ДЛЯ ЭКРАНА "О ПРИЛОЖЕНИИ"
      'about_full_text': 
        'Vorxy Code Editor — это мобильная среда разработки для устройств на базе Android. '
        'Приложение позволяет писать, редактировать и сохранять код на 10 языках программирования '
        'с подсветкой синтаксиса.\n\n'
        'Приложение разработано для программистов, студентов и всех, кто хочет иметь доступ к '
        'своему коду в любое время и в любом месте.\n\n'
        'Поддерживаемые языки:\n'
        '• Python\n'
        '• C\n'
        '• C++\n'
        '• Java\n'
        '• C#\n'
        '• JavaScript\n'
        '• Visual Basic\n'
        '• SQL\n'
        '• R\n'
        '• Rust\n\n'
        'Для кого это приложение:\n'
        '• Разработчики программного обеспечения\n'
        '• Студенты IT-специальностей\n'
        '• Преподаватели программирования\n'
        '• Любители и энтузиасты\n\n'
        '© 2026 GOSTOWN Co. Все права защищены.',
      'description': 
        'Мобильная среда разработки для создания и редактирования кода на 10 языках программирования.',
      'system_requirements': 'Системные требования',
      'system_requirements_list': 'Android 7.0 и выше. 25 МБ свободного места.',
      'privacy_title': 'Политика конфиденциальности',
      'terms_title': 'Пользовательское соглашение',
      'code_ready': 'Напишите код здесь...',
      'language_label': 'Язык:',
      'line': 'строк',
      'undo_hint': 'Отменить',
      'redo_hint': 'Повторить',
    },
    'en': {
      'app_name': 'Vorxy Code Editor',
      'settings': 'Settings',
      'languages': 'Programming Languages',
      'editor': 'Editor',
      'files': 'Files',
      'dark_theme': 'Dark Theme',
      'light_theme': 'Light Theme',
      'auto_save': 'Auto Save',
      'support': 'Support',
      'telegram_channel': 'Telegram Channel',
      'telegram_chat': 'Telegram Chat',
      'report_bug': 'Report Bug',
      'legal': 'Legal Information',
      'privacy_policy': 'Privacy Policy',
      'terms': 'Terms of Service',
      'about': 'About',
      'name': 'Name',
      'version': 'Version',
      'developer': 'Developer',
      'exit': 'Exit',
      'language': 'Interface Language',
      'save': 'Save',
      'done': 'Done',
      'select_language': 'Select language',
      'language_changed': 'Language changed to',
      'file_saved': 'File saved',
      'file_saved_msg': 'File saved',
      'error': 'Error',
      'close': 'Close',
      'general': 'General',
      'about_app': 'About',
      // НОВЫЙ ПОЛНЫЙ ТЕКСТ ДЛЯ ЭКРАНА "О ПРИЛОЖЕНИИ" (АНГЛ)
      'about_full_text':
        'Vorxy Code Editor is a mobile development environment for Android devices. '
        'The application allows you to write, edit and save code in 10 programming '
        'languages with syntax highlighting.\n\n'
        'The application is designed for programmers, students and anyone who wants '
        'to have access to their code anytime, anywhere.\n\n'
        'Supported languages:\n'
        '• Python\n'
        '• C\n'
        '• C++\n'
        '• Java\n'
        '• C#\n'
        '• JavaScript\n'
        '• Visual Basic\n'
        '• SQL\n'
        '• R\n'
        '• Rust\n\n'
        'Who is this application for:\n'
        '• Software developers\n'
        '• IT students\n'
        '• Programming teachers\n'
        '• Hobbyists and enthusiasts\n\n'
        '© 2026 GOSTOWN Co. All rights reserved.',
      'description':
        'Mobile development environment for creating and editing code in 10 programming languages.',
      'system_requirements': 'System Requirements',
      'system_requirements_list': 'Android 7.0 and above. 25 MB free space.',
      'privacy_title': 'Privacy Policy',
      'terms_title': 'Terms of Service',
      'code_ready': 'Write your code here...',
      'language_label': 'Language:',
      'line': 'lines',
      'undo_hint': 'Undo',
      'redo_hint': 'Redo',
    },
  };

  // ... (остальные константы без изменений: languageDescriptions, privacyPolicyTranslations, termsTranslations, getPrivacyPolicy, getTerms)
  // Они остаются ТАКИМИ ЖЕ, как в вашем исходном файле
  // Я не стал их дублировать, чтобы не тратить лимит, но они должны остаться
}
