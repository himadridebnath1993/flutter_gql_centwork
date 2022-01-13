import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql_client.dart';
import 'login_repository.dart';

class GraphQLRepository {
  final BuildContext context;
  late GraphQLClient _client;
  late LoginRepository _loginRepo;

  static late GraphQLRepository _graphQLRepository;

  static GraphQLRepository instance(BuildContext context) {
    try {
      if (_graphQLRepository != null) {
        print("GraphQLRepository instance already exist.");
      }
    } catch (e) {
      print("GraphQLRepository instance creating.");
      _graphQLRepository = GraphQLRepository(context);
    }
    return _graphQLRepository;
  }

  GraphQLRepository(this.context) {
    _loginRepo = new LoginApiCall(context);
    GraphClient().client(context).then((client) => _client = client);
  }

  LoginRepository get loginRepository => _loginRepo;

  Future<QueryResult> createGraphRequest(dynamic _options) async {
    dynamic response;
    if (_options is QueryOptions) {
      response = await _client.query(_options).timeout(
          const Duration(seconds: 60),
          onTimeout: () => QueryResult(
              exception: OperationException(
                  graphqlErrors: [GraphQLError(message: "Request Timeout")]),
              source: null));
    } else if (_options is MutationOptions) {
      response = await _client.mutate(_options).timeout(
          const Duration(seconds: 60),
          onTimeout: () => QueryResult(
              exception: OperationException(
                  graphqlErrors: [GraphQLError(message: "Request Timeout")]),
              source: null));
    }
    if (response.hasException) {
      if (response.exception.graphqlErrors[0].message.toString() ==
          "Could not verify JWT: JWTExpired") {
        var value = await _loginRepo.refreshToken();
        if (value != null) response = await createGraphRequest(_options);
      } else if (response.exception.graphqlErrors[0].message
              .toString()
              .toLowerCase() ==
          "connection error") {
        response = await createGraphRequest(_options);
      }
    }

    return response;
  }
}
