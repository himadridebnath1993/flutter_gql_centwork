import 'package:flutter/material.dart';
import 'package:rainbow/constant/colors.dart';
import 'package:rainbow/constant/model.dart';

class DrawerLayout {
  final Widget _profile;
  final List<ActionMenu> _menus;
  final Function(ActionMenu menu, int index) _onItemSelect;
  DrawerLayout(Widget profile, List<ActionMenu> menus,
      Function(ActionMenu menu, int index) onItemSelect)
      : _profile = profile,
        _menus = menus,
        _onItemSelect = onItemSelect;
  int _index = 0;
  setIndex(index) {
    _index = index;
  }

  Widget build() {
    return _DrawerMenu(_profile, _menus, _onItemSelect, this);
  }
}

class _DrawerMenu extends StatelessWidget {
  final DrawerLayout drawer;
  final Widget profile;
  final List<ActionMenu> menus;
  final Function(ActionMenu menu, int index) onItemSelect;
  const _DrawerMenu(this.profile, this.menus, this.onItemSelect, this.drawer,
      {key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          profile,
          Expanded(
            child: ListView.separated(
                itemBuilder: (BuildContext cntx, index) {
                  return drawerItem(menus[index], drawer._index, () {
                    drawer._index = menus[index].selectable
                        ? menus[index].id
                        : drawer._index;
                    Navigator.pop(context);
                    Future.delayed(Duration.zero).then(
                        (value) => onItemSelect(menus[index], menus[index].id));
                  });
                },
                separatorBuilder: (BuildContext cntx, index) =>
                    Divider(height: 1),
                itemCount: this.menus.length),
          )
        ],
      ),
    );
  }
}

Widget drawerItem(ActionMenu menu, selected, onClick) {
  return Container(
    color: menu.id == selected ? primaryColor : Colors.transparent,
    padding: EdgeInsets.only(left: 6),
    child: ListTile(
        selected: menu.id == selected,
        selectedTileColor: Colors.grey[200],
        leading: Padding(
          padding: EdgeInsets.only(right: 12, left: 12),
          child: menu.getIcon(menu.id == selected ? primaryColor : null),
        ),
        title: Text(
          menu.text,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight:
                menu.id == selected ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        onTap: onClick),
  );
}
