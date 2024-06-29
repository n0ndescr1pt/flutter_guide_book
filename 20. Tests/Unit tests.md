
###  Installing
```shell
import 'package:flutter_test/flutter_test.dart';
```

#### Testing

`setUp()` будет выполняться перед каждым тестом в группе или наборе тестов, а `tearDown()` будет выполняться после него

```dart
@OnPlatform({
  // спецификации платформы к примеру дает windows больше времени.
  'windows': Timeout.factor(2)
})


void main() {
	setUp((){
	//code
	});

	tearDown((){
	//code
	});
	
	group("групирование тестов по какому то признаку", () {
	
		test(
		'описание', () {
			int result = 1+1;
			expect(result, 2);
		});
		
		test('do a thing', () {
		    // ...
		}, onPlatform: {
		    'safari': Skip('Safari is currently broken (see #1234)')
		});
  });
}
```

#### Mock test

На mock классах можно проверять сколько раз и какой метод был вызван
```dart
test('should call getCurrentReportType method', () {
verify(cat.sound();).called(1);
});

when(cat.sound()).thenReturn("Meow");
expect(cat.sound(), "Meow");
```

#### Тестирование shared preferences

```dart
test('Can Create Preferences', () async{

    SharedPreferences.setMockInitialValues({}); //set values here
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool working = false;
    String name = 'john';
    pref.setBool('working', working);
    pref.setString('name', name);

    expect(pref.getBool('working'), false);
    expect(pref.getString('name'), 'john');
  });
```

#### Тестирование sqflite

Установка
```yaml
flutter pub add --dev sqflite_common_ffi
```

```dart
void main() async {
	late Database database;
  
	setUpAll(() async {
		sqfliteFfiInit();
		database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
		await database.execute('''
		CREATE TABLE $tableName (
		id TEXT PRIMARY KEY,
		data DATE,
		name TEXT
		)
		''');
	});

	test('test db', () async {
	await database.delete($tableName)
	}
}
```