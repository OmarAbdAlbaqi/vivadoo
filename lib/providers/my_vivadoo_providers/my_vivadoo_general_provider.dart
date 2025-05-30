import 'dart:async';

import 'package:flutter/material.dart';
class MyVivadooProvider with ChangeNotifier{

  double toolbarHeightValue = 350.0;
   Timer? timer;

   setToolbarHeightValue(double value){
     toolbarHeightValue = value;
     notifyListeners();
   }
  WidgetStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }
    return WidgetStateProperty.resolveWith(getColor);
  }
  void changeValue(bool increase) {
    final double startValue = increase ? 150.0 : 350.0;
    final double endValue = increase ? 350.0 : 150.0;
    const int duration = 200; // milliseconds
    const int steps = 50; // number of steps for the transition
    const double stepTime = duration / steps; // time per step
    final double stepValue = (endValue - startValue) / steps; // value change per step
    toolbarHeightValue = startValue;
    timer?.cancel(); // cancel any previous timer
    int currentStep = 0;
    timer = Timer.periodic(Duration(milliseconds: stepTime.round()), (timer) {
      if (currentStep >= steps) {
        timer.cancel();
      } else {
          toolbarHeightValue += stepValue;
        currentStep++;
      }
      notifyListeners();
    });

  }
}