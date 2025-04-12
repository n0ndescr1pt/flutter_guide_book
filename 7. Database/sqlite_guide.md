# SQLite Guide

## Dependencies

Add to your `pubspec.yaml`:
```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

## Basic Implementation

### 1. Database Helper

```dart
// lib/data/datasources/local/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
```

### 2. Usage Example

```dart
// lib/presentation/pages/user_page.dart
import 'package:flutter/material.dart';
import '../../data/datasources/local/database_helper.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await DatabaseHelper.instance.getUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _addUser() async {
    await DatabaseHelper.instance.insertUser({
      'name': _nameController.text,
      'email': _emailController.text,
    });
    _nameController.clear();
    _emailController.clear();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                ElevatedButton(
                  onPressed: _addUser,
                  child: Text('Add User'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
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

## Best Practices

1. **Database Initialization**
   - Use singleton pattern for database helper
   - Initialize database in app startup
   - Handle database versioning properly

2. **CRUD Operations**
   - Use parameterized queries to prevent SQL injection
   - Handle errors appropriately
   - Use transactions for multiple operations

3. **Performance**
   - Use indexes for frequently queried columns
   - Implement pagination for large datasets
   - Close database connections when not needed

4. **Clean Architecture**
   - Keep database operations in data layer
   - Use repositories to abstract database operations
   - Implement proper error handling

## Common Issues and Solutions

1. **Database Locking**
   - Use transactions for multiple operations
   - Implement proper connection management
   - Handle concurrent access carefully

2. **Migration Issues**
   - Plan database schema changes carefully
   - Implement proper version management
   - Test migrations thoroughly

3. **Performance Optimization**
   - Use indexes appropriately
   - Implement caching when needed
   - Optimize query patterns 