import 'package:flutter/material.dart';
import 'package:rainbow/constant/model.dart';

class DialogFilter {
  final BuildContext context;
  final List<ActionMenu> list;
  final Function(List) onItemChecked;
  final Function(ActionMenu) onItemSelect;
  DialogFilter(this.context, this.list,
      {required this.onItemChecked, required this.onItemSelect}) {
    _chkList = [list[0].id];
  }

  List<int> _chkList = [], _tmpList = [];
  var setState;
  Future<dynamic> show() async {
    _tmpList.clear();
    _tmpList.addAll(_chkList);
    var d = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            this.setState = setState;
            return AlertDialog(
                contentPadding: EdgeInsets.zero,
                scrollable: true,
                actions: onItemChecked != null
                    ? [
                        FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel")),
                        FlatButton(
                            onPressed: () {
                              _chkList.clear();
                              _chkList.addAll(_tmpList);
                              onItemChecked(_chkList);
                              Navigator.pop(context);
                            },
                            child: Text("Submit"))
                      ]
                    : [],
                content: Container(
                  child: Column(children: [
                    onItemChecked != null ? _getCheckList() : _getRadioList(),
                  ]),
                ));
          });
        });
    return d;
  }

  Widget _getRadioList() {
    return Column(
        children: list
            .map((e) => RadioListTile<ActionMenu>(
                  value: e,
                  groupValue: list[_tmpList[0]],
                  onChanged: (ind) {
                    setState(() => _tmpList[0] = list.indexOf(ind!));
                    if (onItemSelect != null) {
                      _chkList.clear();
                      _chkList.addAll(_tmpList);
                      onItemSelect(e);
                      Navigator.pop(context);
                    }
                  },
                  title: Text(e.text),
                ))
            .toList());
  }

  Widget _getCheckList() {
    return Column(
        children: list
            .map((e) => CheckboxListTile(
                  value: _tmpList.contains(e.id),
                  onChanged: (chk) {
                    if (chk!) {
                      _tmpList.add(e.id);
                    } else {
                      _tmpList.remove(e.id);
                    }
                    setState(() => _chkList = _chkList);
                  },
                  title: Text(e.text),
                ))
            .toList());
  }
}
