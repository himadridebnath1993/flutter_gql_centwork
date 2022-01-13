import 'dart:async';

import 'package:flutter/material.dart';

class DialogView {
  static int SUCCESS = 1;
  static int ERROR = 2;
  static int WARNING = 0;

  final String? message, asset;
  final int? type;
  final Color? color;
  final BuildContext context;
  final bool? dismissible;

  DialogView(this.context, this.message,
      {this.asset, this.type = 0, this.color, this.dismissible = true});

  bool inShowing = false;
  show({bool autoClose = false}) {
    inShowing = true;
    showDialog(
      context: context,
      barrierDismissible: this.dismissible!,
      builder: (_) => _PopUp(this.message!, this.asset!, type: this.type!),
    ).then((value) {
      inShowing = false;
    });

    if (autoClose) {
      Timer(Duration(seconds: 3), () {
        if (inShowing) {
          dismiss();
        }
      });
    }

    return this;
  }

  dismiss() {
    inShowing = false;
    Navigator.pop(context);
  }
}

class _PopUp extends StatefulWidget {
  final String message, asset;
  final int type;
  final Color? color;
  const _PopUp(this.message, this.asset, {this.type = 0, this.color});

  @override
  State<StatefulWidget> createState() => _PopUpState();
}

class _PopUpState extends State<_PopUp> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  String? _asset, _title;
  Color? _color;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(
        parent: controller!, curve: Curves.fastLinearToSlowEaseIn);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();

    _asset = (widget.type == DialogView.SUCCESS)
        ? "assets/ok.png"
        : (widget.type == DialogView.ERROR)
            ? "assets/cross.png"
            : "assets/alert.png";
    _color = (this.widget.type == DialogView.SUCCESS)
        ? Colors.lime[600]
        : (this.widget.type == DialogView.ERROR)
            ? Colors.red
            : Colors.yellow[700];

    _title = (this.widget.type == DialogView.SUCCESS)
        ? 'Great!'
        : (this.widget.type == DialogView.ERROR)
            ? 'Oops!'
            : 'Warning!';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation!,
          child: Container(
            width: 300.0,
            height: 220.0,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        widget.asset != null ? widget.asset : _asset!,
                        package: widget.asset == null ? "cogos_mobilib" : null,
                        height: 70,
                        width: 70,
                      ),
                      Text(_title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              color: _color,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: ShapeDecoration(
                        color: _color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(15.0),
                          bottomRight: const Radius.circular(15.0),
                        ))),
                    child: Center(
                      child: Text(this.widget.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
