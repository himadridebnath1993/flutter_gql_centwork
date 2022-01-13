import 'package:flutter/material.dart';

class ModalProgress extends StatefulWidget {
  final Widget child;

  ModalProgress({required this.child});

  static _ModalProgressState? of(BuildContext context) {
    final progressHudState =
        context.findAncestorStateOfType<_ModalProgressState>();
    assert(() {
      if (progressHudState == null) {
        throw FlutterError(
            'ProgressHUD operation requested with a context that does not include a ProgressHUD.\n'
            'The context used to show ProgressHUD must be that of a widget '
            'that is a descendant of a ProgressHUD widget.');
      }
      return true;
    }());

    return progressHudState;
  }

  @override
  _ModalProgressState createState() => _ModalProgressState();
}

class _ModalProgressState extends State<ModalProgress>
    with SingleTickerProviderStateMixin {
  bool _isShow = false;

  late AnimationController _controller;
  late Animation _animation;

  void show() {
    setState(() {
      _controller.forward();
      _isShow = true;
    });
  }

  void showWithText(String text) {
    setState(() {
      _controller.forward();
      _isShow = true;
    });
  }

  void dismiss() {
    setState(() {
      _controller.reverse();
      _isShow = false;
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _animation.addStatusListener((status) {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    children.add(Center(
      child: Container(
          padding: EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "Loading...",
                style: TextStyle(color: Colors.white),
              ),
            )
          ])),
    ));

    return Stack(
      children: <Widget>[
        widget.child,
        IgnorePointer(
          ignoring: !_isShow,
          child: TickerMode(
            enabled: _isShow,
            child: FadeTransition(
              opacity: _animation as Animation<double>,
              child: Stack(children: children),
            ),
          ),
        ),
      ],
    );
  }
}
