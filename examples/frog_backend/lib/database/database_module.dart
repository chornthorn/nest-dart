import 'package:nest_core/nest_core.dart';
import 'package:sqlite3/sqlite3.dart';

class DatabaseService {
  final Database _database;

  DatabaseService(this._database);

  /// Execute a query and return results
  ResultSet query(String sql, [List<Object?> parameters = const []]) {
    return _database.select(sql, parameters);
  }

  /// Execute a statement (INSERT, UPDATE, DELETE)
  void execute(String sql, [List<Object?> parameters = const []]) {
    _database.execute(sql, parameters);
  }

  /// Execute a statement and return the number of affected rows
  int executeAndReturnChanges(
    String sql, [
    List<Object?> parameters = const [],
  ]) {
    _database.execute(sql, parameters);
    return _database.updatedRows;
  }

  /// Get the last inserted row ID
  int get lastInsertRowId => _database.lastInsertRowId;

  /// Begin a transaction
  void beginTransaction() {
    _database.execute('BEGIN TRANSACTION');
  }

  /// Commit a transaction
  void commitTransaction() {
    _database.execute('COMMIT');
  }

  /// Rollback a transaction
  void rollbackTransaction() {
    _database.execute('ROLLBACK');
  }

  /// Execute code within a transaction
  T transaction<T>(T Function() action) {
    beginTransaction();
    try {
      final result = action();
      commitTransaction();
      return result;
    } catch (e) {
      rollbackTransaction();
      rethrow;
    }
  }

  /// Close the database connection
  void close() {
    _database.dispose();
  }
}

class DatabaseModule extends Module {
  @override
  List<Module> get imports => [];

  @override
  List<Type> get exports => [DatabaseService];

  @override
  Future<void> providers(Locator locator) async {
    final database = sqlite3.open('app.db');
    _initializeSchema(database);

    // Register SQLite database instance
    locator.registerSingleton<Database>(database);

    // Register DatabaseService
    locator.registerSingleton<DatabaseService>(DatabaseService(database));
  }

  void _initializeSchema(Database db) {
    // Create users table
    db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }
}
