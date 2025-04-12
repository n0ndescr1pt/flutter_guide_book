# BLoC (Business Logic Component) Architecture

BLoC - это паттерн, который отделяет бизнес-логику от UI, используя реактивное программирование.

## Основные компоненты

1. **Events (События)**
   - Представляют пользовательские действия
   - Неизменяемые объекты
   - Каждое действие пользователя преобразуется в Event

2. **States (Состояния)**
   - Представляют состояние UI
   - Неизменяемые объекты
   - Каждое изменение состояния создает новый State

3. **BLoC**
   - Преобразует Events в States
   - Содержит бизнес-логику
   - Управляет потоком данных

## Пример реализации

```dart
// Events
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

// States
abstract class CounterState {}
class CounterInitial extends CounterState {
  final int count;
  CounterInitial(this.count);
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial(0)) {
    on<IncrementEvent>((event, emit) {
      final currentState = state as CounterInitial;
      emit(CounterInitial(currentState.count + 1));
    });

    on<DecrementEvent>((event, emit) {
      final currentState = state as CounterInitial;
      emit(CounterInitial(currentState.count - 1));
    });
  }
}

// View
class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state is CounterInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Count: ${state.count}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(DecrementEvent());
                      },
                      child: Text('-'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(IncrementEvent());
                      },
                      child: Text('+'),
                    ),
                  ],
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
```

## Сравнение с другими паттернами

### Похож на MVI
- Оба используют однонаправленный поток данных
- Оба разделяют UI и бизнес-логику
- Оба используют реактивное программирование

### Отличия от MVC
- Более строгое разделение ответственности
- Использование реактивного подхода вместо императивного
- Лучшая тестируемость

### Отличия от MVVM
- Более явное управление состоянием
- Использование Events вместо прямых вызовов
- Лучшая изоляция UI

## Преимущества

1. **Предсказуемость**
   - Однонаправленный поток данных
   - Легко отслеживать изменения состояния

2. **Тестируемость**
   - Легко тестировать бизнес-логику
   - Можно тестировать UI отдельно

3. **Масштабируемость**
   - Легко добавлять новые функции
   - Четкое разделение ответственности

## Недостатки

1. **Сложность начальной настройки**
   - Требуется больше кода для базовой функциональности
   - Необходимость создания множества классов

2. **Кривая обучения**
   - Необходимость понимания реактивного программирования
   - Сложность для начинающих разработчиков 