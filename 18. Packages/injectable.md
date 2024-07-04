`injectable` - это библиотека для Flutter и Dart, которая упрощает внедрение зависимостей (Dependency Injection, DI) с помощью аннотаций и генерации кода. Она тесно интегрируется с `get_it`, популярным сервис-локатором, что позволяет автоматизировать создание и управление зависимостями.

### Установка в pubspec.yaml
```yaml
dependencies:  
  # add injectable to your dependencies  
  injectable:  
  # add get_it  
  get_it:  
  
dev_dependencies:  
  # add the generator to your dev_dependencies  
  injectable_generator:  
  # add build runner if not already added  
  build_runner: 
```


### Setup
```dart
final getIt = GetIt.instance;  
  
@InjectableInit(  
	generateForDir: ['lib'],
	initializerName: 'init', 
	preferRelativeImports: true,
	asExtension: true, 
)  
Future<void> configureDependencies(String env) => getIt.init(environment: env);  
```

- **`generateForDir: ['lib']`:**
    - **Описание:** Определяет, для каких директорий следует генерировать код зависимостей.
    - **Пояснение:** В данном случае, `injectable` будет сканировать только папку `lib` для поиска классов, помеченных аннотациями `@injectable`, `@singleton`, и т.д., и генерировать код для них.
    - **Преимущества:** Ускоряет процесс генерации кода, так как сканируется только указанная директория.

- **`initializerName: 'init'`:**
    - **Описание:** Указывает имя функции инициализации, которую нужно сгенерировать.
    - **Пояснение:** В данном случае, имя функции инициализации будет `init`. Эта функция будет содержать весь код для регистрации зависимостей в `getIt`.
    - **Преимущества:** Позволяет кастомизировать имя функции, что может быть полезно для различения нескольких конфигураций в больших проектах.

- **`preferRelativeImports: true`:**
    - **Описание:** Определяет, использовать ли относительные пути для импортов в сгенерированном коде.
    - **Пояснение:** Если `true`, то для всех импортов в сгенерированном коде будут использоваться относительные пути (например, `import '../service/my_service.dart';`).
    - **Преимущества:** Предотвращает проблемы с путями при перемещении или копировании проекта в другую директорию. Делает код более переносимым.

- **`asExtension: true`:**
    - **Описание:** Определяет, будет ли функция инициализации генерироваться как расширение для экземпляра `GetIt`.
    - **Пояснение:** Если `true`, то будет сгенерирован метод расширения для `GetIt`, например, `getIt.init()`.
    - **Преимущества:** Удобство использования, так как это позволяет вызывать метод инициализации прямо на экземпляре `GetIt`, улучшая читаемость и структуру кода.

### main.dart
```dart
void main() {  
	runZonedGuarded(() async {
		WidgetsFlutterBinding.ensureInitialized();
			await configureDependency(Environment.prod);
			runApp(MyApp());
		}, (error, stack) {
		getIt<Talker>().handle(error, stack, "Uncaught exeption");
	});
}  
```

### Аннотации

#### Пример регистрации репозитория с дата сурсом

Repository
```dart
abstract interface class IRepository {
  Future<void> getString();
}

@Injectable(as: IRepository, env: [Environment.prod])
class Repository implements IRepository {
	final IDataSource _dbDataSource;

	Future<void> getString(){
		_dbDataSource.getString();
	}
}
```

Data source
```dart
abstract interface class IDataSource {
  Future<void> getString();
}

@Injectable(as: IDataSource, env: [Environment.prod])
class DataSource implements IDataSource {
	final Database _database; //регистрируем в @module
	const DbReportsDataSource({required Database database})
		 : _database = database;
      
	Future<void> getString(){
		_database.getString();
	}
}
```

а для блока  просто пишем @singleton
```dart
@singleton
class SomeBloc extends Bloc<SomeEvent, SomeState> {
	final IRepository _repository;

	DetailReportBloc({required IRepository repository})
		: _repository = repository, 
			super(SomeInitial()) {
	on<SomeEvent>(_do);
  }
```

#### Инжектирование модулей

Модули помогают сгруппировать связанные зависимости в одном месте. Это упрощает управление и обслуживание кода, так как все зависимости, связанные с определенной областью, находятся в одном классе.
```dart

@module
abstract class AppModule {
  @Singleton(env: [Environment.prod])
  Talker getTalker() {
    return TalkerFlutter.init(
      filter: BaseTalkerFilter(types: []),
      settings: TalkerSettings(enabled: true),
    );
  }
  
  @preResolve
  @Singleton(env: [Environment.prod])
  Future<Database> getDatabase() async {
    return await DBProvider.db.database(tableName: "datatableName");
  }
  
  @preResolve
  @Singleton(env: [Environment.prod])
  Future<SharedPreferences> getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }
}
```



- **@injectable** - Помечает класс для автоматического создания и регистрации зависимостей.
- **@singleton** - Единственный экземпляр
- **@lazySingleton** - Создается при первом **запросе**
- **@preResolve** - Если возвращает Future<> можно пометить этой аннотацией
- **@module** - Определяет класс, который предоставляет зависимости для контейнера

- **@Named** - Позволяет делать несколько реализаций одного и того же интерфейса
```dart
//пример использования на интерфейсе IConfig
@Named("ChuckConfig")
@Injectable(as: IRepository, env: [Environment.prod])
class Repository1 implements IConfig {...}

@Named("AnotherConfig")
@Injectable(as: IRepository, env: [Environment.prod])
class Repository2 implements IConfig {...}

final chuckConfig = getIt<IConfig>(instanceName: 'ChuckConfig');
final anotherConfig = getIt<IConfig>(instanceName: 'AnotherConfig');
```
