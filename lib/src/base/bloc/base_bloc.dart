import 'dart:async';

import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rainbow/src/constant/message.dart';
import 'package:rainbow/src/function/common_fun.dart';
import 'package:rainbow/src/service/repository/graphql_repository.dart';
import 'package:rainbow/src/service/repository/login_repository.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  late GraphQLRepository _repository;
  late StreamSubscription _subscription;
  dynamic _data;
  BuildContext context;
  BaseBloc(this.context) : super(BaseInitial()) {
    _repository = GraphQLRepository.instance(context);
  }

  @override
  add(BaseEvent e) async {
    await Future.delayed(Duration.zero);
    super.add(e);
  }

  @override
  Stream<BaseState> mapEventToState(
    BaseEvent event,
  ) async* {
    yield BaseLoading();
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (e, stackTrace) {
      developer.log('$e', name: 'BaseBloc', error: e, stackTrace: stackTrace);
      yield BaseError(e.toString());
    }
  }

  void holdConfig(data) {
    _data = data;
  }

  dynamic getConfig() {
    return _data;
  }

  Future<QueryResult> graphRequest(dynamic query) async {
    if (query is QueryOptions || query is MutationOptions) {
      var response = await _repository.createGraphRequest(query);
      if (!response.hasException) {
        return response;
      } else {
        this.add(
            BError(getUserError(response.exception!.graphqlErrors[0].message)));
        return response;
      }
    } else {
      this.add(BError("Invalid Query"));
      return createGraphError("Invalid Query");
    }
  }

  LoginRepository get loginRepository => _repository.loginRepository;

  blocDispose() {
    _subscription.cancel();
  }
}
