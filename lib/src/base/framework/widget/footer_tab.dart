import 'package:flutter/material.dart';
import 'package:rainbow/constant/colors.dart';
import 'package:rainbow/constant/model.dart';

class FooterTab {
  late int _tabselect;
  List<ActionMenu>? _menus;
  late Function(ActionMenu) _onTabSelect;

  initFooter(_tabselect, _menus, _onTabSelect) {
    this._tabselect = _tabselect;
    this._menus = _menus;
    this._onTabSelect = _onTabSelect;
  }

  Widget? build() {
    return _menus != null && _menus!.length > 0
        ? _Footer(this._tabselect, this._menus!, this._onTabSelect)
        : null;
  }
}

class _Footer extends StatefulWidget {
  final int tabselect;
  final List<ActionMenu> menus;
  final Function(ActionMenu) onTabSelect;

  const _Footer(this.tabselect, this.menus, this.onTabSelect);

  @override
  _FooterState createState() => new _FooterState();
}

class _FooterState extends State<_Footer> {
  var _col = 5;
  var _currentIndex = 0;
  List<ActionMenu> _menus = [];
  static const _duration = Duration(milliseconds: 300);
  bool _canExpand = false;
  @override
  void initState() {
    super.initState();
    if (widget.menus.length > _col) {
      _menus.addAll(widget.menus.getRange(0, 2));
      _menus.add(ActionMenu(id:0,icon: Icons.apps, text: ''));
      _menus.addAll(widget.menus.getRange(2, widget.menus.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
            ),
          ],
        ),
        child: widget.menus.length <= _col
            ? BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                onTap: (v) {
                  setState(() => {_currentIndex = v});
                  widget.onTabSelect(widget.menus[v]);
                },
                unselectedItemColor: Colors.grey,
                selectedItemColor: primaryColor,
                currentIndex: _currentIndex,
                items: widget.menus
                    .map(
                      (e) => e.getIcon() != null
                          ? BottomNavigationBarItem(
                              icon: e.getIcon(
                                  _currentIndex != widget.menus.indexOf(e)
                                      ? Colors.grey
                                      : primaryColor),
                              label: e.text)
                          : BottomNavigationBarItem(
                              icon: Text(e.text),
                              activeIcon: Text(
                                e.text.replaceAll(" ", "\n"),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Container(
                                height: 0.0,
                              ),
                            ),
                    )
                    .toList())
            : AnimatedContainer(
                color: Colors.white,
                height: getHeight(_canExpand ? _menus.length : _col),
                duration: _duration,
                child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _canExpand ? _menus.length : _col,
                    reverse: true,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _col, childAspectRatio: 2 / 1.5),
                    itemBuilder: (BuildContext context, int index) {
                      return FlatButton(
                        onPressed: () {
                          _canExpand = index == 2 ? !_canExpand : false;
                          setState(() => {
                                _currentIndex =
                                    index != 2 ? index : _currentIndex
                              });
                        },
                        onLongPress: () {},
                        child: Tooltip(
                          message: _menus[index].text != null
                              ? _menus[index].text
                              : '',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _menus[index].getIcon(index == 2
                                  ? Colors.black
                                  : _currentIndex != index
                                      ? Colors.grey
                                      : primaryColor),
                              _menus[index].text != null
                                  ? Text(_menus[index].text,
                                      textAlign: TextAlign.center,
                                      overflow: _currentIndex != index
                                          ? TextOverflow.ellipsis
                                          : TextOverflow.clip,
                                      style: TextStyle(
                                          fontWeight: _currentIndex != index
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                          color: _currentIndex != index
                                              ? Colors.grey
                                              : primaryColor))
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    })));
  }

  double getHeight(int l) {
    return 60 *
        ((l / _col) - (l / _col).toInt() > 0
                ? (l / _col).toInt() + 1
                : (l / _col).toInt())
            .toDouble();
  }
}
