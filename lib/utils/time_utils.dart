import 'dart:async';
import 'package:flutter/material.dart';

class TimeUtils {

  static Timer startTime({startText = 3,endText = 1,Function callBack}){
    var _timer = new Timer.periodic(const Duration(seconds: 1), (t){
      startText -= 1;
      if(startText <= endText){
         if(callBack != null){
            callBack();
         }
         debugPrint("[TimeUtils.startTime]: ---倒计时时间: $startText");
         t.cancel();// 执行结束后把定时器取消
      }
    });
    return _timer ;
  }

  static void delayTime({milliseconds = 1000,Function callBack}){
     Future.delayed(Duration(milliseconds: milliseconds),(){
        if(callBack != null){
           callBack();
        }
     });
  }

  static int getCurrentMilliseconds() => DateTime.now().millisecondsSinceEpoch ;

}
