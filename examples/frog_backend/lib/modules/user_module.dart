// User domain
import 'package:nest_core/nest_core.dart';

import '../database/database_module.dart';
import 'core_module.dart';

class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}

class UserRepository {
  final DatabaseService _database;
  final LoggerService _logger;

  UserRepository(this._database, this._logger);

  List<User> findAll() {
    _logger.log('Finding all users');
    final results = _database.query('SELECT * FROM users ORDER BY id');
    return results.map((row) => User.fromMap(row)).toList();
  }

  User? findById(int id) {
    _logger.log('Finding user by id: $id');
    final results = _database.query('SELECT * FROM users WHERE id = ?', [id]);
    if (results.isEmpty) return null;
    return User.fromMap(results.first);
  }

  User? create(String name, String email) {
    _logger.log('Creating user: $name');
    _database.execute('INSERT INTO users (name, email) VALUES (?, ?)', [
      name,
      email,
    ]);
    final id = _database.lastInsertRowId;
    return User(id: id, name: name, email: email);
  }

  bool update(int id, {String? name, String? email}) {
    _logger.log('Updating user: $id');
    final updates = <String>[];
    final params = <Object?>[];

    if (name != null) {
      updates.add('name = ?');
      params.add(name);
    }
    if (email != null) {
      updates.add('email = ?');
      params.add(email);
    }

    if (updates.isEmpty) return false;

    params.add(id);
    final sql = 'UPDATE users SET ${updates.join(', ')} WHERE id = ?';
    final changes = _database.executeAndReturnChanges(sql, params);
    return changes > 0;
  }

  bool delete(int id) {
    _logger.log('Deleting user: $id');
    final changes = _database.executeAndReturnChanges(
      'DELETE FROM users WHERE id = ?',
      [id],
    );
    return changes > 0;
  }
}

class UserService {
  final UserRepository _repository;
  final LoggerService _logger;

  UserService(this._repository, this._logger);

  List<User> getAllUsers() {
    _logger.log('UserService: Getting all users');
    return _repository.findAll();
  }

  User? getUserById(int id) {
    _logger.log('UserService: Getting user by id: $id');
    return _repository.findById(id);
  }

  User? createUser(String name, String email) {
    _logger.log('UserService: Creating user: $name');
    return _repository.create(name, email);
  }

  bool updateUser(int id, {String? name, String? email}) {
    _logger.log('UserService: Updating user: $id');
    return _repository.update(id, name: name, email: email);
  }

  bool deleteUser(int id) {
    _logger.log('UserService: Deleting user: $id');
    return _repository.delete(id);
  }
}

class UserModule extends Module {
  @override
  List<Module> get imports => [DatabaseModule(), CoreModule()];

  @override
  Future<void> providers(Locator locator) async {
    locator.registerSingleton<UserRepository>(
      UserRepository(
        locator.get<DatabaseService>(),
        locator.get<LoggerService>(),
      ),
    );

    locator.registerSingleton<UserService>(
      UserService(locator.get<UserRepository>(), locator.get<LoggerService>()),
    );
  }
}
