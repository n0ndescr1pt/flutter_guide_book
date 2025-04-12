# MVC (Model-View-Controller) Architecture

MVC - это классический архитектурный паттерн, который разделяет приложение на три основных компонента.

## Основные компоненты

1. **Model (Модель)**
   - Представляет данные и бизнес-логику
   - Не зависит от UI
   - Содержит структуры данных и методы их обработки

2. **View (Представление)**
   - Отображает данные пользователю
   - Получает данные от Controller
   - Не содержит бизнес-логики

3. **Controller (Контроллер)**
   - Обрабатывает пользовательские действия
   - Обновляет Model
   - Обновляет View на основе изменений в Model

## Пример реализации

```dart
// Model
class Todo {
  final String id;
  final String title;
  bool isCompleted;
  
  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

// Controller
class TodoController {
  final List<Todo> _todos = [];
  List<Todo> get todos => List.unmodifiable(_todos);
  
  void addTodo(String title) {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
    );
    _todos.add(todo);
  }
  
  void toggleTodo(String id) {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex != -1) {
      _todos[todoIndex].isCompleted = !_todos[todoIndex].isCompleted;
    }
  }
  
  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
  }
}

// View
class TodoView extends StatefulWidget {
  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final _controller = TodoController();
  final _textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter todo title',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _controller.addTodo(_textController.text);
                      _textController.clear();
                      setState(() {});
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _controller.todos.length,
              itemBuilder: (context, index) {
                final todo = _controller.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) {
                      _controller.toggleTodo(todo.id);
                      setState(() {});
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _controller.deleteTodo(todo.id);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## Преимущества

1. **Простота понимания**
   - Классический паттерн
   - Прямая связь между компонентами
   - Легко для начинающих

2. **Разделение ответственности**
   - Четкое разделение между UI и бизнес-логикой
   - Легко поддерживать

3. **Быстрая разработка**
   - Меньше кода для базовой функциональности
   - Простое добавление новых функций

## Недостатки

1. **Сложность масштабирования**
   - Может стать сложным в больших приложениях
   - Сложно поддерживать при росте проекта

2. **Тестируемость**
   - Сложнее тестировать из-за тесной связи компонентов
   - Необходимость мокирования зависимостей 