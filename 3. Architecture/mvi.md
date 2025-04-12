# MVI (Model-View-Intent) Architecture

MVI - это архитектурный паттерн, который следует принципам реактивного программирования и однонаправленного потока данных.

## Основные компоненты

1. **Model (Модель)**
   - Представляет состояние UI
   - Неизменяемый (immutable)
   - Содержит все данные, необходимые для отображения

2. **View (Представление)**
   - Отображает состояние из Model
   - Отправляет пользовательские действия как Intent
   - Не содержит бизнес-логики

3. **Intent (Намерение)**
   - Представляет пользовательские действия
   - Неизменяемые объекты
   - Каждое действие пользователя преобразуется в Intent

## Пример реализации

```dart
// Model
class CounterState {
  final int count;
  
  const CounterState({required this.count});
  
  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }
}

// Intent
abstract class CounterIntent {}
class IncrementIntent extends CounterIntent {}
class DecrementIntent extends CounterIntent {}

// View
class CounterView extends StatelessWidget {
  final CounterState state;
  final Function(CounterIntent) onIntent;

  const CounterView({
    required this.state,
    required this.onIntent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: ${state.count}'),
        ElevatedButton(
          onPressed: () => onIntent(IncrementIntent()),
          child: Text('Increment'),
        ),
        ElevatedButton(
          onPressed: () => onIntent(DecrementIntent()),
          child: Text('Decrement'),
        ),
      ],
    );
  }
}

// Presenter/ViewModel
class CounterPresenter {
  final _stateController = StreamController<CounterState>.broadcast();
  Stream<CounterState> get state => _stateController.stream;
  
  CounterState _currentState = CounterState(count: 0);
  
  void dispatch(CounterIntent intent) {
    if (intent is IncrementIntent) {
      _currentState = _currentState.copyWith(count: _currentState.count + 1);
    } else if (intent is DecrementIntent) {
      _currentState = _currentState.copyWith(count: _currentState.count - 1);
    }
    _stateController.add(_currentState);
  }
}
```

## Преимущества

1. **Предсказуемость**
   - Однонаправленный поток данных
   - Легко отслеживать изменения состояния

2. **Тестируемость**
   - Каждый компонент можно тестировать отдельно
   - Легко создавать тестовые сценарии

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