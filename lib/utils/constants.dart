class AppConstants {
  static const String appName = 'Vorxy Code Editor';
  static const String version = '3.7.7';
  static const String developer = 'GOSTOWN Co.';
  static const String telegramChannel = 'https://t.me/VorxyCodeEditor';
  static const String telegramChat = 'https://t.me/VorxyCodeEditorChat';
  static const String githubRepo = 'https://github.com/Vorxy-ops/Vorxy-Code-Editor.git';
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
      'theme': 'Тема',
      'telegram_channel': 'Telegram-канал',
      'telegram_chat': 'Чат Telegram',
      'github': 'GitHub',
      'legal': 'Юридическая информация',
      'privacy_policy': 'Политика конфиденциальности',
      'terms': 'Пользовательское соглашение',
      'about': 'О приложении',
      'name': 'Название',
      'version': 'Версия',
      'developer': 'Разработчик',
      'exit': 'Выйти',
      'yes': 'Да',
      'no': 'Нет',
      'exit_app': 'Выйти из приложения',
      'exit_app_confirm': 'Вы действительно хотите выйти?',
      'language': 'Язык интерфейса',
      'save': 'Сохранить',
      'done': 'Готово',
      'select_language': 'Выберите язык',
      'language_changed': 'Язык изменён на',
      'file_saved': 'Файл сохранён',
      'file_loaded': 'Файл загружен',
      'unsupported_extension': 'Неподдерживаемое расширение файла',
      'error': 'Ошибка',
      'close': 'Закрыть',
      'general': 'Общие',
      'about_app': 'О приложении',
      'save_file': 'Сохранить файл',
      'enter_file_name': 'Введите имя файла',
      'cancel': 'Отмена',
      'file_deleted': 'Файл удалён',
      'no_files': 'Нет сохранённых файлов',
      'save_files_to_view': 'Сохраните или загрузите файл, чтобы он появился здесь',
      'cannot_open_link': 'Не удалось открыть ссылку:',
      'error_loading_file': 'Ошибка загрузки файла:',
      'file_exists': 'Файл со схожим названием уже существует. Переименуйте файл.',
      'delete_file': 'Удалить файл',
      'delete_files': 'Удалить файл(ы)',
      'delete_confirm': 'Вы действительно хотите удалить файл',
      'delete_files_confirm': 'Вы действительно хотите удалить файл(ы)',
      'delete_note': '(примечание: данный(е) файл(ы) будет(ут) удален(ы) из списка файлов приложения и устройства)',
      'delete_all': 'Удалить все файлы',
      'delete_all_confirm': 'Вы действительно хотите удалить все файлы',
      'delete_all_note': '(примечание: все файлы будут удалены из списка файлов приложения и устройства)',
      'select_files': 'Выбрать файлы для удаления',
      'delete_selected': 'Удалить',
      'refresh': 'Обновить список',
      'select_language_label': 'Выберите язык:',
      'share_code': 'Отправить код',
      'chars': 'симв.',
      'line': 'строк',
      'code_ready': 'Напишите код здесь...',
      'language_label': 'Язык:',
      'privacy_title': 'Политика конфиденциальности',
      'terms_title': 'Пользовательское соглашение',
      'about_description': 'Vorxy Code Editor — это мобильная среда разработки для устройств на базе Android. Приложение позволяет писать, редактировать, загружать и сохранять код на 10 языках программирования с подсветкой синтаксиса.',
      'about_full_text': 
        'Vorxy Code Editor — это мобильная среда разработки для устройств на базе Android. '
        'Приложение позволяет писать, редактировать, загружать и сохранять код на 10 языках программирования '
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
        '© 2026 GOSTOWN Co. Все права защищена.',
    },
    'en': {
      'app_name': 'Vorxy Code Editor',
      'settings': 'Settings',
      'languages': 'Programming Languages',
      'editor': 'Editor',
      'files': 'Files',
      'dark_theme': 'Dark Theme',
      'light_theme': 'Light Theme',
      'theme': 'Theme',
      'telegram_channel': 'Telegram Channel',
      'telegram_chat': 'Telegram Chat',
      'github': 'GitHub',
      'legal': 'Legal Information',
      'privacy_policy': 'Privacy Policy',
      'terms': 'Terms of Service',
      'about': 'About',
      'name': 'Name',
      'version': 'Version',
      'developer': 'Developer',
      'exit': 'Exit',
      'yes': 'Yes',
      'no': 'No',
      'exit_app': 'Exit App',
      'exit_app_confirm': 'Do you really want to exit?',
      'language': 'Interface Language',
      'save': 'Save',
      'done': 'Done',
      'select_language': 'Select language',
      'language_changed': 'Language changed to',
      'file_saved': 'File saved',
      'file_loaded': 'File loaded',
      'unsupported_extension': 'Unsupported file extension',
      'error': 'Error',
      'close': 'Close',
      'general': 'General',
      'about_app': 'About',
      'save_file': 'Save file',
      'enter_file_name': 'Enter file name',
      'cancel': 'Cancel',
      'file_deleted': 'File deleted',
      'no_files': 'No saved files',
      'save_files_to_view': 'Save or load a file to see it here',
      'cannot_open_link': 'Unable to open link:',
      'error_loading_file': 'Error loading file:',
      'file_exists': 'A file with a similar name already exists. Please rename the file.',
      'delete_file': 'Delete file',
      'delete_files': 'Delete file(s)',
      'delete_confirm': 'Do you really want to delete the file',
      'delete_files_confirm': 'Do you really want to delete the file(s)',
      'delete_note': '(note: the file(s) will be deleted from the app file list and from the device)',
      'delete_all': 'Delete all files',
      'delete_all_confirm': 'Do you really want to delete all files',
      'delete_all_note': '(note: all files will be deleted from the app file list and from the device)',
      'select_files': 'Select files to delete',
      'delete_selected': 'Delete',
      'refresh': 'Refresh list',
      'select_language_label': 'Select language:',
      'share_code': 'Share code',
      'chars': 'chars',
      'line': 'lines',
      'code_ready': 'Write your code here...',
      'language_label': 'Language:',
      'privacy_title': 'Privacy Policy',
      'terms_title': 'Terms of Service',
      'about_description': 'Vorxy Code Editor is a mobile development environment for Android devices. The application allows you to write, edit, load and save code in 10 programming languages with syntax highlighting.',
      'about_full_text':
        'Vorxy Code Editor is a mobile development environment for Android devices. '
        'The application allows you to write, edit, load and save code in 10 programming '
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
    },
  };

  static const Map<String, Map<String, String>> languageDescriptions = {
    'ru': {
      'python': 'Универсальный язык для AI и веба',
      'c': 'Основа операционных систем',
      'cpp': 'Игры и высоконагруженные системы',
      'java': 'Корпоративная разработка и Android',
      'csharp': 'Windows-приложения и Unity',
      'js': 'Веб-разработка и серверы',
      'vb': 'Классические Windows-приложения',
      'sql': 'Работа с базами данных',
      'r': 'Статистика и научные исследования',
      'rust': 'Безопасные высоконагруженные системы',
    },
    'en': {
      'python': 'Universal language for AI and web',
      'c': 'Foundation of operating systems',
      'cpp': 'Games and high-performance systems',
      'java': 'Enterprise development and Android',
      'csharp': 'Windows apps and Unity',
      'js': 'Web development and servers',
      'vb': 'Classic Windows applications',
      'sql': 'Database management',
      'r': 'Statistics and scientific research',
      'rust': 'Safe high-performance systems',
    },
  };

  static const Map<String, String> privacyPolicyTranslations = {
    'ru': 'ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ Vorxy Code Editor.\n\nДата вступления в силу: 1 сентября 2026 года.\n\n1. Введение.\n\nНастоящая Политика конфиденциальности описывает, как компания GOSTOWN Co. собирает, использует и защищает информацию, которую вы предоставляете при использовании мобильного приложения Vorxy Code Editor.\n\nМы уважаем вашу конфиденциальность и обязуемся защищать ваши персональные данные.\n\n2. Какую информацию мы собираем.\n\nПриложение Vorxy Code Editor работает полностью без интернета и не собирает ваши персональные данные. Мы не запрашиваем, не храним и не передаём информацию о вас третьим лицам.\n\nПри использовании Приложения: Код и файлы хранятся локально на вашем устройстве. Мы не имеем доступа к ним. Настройки сохраняются локально на вашем устройстве. Персональные данные не запрашиваются.\n\n3. Как мы используем вашу информацию.\n\nПоскольку мы не собираем вашу информацию, мы не используем её ни для каких целей.\n\n4. Передача данных третьим лицам.\n\nМы не передаём, не продаём и не обмениваем вашу информацию с третьими лицами.\n\n5. Хранение данных.\n\nВсе ваши данные хранятся исключительно на вашем устройстве.\n\n6. Безопасность.\n\nМы принимаем все разумные меры для защиты данных.\n\n7. Ссылки на сторонние ресурсы.\n\nПриложение может содержать ссылки на внешние ресурсы.\n\n8. Изменения в Политике конфиденциальности.\n\nМы оставляем за собой право обновлять настоящую Политику.\n\n9. Контакты.\n\nTelegram-канал\nЧат Telegram\nGitHub',
    'en': 'PRIVACY POLICY Vorxy Code Editor.\n\nEffective Date: September 1, 2026.\n\n1. Introduction.\n\nThis Privacy Policy describes how GOSTOWN Co. collects, uses and protects the information you provide when using the Vorxy Code Editor mobile application.\n\nWe respect your privacy and are committed to protecting your personal data.\n\n2. What information we collect.\n\nThe Vorxy Code Editor application works completely without internet and does not collect your personal data. We do not request, store or transfer information about you to third parties.\n\nWhen using the Application: Code and files are stored locally on your device. Settings are saved locally on your device. Personal data is not requested.\n\n3. How we use your information.\n\nSince we do not collect your information, we do not use it for any purposes.\n\n4. Transfer of data to third parties.\n\nWe do not transfer, sell or exchange your information with third parties.\n\n5. Data storage.\n\nAll your data is stored exclusively on your device.\n\n6. Security.\n\nWe take all reasonable measures to protect data.\n\n7. Links to third party resources.\n\nThe Application may contain links to external resources.\n\n8. Changes to the Privacy Policy.\n\nWe reserve the right to update this Privacy Policy.\n\n9. Contacts.\n\nTelegram Channel\nTelegram Chat\nGitHub',
  };

  static const Map<String, String> termsTranslations = {
    'ru': 'ПОЛЬЗОВАТЕЛЬСКОЕ СОГЛАШЕНИЕ Vorxy Code Editor.\n\nДата вступления в силу: 1 сентября 2026 года.\n\n1. Общие положения.\n\nНастоящее Пользовательское соглашение регулирует отношения между компанией GOSTOWN Co. и пользователем мобильного приложения Vorxy Code Editor.\n\nИспользование Приложения означает полное и безоговорочное принятие условий настоящего Соглашения.\n\n2. Функционал Приложения.\n\nПриложение предоставляет пользователю возможность писать и редактировать код на 10 языках программирования, сохранять и открывать файлы локально на устройстве, управлять файлами и папками, настраивать внешний вид и поведение редактора.\n\n3. Права и обязанности пользователя.\n\nПользователь обязуется использовать Приложение в соответствии с его функциональным назначением, не использовать Приложение для создания вредоносного кода или ПО, не нарушать законодательство страны проживания.\n\nПользователь имеет право бесплатно использовать все функции Приложения, сохранять свой код и файлы локально.\n\n4. Права и обязанности Правообладателя.\n\nПравообладатель обязуется предоставлять доступ к Приложению и его функциям, исправлять выявленные ошибки и улучшать Приложение, обеспечивать работу каналов связи.\n\nПравообладатель имеет право вносить изменения в функционал Приложения и обновлять Соглашение.\n\n5. Ограничение ответственности.\n\nПриложение предоставляется как есть. Правообладатель не гарантирует, что Приложение будет работать без ошибок и сбоев.\n\nПравообладатель не несёт ответственности за потерю данных, ущерб, работу сторонних сервисов.\n\n6. Интеллектуальная собственность.\n\nКод Приложения и его дизайн являются интеллектуальной собственностью Правообладателя.\n\nПользователь сохраняет все права на свой код и файлы.\n\n7. Заключительные положения.\n\nСоглашение вступает в силу с момента первого использования Приложения.\n\nВсе споры решаются в соответствии с законодательством страны регистрации Правообладателя.\n\n8. Контакты.\n\nTelegram-канал\nЧат Telegram\nGitHub',
    'en': 'TERMS OF SERVICE Vorxy Code Editor.\n\nEffective Date: September 1, 2026.\n\n1. General Provisions.\n\nThis Terms of Service governs the relationship between GOSTOWN Co. and the user of the Vorxy Code Editor mobile application.\n\nUse of the Application constitutes full and unconditional acceptance of the terms of this Agreement.\n\n2. Functionality of the Application.\n\nThe Application provides the user with the ability to write and edit code in 10 programming languages, save and open files locally on the device, manage files and folders, customize the appearance and behavior of the editor.\n\n3. Rights and obligations of the user.\n\nThe user undertakes to use the Application in accordance with its functional purpose, not to use the Application to create malicious code or software, not to violate the laws of the country of residence.\n\nThe user has the right to use all features of the Application for free, save code and files locally.\n\n4. Rights and obligations of the Copyright Holder.\n\nThe Copyright Holder undertakes to provide access to the Application and its functions, correct identified errors and improve the Application, ensure the operation of communication channels.\n\nThe Copyright Holder has the right to make changes to the functionality of the Application and update this Agreement.\n\n5. Limitation of liability.\n\nThe Application is provided as is. The Copyright Holder does not guarantee that the Application will operate without errors and failures.\n\nThe Copyright Holder is not responsible for loss of data, damage, operation of third-party services.\n\n6. Intellectual property.\n\nThe Application code and its design are the intellectual property of the Copyright Holder.\n\nThe user retains all rights to their code and files.\n\n7. Final provisions.\n\nThis Agreement comes into force from the moment of first use of the Application.\n\nAll disputes are resolved in accordance with the legislation of the country of registration of the Copyright Holder.\n\n8. Contacts.\n\nTelegram Channel\nTelegram Chat\nGitHub',
  };

  static String getPrivacyPolicy(String langCode) {
    return privacyPolicyTranslations[langCode] ?? privacyPolicyTranslations['ru']!;
  }

  static String getTerms(String langCode) {
    return termsTranslations[langCode] ?? termsTranslations['ru']!;
  }
}
