import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rainbow/constant/model.dart';
import 'package:rainbow/src/app_config.dart';
import 'package:rainbow/src/base/bloc/base_bloc.dart';
import 'package:rainbow/src/widget/dialog_view.dart';

import 'widget/action_bar.dart';
import 'widget/drawer_menu.dart';
import 'widget/fabutton.dart';
import 'widget/footer_tab.dart';
import 'widget/model_progress.dart';
import 'widget/login_handler.dart';
import 'widget/responsive.dart';

// ignore: must_be_immutable
abstract class ActionBarWidget extends StatelessWidget {
  BaseBloc? _bloc;
  late ActionBar _appbar;
  late FooterTab _footerTab;
  DrawerLayout? _drawerLayout;
  FAButton? _faButton;
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
  void inititial(BuildContext context, BaseBloc? bloc) {
    _bloc = bloc;
  }

  @mustCallSuper
  @protected
  void buildDrawerLayout(context,
      [Widget? profile,
      List<ActionMenu>? menus,
      Function(ActionMenu, int)? onItemSelect]) {
    if (profile != null || (menus != null && menus.length > 0))
      _drawerLayout =
          DrawerLayout(profile ?? Container(), menus ?? [], (menu, index) {
        if (onItemSelect != null) onItemSelect(menu, index);
        update();
      });
  }

  @mustCallSuper
  @protected
  void buildFloatingActionButton(context,
      [List<ActionMenu>? menus, Function(ActionMenu, int)? onItemSelect]) {
    if (_faButton == null) {
      _faButton = FAButton(menus == null ? [] : menus, (menu, index) {
        if (onItemSelect != null) onItemSelect(menu, index);
        buildFloatingActionButton(context);
        update();
      });
    } else if (_faButton != null) {
      _faButton!.setMenus(menus);
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
            return _StatefulBody(listener: stateListener, action: this);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future _buildMedule(context) async {
    _appbar = ActionBar();
    _context = context;
    _footerTab = FooterTab();
    buildDrawerLayout(context);
    inititial(context, _bloc);
    buildFloatingActionButton(context);
  }

  BuildContext get instContext => _context;
  initActionBar(String title,
      {ValueChanged<String>? onSearch,
      List<ActionMenu>? options,
      Function(ActionMenu)? onOptionSelect,
      List<ActionMenu>? tabs,
      Function(ActionMenu, int)? onTabSelect}) {
    _appbar.setTitle(title);
    _appbar.setOnSearchListner(onSearch!);
    _appbar.createOptionMenu(options!, (v) {
      _body.setUpdate();
      onOptionSelect!(v);
    });
    if (tabs != null)
      _appbar.createTabBar(tabs, (v, index) {
        _body.setUpdate();
        onTabSelect!(v, index);
      });
  }

  initFooterTab(
      {required List<ActionMenu> list,
      required Function(ActionMenu) onSelect,
      int? selection}) {
    _footerTab.initFooter(selection, list, (v) {
      if (onSelect != null) onSelect(v);
      _body.setUpdate();
    });
  }

  BaseBloc getBloc() {
    return _bloc!;
  }

  FAButton getFabButton() {
    return _faButton!;
  }

  ActionBar getActionBar() {
    return ActionBar.getInstance();
  }

  AppConfig? getAppConfig() {
    return AppConfig.of(instContext);
  }

  late _StatefulBodyState _body;
  _setStateBody(_StatefulBodyState body) {
    _body = body;
  }

  DrawerLayout? getDrawerlayout() {
    return _drawerLayout;
  }

  void update() {
    if (_body != null) _body.setUpdate();
  }

  bool get isValidate => _body.validate();

  void autoValidate(bool b) {
    _autoValidate = b;
    _body.setUpdate();
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
  final ActionBarWidget action;

  const _StatefulBody({Key? key, required this.listener, required this.action})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _StatefulBodyState(action);
}

class _StatefulBodyState extends State<_StatefulBody>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late ActionBarWidget action;
  _StatefulBodyState(this.action);
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
    try {
      WidgetsBinding.instance!.removeObserver(this);
      ModalProgress.of(context)!.dismiss();
    } catch (e) {}

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ModalProgress.of(context)!.dismiss();
    } else if (state == AppLifecycleState.paused) {
      ModalProgress.of(context)!.dismiss();
    }
  }

  setUpdate([data]) {
    Future.delayed(Duration.zero, () {
      try {
        if (action._bloc != null &&
            action.instContext == action._bloc!.context) {
          action._bloc!.add(BRefresh(data));
        } else {
          setState(() {});
        }
      } catch (e) {}
    });
  }

  bool validate() {
    form = _formKey.currentState!;
    action._autoValidate = true;
    return form.validate();
  }

  @override
  Widget build(BuildContext context) {
    action._setStateBody(this);
    return WillPopScope(
      onWillPop: () async {
        ActionBar.pop();
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        } else {
          exitAlert(context);
          // Navigator.pop(context, false);
        }
        return Future.value(false);
      },
      child: Scaffold(
          drawer: this.action._drawerLayout != null
              ? Container(
                  height: double.infinity,
                  width: 260,
                  color: Colors.white,
                  child: this.action._drawerLayout!.build(),
                )
              : null,
          appBar: widget.action._appbar.build(),
          bottomNavigationBar: this.action._footerTab.build(),
          floatingActionButton: this.action._faButton != null
              ? this.action._faButton!.build()
              : null,
          body: (action._bloc != null &&
                  action.instContext == action._bloc!.context)
              ? ModalProgress(
                  child: BlocListener<BaseBloc, BaseState>(
                    bloc: widget.action._bloc,
                    listener: (context, state) {
                      if (state is BaseLoading || state is BaseInitial) {
                        ModalProgress.of(context)!.show();
                      } else {
                        ModalProgress.of(context)!.dismiss();
                        if (state is BaseError) {
                          DialogView(context, state.error,
                                  type: DialogView.ERROR)
                              .show(autoClose: true);
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
                      bloc: action._bloc,
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          autovalidateMode: action._autoValidate
                              ? AutovalidateMode.always
                              : AutovalidateMode.disabled,
                          child: Responsive(
                              desktop: action.layoutDesktop(context),
                              tablet: action.layoutTab(context),
                              mobile: action.layoutMobile(context)),
                        );
                      },
                    ),
                  ),
                )
              : Form(
                  key: _formKey,
                  autovalidateMode: action._autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Responsive(
                      desktop: action.layoutDesktop(context),
                      tablet: action.layoutTab(context),
                      mobile: action.layoutMobile(context)),
                )),
    );
  }
}
