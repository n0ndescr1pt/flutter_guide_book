```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

	TestWidgetsFlutterBinding.ensureInitialized();
	  
	YourBloc buildBloc() {
		return YourBloc();
	}
	
	group("constructor", () {
		test("works properly", () {
		expect(buildBloc, returnsNormally);
	});
	
	test("has correct initial state", () {
		expect(buildBloc().state, equals(const YourBlocInitial()));
		});
	});
	
	group("InitialEvent", () {
		blocTest<YourBloc, YourBlocState>(
		'emits [YourBlocState] when YourBlocEvent is added.',
		build: () => buildBloc(),
		wait: const Duration(seconds: 1),
		act: (bloc) => bloc.add(const YourBlocEvent()),
		expect: () => [const YourBlocState()],
		verify: (bloc) {
			verify(mockRepository.doSomething(any)).called(1);
			verify(mockRepository.doSomething()).called(1);
 			}, //verify так же можно использовать (только на mock классах) чтобы                удостовериться вызывается ли этот метод
		);
	});
}
```