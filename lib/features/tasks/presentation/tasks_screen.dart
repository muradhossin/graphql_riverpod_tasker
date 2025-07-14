import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_riverpod_tasker/features/tasks/domain/task_model.dart';
import 'package:graphql_riverpod_tasker/features/tasks/providers/task_provider.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if(tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final Task task = tasks[index];
              return ListTile(
                title: Text(task.title),
                leading: Icon(
                  task.completed ? Icons.check_box : Icons.check_box_outline_blank,
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
