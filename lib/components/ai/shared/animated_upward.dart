import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/res/index.dart';

///  定义AnimationBuilder
typedef AnimationBuilder = Animation<double> Function(BuildContext context);

class AnimatedUpWard extends StatefulWidget {

  final double animHeight ; // 包含child Widget的 parent Widget的高度
  final Color backgroundColor ;
  final Widget child ;
  final bool supportUpWardAnimation ; // 支持向上滑动动画
  final bool execute ; // 开始执行动画
  final bool supportFadeAnimation ; // 支持透明度动画
  final Duration duration ;
  final Curve curve ;
  final AnimationBuilder builder ;

  AnimatedUpWard({
    Key key,
    this.animHeight,
    this.backgroundColor,
    @required this.child,
    this.supportUpWardAnimation = false ,
    this.supportFadeAnimation = false ,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeIn,
    this.execute = false ,
    this.builder,
  }) :  assert(child != null),
        super(key:key);

  @override
  _AnimatedUpWardState createState() => _AnimatedUpWardState();

}

class _AnimatedUpWardState extends State<AnimatedUpWard> with SingleTickerProviderStateMixin{

  AnimationController _controller ;
  Animation<double> _animation ;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: widget.duration);
    _animation = Tween<double>(begin: 0.0,end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _controller.addListener(_animationListener);
  }

  void _animationListener(){
    setState(() {

    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_animationListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedUpWard oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("[didUpdateWidget]  --- oldWidget.isUpWardAnimation = ${oldWidget.supportUpWardAnimation} , widget.isUpWardAnimation = ${widget.supportFadeAnimation}");
    if((oldWidget.execute != widget.execute)){
       _controller.reset();
       _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.animHeight ?? Dimens.dimen_100dp,
      color: widget.backgroundColor ?? Colours.background_color,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            child: FadeTransition(
              opacity: widget.supportFadeAnimation && widget.execute ? (widget.builder ?? _animation ) : AlwaysStoppedAnimation(1.0),
              child: widget.child,
            ),
            left: 0,
            right: 0,
            bottom: widget.supportUpWardAnimation && widget.execute ? - widget.animHeight * (1 - (widget.builder ?? _animation?.value ?? 0.0 )) : 0.0,
          ),
        ],
      ),
    );
  }
}