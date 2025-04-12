# MVVM (Model-View-ViewModel) Architecture

MVVM - это архитектурный паттерн, который разделяет логику представления от бизнес-логики и данных.

## Основные компоненты

1. **Model (Модель)**
   - Представляет данные и бизнес-логику
   - Не зависит от UI
   - Содержит структуры данных и методы их обработки

2. **View (Представление)**
   - Отображает данные пользователю
   - Отправляет пользовательские действия в ViewModel
   - Не содержит бизнес-логики

3. **ViewModel (Модель представления)**
   - Связывает View и Model
   - Преобразует данные Model для отображения
   - Обрабатывает пользовательские действия
   - Управляет состоянием UI

## Пример реализации

```dart
// Model
class User {
  final String name;
  final String email;
  
  User({required this.name, required this.email});
}

// ViewModel
class UserViewModel extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Имитация загрузки данных
      await Future.delayed(Duration(seconds: 2));
      _user = User(name: 'John Doe', email: 'john@example.com');
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void updateUser(String name, String email) {
    _user = User(name: name, email: email);
    notifyListeners();
  }
}

// View
class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(),
      child: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return CircularProgressIndicator();
          }
          
          final user = viewModel.user;
          if (user == null) {
            return Text('No user data');
          }
          
          return Column(
            children: [
              Text('Name: ${user.name}'),
              Text('Email: ${user.email}'),
              ElevatedButton(
                onPressed: () => viewModel.loadUser(),
                child: Text('Refresh'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

## Преимущества

1. **Разделение ответственности**
   - Четкое разделение между UI и бизнес-логикой
   - Легко поддерживать и тестировать

2. **Переиспользование кода**
   - ViewModel можно использовать с разными View
   - Бизнес-логика изолирована от UI

3. **Тестируемость**
   - Легко тестировать ViewModel
   - Можно мокать зависимости

## Недостатки

1. **Сложность для простых приложений**
   - Избыточен для небольших проектов
   - Требует больше кода

2. **Управление состоянием**
   - Может быть сложно управлять состоянием в больших приложениях
   - Необходимость дополнительных библиотек для управления состоянием 