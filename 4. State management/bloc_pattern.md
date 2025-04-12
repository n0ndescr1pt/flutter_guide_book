# BLoC Pattern Guide

## Table of Contents
- [Introduction](#introduction)
- [Clean Architecture Integration](#clean-architecture-integration)
- [Dependencies](#dependencies)
- [Examples](#examples)
- [Best Practices](#best-practices)

## Introduction

BLoC (Business Logic Component) is a design pattern that helps separate business logic from the UI layer. It's particularly useful in Flutter applications following Clean Architecture principles.

## Clean Architecture Integration

In Clean Architecture, BLoC typically resides in the presentation layer:

```
lib/
├── core/
│   ├── error/
│   └── usecases/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    │   ├── cubit/
    │   └── bloc/
    ├── pages/
    └── widgets/
```

## Dependencies

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

## Examples

We provide two different examples of implementing BLoC pattern:

1. [Cubit Example](cubit_example.md) - A simpler implementation using Cubit
2. [Bloc Example](bloc_example.md) - A more complex implementation using Bloc with events

Both examples demonstrate:
- Integration with Freezed for immutable state
- Clean Architecture principles
- Proper separation of concerns
- UI implementation with BlocBuilder

## Code Generation

After creating the Freezed files, run the following command to generate the code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the necessary `.freezed.dart` files for your states and events. 