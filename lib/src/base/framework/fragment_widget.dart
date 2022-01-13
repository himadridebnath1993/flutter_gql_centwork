import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rainbow/constant/model.dart';
import 'package:rainbow/src/base/bloc/base_bloc.dart';

import 'widget/action_bar.dart';
import 'widget/fabutton.dart';
import 'widget/footer_tab.dart';
import 'widget/login_handler.dart';
import 'widget/responsive.dart';

// ignore: must_be_immutable
abstract class FragmentWidget extends StatelessWidget {
  FragmentWidget({Key? key, BaseBloc? bloc})
      : this._bloc = bloc,
        super(key: key);

  BaseBloc? _bloc;
  late FooterTab _footerTab;
  late FAButton _faButton;
  late BuildContext _context;

  bool _autoValidate = false;
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
  @mustCallSuper
  buildFloatingActionButton(context,
      [List<ActionMenu>? menus, Function(ActionMenu, int)? onItemSelect]) {
    if (_faButton == null) {
      _faButton = FAButton(menus!, (menu, index) {
        if (onItemSelect != null) onItemSelect(menu, index);
        buildFloatingActionButton(context);
        update();
      });
    } else if (_faButton != null) {
      _faButton.setMenus(menus);
    }
  }

  @protected
  stateListener(BuildContext context, BaseState state);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _buildMedule(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _StatefulBody(listener: stateListener, fragment: this);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future _buildMedule(context) async {
    _footerTab = FooterTab();
    _context = context;
    try {
      inititial(context, _bloc!);
    } catch (e) {}
    try {
      buildFloatingActionButton(context);
    } catch (e) {}
  }

  initFooterTab(
      {required List<ActionMenu> list,
      required Function(ActionMenu) onSelect,
      required int selection}) {
    _footerTab.initFooter(selection, list, (v) {
      if (onSelect != null) onSelect(v);
      _body.setUpdate();
    });
  }

  BaseBloc getBloc() {
    return _bloc!;
  }

  FAButton getFabButton() {
    return _faButton;
  }

  late _StatefulBodyState _body;
  _setStateBody(_StatefulBodyState body) {
    _body = body;
  }

  ActionBar getActionBar() {
    return ActionBar.getInstance();
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
    ActionBar.pop();
    if (Navigator.of(instContext).canPop()) {
      Navigator.pop(instContext, data);
    } else {
      exitAlert(instContext);
    }
  }
}

class _StatefulBody extends StatefulWidget {
  final Function(BuildContext, BaseState) listener;
  final FragmentWidget fragment;

  const _StatefulBody(
      {Key? key, required this.listener, required this.fragment})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _StatefulBodyState(fragment);
}

class _StatefulBodyState extends State<_StatefulBody>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  FragmentWidget fragment;
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
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
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

  setUpdate([data]) {
    Future.delayed(Duration.zero, () {
      try {
        if (fragment._bloc != null &&
            fragment.instContext == fragment._bloc!.context) {
          fragment._bloc!.add(BRefresh(data));
        } else {
          setState(() {});
        }
      } catch (e) {}
    });
  }

  bool validate() {
    form = _formKey.currentState!;
    fragment._autoValidate = true;
    return form.validate();
  }

  @override
  Widget build(BuildContext context) {
    fragment._setStateBody(this);
    return Scaffold(
        bottomNavigationBar: this.fragment._footerTab.build(),
        floatingActionButton: this.fragment._faButton != null
            ? this.fragment._faButton.build()
            : null,
        floatingActionButtonLocation: this.fragment._faButton != null
            ? this.fragment._faButton.location
            : FloatingActionButtonLocation.endFloat,
        body: (fragment._bloc != null &&
                fragment.instContext == fragment._bloc!.context)
            ? BlocListener<BaseBloc, BaseState>(
                bloc: widget.fragment._bloc,
                listener: (context, state) {
                  if (state is BaseLoading || state is BaseInitial) {
                    try {
                     // dismissProgressDialog();
                    } catch (e) {}
                   // showProgressDialog(context: context);
                  } else {
                   // dismissProgressDialog();
                    if (state is BaseError) {
                      Timer(Duration(seconds: 1), () {
                        if (state.error.length > 0)
                          try {
                            this.widget.listener(context, state);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)));
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
                    mobile: fragment.layoutMobile(context))));
  }
}
