
## Что такое OpenAPI?

OpenAPI (ранее Swagger) — это спецификация, описывающая API. Она позволяет документировать API в формате YAML или JSON, чтобы:

- Легко генерировать клиентский и серверный код.
- Упростить взаимодействие между фронтенд- и бэкенд-разработчиками.
- Проверять корректность запросов и ответов.

Пример спецификации OpenAPI:

```yaml
openapi: 3.0.0
info:
  title: Workout API
  version: 1.0.0
paths:
  /workoutPrevious/section/{sectionId}:
    get:
      summary: Get workouts for previous days
      parameters:
        - name: sectionId
          in: path
          required: true
          schema:
            type: integer
      responses:
        200:
          description: List of workouts
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Schedule'
components:
  schemas:
    Schedule:
      type: object
      properties:
        id:
          type: integer
        workouts:
          type: array
          items:
            type: string
```

## Что такое Chopper?

[Chopper](https://pub.dev/packages/chopper) — это библиотека для создания API-клиентов во Flutter. Она поддерживает:

- Генерацию клиентского кода на основе OpenAPI.
- Удобную обработку запросов и ответов.

## Установка Chopper

Добавьте зависимости в `pubspec.yaml`:

```yaml
dependencies:
  chopper: ^4.0.0

dev_dependencies:
  build_runner: ^2.0.0
  chopper_generator: ^4.0.0
```

Установите пакеты:

```bash
flutter pub get
```

## Как использовать OpenAPI и Chopper

### 1. Подготовка спецификации OpenAPI

Если у вас уже есть спецификация (например, файл `openapi.yaml`), вы можете использовать её для генерации кода. Если спецификации нет, попросите бэкенд-разработчика её предоставить.

### 2. Генерация API-клиента

#### Установите OpenAPI Generator

Для генерации кода вам нужен инструмент [openapi-generator-cli](https://openapi-generator.tech/):

```bash
brew install openapi-generator # Для macOS
choco install openapi-generator-cli # Для Windows
```

#### Генерация кода

Выполните команду для генерации Dart-клиента с поддержкой Chopper:

```bash
openapi-generator-cli generate \
  -i openapi.yaml \
  -g dart-dio-next \
  -o ./generated \
  --additional-properties=useChopper=true
```

- `-i` — путь к файлу спецификации.
- `-g` — язык генерации (Dart).
- `-o` — папка для сгенерированного кода.
- `--additional-properties=useChopper=true` — включение Chopper.

### 3. Подключение сгенерированного клиента

Переместите сгенерированные файлы в папку вашего проекта, например: `lib/generated/`.

Создайте экземпляр ChopperClient:

```dart
import 'package:chopper/chopper.dart';
import 'generated/openapi.swagger.dart';

final chopper = ChopperClient(
  baseUrl: 'https://api.example.com',
  services: [Openapi()], // Подключение сгенерированного клиента
  interceptors: [
    HttpLoggingInterceptor(),
  ],
);

final api = chopper.getService<Openapi>();
```

### 4. Вызов API

Теперь вы можете вызывать методы API, сгенерированные из OpenAPI:

```dart
Future<void> fetchWorkouts() async {
  final response = await api.workoutPreviousSectionSectionIdGet(sectionId: 1);

  if (response.isSuccessful) {
    print(response.body); // Объект Schedule
  } else {
    print('Error: ${response.statusCode}');
  }
}
```

### 5. Обработка ошибок

Для обработки ошибок используйте перехватчики (interceptors) или обрабатывайте их вручную:

```dart
class ErrorInterceptor extends RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    print('Request: ${request.url}');
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) {
    if (!response.isSuccessful) {
      throw Exception('Error: ${response.statusCode}');
    }
    return response;
  }
}
```

Добавьте интерцептор в ChopperClient:

```dart
final chopper = ChopperClient(
  baseUrl: 'https://api.example.com',
  services: [Openapi()],
  interceptors: [ErrorInterceptor()],
);
```

### 6. Генерация моделей (опционально)

Если требуется кастомная обработка моделей, вы можете использовать пакеты, такие как `json_serializable`.

Пример модели:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final int id;
  final List<String> workouts;

  Schedule({required this.id, required this.workouts});

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
```

## Полезные ссылки

- [OpenAPI Generator](https://openapi-generator.tech/)
- [Chopper на Pub.dev](https://pub.dev/packages/chopper)
- [Документация OpenAPI](https://swagger.io/specification/)

Теперь вы готовы работать с OpenAPI и Chopper во Flutter!



