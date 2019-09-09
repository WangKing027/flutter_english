import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:oktoast/oktoast.dart';

class LabelItemWidget extends StatelessWidget{

  final String labelText ;
  final String labelBtnText;
  final VoidCallback callback ;
  LabelItemWidget({this.labelText = "",this.labelBtnText = "",this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: 4.0,
          height: 16.0,
          color: Colors.orange,
          margin: EdgeInsets.only(right: 8.0),
        ),
        Text("$labelText",
          style: TextStyle(
            color: HexColor("#333333"),
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
        ),
        Expanded(
          child: Text(""),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(0.0),
          onPressed: labelBtnText.length > 0 ? _onPressed : null,
          child: Center(
            child: Text("$labelBtnText",style: TextStyle(color: HexColor("#666666"),fontSize: 14.0),),
          ),
        ),
      ],
    );
  }

  void _onPressed(){
    showToast("$labelBtnText");
    if(callback != null){
       callback();
    }
  }

}