import 'package:flutter/material.dart';
import 'package:flutter_mvvm/base/route_page_builder.dart';

class MyRouteFactory{

    static Future<dynamic> push({BuildContext context,Widget page}) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => page));

    static Future<dynamic> pushFade({BuildContext context,Widget page}) => Navigator.push(context, FadeRoutePage(child: page));

    static Future<dynamic> pushScale({BuildContext context,Widget page}) => Navigator.push(context, ScaleRoutePage(child: page));

    static Future<dynamic> pushRotation({BuildContext context,Widget page}) => Navigator.push(context, RotationRoutePage(child: page));

    static Future<dynamic> pushSlideX({BuildContext context,Widget page}) => Navigator.push(context, SlideXRoutePage(child: page));

    static Future<dynamic> pushSlideY({BuildContext context,Widget page}) => Navigator.push(context, SlideYRoutePage(child: page));

    static Future<dynamic> pushCombination({BuildContext context,Widget page}) => Navigator.push(context, CombinationRoutePage(child: page));

    static Future<dynamic> pushReplace({BuildContext context,Widget page}) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => page));

    static Future<dynamic> pushReplaceFade({BuildContext context,Widget page}) => Navigator.pushReplacement(context, FadeRoutePage(child: page));

    static Future<dynamic> pushReplaceScale({BuildContext context,Widget page}) => Navigator.pushReplacement(context, ScaleRoutePage(child: page));

    static Future<dynamic> pushReplaceRotation({BuildContext context,Widget page}) => Navigator.pushReplacement(context, RotationRoutePage(child: page));

    static Future<dynamic> pushReplaceSlideX({BuildContext context,Widget page}) => Navigator.pushReplacement(context, SlideXRoutePage(child: page));

    static Future<dynamic> pushReplaceSlideY({BuildContext context,Widget page}) => Navigator.pushReplacement(context, SlideYRoutePage(child: page));

    static Future<dynamic> pushReplaceCombination({BuildContext context,Widget page}) => Navigator.pushReplacement(context, CombinationRoutePage(child: page));
}