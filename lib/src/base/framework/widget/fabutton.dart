import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rainbow/constant/colors.dart';
import 'package:rainbow/constant/model.dart';

class FAButton {
  late List<ActionMenu> _menus;
  late final Function(ActionMenu menu, int index) _onItemSelect;
  FAButton(
      List<ActionMenu> menus, Function(ActionMenu menu, int index) onItemSelect)
      : _menus = menus,
        _onItemSelect = onItemSelect;

  setMenus(List<ActionMenu>? menus) {
    _menus = menus ?? [];
    _update();
  }

  List<ActionMenu> get menus => _menus;

  FloatingActionButtonLocation? get location {
    return _menus == null || _menus.length > 1 || _menus.length == 0
        ? null
        : _menus[0].text != null
            ? FloatingActionButtonLocation.centerFloat
            : FloatingActionButtonLocation.endFloat;
  }

  Widget build() {
    return _faButton(this);
  }

  late _faButtonState _faState;
  void _setStateControl(state) {
    _faState = state;
  }

  _update() {
    if (_faState != null) {
      _faState.updateState();
    }
  }
}

class _faButton extends StatefulWidget {
  final FAButton fab;
  _faButton(this.fab);

  @override
  _faButtonState createState() => _faButtonState();
}

class _faButtonState extends State<_faButton> {
  @override
  void initState() {
    widget.fab._setStateControl(this);
    super.initState();
  }

  updateState() {
    try {
      Future.delayed(Duration.zero, () {
        setState(() => {});
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return widget.fab._menus != null && widget.fab._menus.length > 1
        ? SpeedDial(
            backgroundColor: primaryColor,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            overlayColor: Colors.black12,
            visible: true,
            curve: Curves.bounceIn,
            children: widget.fab._menus
                .map<SpeedDialChild>((e) => SpeedDialChild(
                      child: e.getIcon(Colors.black),
                      backgroundColor: Colors.white,
                      onTap: () => widget.fab._onItemSelect(e, e.id),
                      label: e.text,
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      labelBackgroundColor: Colors.white,
                    ))
                .toList())
        : widget.fab._menus != null && widget.fab._menus.length == 1
            ? widget.fab._menus[0].text != null
                ? FloatingActionButton.extended(
                    onPressed: () => widget.fab._onItemSelect(
                        widget.fab._menus[0], widget.fab._menus[0].id),
                    label: Text(widget.fab._menus[0].text),
                    icon: widget.fab._menus[0].getIcon(),
                    backgroundColor: primaryColor,
                  )
                : FloatingActionButton(
                    onPressed: () => widget.fab._onItemSelect(
                        widget.fab._menus[0], widget.fab._menus[0].id),
                    child: widget.fab._menus[0].getIcon(),
                    backgroundColor: primaryColor,
                  )
            : Visibility(
                visible: false,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.add),
                ),
              );
  }
}
