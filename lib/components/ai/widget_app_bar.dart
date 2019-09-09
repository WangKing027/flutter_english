import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter_mvvm/components/ai/widget_progress.dart';
import 'package:flutter_mvvm/res/index.dart';

class AppBarWidget extends StatelessWidget implements ObstructingPreferredSizeWidget {

  final int maxProgress;
  final int currentProgress;
  final VoidCallback onPausePressed;

  AppBarWidget({
    Key key,
    this.maxProgress,
    this.currentProgress,
    this.onPausePressed
  }) : super(key : key);

  @override
  bool get fullObstruction => false;

  @override
  Size get preferredSize => Size.fromHeight(Dimens.dimen_48dp);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimens.dimen_18dp,
              Platform.isIOS ? 0.0 : MediaQueryData.fromWindow(ui.window).padding.top ,
              Dimens.dimen_18dp,
              0.0,
            ),
            child: ProgressWidget(
              size: Size(MediaQuery.of(context).size.width - Dimens.dimen_36dp,
                  Dimens.dimen_23dp),
              maxProgress: maxProgress,
              currentProgress: currentProgress,
              progressStrokeWidth: Dimens.dimen_6dp,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: Dimens.dimen_24dp),
            child: GestureDetector(
              child: Image.asset("assets/images/icon_stop.png",
                  width: Dimens.dimen_25dp, height: Dimens.dimen_25dp),
              onTap: () {
                if (onPausePressed != null) {
                  onPausePressed();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

