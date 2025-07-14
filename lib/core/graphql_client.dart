import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink('https://graphqlzero.almansi.me/api');

GraphQLClient getGraphQLClient() {
  return GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );
}