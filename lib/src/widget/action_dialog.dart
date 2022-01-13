import 'package:flutter/material.dart';
import 'package:rainbow/src/constant/colors.dart';

class ActionDialog {
  final String message, posBTtxt, negBTtxt;
  final BuildContext context;
  final Function? clickOnPositive, clickOnNegative;

  const ActionDialog(this.context, this.message,
      {this.posBTtxt = "YES",
      this.clickOnPositive,
      this.negBTtxt = "NO",
      this.clickOnNegative});

  show() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PopUp(this.message, this.posBTtxt,
            this.clickOnPositive, this.negBTtxt, this.clickOnNegative));
  }

  dismiss() {
    Navigator.pop(context);
  }
}

class _PopUp extends StatefulWidget {
  final String message, posBTtxt, negBTtxt;
  final Function? clickOnPositive, clickOnNegative;
  const _PopUp(this.message, this.posBTtxt, this.clickOnPositive, this.negBTtxt,
      this.clickOnNegative);

  @override
  State<StatefulWidget> createState() => _PopUpState();
}

class _PopUpState extends State<_PopUp> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {

    print(this.widget.message);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            padding: EdgeInsets.all(16),
            width: 280.0,
            height: 180.0,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                        child: Text(this.widget.message,
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)))),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      widget.negBTtxt != null
                          ? Card(
                              margin: EdgeInsets.all(3),
                              child: InkWell(
                                onTap: () {
                                  if (widget.clickOnNegative == null) {
                                    Navigator.of(context).pop();
                                  } else {
                                    widget.clickOnNegative!();
                                  }
                                },
                                child: Container(
                                  width: 50,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    widget.negBTtxt,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          : Column(),
                      widget.posBTtxt != null
                          ? Card(
                              margin: EdgeInsets.all(3),
                              color: primaryColor,
                              child: InkWell(
                                onTap: () {
                                  if (widget.clickOnPositive == null) {
                                    Navigator.of(context).pop();
                                  } else {
                                    widget.clickOnPositive!();
                                  }
                                },
                                child: Container(
                                  width: 50,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.posBTtxt,
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            )
                          : Column()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
