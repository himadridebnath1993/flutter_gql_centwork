import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow/src/base/bloc/base_bloc.dart';

import 'widget/login_handler.dart';
import 'widget/responsive.dart';

abstract class FragmentDialog {
  final BuildContext _contextPop;
  final type;
  final String _title;
  static int get FD_FULL => 1;
  static int get FD_NORMAL => 0;
  late BaseBloc _bloc;
  late BuildContext _context;
  late bool _autoValidate = false;
  @mustCallSuper
  @protected
  FragmentDialog(BuildContext context, String title, [this.type = 0])
      : _title = title,
        _contextPop = context;

  @protected
  Widget? layoutMobile(BuildContext context);
  @protected
  Widget? layoutTab(BuildContext context);
  @protected
  Widget? layoutDesktop(BuildContext context);

  @mustCallSuper
  @protected
  inititial(BuildContext context, BaseBloc bloc) {
    _bloc = bloc;
  }

  @protected
  stateListener(BuildContext context, BaseState state) {}

  Future<dynamic> show() async {
    var d = await showDialog(
        context: _contextPop,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return FutureBuilder(
              future: _buildMedule(context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return this.type == FD_NORMAL
                    ? AlertDialog(
                        scrollable: true,
                        content: _StatefulBody(
                            listener: stateListener, fragment: this))
                    : Scaffold(
                        appBar: AppBar(
                            title: Text(_title),
                            leading: IconButton(
                              tooltip: "Close",
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            )),
                        body: _StatefulBody(
                            listener: stateListener, fragment: this));
              });
        });
    return d;
  }

  Future _buildMedule(context) async {
    try {
      _context = context;
      inititial(context, _bloc);
    } catch (e) {}
  }

  BaseBloc getBloc() {
    return _bloc;
  }

  late _StatefulBodyState _body;
  _setStateBody(_StatefulBodyState body) {
    _body = body;
  }

  BuildContext get instContext => _context;
  void update() {
    if (_body != null) _body.setUpdate();
  }

  bool get isValidate => _body.validate();
  void autoValidate(bool b) {
    _autoValidate = b;
    update();
  }

  Future navigateTo(Widget wid) {
    return Navigator.of(instContext)
        .push(MaterialPageRoute(builder: (context) => wid));
  }

  goBack([data]) {
    if (Navigator.of(instContext).canPop()) {
      Navigator.pop(instContext, data);
    } else {
      exitAlert(instContext);
    }
  }
}

class _StatefulBody extends StatefulWidget {
  final Function(BuildContext, BaseState) listener;
  final FragmentDialog fragment;

  const _StatefulBody(
      {Key? key, required this.listener, required this.fragment})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _StatefulBodyState(fragment);
}

class _StatefulBodyState extends State<_StatefulBody>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  FragmentDialog fragment;
  _StatefulBodyState(this.fragment);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FormState form;

  @override
  void didChangeDependencies() {
    print('didChangeDependencies()');
    print(Theme.of(context));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      try {
       // dismissProgressDialog();
      } catch (e) {}
    }
  }

  bool validate() {
    form = _formKey.currentState!;
    fragment._autoValidate = true;
    return form.validate();
  }

  setUpdate([data]) {
    Future.delayed(Duration.zero, () {
      try {
        if (fragment._bloc != null &&
            fragment._context == fragment._bloc.context) {
          fragment._bloc.add(BRefresh(data));
        } else {
          setState(() {});
        }
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    fragment._setStateBody(this);
    return (fragment._bloc != null &&
            fragment._context == fragment._bloc.context)
        ? BlocListener<BaseBloc, BaseState>(
            bloc: widget.fragment._bloc,
            listener: (context, state) {
              if (state is BaseLoading || state is BaseInitial) {
                try {
                 // dismissProgressDialog();
                } catch (e) {}
                //showProgressDialog(context: context);
              } else {
               // dismissProgressDialog();
                if (state is BaseError) {
                  Timer(Duration(seconds: 1), () {
                    if (state.error.length > 0)
                      try {
                        this.widget.listener(context, state);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.error)));
                      } catch (e) {}
                  });
                } else if (state is BaseRefresh) {
                  if (state.propss!.isNotEmpty) {
                    this.widget.listener(context, state);
                  }
                } else {
                  this.widget.listener(context, state);
                }
              }
            },
            child: BlocBuilder<BaseBloc, BaseState>(
              bloc: fragment._bloc,
              builder: (context, state) {
                return Form(
                    key: _formKey,
                    autovalidateMode: fragment._autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Responsive(
                      desktop: fragment.layoutDesktop(context),
                      tablet: fragment.layoutTab(context),
                      mobile: fragment.layoutMobile(context)));
              },
            ),
          )
        : Form(
            key: _formKey,
            autovalidateMode: fragment._autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Responsive(
                      desktop: fragment.layoutDesktop(context),
                      tablet: fragment.layoutTab(context),
                      mobile: fragment.layoutMobile(context)));
  }
}
