import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter_mvvm/res/index.dart';

class PausePage extends StatefulWidget {
  final double top;
  final double left;
  final double right;
  final double bottom;

  PausePage({
    this.top = 0.0,
    this.left = 0.0,
    this.right,
    this.bottom,
  });

  @override
  State<StatefulWidget> createState() => _PausePageState();
}

class _PausePageState extends State<PausePage> {
  double _left;
  double _top;

  @override
  void initState() {
    super.initState();
    _left = widget.left != 0 ? widget.left : Dimens.dimen_15dp;
    _top = widget.top != 0.0 ? widget.top : Dimens.dimen_18dp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colours.black_alpha_30,
        body: Material(
          color: Colors.transparent,
          child: Container(
            height: Dimens.dimen_150dp,
            margin: EdgeInsets.only(left: _left, top: _top),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.dimen_12dp),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _getItemButtonWidget("assets/images/icon_continue.png", "继续学习"),
                _getItemButtonWidget("assets/images/icon_again.png", "重做"),
                _getItemButtonWidget("assets/images/icon_close.png", "退出"),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        bool _pop = Navigator.of(context).pop(PausePageAction.continueLearning);
      },
    );
  }

  Widget _getItemButtonWidget(String imgPath, String text) {
    return FlatButton(
        onPressed: () {
          _clickEvent(text);
        },
        padding: EdgeInsets.only(left: 0.0),
        child: SizedBox.fromSize(
          size: Size(Dimens.dimen_145dp, Dimens.dimen_50dp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Image.asset(
                  imgPath,
                  width: Dimens.dimen_21dp,
                  height: Dimens.dimen_21dp,
                ),
                margin: EdgeInsets.only(
                    left: Dimens.dimen_15dp, right: Dimens.dimen_15dp),
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: Dimens.font_15sp, color: Colours.black_color),
              )
            ],
          ),
        ));
  }

  void _clickEvent(String text) {
    PausePageAction item;
    switch (text) {
      case "继续学习":
        item = PausePageAction.continueLearning;
        break;
      case "重做":
        item = PausePageAction.again;
        break;
      case "退出":
        item = PausePageAction.exit;
        break;
    }
    bool _pop = Navigator.of(context).pop(item);
  }
}

enum PausePageAction {
  again, // 重做
  exit, // 退出
  continueLearning // 继续学习
}
