import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/utils/time_utils.dart';
import 'package:flutter_mvvm/utils/screen_utils.dart';

class LogUtils {

  static final _screenMaxWidth = Math.max(ScreenUtil.getInstance().screenWidth, ScreenUtil.getInstance().screenHeight).toInt();

  static void m(String msg) => debugPrint("【$msg】" ?? "");

  static void d({String tag,String msg}) => _printLog(tag: tag,msg: msg);

  static void _printLog({String tag =  "",String msg = ""}){
     int _currentTime = TimeUtils.getCurrentMilliseconds();
     String _wrapMessage = _wrapLine(msg ?? "");
     String _printStr = '''
      |~~~~~~~~~~~~~~~~~~~~~~~~begin:$tag~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
      |                                                              | 
      |--------------------------------------------------------------|
      |tag: ${tag ?? ""}                                             | 
      |--------------------------------------------------------------|
      |timestamp: $_currentTime                                      | 
      |---------------------------------------------------------------
      |msg: $_wrapMessage                                           
      |---------------------------------------------------------------
      |                                                              | 
      |~~~~~~~~~~~~~~~~~~~~~~~~~end:$tag~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
     ''';
     debugPrint(_printStr);
  }

  // 换行打印
  static String _wrapLine(String msg){
    StringBuffer sb = StringBuffer();
    int _screenMaxLength = _getAvailableLength();
    if(msg.length > _screenMaxLength){
       int _startIndex = 0 ;
       int _multiple = msg.length ~/ _screenMaxLength ;
       // 整数部分
       for(int i = 0 ; i < _multiple ; i ++){
           String _childStr = msg.substring(_startIndex,_screenMaxLength + _startIndex);
           sb.write(_childStr);
           sb.write("\n       | ");
           _startIndex += _childStr.length ;
       }
       // 剩余部分
       int _multipleInteLength = _multiple * _screenMaxLength ;
       int _last = msg.length - _multipleInteLength;
       if(_last > 0){
          sb.write(msg.substring(_multipleInteLength , msg.length));
       } else {
          sb.write("");
       }
    } else {
      sb.write(msg);
    }
    return sb.toString() ;
  }

  // 获取Log可显示区域
  static int _getAvailableLength({BuildContext context}){
//    MediaQueryData mediaQueryData = MediaQuery.of(context);
//    mediaQueryData.devicePixelRatio;

    return _screenMaxWidth ;
  }

}

