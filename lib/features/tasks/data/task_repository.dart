import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_riverpod_tasker/core/graphql_client.dart';
import 'package:graphql_riverpod_tasker/features/tasks/domain/task_model.dart';

class TaskRepository {
  final GraphQLClient _client = getGraphQLClient();

  Future<List<Task>> fetchTasks() async {
    const String query = '''
     query {
        posts {
          id
          title
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(
        document: gql(query),
      )
    );

    if(result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List data = result.data?['posts'] ?? [];
    return data.map((e) => Task.fromJson({
      'id': e['id'].toString(),
      'title': e['title'].toString(),
      'completed': false,
    })).toList();
  }
}