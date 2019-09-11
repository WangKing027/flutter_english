import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/index.dart';

class NoticeTextWidget extends StatelessWidget{

  final TextStyle style ;
  final double height ;
  final String text ;

  NoticeTextWidget({
    Key key,this.style,this.text,this.height
  }) : assert(text != null),
       super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text ?? "",
        style: TextStyle(
          color: style?.color ?? Colours.navy_blue_color,
          fontSize: style?.fontSize ?? Dimens.font_18sp,
          fontWeight: style?.fontWeight ?? FontWeight.bold
        ),
      ),
      height: height ?? Dimens.dimen_25dp ,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: Dimens.dimen_18dp),
    );
  }

}