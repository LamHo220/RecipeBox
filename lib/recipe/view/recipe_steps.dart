import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_box/common/constants/colors.dart';
import 'package:recipe_box/common/constants/style.dart';

class Steps extends StatefulWidget {
  const Steps(
      {Key? key,
      required this.name,
      required this.steps,
      required this.closedContainer})
      : super(key: key);
  final String name;
  final List<String> steps;
  final Function closedContainer;

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => widget.closedContainer(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBar: BottomAppBar(
            child: LottieBuilder.asset(
          'assets/95531-chef.json',
          height: 64,
        )),
        body: Column(
          children: [
            Text(widget.name,
                style: Style.heading.copyWith(
                  color: ThemeColors.primaryDark,
                )),
            Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          style: _style(),
                          onPressed: controls.onStepContinue,
                          child: Text(
                              controls.currentStep != widget.steps.length - 1
                                  ? 'NEXT'
                                  : 'BACK'),
                        ),
                        if (controls.currentStep != 0 &&
                            controls.currentStep != widget.steps.length - 1)
                          TextButton(
                            onPressed: controls.onStepCancel,
                            child: const Text(
                              'BACK',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                currentStep: _index,
                onStepCancel: () {
                  if (_index > 0) {
                    setState(() {
                      _index -= 1;
                    });
                  }
                },
                onStepContinue: () {
                  if (_index < widget.steps.length) {
                    setState(() {
                      _index += 1;
                    });
                  }
                  if (_index == widget.steps.length) {
                    widget.closedContainer();
                    setState(() {
                      _index = 0;
                    });
                  }
                },
                onStepTapped: (int index) {
                  setState(() {
                    _index = index;
                  });
                },
                steps: [
                  for (String step in widget.steps)
                    Step(
                      title: Text(
                        step,
                        maxLines: 1,
                      ),
                      content: Container(
                          alignment: Alignment.centerLeft, child: Text(step)),
                    )
                ]),
          ],
        ));
  }
}

ButtonStyle _style() {
  return ButtonStyle(shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
    (Set<MaterialState> states) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    },
  ), elevation: MaterialStateProperty.resolveWith<double?>(
    (Set<MaterialState> states) {
      return 0;
    },
  ), backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      return ThemeColors.primaryLight;
    },
  ));
}
