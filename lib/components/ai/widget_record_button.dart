import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/index.dart';

class RecordButtonWidget extends StatefulWidget{

  final VoidCallback onPressed;
  final bool clickable ;
  final double widgetHeight ;
  final EdgeInsetsGeometry padding ;
  final Color backgroundColor ;

  RecordButtonWidget({
    Key key,
    this.clickable = true,
    this.onPressed ,
    this.widgetHeight,
    this.padding,
    this.backgroundColor,
  }) : super(key:key);

  @override
  State<StatefulWidget> createState() => _RecordButtonWidgetState();

}

class _RecordButtonWidgetState extends State<RecordButtonWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.widgetHeight ?? Dimens.dimen_82dp,
      alignment: widget.padding != null ? Alignment.topCenter : Alignment.center,
      padding: widget.padding ?? EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: (){
          if(widget.clickable){
            if(widget.onPressed!= null){
              widget.onPressed();
            }
          }
        },
        child: Container(
          width: Dimens.dimen_185dp,
          height: Dimens.dimen_55dp,
          decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colours.progressbar_color,
              borderRadius: BorderRadius.circular(Dimens.dimen_28dp)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset("assets/images/icon_white_record.png",
                width: Dimens.dimen_25dp,
                height: Dimens.dimen_25dp,
              ),
              Padding(
                padding: EdgeInsets.only(left: Dimens.dimen_8dp),
                child: Text("朗读文本",
                  style: TextStyle(
                    color: Colours.white_color,
                    fontSize: Dimens.font_16sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}