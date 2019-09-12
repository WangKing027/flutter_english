import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/res/index.dart';

// 单个Item构建
typedef ItemWidgetBuilder = Widget Function(BuildContext context,int index);

// 答对的Item构建
//typedef ItemCorrectWidgetBuilder = Widget Function(BuildContext context,int index);

// 答错的Item构建
//typedef ItemErrorWidgetBuilder = Widget Function(BuildContext context,int index);

class SemanticWordMatchPart extends StatefulWidget{

  final double expandHeight ;
  final int duration ;
  final int interpDuration ;
  final ItemWidgetBuilder builder ;
//  final ItemCorrectWidgetBuilder correctBuilder ;
//  final ItemErrorWidgetBuilder errorBuilder ;
  final int itemCount ; // item的个数
  final double space ; // 间隔
  final double cacheExtent ; // item的高度
  final int rightIndex ; // 正确答案下标
  final int clickCount ; // 最多点击次数
  final Function onPressed;
  final bool clickable ;

  SemanticWordMatchPart({
    Key key,
    this.expandHeight ,
    this.duration = 300 ,
    this.interpDuration = 80,
    @required this.builder ,
//    this.correctBuilder ,
//    this.errorBuilder ,
    @required this.itemCount,
    @required this.cacheExtent,
    this.space = 8.0,
    @required this.rightIndex,
    @required this.onPressed,
    this.clickable = true ,
    this.clickCount = 2,
  }) :  assert(builder != null),
        assert(cacheExtent != null),
        assert(onPressed != null),
        assert(itemCount !=null && itemCount > 0),
        super(key:key);

  @override
  State<StatefulWidget> createState() => _SemanticWordMatchPartState();

}

class _SemanticWordMatchPartState extends State<SemanticWordMatchPart> with TickerProviderStateMixin , WidgetsBindingObserver{

  List<AnimationController> _controllerList = [];
  List<Animation<double>> _animationList = [];

  //[click time]
  int _clickCount ;

  // [right index]
  int _rightIndex ;

  // [click index]
  int _clickIndex  = -1;
  _ViewState _viewState = _ViewState.Normal ;

  @override
  void initState() {
    super.initState();
    _clickCount = widget.clickCount ;
    _rightIndex = widget.rightIndex ;
    _initAnimation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      debugPrint("[addPostFrameCallback] --- $timeStamp");
      if(mounted){
         Future.delayed(Duration(milliseconds: 400),(){
           _startAnimation(init: true);
         });
      }
    });
  }

  void _initAnimation(){
    if(widget.itemCount > 0){
      for(var i = 0 ; i < widget.itemCount ; i ++){
        AnimationController _controller = AnimationController(vsync: this,duration: Duration(milliseconds: widget.duration + i * widget.interpDuration));
        _animationList.add(Tween<double>(begin: 0.0,end: 1.0)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.ease)));
        _controller.addListener(_animationListener);
        _controllerList.add(_controller);
      }
    }
  }

  void _animationListener(){
    setState(() {
    });
  }

  /**
   * @param init 初次启动整体动画启动
   * @param movePosition 指定执行动画的下标
   */
  void _startAnimation({bool init = false , int movePosition}){
    if(init){
      _controllerList?.forEach((_controller){
        _controller.forward();
      });
    } else {
      if(movePosition == null){
         throw FlutterError("move position 不可为空~");
      }
      if(movePosition >= _controllerList.length || movePosition < 0){
        throw FlutterError("move position 下标越界，请注意查看下标~");
      }
      _controllerList[movePosition].reset();
      _controllerList[movePosition].forward();
    }
  }

  @override
  void dispose() {
    _controllerList?.forEach((_controller){
      _controller?.removeListener(_animationListener);
      _controller?.dispose();
      _controller = null ;
    });
    super.dispose();
  }

  @override
  void didUpdateWidget(SemanticWordMatchPart oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.expandHeight ?? (widget.cacheExtent + widget.space) * widget.itemCount,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
           for(var i = widget.itemCount - 1 ; i > -1 ; i --)
             Positioned(
               child: AnimatedOpacity(
                 opacity: _viewState == _ViewState.Normal ? 1.0 : 0.0,
                 duration: Duration(milliseconds: widget.duration),
                 child: GestureDetector(
                   child: widget.builder(context,i),
                   onTap: (){
                     if(widget.clickable){
                       setState(() {
                         _clickIndex = i ;
                       });
                       widget.onPressed(i);
                     }
                   },
                 ),
               ),
               left: 0.0,right: 0.0,
               bottom: -(widget.cacheExtent + widget.space) + ((widget.cacheExtent * i + (widget.cacheExtent + widget.space) + (i + 1) * widget.space) * _animationList[i].value),
             ),
        ],
      ),
    );
  }

}

enum _ViewState {
  Correct, // 答对
  Error, // 答错
  Normal // 正常
}
