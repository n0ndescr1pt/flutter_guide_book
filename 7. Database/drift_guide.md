# Drift Guide

Drift (formerly Moor) is a reactive persistence library for Flutter and Dart, built on top of SQLite.

## Dependencies

Add to your `pubspec.yaml`:
```yaml
dependencies:
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.2
  path: ^1.8.3

dev_dependencies:
  drift_dev: ^2.14.0
  build_runner: ^2.4.6
```

## Basic Implementation

### 1. Define Tables

```dart
// lib/data/datasources/local/tables/user_table.dart
import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### 2. Create DAO

```dart
// lib/data/datasources/local/dao/user_dao.dart
import 'package:drift/drift.dart';
import '../tables/user_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  // CRUD Operations
  Future<List<User>> getAllUsers() => select(users).get();

  Future<User?> getUserById(int id) => 
    (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);

  Future<int> deleteUser(int id) => (delete(users)..where((u) => u.id.equals(id))).go();

  // Complex Queries
  Future<List<User>> getUsersByEmail(String email) => 
    (select(users)..where((u) => u.email.like('%$email%'))).get();

  Stream<List<User>> watchAllUsers() => select(users).watch();

  Stream<User?> watchUserById(int id) => 
    (select(users)..where((u) => u.id.equals(id))).watchSingleOrNull();

  // Transactions
  Future<void> createUserWithProfile(UsersCompanion user, ProfilesCompanion profile) async {
    await transaction(() async {
      final userId = await into(users).insert(user);
      await into(profiles).insert(
        profile.copyWith(userId: Value(userId)),
      );
    });
  }

  Future<void> updateUserAndProfile(
    UsersCompanion user,
    ProfilesCompanion profile,
  ) async {
    await transaction(() async {
      await update(users).replace(user);
      await update(profiles).replace(profile);
    });
  }

  // Joins and Relationships
  Future<List<UserWithProfile>> getUsersWithProfiles() {
    final query = select(users).join([
      innerJoin(profiles, profiles.userId.equalsExp(users.id)),
    ]);

    return query.map((row) {
      return UserWithProfile(
        user: row.readTable(users),
        profile: row.readTable(profiles),
      );
    }).get();
  }

  Stream<List<UserWithProfile>> watchUsersWithProfiles() {
    final query = select(users).join([
      innerJoin(profiles, profiles.userId.equalsExp(users.id)),
    ]);

    return query.map((row) {
      return UserWithProfile(
        user: row.readTable(users),
        profile: row.readTable(profiles),
      );
    }).watch();
  }

  // Batch Operations
  Future<void> deleteUsersAndProfiles(List<int> userIds) async {
    await transaction(() async {
      await (delete(profiles)..where((p) => p.userId.isIn(userIds))).go();
      await (delete(users)..where((u) => u.id.isIn(userIds))).go();
    });
  }

  // Custom Queries
  Future<List<User>> getActiveUsers() {
    return customSelect(
      'SELECT * FROM users WHERE last_active > ?',
      variables: [
        Variable.withDateTime(DateTime.now().subtract(Duration(days: 30))),
      ],
    ).map((row) => User.fromData(row.data, this)).get();
  }

  // Aggregation
  Future<Map<String, dynamic>> getUserStats() {
    return customSelect(
      'SELECT COUNT(*) as total_users, '
      'MAX(created_at) as latest_user, '
      'MIN(created_at) as oldest_user '
      'FROM users',
    ).getSingle();
  }
}

// Data class for joined results
class UserWithProfile {
  final User user;
  final Profile profile;

  UserWithProfile({required this.user, required this.profile});
}
```

### 3. Create Database Class

```dart
// lib/data/datasources/local/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/user_table.dart';
import 'dao/user_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Users], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(users, users.createdAt);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.sqlite'));
    return NativeDatabase(file);
  });
}
```

### 4. Generate Code

Run the following command to generate the database code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Usage Example

```dart
// lib/presentation/pages/user_page.dart
import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/tables/user_table.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late AppDatabase _db;
  late UserDao _userDao;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _userDao = _db.userDao;
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _userDao.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _addUser() async {
    await _userDao.insertUser(
      UsersCompanion.insert(
        name: Value(_nameController.text),
        email: Value(_emailController.text),
        createdAt: Value(DateTime.now()),
      ),
    );
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
            child: StreamBuilder<List<User>>(
              stream: _userDao.watchAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: Text(
                        'Created: ${user.createdAt.toString().split('.')[0]}',
                      ),
                    );
                  },
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

## Advanced Features

1. **Migrations**
```dart
@DriftDatabase(tables: [Users], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(users, users.createdAt);
        }
      },
    );
  }
}
```

2. **Streams and Observers**
```dart
// In UserDao
Stream<List<User>> watchAllUsers() => select(users).watch();
Stream<User?> watchUserById(int id) => 
  (select(users)..where((u) => u.id.equals(id))).watchSingleOrNull();
```

3. **Complex Queries**
```dart
// In UserDao
Future<List<User>> getUsersByEmail(String email) => 
  (select(users)..where((u) => u.email.like('%$email%'))).get();

Future<List<User>> getUsersCreatedAfter(DateTime date) => 
  (select(users)..where((u) => u.createdAt.isBiggerThan(date))).get();
```

4. **Transactions and Batch Operations**
```dart
// In UserDao
Future<void> createUserWithProfile(UsersCompanion user, ProfilesCompanion profile) async {
  await transaction(() async {
    final userId = await into(users).insert(user);
    await into(profiles).insert(
      profile.copyWith(userId: Value(userId)),
    );
  });
}

Future<void> deleteUsersAndProfiles(List<int> userIds) async {
  await transaction(() async {
    await (delete(profiles)..where((p) => p.userId.isIn(userIds))).go();
    await (delete(users)..where((u) => u.id.isIn(userIds))).go();
  });
}
```

5. **Joins and Relationships**
```dart
// In UserDao
Future<List<UserWithProfile>> getUsersWithProfiles() {
  final query = select(users).join([
    innerJoin(profiles, profiles.userId.equalsExp(users.id)),
  ]);

  return query.map((row) {
    return UserWithProfile(
      user: row.readTable(users),
      profile: row.readTable(profiles),
    );
  }).get();
}
```

6. **Custom Queries and Aggregation**
```dart
// In UserDao
Future<List<User>> getActiveUsers() {
  return customSelect(
    'SELECT * FROM users WHERE last_active > ?',
    variables: [
      Variable.withDateTime(DateTime.now().subtract(Duration(days: 30))),
    ],
  ).map((row) => User.fromData(row.data, this)).get();
}

Future<Map<String, dynamic>> getUserStats() {
  return customSelect(
    'SELECT COUNT(*) as total_users, '
    'MAX(created_at) as latest_user, '
    'MIN(created_at) as oldest_user '
    'FROM users',
  ).getSingle();
}
``` 