import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomAppBarWidget extends StatelessWidget {

  final List<Widget> actions ;
  final double height ;
  final Color backgroundColor ;
  CustomAppBarWidget({Key key,
    this.actions ,
    this.height ,
    this.backgroundColor,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQueryData.fromWindow(ui.window).padding.top,left: 10.0,right: 10.0,),
      color: backgroundColor ?? Colors.transparent,
      height: (height ?? 56.0) + MediaQueryData.fromWindow(ui.window).padding.top ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CupertinoButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: ()=>Navigator.of(context).pop(),
            padding: const EdgeInsets.all(0.0),
          ),
          Expanded(child: Text("")),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions ?? <Widget>[Text("")],
          ),
        ],
      ),
    );
  }

}