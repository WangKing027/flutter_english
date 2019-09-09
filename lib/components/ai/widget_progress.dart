import 'package:flutter_mvvm/res/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/base/event_bus.dart';

class ProgressWidget extends StatefulWidget{

  final double progressStrokeWidth;
  final int maxProgress;
  final int currentProgress ;
  final Size size ;

  ProgressWidget({
    Key key,
    this.progressStrokeWidth = 0,
    this.maxProgress = 100,
    this.currentProgress= 0,
    @required this.size
  }) :  assert(size != null),
        super(key:key);

  @override
  State<StatefulWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> with SingleTickerProviderStateMixin{
  AnimationController _controller ;
  Animation<double> _animation ;
  int _oldProgress = 0 , _currentProgress = 0;
  double _progressStrokeWith ;

  @override
  void initState() {
    super.initState();
    _progressStrokeWith = widget.progressStrokeWidth != 0 ? widget.progressStrokeWidth : Dimens.dimen_6dp ;
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 250));
    _animation = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addListener(_animationListener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_animationListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("[didUpdateWidget] : CurrentProgress = ${widget.currentProgress} , OldProgress = ${oldWidget.currentProgress} , MaxProgress = ${widget.maxProgress}");
    _oldProgress = oldWidget.currentProgress ;
    if(oldWidget.currentProgress != widget.currentProgress){
        _currentProgress = widget.currentProgress ;
       _animationStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget customPaint = _getCustomPaintWidget();
    return AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget child){
            return customPaint;
        },
        child: customPaint,
    );
  }

  Widget _getCustomPaintWidget(){
     return CustomPaint(
       painter: _AnimationProgressPainter(
         paddingLeft: 0.0,
         paddingRight: 0.0,
         progressStrokeWidth: _progressStrokeWith,
         maxValue: widget.maxProgress,
         stopValue: _getAnimationProgressValue(),
       ),
       size: widget.size,
     );
  }

  double _getAnimationProgressValue(){
    double _animValue = _animation != null ? _animation.value : 1.0;
    int _differ = _getDifferValue();
//    debugPrint("[_getAnimationProgressValue] : differ: $_differ , _progressValue: ${_oldProgress + _differ * _animValue}");
    return (_oldProgress + _differ * _animValue )  ;
  }

  int _getDifferValue(){
    int _progress = _formatProgress(_currentProgress);
    int _diffValue = _progress - _oldProgress ;
    return _diffValue;
  }

  int _formatProgress(int progress) {
    if (progress == null) {
      progress = 1 ;
    } else if(progress > widget.maxProgress){
       progress = widget.maxProgress;
    } else if(progress < 0){
      progress = 0;
    }
    return progress ;
  }

  void _animationListener() => setState(() {});

  void _animationStart(){
    _controller.reset();
    _controller.forward();
  }
}

class _AnimationProgressPainter extends CustomPainter {

  Paint bgPaint ;
  Paint progressPaint ;
  double progressStrokeWidth;
  double paddingLeft;
  double paddingRight;
  int maxValue;
  double stopValue ;

  _AnimationProgressPainter({
    this.progressStrokeWidth,
    this.paddingLeft,
    this.paddingRight,
    this.stopValue,
    this.maxValue
  }){
      bgPaint = Paint()
          ..strokeCap = StrokeCap.round
          ..strokeWidth = progressStrokeWidth
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = Colours.progressbar_bg_color;
      progressPaint = Paint()
          ..strokeWidth = progressStrokeWidth
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = Colours.progressbar_color;
  }

  @override
  void paint(Canvas canvas, Size size) {
      double width = size.width;
      double height = size.height;
      double paddingTopBottom = height > progressStrokeWidth ? (height - progressStrokeWidth)/2 : 0 ;
      // draw bg
      RRect rRect = RRect.fromLTRBR(paddingLeft, paddingTopBottom, width - paddingRight - paddingLeft, progressStrokeWidth + paddingTopBottom, Radius.circular(progressStrokeWidth / 2));
      canvas.drawRRect(rRect, bgPaint);
      // draw progress
      double progressWith = (width - paddingRight - paddingLeft) * stopValue  / maxValue ;
      RRect rRectProgress = RRect.fromLTRBR(paddingLeft, paddingTopBottom, progressWith , progressStrokeWidth + paddingTopBottom, Radius.circular(progressStrokeWidth / 2));
//      debugPrint("[paint] : ---rRectProgress:$rRectProgress, progressPaint: $progressPaint");
      canvas.drawRRect(rRectProgress, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
//      debugPrint("---shouldRepaint---${stopValue != maxValue} ==> stopValue: $stopValue ===> maxValue: $maxValue");
      return  stopValue != maxValue ;
  }
}