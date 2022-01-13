import 'package:flutter/material.dart';

abstract class SecureMenu {
  final int _id;
  final String _text;
  final IconData? _icon;
  final String? _asset;
  final bool? _selectable;
  const SecureMenu(
      int id, String text, IconData? icon, String? asset, bool selectable)
      : _id = id,
        _text = text,
        _asset = asset,
        _selectable = selectable,
        _icon = icon;

  int get id => this._id;
  String get text => this._text;
  bool get selectable => this._selectable??false;
  // IconData get icon => this._icon;
  // String get asset => this._asset;
}

class ActionMenu extends SecureMenu {
  const ActionMenu(
      {required int id,
      required String text,
      IconData? icon,
      String? asset,
      bool selectable = true})
      : super(id, text, icon, asset, selectable);

  Widget getIcon([Color? color]) => _icon != null
      ? Icon(_icon, color: color)
      : _asset != null
          ? Image.asset('assets/icons/$_asset', scale: 2.5, color: color)
          : Icon(Icons.done_outlined, color: color);
}
