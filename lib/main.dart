import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow/src/app_config.dart';

import 'src/base/bloc/base_bloc_observer.dart';

void main() async {
  var config = AppConfig(TestApp(), portal: '');
  BlocOverrides.runZoned(
    () {
      runApp(config);
    },
    blocObserver: BaseBlocObserver(),
  );
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Successfuly Login"),
    ));
  }
}
