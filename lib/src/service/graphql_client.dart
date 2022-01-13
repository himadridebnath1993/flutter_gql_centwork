import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rainbow/src/constant/constants.dart' as constants;
import 'package:rainbow/src/data/preference/preference.dart';

import '../app_config.dart';

abstract class GraphiQLClient {
  Future<GraphQLClient> client(context);
}

class GraphClient extends GraphiQLClient {
  Future<GraphQLClient> client(context) async {
    await initHiveForFlutter();
    var config = AppConfig.of(context);
    var preference = await Preference.getInstance();
    var apiToken = preference.getString(constants.TOKEN);
    var mode =
        (preference.getServerCode(constants.SERVER_CODE) == constants.TEST_CODE)
            ? AppConfig.MODE_TEST
            : AppConfig.MODE_PRODUCTION;

    final Link _link =
        HttpLink(config!.getBaseUrl(mode) + 'api/v1/graphql', defaultHeaders: {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
      'x-hasura-role': config.getAppRole(apiToken),
    });
    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: _link,
    );
  }
}
