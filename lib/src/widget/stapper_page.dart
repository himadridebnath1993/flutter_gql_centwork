import 'package:rainbow/src/constant/colors.dart';
import 'package:flutter/material.dart';

class StepperPage extends StatefulWidget {
  final List<Step> listStep;
  final bool stepTapEnable;
  final StepperType type;
  final VoidCallback onCancel, onFinish;
  final Function(int) onContinue;
  final Future<bool> Function(int)? validate;

  const StepperPage(this.listStep,
      {this.stepTapEnable = false,
      required this.onContinue,
      this.type = StepperType.horizontal,
      required this.onCancel,
      this.validate,
      required this.onFinish});

  @override
  _StepperState createState() => _StepperState();
}

class _StepperState extends State<StepperPage> {
  int _currentStep = 0;
  List<Step> _steps = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stepper(
        controlsBuilder: (BuildContext context,
            {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _currentStep != 0
                  ? OutlineButton(
                      borderSide: BorderSide(color: primaryColor),
                      textColor: primaryColor,
                      onPressed: onStepCancel,
                      child: const Text('Back'),
                    )
                  : Container(width: 70),
              _currentStep != _steps.length - 1
                  ? OutlineButton(
                      borderSide: BorderSide(color: primaryColor),
                      textColor: primaryColor,
                      onPressed: onStepContinue,
                      child: Text('Next'),
                    )
                  : RaisedButton(
                      color: primaryColor,
                      textColor: Colors.white,
                      onPressed: onStepContinue,
                      child: Text('Submit'),
                    )
            ],
          );
        },
        currentStep: this._currentStep,
        steps: _mySteps(),
        type: widget.type,
        onStepTapped: onStepTapped,
        onStepCancel: onStepCancel,
        onStepContinue: onStepContinue,
      ),
    );
  }

  onStepTapped(step) {
    if (widget.stepTapEnable) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  onStepCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep = _currentStep - 1;
        if (widget.onCancel != null) widget.onCancel();
      } else {
        _currentStep = 0;
      }
    });
  }

  onStepContinue() async {
    if (this.widget.validate == null || await this.widget.validate!(_currentStep))
      setState(() {
        if (_currentStep < this._steps.length - 1) {
          _currentStep = _currentStep + 1;
          if (widget.onContinue != null) widget.onContinue(_currentStep);
        } else {
          if (widget.onFinish != null) widget.onFinish();
        }
      });
  }

  List<Step> _mySteps() {
    _steps = [];
    for (var i = 0; i < widget.listStep.length; i++) {
      _steps.add(Step(
          title: widget.listStep[i].title,
          content: widget.listStep[i].content,
          isActive: _currentStep >= i));
    }
    return _steps;
  }

  void activeStapes(step) {
    print("onStepTapped : " + step.toString());
  }
}
