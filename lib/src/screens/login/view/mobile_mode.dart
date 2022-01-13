import 'package:flutter/material.dart';
import 'package:rainbow/rainbow.dart';
import 'package:rainbow/src/base/bloc/base_bloc.dart';

import 'widgets/login_form.dart';

class MobileMode extends StatelessWidget {
  BaseBloc bloc;
  MobileMode(this.bloc);
  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color.fromRGBO(66, 105, 255, 1),
                      Color.fromRGBO(66, 205, 255, 1)
                    ])),
                child: Column(children: [
                  AppAssetImage('assets/images/login-form.png',
                      scale: 3,
                      height: heightSize * 0.4,
                      width: widthSize * 0.6,
                      package: 'rainbow'),
                  SingleChildScrollView(
                      child: LoginForm(
                          0.007,
                          0.04,
                          widthSize * 0.04,
                          0.06,
                          0.04,
                          0.07,
                          widthSize * 0.09,
                          0.05,
                          0.032,
                          0.04,
                          0.032,
                          bloc: bloc))
                ]))));
  }
}
