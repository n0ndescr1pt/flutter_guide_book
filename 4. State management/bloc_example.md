# Bloc Example with Freezed

This example demonstrates how to implement a simple counter using Bloc and Freezed.

## 1. Create Events and State with Freezed

```dart
// lib/presentation/bloc/bloc/counter_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_event.freezed.dart';

@freezed
class CounterEvent with _$CounterEvent {
  const factory CounterEvent.increment() = _Increment;
  const factory CounterEvent.decrement() = _Decrement;
}

// lib/presentation/bloc/bloc/counter_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_state.freezed.dart';

@freezed
class CounterState with _$CounterState {
  const factory CounterState({
    @Default(0) int count,
  }) = _CounterState;
}
```

## 2. Create Bloc

```dart
// lib/presentation/bloc/bloc/counter_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<_Increment>((event, emit) {
      emit(state.copyWith(count: state.count + 1));
    });

    on<_Decrement>((event, emit) {
      emit(state.copyWith(count: state.count - 1));
    });
  }
}
```

## 3. Usage in UI

```dart
// lib/presentation/pages/counter_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/counter_bloc.dart';
import '../bloc/bloc/counter_event.dart';
import '../bloc/bloc/counter_state.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter Example')),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Count: ${state.count}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<CounterBloc>().add(
                            const CounterEvent.decrement(),
                          ),
                      child: Text('-'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => context.read<CounterBloc>().add(
                            const CounterEvent.increment(),
                          ),
                      child: Text('+'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 