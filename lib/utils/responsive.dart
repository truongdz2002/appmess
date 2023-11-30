import 'package:flutter/material.dart';

class Responsive{

  static double getHeight(BuildContext context) {
    final size=View.of(context).platformDispatcher.views.first.physicalSize/
        View.of(context).platformDispatcher.views.first.devicePixelRatio;
    return size.height;
  }

  static double getWidth(BuildContext context) {
    final size=View.of(context).platformDispatcher.views.first.physicalSize/
        View.of(context).platformDispatcher.views.first.devicePixelRatio;
    return size.width;
  }
  // screen splash
  static double marginTopElementLogo(BuildContext context) {
    return getHeight(context) * .15;

  }
  static double widthElementLogo(BuildContext context) {
    return getWidth(context) * .5;

  }
  static double marginRightElementLogo(BuildContext context) {
    return getWidth(context) * .25;
  }
  static double heightTextIntro(BuildContext context) {
    return getHeight(context) * .15;
  }
  //screen home







}