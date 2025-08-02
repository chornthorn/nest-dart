import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoDetailView extends StatefulWidget {
  final int todoId;

  const TodoDetailView({super.key, required this.todoId});

  @override
  State<TodoDetailView> createState() => _TodoDetailViewState();
}

class _TodoDetailViewState extends State<TodoDetailView> {
  @override
  void initState() {
    super.initState();
    // Load the specific todo when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().loadTodoById(widget.todoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo #${widget.todoId}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: todoProvider.isLoading
                    ? null
                    : () => todoProvider.loadTodoById(widget.todoId),
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
            Text('Loading todo...'),
          ],
        ),
      );
    }

    if (todoProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading todo',
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
                onPressed: () => todoProvider.loadTodoById(widget.todoId),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final todo = todoProvider.selectedTodo;
    if (todo == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Todo not found'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => todoProvider.loadTodoById(widget.todoId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(todo),
            const SizedBox(height: 16),
            _buildDetailsCard(todo),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(Todo todo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  todo.completed
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: todo.completed ? Colors.green : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.completed ? 'Completed' : 'Pending',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: todo.completed
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Todo #${todo.id}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Todo todo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('ID', todo.id.toString()),
            const SizedBox(height: 12),
            _buildDetailRow('User ID', todo.userId.toString()),
            const SizedBox(height: 12),
            _buildDetailRow('Title', todo.title, isCompleted: todo.completed),
            const SizedBox(height: 12),
            _buildDetailRow('Status', todo.completed ? 'Completed' : 'Pending'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isCompleted = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            decoration: isCompleted && label == 'Title'
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
      ],
    );
  }
}
