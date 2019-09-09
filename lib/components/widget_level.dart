import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LevelWidget extends StatelessWidget {

  final LevelSpan levelSpan ;
  final LevelTextSpan textSpan ;

  LevelWidget({
    Key key,
    @required this.levelSpan ,
    @required this.textSpan,
  }) : super(key :key);

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
      children: <InlineSpan>[
        WidgetSpan(
          alignment: ui.PlaceholderAlignment.middle,
          child: Container(
            width: levelSpan.size ?.width ?? 25.0,
            height: levelSpan.size ?.height ?? 15.0,
            margin: const EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color:levelSpan.bgColor,
            ),
            child: Center(
              child: Text(levelSpan.level,style: levelSpan.style ?? TextStyle(color: Colors.white,fontSize: 9.0),),
            ),
          ),
        ),
        WidgetSpan(
          alignment: ui.PlaceholderAlignment.middle,
          child: Padding(
            padding: textSpan.padding ?? const EdgeInsets.only(left: 0.0),
            child: Text(textSpan.text,
              style: textSpan.style ?? TextStyle(color: Colors.grey,fontSize: 10.0),
            ),
          ),
        ),
      ]
    ));
  }
}

class LevelSpan{
  final Size size ;
  final String level ;
  final TextStyle style ;
  final Color bgColor ;
  LevelSpan({this.size,this.level = "",this.style,this.bgColor = Colors.red});
}

class LevelTextSpan{
  final String text ;
  final TextStyle style ;
  final EdgeInsetsGeometry padding ;
  LevelTextSpan({this.text = "",this.style,this.padding});
}