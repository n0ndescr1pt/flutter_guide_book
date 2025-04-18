
## Гайд 1: Установка FVM и переключение версий Flutter (Windows и macOS)

**Что такое FVM?** Flutter Version Management (FVM) – утилита для установки нескольких версий Flutter SDK и быстрого переключения между ними. Это полезно, если разные проекты требуют разные версии Flutter.

### Установка FVM через Pub

- **Windows:** Убедитесь, что Flutter SDK установлен и **Flutter/Dart** доступны в командной строке. Откройте PowerShell/Command Prompt и выполните:
    
    ```bash
    flutter pub global activate fvm
    ```
    
    Это скачает и установит FVM как глобальный пакет Dart ([Полное руководство по использованию FVM (Flutter Version Management) – жонглируйте версиями Flutter sdk в своих проектах / Хабр](https://habr.com/ru/articles/758212/#:~:text=%D0%92%20%D0%BA%D0%B0%D1%87%D0%B5%D1%81%D1%82%D0%B2%D0%B5%20%D0%B4%D1%80%D1%83%D0%B3%D0%BE%D0%B3%D0%BE%20%D1%80%D0%B5%D1%88%D0%B5%D0%BD%D0%B8%D1%8F%20%D0%B2%D1%8B,%D0%BF%D0%B0%D0%BA%D0%B5%D1%82%2C%20%D1%83%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%B8%D0%B2%20%D0%B5%D0%B3%D0%BE%20%D0%BF%D1%80%D0%BE%D1%81%D1%82%D0%BE%D0%B9%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D0%BE%D0%B9)). После установки добавьте путь к FVM в переменные окружения. Для Windows путь по умолчанию – `%USERPROFILE%\AppData\Local\Pub\Cache\bin` (его нужно добавить в `%PATH%`) ([dart - Flutter version management. error : -bash: fvm: command not found - Stack Overflow](https://stackoverflow.com/questions/63468608/flutter-version-management-error-bash-fvm-command-not-found#:~:text=0)). Перезапустите терминал, затем проверьте установку командой `fvm --version`.
    
- **macOS:** Также убедитесь в наличии Flutter SDK. Откройте Terminal и выполните команду:
    
    ```bash
    flutter pub global activate fvm
    ```
    
    После успешной установки убедитесь, что папка с исполняемым файлом FVM добавлена в `PATH`. Как правило, нужно добавить строку
    
    ```bash
    export PATH="$PATH:$HOME/.pub-cache/bin"
    ```
    
    в ваш shell-профиль (`~/.bash_profile`, `~/.zshrc` и т.д.) ([Using Flutter FVM in Windows & MacOS | by Iliyass Zamouri | Medium](https://medium.com/@iliyass.zamouri/using-flutter-fvm-in-windows-1c23e38bccdb#:~:text=,the%20end%20of%20the%20file)). Затем откройте новый терминал и проверьте установку (`fvm --version`).
    

### Установка нужной версии Flutter и переключение

1. **Установка версии Flutter:** Используйте команду `fvm install <версия>` для загрузки указанной версии Flutter. Например:
    
    ```bash
    fvm install 3.19.0
    ```
    
    Эта команда загрузит Flutter SDK версии **3.19.0** и сохранит её в локальном кеш FVM.
    
2. **Переключение версии (глобально):** Чтобы использовать новую версию по умолчанию для всех проектов, выполните:
    
    ```bash
    fvm global 3.19.0
    ```
    
    Теперь команды `fvm flutter ...` вне проектов будут использовать Flutter 3.19.0 (глобальная “default” версия) ([Basic Commands – FVM](https://fvm.app/documentation/guides/basic-commands#:~:text=Global)) ([Basic Commands – FVM](https://fvm.app/documentation/guides/basic-commands#:~:text=Setting%20a%20Global%20Version%3A%20To,global%20version%2C%20you%20would%20run)). Вы можете проверить текущую глобальную версию командой `fvm list` – она покажет все установленные SDK и пометит активную версию.
    
3. **Переключение версии (в конкретном проекте):** Перейдите в каталог проекта и выполните:
    
    ```bash
    fvm use 3.19.0
    ```
    
    FVM скачает (если ещё не скачано) версию 3.19.0 и **активирует её для данного проекта** ([Полное руководство по использованию FVM (Flutter Version Management) – жонглируйте версиями Flutter sdk в своих проектах / Хабр](https://habr.com/ru/articles/758212/#:~:text=,%D0%95%D1%81%D1%82%D1%8C%20%D1%82%D0%B0%D0%BA%D0%B6%D0%B5%20%D0%BD%D0%B5%D0%BA%D0%BE%D1%82%D0%BE%D1%80%D1%8B%D0%B5%20%D0%BF%D0%BE%D0%BB%D0%B5%D0%B7%D0%BD%D1%8B%D0%B5%20%D1%84%D0%BB%D0%B0%D0%B3%D0%B8)). В папке проекта появится директория `.fvm`, внутри которой:
    
    - символьная ссылка `flutter_sdk` указывает на установленный SDK 3.19.0,
        
    - файл `fvm_config.json` хранит информацию о версии Flutter для проекта ([Полное руководство по использованию FVM (Flutter Version Management) – жонглируйте версиями Flutter sdk в своих проектах / Хабр](https://habr.com/ru/articles/758212/#:~:text=,%D0%95%D1%81%D1%82%D1%8C%20%D1%82%D0%B0%D0%BA%D0%B6%D0%B5%20%D0%BD%D0%B5%D0%BA%D0%BE%D1%82%D0%BE%D1%80%D1%8B%D0%B5%20%D0%BF%D0%BE%D0%BB%D0%B5%D0%B7%D0%BD%D1%8B%D0%B5%20%D1%84%D0%BB%D0%B0%D0%B3%D0%B8)).
        

## Использование FVM в проектах Flutter

После установки FVM важно понять, как применять его в реальных проектах для управления версиями SDK.

### Локальная привязка версии через `fvm use`

При выполнении команды `fvm use <версия>` в папке проекта FVM создаёт скрытую папку **`.fvm`**. В ней хранится:

- **Flutter SDK для проекта:** в `.fvm/flutter_sdk` находится ссылка на нужную версию SDK. Эту папку обычно добавляют в `.gitignore`, так как SDK не нужно хранить в репозитории ([Flutter Version Management with FVM: Your New Favorite Tool | Medium](https://medium.com/@flutterwtf/flutter-version-management-with-fvm-your-new-favorite-tool-600b9f44b112#:~:text=%2A%20%60.fvm%2Fflutter_sdk%60%20,and%20paste%20the%20following%20line)).
    
- **Конфигурация проекта `fvm_config.json`:** файл с указанием версии Flutter для данного проекта ([Flutter Version Management with FVM: Your New Favorite Tool | Medium](https://medium.com/@flutterwtf/flutter-version-management-with-fvm-your-new-favorite-tool-600b9f44b112#:~:text=%2A%20%60.fvm%2Fflutter_sdk%60%20,and%20paste%20the%20following%20line)). Например, после `fvm use 3.19.0` файл будет содержать `"flutterSdkVersion": "3.19.0"`. **Не меняйте этот файл вручную**, FVM обновляет его автоматически. Рекомендуется добавить `fvm_config.json` в систему контроля версий, чтобы у всех разработчиков проекта была единая версия Flutter ([A Complete Guide to Using Flutter Version Management](https://dianapps.com/blog/a-complete-guide-to-using-flutter-version-management-fvm/#:~:text=)). Новый участник команды может клонировать проект и просто выполнить `fvm install` – FVM прочитает `fvm_config.json` и скачает нужную версию SDK ([A Complete Guide to Using Flutter Version Management](https://dianapps.com/blog/a-complete-guide-to-using-flutter-version-management-fvm/#:~:text=fvm_config,up%20their%20environment%20by%20running)).
    

### Выполнение Flutter-команд через FVM

Чтобы выполнить команды Flutter с учётом версии, заданной FVM, используйте префикс `fvm`. FVM перехватывает стандартные команды Flutter и направляет их в нужный SDK ([Полное руководство по использованию FVM (Flutter Version Management) – жонглируйте версиями Flutter sdk в своих проектах / Хабр](https://habr.com/ru/articles/758212/#:~:text=,%D0%B8%20%D1%82.%D0%B4)). Примеры основных команд:

- **Получение пакетов:** вместо `flutter pub get` в проекте под FVM выполните:
    
    ```bash
    fvm flutter pub get
    ```
    
    Это запустит получение зависимостей для версии Flutter, указанной в `fvm_config.json`.
    
- **Запуск приложения:** вместо `flutter run` используйте:
    
    ```bash
    fvm flutter run
    ```
    
    Команда запустит приложение с Flutter SDK, привязанным к проекту ([Flutter Version Management with FVM: Your New Favorite Tool | Medium](https://medium.com/@flutterwtf/flutter-version-management-with-fvm-your-new-favorite-tool-600b9f44b112#:~:text=Running%20Flutter%20App)). Аналогично для сборки: `fvm flutter build <таргет>` (например, APK, iOS), тестирования: `fvm flutter test` и т.д. – достаточно добавить префикс `fvm` перед обычной командой Flutter.
    
- **Dart-команды:** FVM также может выполнять команды Dart, связанные с текущим Flutter SDK. Например, `fvm dart pub get` эквивалентен вышеуказанной команде и работает через ту же версию Dart/Flutter SDK.
    

Помните: если вы находитесь внутри проекта с настроенным FVM, **всегда запускайте Flutter-команды с префиксом `fvm`**, чтобы использовать корректную версию SDK. Если запустить команду напрямую (`flutter run`), она возьмёт глобальный Flutter из PATH, что может привести к несоответствиям версий.

### Полезные советы при работе с FVM

- **Смена версии в проекте:** Вы можете в любой момент переключить версию Flutter, выполнив снова `fvm use <другая_версия>` в папке проекта. FVM обновит символическую ссылку и `fvm_config.json` для нового SDK. Весь последующий `fvm flutter ...` будет выполняться с новой версией.
    
- **Глобальная версия по умолчанию:** Если в проекте **не** выполнен `fvm use` (нет локальной конфигурации), то при вызове `fvm flutter <команда>` используется глобальная версия (настроенная через `fvm global`) ([Basic Commands – FVM](https://fvm.app/documentation/guides/basic-commands#:~:text=Global)) ([Basic Commands – FVM](https://fvm.app/documentation/guides/basic-commands#:~:text=Setting%20a%20Global%20Version%3A%20To,global%20version%2C%20you%20would%20run)). Обычно рекомендуется явно задавать версию на проект, а глобальную использовать только при необходимости.
    
- **Совместная разработка:** Храните файл `fvm_config.json` в репозитории, чтобы все участники использовали одну версию SDK ([A Complete Guide to Using Flutter Version Management](https://dianapps.com/blog/a-complete-guide-to-using-flutter-version-management-fvm/#:~:text=)). Игнорируйте `.fvm/flutter_sdk` в Git, чтобы не включать сам SDK ([Flutter Version Management with FVM: Your New Favorite Tool | Medium](https://medium.com/@flutterwtf/flutter-version-management-with-fvm-your-new-favorite-tool-600b9f44b112#:~:text=%2A%20%60.fvm%2Fflutter_sdk%60%20,and%20paste%20the%20following%20line)). После клонирования проекта достаточно выполнить `fvm install` и затем `fvm flutter pub get`, чтобы настроиться на нужную версию.
    
- **CI/CD:** В средах непрерывной интеграции можно установить FVM и добавить шаги `fvm install` (для установки версии из config) и команды через `fvm flutter ...` для сборки и тестов, чтобы гарантировать консистентность версии на сервере сборки ([A Complete Guide to Using Flutter Version Management](https://dianapps.com/blog/a-complete-guide-to-using-flutter-version-management-fvm/#:~:text=Ensure%20consistency%20across%20team%20members,up%20their%20environment%20by%20running)) ([A Complete Guide to Using Flutter Version Management](https://dianapps.com/blog/a-complete-guide-to-using-flutter-version-management-fvm/#:~:text=used%20during%20builds%20and%20tests,An%20example%20CI%20command)).
    