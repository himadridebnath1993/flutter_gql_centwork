import 'package:flutter/cupertino.dart';
import 'package:rainbow/rainbow.dart';

class Dashboard extends ActionBarWidget {
  @override
  Widget? layoutDesktop(BuildContext context) => null;

  @override
  Widget? layoutMobile(BuildContext context) =>
      Center(child: Text("Welcome to Dashboard"));

  @override
  Widget? layoutTab(BuildContext context) => null;

  @override
  stateListener(BuildContext context, BaseState state) {}
}
