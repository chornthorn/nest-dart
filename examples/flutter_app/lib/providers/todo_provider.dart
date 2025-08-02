import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';
import '../utils/config_preference.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService;
  final ConfigPreference? _config;

  TodoProvider(this._todoService, [this._config]);

  List<Todo> _todos = [];
  Todo? _selectedTodo;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Todo> get todos => _todos;
  Todo? get selectedTodo => _selectedTodo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all todos
  Future<void> loadTodos() async {
    _setLoading(true);
    _setError(null);

    try {
      _todos = await _todoService.getAllTodos();

      // Save last refresh time to preferences
      _config?.setLastRefresh(DateTime.now());

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load a specific todo by ID
  Future<void> loadTodoById(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      _selectedTodo = await _todoService.getTodoById(id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _selectedTodo = null;
    } finally {
      _setLoading(false);
    }
  }

  // Refresh todos
  Future<void> refreshTodos() async {
    await loadTodos();
  }

  // Clear selected todo
  void clearSelectedTodo() {
    _selectedTodo = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Find todo by ID from the loaded todos list
  Todo? findTodoById(int id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get completed todos
  List<Todo> get completedTodos =>
      _todos.where((todo) => todo.completed).toList();

  // Get pending todos
  List<Todo> get pendingTodos =>
      _todos.where((todo) => !todo.completed).toList();

  // Get filtered todos based on user preference
  List<Todo> get filteredTodos {
    final showCompleted = _config?.getShowCompleted() ?? true;
    if (showCompleted) {
      return _todos;
    } else {
      return pendingTodos;
    }
  }

  // Get todos count
  int get todosCount => _todos.length;
  int get completedCount => completedTodos.length;
  int get pendingCount => pendingTodos.length;
}
