import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

abstract class TodoService {
  Future<List<Todo>> getAllTodos();
  Future<Todo> getTodoById(int id);
}

class JsonPlaceholderTodoService implements TodoService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  JsonPlaceholderTodoService({http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<List<Todo>> getAllTodos() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/todos'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw TodoServiceException(
          'Failed to load todos: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is TodoServiceException) rethrow;
      throw TodoServiceException('Network error: $e');
    }
  }

  @override
  Future<Todo> getTodoById(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/todos/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return Todo.fromJson(jsonMap);
      } else if (response.statusCode == 404) {
        throw TodoServiceException('Todo with ID $id not found', 404);
      } else {
        throw TodoServiceException(
          'Failed to load todo: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is TodoServiceException) rethrow;
      throw TodoServiceException('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

class TodoServiceException implements Exception {
  final String message;
  final int? statusCode;

  TodoServiceException(this.message, [this.statusCode]);

  @override
  String toString() => 'TodoServiceException: $message';
}
