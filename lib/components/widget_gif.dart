import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GifWidget extends StatefulWidget {

  final int duration ;
  final List<CustomWidgetModel> customWidgetList;

  GifWidget({
    Key key,
    this.duration,
    @required this.customWidgetList
  }) : super(key : key);

  @override
  State<StatefulWidget> createState() => _GifWidgetState();

}

class _GifWidgetState extends State<GifWidget> with SingleTickerProviderStateMixin{
  AnimationController _controller ;
  Animation<int> _animation ;
  int _length ;

  @override
  void initState() {
    super.initState();
    _length = widget.customWidgetList ?.length ?? 0 ;
    _controller = AnimationController(vsync: this,duration:Duration(milliseconds: widget.duration ??  900))
      ..repeat();
    _animation = IntTween(begin: 0,end: _length > 0 ? _length - 1 : 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
          return widget.customWidgetList[_animation.value].childWidget;
        }
    );
  }
}

class CustomWidgetModel {
  Widget childWidget;
  CustomWidgetModel({this.childWidget});
}
