import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:oktoast/oktoast.dart';

class GoLoginWidget extends StatelessWidget{

  final double widgetHeight ;
  final double imageWidth ;
  final double imageHeight ;
  final String tipImageUrl ;
  final bool isLocal ;
  final VoidCallback callback ;

  GoLoginWidget({
    Key key,
    this.widgetHeight = 240.0,
    this.imageWidth = 140.0,
    this.imageHeight = 140.0,
    @required this.tipImageUrl,
    this.isLocal = true,
    this.callback,
  }) : assert(tipImageUrl != null ),
       super(key : key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widgetHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          isLocal ? Image.asset("$tipImageUrl",width: imageWidth, height: imageHeight,)
               : Image.network("$tipImageUrl",width: imageWidth,height: imageHeight,),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(text: "立即登录",style: TextStyle(color: HexColor("#7FBFFF"),fontSize: 14.0,),
                    recognizer: TapGestureRecognizer()..onTap = (){
                        showToast("立即登录");
                        if(callback != null){
                           callback();
                        }
                    }),
                TextSpan(text:"并且添加课程",style: TextStyle(color: HexColor("#666666"),fontSize: 14.0),),
              ],
            ),
          ),
        ],
      ),
    );
  }

}