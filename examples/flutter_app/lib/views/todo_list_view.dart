import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  void initState() {
    super.initState();
    // Load todos when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: todoProvider.isLoading
                    ? null
                    : () => todoProvider.refreshTodos(),
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return _buildBody(todoProvider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoByIdDialog(),
        tooltip: 'View Todo by ID',
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildBody(TodoProvider todoProvider) {
    if (todoProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading todos...'),
          ],
        ),
      );
    }

    if (todoProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading todos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              todoProvider.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => todoProvider.refreshTodos(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => todoProvider.refreshTodos(),
      child: ListView.builder(
        itemCount: todoProvider.todos.length,
        itemBuilder: (context, index) {
          final todo = todoProvider.todos[index];
          return _buildTodoTile(todo);
        },
      ),
    );
  }

  Widget _buildTodoTile(Todo todo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: todo.completed ? Colors.green : Colors.orange,
          child: Text(
            todo.id.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed ? Colors.grey : null,
          ),
        ),
        subtitle: Text('User ID: ${todo.userId}'),
        trailing: Icon(
          todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: todo.completed ? Colors.green : Colors.grey,
        ),
        onTap: () => _navigateToTodoDetail(todo.id),
      ),
    );
  }

  void _navigateToTodoDetail(int todoId) {
    context.push('/todos/$todoId');
  }

  void _showTodoByIdDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('View Todo by ID'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Todo ID',
            hintText: 'Enter todo ID (1-200)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(controller.text);
              if (id != null && id > 0) {
                Navigator.of(context).pop();
                _navigateToTodoDetail(id);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid todo ID'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}
