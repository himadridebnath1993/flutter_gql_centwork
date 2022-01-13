part of 'base_bloc.dart';

@immutable
abstract class BaseEvent {
  Stream<BaseState> applyAsync({required BaseState currentState,required BaseBloc bloc});
}

class BError extends BaseEvent {
  final dynamic error;
  BError(this.error);
  @override
  Stream<BaseState> applyAsync({required BaseState currentState,required BaseBloc bloc}) async* {
    await Timer(const Duration(milliseconds: 400), () {});
    yield BaseError(error);
  }
}

class BRefresh extends BaseEvent {
  final dynamic data;
  BRefresh([this.data]);

   @override
  Stream<BaseState> applyAsync({required BaseState currentState,required BaseBloc bloc}) async* {
    yield BaseRefresh(data);
  }
}
