import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_riverpod_tasker/features/tasks/domain/task_model.dart';
import 'package:graphql_riverpod_tasker/features/tasks/presentation/widgets/add_task_dialog.dart';
import 'package:graphql_riverpod_tasker/features/tasks/providers/task_list_provider.dart';
import 'package:graphql_riverpod_tasker/features/tasks/providers/task_provider.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  late final TaskListNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(taskListProvider.notifier);
    notifier.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListProvider);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await showDialog<String>(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
          if(title != null && title.isNotEmpty) {
            await notifier.addTask(title);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


