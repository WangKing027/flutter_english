import 'package:flutter/material.dart';

typedef widgetListBuilder = List<Widget> Function();

class AnimatedGifWidget extends StatefulWidget {

  final int duration ;
  final widgetListBuilder builder ;

  AnimatedGifWidget({
    Key key,
    @required this.builder,
    this.duration ,
  }) : assert(null != builder),
       assert(null != duration),
       super(key:key);

  @override
  State<StatefulWidget> createState() => _AnimatedGifWidgetState();

}

class _AnimatedGifWidgetState extends State<AnimatedGifWidget> with SingleTickerProviderStateMixin {

  AnimationController _controller ;
  Animation<int> _animation ;
  List<Widget> widgets ;

  @override
  void initState() {
    super.initState();
    widgetListBuilder builder = widget.builder;
    widgets = builder();
    _controller = AnimationController(vsync: this,duration:Duration(milliseconds: widget.duration ??  900))
      ..repeat();
    CurvedAnimation cured = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _animation = IntTween(begin: 0,end: (widgets?.length ?? 0) > 0 ? (widgets.length - 1) : 0).animate(cured);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext ctx,Widget child){
        return widgets[_animation.value];
      }
    );
  }

}