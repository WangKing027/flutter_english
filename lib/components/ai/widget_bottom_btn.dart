import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/index.dart';

class BottomBtnWidget extends StatelessWidget{

  final String text ;
  final VoidCallback onPressed ;

  BottomBtnWidget({
    Key key,
    this.text = "继续",
    @required this.onPressed,
  }) :  assert(onPressed != null),
        super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimens.dimen_84dp,
      margin: EdgeInsets.only(top: Dimens.dimen_4dp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.dimen_16dp),
              topRight: Radius.circular(Dimens.dimen_16dp)),
          boxShadow: [
            BoxShadow(
                color: Colours.shadow_color,
                offset: Offset(0, -3),
                blurRadius: 2.0,
                spreadRadius: 0.0,
            ),
          ],
          color: Colors.white),
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(
              top: Dimens.dimen_20dp,
              bottom: Dimens.dimen_20dp,
              left: Dimens.dimen_24dp,
              right: Dimens.dimen_24dp),
          width: MediaQuery.of(context).size.width - Dimens.dimen_48dp,
          height: Dimens.dimen_44dp,
          decoration: BoxDecoration(
            color: Colours.progressbar_color,
            borderRadius: BorderRadius.circular(Dimens.dimen_8dp),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: Dimens.font_18sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onTap:() => onPressed(),
      ),
    );
  }

}