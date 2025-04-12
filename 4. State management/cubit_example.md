# Cubit Example with Freezed

This example demonstrates how to implement a simple counter using Cubit and Freezed.

## 1. Create State with Freezed

```dart
// lib/presentation/bloc/cubit/counter_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_state.freezed.dart';

@freezed
class CounterState with _$CounterState {
  const factory CounterState({
    @Default(0) int count,
  }) = _CounterState;
}
```

## 2. Create Cubit

```dart
// lib/presentation/bloc/cubit/counter_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());

  void increment() {
    emit(state.copyWith(count: state.count + 1));
  }

  void decrement() {
    emit(state.copyWith(count: state.count - 1));
  }
}
```

## 3. Usage in UI

```dart
// lib/presentation/pages/counter_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit/counter_cubit.dart';
import '../bloc/cubit/counter_state.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter Example')),
      body: BlocBuilder<CounterCubit, CounterState>(
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
                      onPressed: () => context.read<CounterCubit>().decrement(),
                      child: Text('-'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => context.read<CounterCubit>().increment(),
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
``` 