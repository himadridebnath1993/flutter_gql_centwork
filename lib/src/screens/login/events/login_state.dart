import 'package:rainbow/src/base/bloc/base_bloc.dart';

class LoginSuccessState extends BaseState {
  LoginSuccessState(data) : super([data]);
}

class SilentLoginFailed extends BaseState {
  SilentLoginFailed() : super([]);
}

