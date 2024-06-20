### Локализация приложения при помощи flutter_localizations

Это официальная библиотека интернационализации и локализации для Flutter, поставляемая Google. Она предоставляет переведенные строки и локализованные виджеты для различных локалей.

#### Добавление зависимостей 
```
flutter pub add flutter_localizations--sdk=flutter 
flutter pub add intl:any
```

#### Настройка
Для корректной работы потребуется внести некоторые изменения в проект:

1. В  pubspec.yaml необходимо добавить 
```
	flutter:
	  generate: true
```

2. В директории проекта необходимо создать файл `l10n.yaml`
Пример дефолтных настроек:
```
arb-dir: lib/src/localizations //путь до arb файлов
template-arb-file: en.arb
output-localization-file: app_localizations.dart //путь до файла локализации
```

3. Теперь, когда есть путь, можно создать файлы с необходимыми языками
![[Pasted image 20240601022610.png]]
В моём проекте это выглядит так.

4. Наполнение локализации
Файл `ru.arb`
```
{
    "@@locale": "ru", //Указываем язык текущего файла
    "string1": "Строка на русском языке",
    "string2": "Строка однозначно русском языке"
}
```

Файл `en.arb`
```
{
    "@@locale": "en", //Указываем язык текущего файла
    "string1": "The string is in English",
    "string2": "The string is exactly in English"
}
```

Конечно, это далеко не весь функционал библиотеки.
Больше возможностей в [официальной документации](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)

5. Генерация
К сожалению, наше приложение не может читать прямиком из arb файлов, поэтому, нам нужно выполнить команду `flutter gen-l10n`, после чего будет сгенерирован файл `app_localizations.dart` (В соответствии с `l10n.yaml`). По пути `.dart_tool/flutter_gen/gen_l10n/app_localizations.dart`. Её необходимо выполнять каждый раз при изменении `.arb` файлов

#### Использование
После того, как был сгенерирован `app_localizations.dart`, мы можем обращаться к нему, предварительно импортировав `import 'package:flutter_gen/gen_l10n/app_localizations.dart';` 

Для начала, необходимо сообщить о существовании локализации.
Прописываем это в `MaterialApp`.
```Dart
MaterialApp(
	localizationsDelegates: AppLocalizations.localizationsDelegates,
	supportedLocales: AppLocalizations.supportedLocales,
	home: Container(),
);
```

Теперь, чтобы получить строку пишем `AppLocalizations.of(context)!.string1`.
Узнать текущую локализацию можно при помощи `AppLocalizations.of(context)!.localeName`.

#### Заключение
В этом гайде были рассмотрены основные функции, установка и работа библиотеки. Помимо функции локализации, библиотека помогает с выносом строк, что позитивно влияет на качество и удобство редактирования кода.


*Артём Булаев 06.06.24*


