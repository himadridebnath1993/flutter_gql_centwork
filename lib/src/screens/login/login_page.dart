import 'package:flutter/material.dart';
import 'package:rainbow/src/base/bloc/base_bloc.dart';
import 'package:rainbow/src/base/framework/actionbar_widget.dart';
import 'package:rainbow/src/screens/login/events/login_event.dart';

import 'events/login_state.dart';
import 'view/desktop_mode.dart';
import 'view/mobile_mode.dart';

class LoginPage extends ActionBarWidget {
  @override
  Widget? layoutDesktop(BuildContext context) => DesktopMode(getBloc());

  @override
  Widget? layoutMobile(BuildContext context) => MobileMode(getBloc());

  @override
  Widget? layoutTab(BuildContext context) => null;

  @override
  void inititial(BuildContext context, BaseBloc? bloc) {
    super.inititial(context, BaseBloc(context));
    getActionBar().setVisibility(false);
    getBloc().add(SilentLoginEvent());
  }

  @override
  stateListener(BuildContext context, BaseState state) {
    if (state is LoginSuccessState) {
      Navigator.of(instContext).pushReplacement(
          MaterialPageRoute(builder: (context) => getAppConfig()!.home));
    }
  }
}
