import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/res/index.dart';
import 'package:flutter_mvvm/components/widget_gif.dart';

class IconPlayWidget extends StatefulWidget{

  final bool playVisibly ;
  final double size ;
  final Function onPressed;
  IconPlayWidget({
    Key key,
    this.playVisibly = true ,
    this.size,
    this.onPressed,
  }) : super(key:key);

  @override
  State<StatefulWidget> createState() => _IconPlayWidgetState();

}

class _IconPlayWidgetState extends State<IconPlayWidget>{

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size ?? Dimens.dimen_45dp,
      height: widget.size ?? Dimens.dimen_45dp ,
      child: widget.playVisibly ? CupertinoButton(
        child: Image.asset('assets/images/gif/icon_play_gif_b_03.png',
            width: widget.size ?? Dimens.dimen_45dp,
            height: widget.size ?? Dimens.dimen_45dp,
        ),
        padding: EdgeInsets.all(0),
        onPressed: () {
          if(widget.onPressed != null){
            widget.onPressed("sound");
          }
        },
      ) : CupertinoButton(
          padding:EdgeInsets.all(0),
          child: GifWidget(
            customWidgetList: <CustomWidgetModel>[
              for(int i = 0 ; i < 3 ; i ++)
                CustomWidgetModel(
                  childWidget:Image.asset(
                    "assets/images/gif/icon_play_gif_b_0${i+1}.png",
                    width: widget.size ?? Dimens.dimen_45dp,
                    height: widget.size ?? Dimens.dimen_45dp,
                  ),
                ),
            ],
          ),
          onPressed: null
      ),
    );
  }

}