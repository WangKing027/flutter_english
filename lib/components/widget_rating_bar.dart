import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class RatingBarWidget extends StatelessWidget {

  final RatingBarStyle style ;
  final VoidCallback onPressed ;
  RatingBarWidget({Key key,this.style,this.onPressed})
      : assert(style != null),
        super(key:key);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: (style.starSize + style.offset) * style.count,
      height: style.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: _getRatingStarListWidget(),
      ),
    );
  }

  List<Widget> _getRatingStarListWidget(){
    var _result = <Widget>[] ;
    if(style != null){
      int _count = style.count;
      for(var i =0 ; i < _count ; i ++){
        _result.add(_getSingleStarWidget(i));
      }
    }
    return _result;
  }

  Widget _getSingleStarWidget(int index){
    return SizedBox(
      width: style.starSize + style.offset,
      height: style.starSize + style.offset,
      child: CupertinoButton(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            _getStarWidthScore(index),
            width: style.starSize,
            height: style.starSize,
          ),
          onPressed: onPressed ?? null,
      ),
    );
  }

  String _getStarWidthScore(int index){
     String _result = "assets/images/icon_star_empty.png";
     double _score = style.score ;
     double _fullMark = style.fullMark ;
     if(_score >= (index + 1)){
        _result = "assets/images/icon_star_whole.png" ;
     } else {
        double _diff = (index + 1) - _score ;
        if(_diff.abs() >= 1){
           _result = "assets/images/icon_star_empty.png";
        } else {
          _result = "assets/images/icon_star_half.png";
        }
     }
     return _result;
  }
}


class RatingBarStyle {
  final int count ;
  final Widget wholeImage ;
  final Widget halfImage ;
  final Widget emptyImage ;
  final double score ;
  final double fullMark ;
  final double starSize ;
  final double offset ;
  final double height ;

  RatingBarStyle({
    this.count = 5 ,
    this.wholeImage,
    this.halfImage,
    this.emptyImage,
    this.score = 0 ,
    this.fullMark = 5.0,
    this.starSize = 12.0,
    this.offset = 3.0,
    this.height = 30.0,
  }) : assert( score >=0 && score <= fullMark );

}