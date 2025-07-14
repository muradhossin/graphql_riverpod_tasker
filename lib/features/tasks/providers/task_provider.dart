import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_riverpod_tasker/features/tasks/data/task_repository.dart';
import 'package:graphql_riverpod_tasker/features/tasks/domain/task_model.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.fetchTasks();
});