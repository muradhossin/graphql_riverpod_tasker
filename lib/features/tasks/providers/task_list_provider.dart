import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_riverpod_tasker/features/tasks/domain/task_model.dart';
import 'package:graphql_riverpod_tasker/features/tasks/providers/task_provider.dart';

final taskListProvider = StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>(
  (ref) => TaskListNotifier(ref),
);

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final Ref ref;
  TaskListNotifier(this.ref) : super(
    const AsyncValue.loading(),
  );

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(taskRepositoryProvider);
      final tasks = await repo.fetchTasks();
      state = AsyncValue.data(tasks);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTask(String title) async {
    try {
      final repo = ref.read(taskRepositoryProvider);
      final newTask = await repo.createTask(title);
      final current = state.value ?? [];
      state = AsyncValue.data([newTask, ...current]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}
