import 'package:rainbow/src/base/bloc/base_bloc.dart';

import 'login_state.dart';

class LoginEvent extends BaseEvent {
  var username, password;
  LoginEvent(this.username, this.password);
  @override
  Stream<BaseState> applyAsync(
      {required BaseState currentState, required BaseBloc bloc}) async* {
    var result = await bloc.loginRepository.fetchToken(username, password);

    if (result != null) {
      yield LoginSuccessState("Successfully Login");
    }
  }
}

class SilentLoginEvent extends BaseEvent {
  SilentLoginEvent();
  @override
  Stream<BaseState> applyAsync(
      {required BaseState currentState, required BaseBloc bloc}) async* {
    var result = await bloc.loginRepository.refreshToken();
    if (result != null) {
      yield LoginSuccessState("Successfully Login");
    }else{
      yield SilentLoginFailed();
    }
  }
}
