#### Устанавливаем пакета
```shell
flutter pub add flutter_launcher_icons
```

#### Прописываем в pubspec.yaml
```yaml
dev_dependencies:
  flutter_launcher_icons: "^0.13.1"

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  min_sdk_android: 21 # android min sdk min:16, default 21
  web:
    generate: true
    image_path: "path/to/image.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"
  windows:
    generate: true
    image_path: "path/to/image.png"
    icon_size: 48 # min:48, max:256, default: 48
  macos:
    generate: true
    image_path: "path/to/image.png"
```

#### Обновляем пакеты и иконку
```shell
flutter pub get
flutter pub run flutter_launcher_icons
```

ссылка на pub.dev [click](https://pub.dev/packages/flutter_launcher_icons)


