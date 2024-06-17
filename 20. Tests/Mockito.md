##### Добавление в pubspec.yaml
```bash
flutter pub add --dev mockito
```

### Пояснение
Благодаря mock классам можно тестировать конкретно работу репозитория и то что вызывается его правильный метод. Обеспечивает тестирование отдельных компонентов без зависимости от внешних систем

У нас есть data source или класс которому нужно сделать заглушку
```dart
class Cat {
  String sound() => "Meow";
  bool eatFood(String food, {bool? hungry}) => true;
  Future<void> chew() async => print("Chewing...");
  int walk(List<String> places) => 7;
  void sleep() {}
  void hunt(String place, String prey) {}
  int lives = 9;
}
```

В папке test в любом файле прописываем классы для которых нужно сгенерировать mock
```dart
@GenerateNiceMocks([MockSpec<Cat>()])
void main() {}
```

После генерируем эти классы-заглушки (они будут в текущей директории)
```shell
flutter pub run build_runner build
```

Использование
[[Unit tests#Mock test]]