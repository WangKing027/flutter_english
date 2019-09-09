import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/components/widget_gif.dart';
import 'package:flutter_mvvm/res/index.dart';

class BottomNavWidget extends StatefulWidget {

  final bool gifVisibly;// gif是否可见
  final bool leftNavVisibly;// 显示左箭头
  final bool rightNavVisibly;// 显示右箭头
  final int maxPageCount;// 总页面数量
  final int currentPagePosition;// 当前页
  final Function onNavPressed; // 底部导航功能回调

  BottomNavWidget({
    Key key,
    this.maxPageCount,
    this.currentPagePosition,
    this.onNavPressed,
    this.leftNavVisibly = true,
    this.rightNavVisibly = true,
    this.gifVisibly = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavWidgetState();

}

class _BottomNavWidgetState extends State<BottomNavWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _getWidgetNav(Strings.string_tag_previous),
        _getWidgetNav(Strings.string_tag_sound),
        _getWidgetNav(Strings.string_tag_record),
        _getWidgetNav(Strings.string_tag_next),
      ],
    );
  }

  Widget _getWidgetNav(String type) {
    String iconAssetsPath = "";
    Widget _result;
    switch (type) {
      case Strings.string_tag_previous:
        iconAssetsPath = "assets/images/icon_last.png";
        _result = _getIconButton(type, iconAssetsPath);
        break;
      case Strings.string_tag_sound:
        iconAssetsPath = "assets/images/icon_sound.png";
        _result = AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child,Animation<double> anim){
            return FadeTransition(
              opacity: anim,
              child: child,
            );
          },
          child: widget.gifVisibly ? _getGifAnimWidget() :_getIconButton(type, iconAssetsPath),
        );
        break;
      case Strings.string_tag_record:
        iconAssetsPath = "assets/images/icon_recording.png";
        _result = _getIconButton(type, iconAssetsPath);
        break;
      case Strings.string_tag_next:
        iconAssetsPath = "assets/images/icon_next.png";
        _result = _getIconButton(type, iconAssetsPath);
        break;
    }
    return _result;
  }

  String _getFinalIcon() => "assets/images/icon_final.png";

  Widget _getIconButton(String type, String iconAssetsPath) {
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.only(
              bottom: Dimens.dimen_35dp, top: Dimens.dimen_30dp),
          height: Dimens.dimen_100dp,
          color: Colours.background_color,
          child: AnimatedOpacity(
            opacity: _getOpacity(type),
            duration: const Duration(milliseconds: 300),
            child: type == Strings.string_tag_next ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child,Animation<double> anim){
                return FadeTransition(opacity: anim,child: child,);
              },
              child: Image.asset( _endPosition() ? _getFinalIcon() : iconAssetsPath ,width: Dimens.dimen_35dp,height: Dimens.dimen_35dp,),
            ) : Image.asset(iconAssetsPath,width: Dimens.dimen_35dp,height: Dimens.dimen_35dp,),
          ),
        ),
        onTap: () {
          if(_getOpacity(type) == 1.0){//可见的可点击
             if(widget.onNavPressed != null){
                widget.onNavPressed(type);
             }
          }
        });
  }

  Widget _getGifAnimWidget() {
    return Container(
      height: Dimens.dimen_100dp,
      color: Colours.background_color,
      padding: EdgeInsets.only(bottom: Dimens.dimen_35dp, top: Dimens.dimen_30dp),
      child: GifWidget(
        customWidgetList: <CustomWidgetModel>[
          for(int i = 0 ; i < 3 ; i ++)
            CustomWidgetModel(
              childWidget:Image.asset(
                "assets/images/gif/icon_play_gif_a_${i+1}.png",
                width: Dimens.dimen_35dp,
                height: Dimens.dimen_35dp,
              ),
            ),
        ],
      ),
    );
  }

  double _getOpacity(String type) {
    double result;
    if (widget.maxPageCount != null && widget.currentPagePosition != null) {
      if (type == Strings.string_tag_previous) {
        result = widget.leftNavVisibly
            ? (widget.currentPagePosition == 1 ? 0.0 : 1.0)
            : 0.0;
      } else if (type == Strings.string_tag_next) {
        result = widget.rightNavVisibly ? 1.0 : 0.0;
      } else {
        result = 1.0;
      }
    } else {
      result = 1.0;
    }
    return result;
  }

  bool _endPosition() => widget.currentPagePosition >= widget.maxPageCount;

}
