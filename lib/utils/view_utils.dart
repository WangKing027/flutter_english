import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/colors.dart';
import 'package:flutter_mvvm/res/dimens.dart';
import 'package:oktoast/oktoast.dart';

class ViewUtils {

  static int getScore() => math.Random().nextInt(100) ;

  static String getScoreResultAudio(int score){
     if(score < 60){
       return "wrong.wav";
     } else if(score >= 60 && score < 80){
       return "great.wav";
     } else if(score >= 80){
       return "correct.mp3";
     }
     return "";
  }

  static String getScoreMessage(int score){
    if(score >= 60 && score < 80){
      return "Great!";
    } else if(score >= 80){
      return "Perfect!";
    }
    return "bad!";
  }

  static Color getScoreTextColor(int score){
    if(score >= 60 && score < 80){
      return Colours.nice_color;
    } else if(score >= 80){
      return Colours.green_color;
    }
    return Colours.red_color;
  }

  static void showEvaluateToast(int score,{@required BuildContext context, VoidCallback callback}){
    var _message = getScoreMessage(score);
    var _fontColor = getScoreTextColor(score);
    Widget _widget = Container(
      color:Colors.transparent,
      child: Text(
        _message,
        style: TextStyle(
          color: _fontColor,
          fontSize: 32.0,
          decoration: TextDecoration.none,
        ),
        textAlign: TextAlign.center,
      ),
    );
    showToastWidget(
      _widget,
      context: context,
      position: ToastPosition(align: Alignment.bottomCenter,offset: -Dimens.dimen_100dp),
      dismissOtherToast: true,
      onDismiss: callback
    );
  }

  // 获取组件的高度
  static double getWidgetHeight({@required GlobalKey key}){
    double _result = 0 ;
    if(key != null){
      RenderBox _renderBox = key.currentContext.findRenderObject();
      Offset _itemTopPosition = _renderBox.localToGlobal(Offset.zero);
      Offset _itemBottomPosition = _renderBox.localToGlobal(Offset(0.0,_renderBox.size.height));
      _result = _itemBottomPosition.dy - _itemTopPosition.dy ;
    }
    return _result;
  }

  // 获取组件在屏幕中的位置
  // isLeftTop = true/ 左上角位置  false / 右下角位置
  static Offset getWidgetPositionInWindow({@required GlobalKey key , bool isLeftTop = true }){
    Offset _offset ;
    if(key != null){
      RenderBox _renderBox = key.currentContext.findRenderObject();
      if(isLeftTop){
        _offset = _renderBox.localToGlobal(Offset.zero);
      } else {
        _offset = _renderBox.localToGlobal(Offset(0.0,_renderBox.size.height));
      }
    } else {
      _offset = Offset.zero;
    }
    return _offset ;
  }

}