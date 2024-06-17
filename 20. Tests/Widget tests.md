
Так же можно тестировать локализацию 
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

TestWidgetsFlutterBinding.ensureInitialized();

	group("описание", () {
		setUpAll(() {
			//тот же setUp() только для асинхроннщины
		});
	
		testWidgets("", (WidgetTester tester) async {
			await tester.pumpWidget( 
				MaterialApp(
				localizationsDelegates: AppLocalizations.localizationsDelegates,
				supportedLocales: AppLocalizations.supportedLocales,
				locale: const Locale('en'),
				home: MainApp(),
			);
			await tester.pump(); //ждет время для инициализации виджетов
			
			expect(find.byKey(const Key("reportScreen")), findsOneWidget);
		});
	});
}
```