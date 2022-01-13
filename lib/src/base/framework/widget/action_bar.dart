import 'package:flutter/material.dart';
import 'package:rainbow/constant/colors.dart';
import 'package:rainbow/constant/model.dart';

class ActionBar {
  static List<ActionBar> _listActionbar = [];
  static ActionBar getInstance() {
    return _listActionbar.last;
  }

  static pop() {
    if (_listActionbar.length != 1) return _listActionbar.removeLast();
  }

  ActionBar() {
    _listActionbar.add(this);
  }

  String _title = 'Action Bar';
  setTitle(String title) {
    this._title = title;
    update();
  }

  bool _visibility = true;

  setVisibility(bool b) {
    _visibility = b;
    update();
  }

  String getTitle() {
    return _title;
  }

  ValueChanged<String>? _onSearch;
  setOnSearchListner(ValueChanged<String> onSearch) async {
    this._onSearch = onSearch;
    if (__searchAppBarState != null && __searchAppBarState._icSearch != null)
      __searchAppBarState._icSearch = Icon(Icons.search);
    update();
  }

  resetSearch() {
    if (__searchAppBarState != null && __searchAppBarState._icSearch != null) {
      __searchAppBarState._icSearch = Icon(Icons.search);
      __searchAppBarState._searchText = "";
    }

    update();
  }

  String get searchText =>
      (__searchAppBarState != null && __searchAppBarState._icSearch != null)
          ? __searchAppBarState._searchText
          : '';

  Function? _onOptionSelect;
  List<ActionMenu>? _options;

  createOptionMenu(
      List<ActionMenu> options, Function(ActionMenu) onOptionSelect) {
    this._options = options;
    this._onOptionSelect = onOptionSelect;
  }

  List<ActionMenu> _tabs = [];
  late Function(ActionMenu, int) _onTabSelect;
  double _height = 1;
  createTabBar(List<ActionMenu> tabs, Function(ActionMenu, int) onTabSelect) {
    this._tabs = tabs;
    this._onTabSelect = onTabSelect;
    _height = tabs[0].text != null &&
            tabs[0].getIcon() != null &&
            tabs.length <= 4 &&
            tabs.length > 1
        ? 2.2
        : (tabs[0].text != null || tabs[0].getIcon() != null) && tabs.length > 1
            ? 1.8
            : 1;
    update();
  }

  PreferredSizeWidget build() {
    return _SearchActionBar(
        actionBar: this,
        preferredSize: Size.fromHeight(kToolbarHeight * _height));
  }

  late _SearchAppBarState __searchAppBarState;
  void _setStateControl(state) {
    __searchAppBarState = state;
  }

  update() {
    try {
      if (__searchAppBarState != null) {
        __searchAppBarState.updateState();
      }
    } catch (e) {}
  }
}

class _SearchActionBar extends StatefulWidget implements PreferredSizeWidget {
  final ActionBar actionBar;
  const _SearchActionBar(
      {Key? key, required this.preferredSize, required this.actionBar})
      : super(key: key);

  @override
  final Size preferredSize; // default is 56.0
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

class _SearchAppBarState extends State<_SearchActionBar> {
  late Icon _icSearch;
  late String _searchText;
  late Widget _appBarTitle;
  int _select = 0;
  @override
  void initState() {
    widget.actionBar._setStateControl(this);
    _icSearch = Icon(Icons.search);
    _appBarTitle = Text(widget.actionBar._title == null
        ? 'Action Bar'
        : widget.actionBar._title);
    super.initState();
  }

  updateState() {
    try {
      Future.delayed(Duration.zero, () {
        if (widget != null)
          setState(() => _appBarTitle = Text(widget.actionBar._title == null
              ? 'Action Bar'
              : widget.actionBar._title));
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.actionBar._visibility
        ? DefaultTabController(
            length: this.widget.actionBar._tabs.length,
            child: AppBar(
                title: _appBarTitle,
                actions: _buildActionWidget(),
                bottom: this.widget.actionBar._tabs.length > 1
                    ? TabBar(
                        onTap: (index) => {
                              this.widget.actionBar._onTabSelect(
                                  this.widget.actionBar._tabs[index], index),
                              _select = index
                            },
                        tabs: this
                            .widget
                            .actionBar
                            ._tabs
                            .map((e) => Tab(
                                text: this.widget.actionBar._tabs.length <= 4
                                    ? e.text
                                    : null,
                                icon: e.getIcon(
                                    widget.actionBar._tabs.indexOf(e) == _select
                                        ? Colors.white
                                        : Colors.white60)))
                            .toList())
                    : null),
          )
        : Container(height: 0);
  }

  List<Widget> _buildActionWidget() {
    List<Widget> list = [];
    if (this.widget.actionBar._onSearch != null) {
      list.add(new IconButton(
        tooltip: "Search",
        icon: _icSearch,
        onPressed: () {
          setState(() {
            if (this._icSearch.icon == Icons.search) {
              this._icSearch = Icon(Icons.close);
              this._appBarTitle = new TextField(
                textInputAction: TextInputAction.search,
                autofocus: true,
                onSubmitted: (value) {
                  _searchText = value;
                  this.widget.actionBar._onSearch!(value);
                },
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search, color: Colors.white),
                  hintText: "Search...",
                  focusColor: Colors.white,
                  fillColor: Colors.white,
                  hintStyle: new TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              );
            } else {
              this._icSearch = Icon(Icons.search);
              this._appBarTitle = _appBarTitle = Text(widget.actionBar._title);
              this.widget.actionBar._onSearch!("");
              _searchText = "";
            }
          });
        },
      ));
    }
    if (this.widget.actionBar._options != null &&
        this.widget.actionBar._options!.length == 1) {
      list.add(IconButton(
        tooltip: widget.actionBar._options![0].text,
        icon: widget.actionBar._options![0].getIcon(),
        onPressed: () => this.widget.actionBar._onOptionSelect != null
            ? this
                .widget
                .actionBar
                ._onOptionSelect!(widget.actionBar._options![0])
            : null,
      ));
    } else if (this.widget.actionBar._options != null &&
        this.widget.actionBar._options!.length > 1) {
      list.add(PopupMenuButton<ActionMenu>(
        onSelected: (v) => this.widget.actionBar._onOptionSelect != null
            ? this.widget.actionBar._onOptionSelect!(v)
            : null,
        itemBuilder: (BuildContext context) {
          return this.widget.actionBar._options!.map((ActionMenu choice) {
            return PopupMenuItem<ActionMenu>(
              value: choice,
              child: Row(
                children: [
                  choice.getIcon(primaryColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(choice.text),
                  ),
                ],
              ),
            );
          }).toList();
        },
      ));
    }
    return list;
  }
}
