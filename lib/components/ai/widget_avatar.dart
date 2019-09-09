import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/dimens.dart';

class AvatarWidget extends StatefulWidget {

  final VoidCallback onPressed;
  final bool clickable ;
  final Size size ;
  final String imagePath ;
  final double animExtent;
  final bool isLocal ;
  final AvatarAnimationColors animationColors;
  final bool startAnimation ;
  final EdgeInsetsGeometry padding ;

  AvatarWidget({
    Key key,
    this.onPressed,
    this.clickable = false ,
    this.size ,
    this.animExtent = 0.0,
    @required this.imagePath,
    this.isLocal = true,
    this.animationColors,
    this.padding,
    this.startAnimation = false ,
  }) :  assert(imagePath != null),
        super(key:key) ;

  @override
  State<StatefulWidget> createState()=> _AvatarWidgetState();

}

class _AvatarWidgetState extends State<AvatarWidget> with SingleTickerProviderStateMixin{

  Animation<double> _scaleAnimation;
  Animation<Color> _colorAnimation ;
  AnimationController _controller ;
  Size size = Size(Dimens.dimen_50dp, Dimens.dimen_50dp);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    _scaleAnimation = Tween<double>(begin: 1.0,end: widget.animExtent / (widget.size?.width ?? size.width))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _colorAnimation = ColorTween(begin: widget.animationColors ?.begin ?? Colors.transparent,
        end: widget.animationColors?.end ?? Colors.transparent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.addListener(_animationListener);
    _controller.addStatusListener(_animationStateListener);
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_animationStateListener);
    _controller?.removeListener(_animationListener);
    _controller?.dispose();
    super.dispose();
  }

  void _animationListener(){
    setState(() {

    });
  }

  void _animationStateListener(state){
     if(state == AnimationStatus.completed){
        _controller.reverse();
     } else if(state == AnimationStatus.dismissed){
       _controller.forward();
     }
  }

  @override
  void didUpdateWidget(AvatarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(_controller.isAnimating){
       _controller?.stop(canceled: true);
    }
    if(widget.startAnimation){
      _controller.forward(from: 0.0);
    } else {
      _controller.stop(canceled: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.clickable){
          if(widget.onPressed != null){
            widget.onPressed();
          }
        }
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.all(0.0),
        child: SizedBox(
          height: widget.size?.height ?? size.height,
          width: widget.size?.width ?? size.width,
          child: Stack(
            children: <Widget>[
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: widget.size?.width ?? size.width,
                  height: widget.size?.height ?? size.height,
                  decoration: BoxDecoration(
                    color: widget.startAnimation ? (widget.animationColors != null ? _colorAnimation.value : Colors.transparent) : Colors.transparent,
                    borderRadius: BorderRadius.circular((widget.size?.width ?? size.width) / 2),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(widget.animExtent / 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular((widget.size?.width ?? size.width - widget.animExtent) / 2),
                  child: ClipOval(
                    child: widget.isLocal ? Image.asset("${widget.imagePath}",
                      width: widget.size?.width ?? size.width - widget.animExtent,
                      height: widget.size?.height ?? size.height - widget.animExtent,
                    ) : Image.network("${widget.imagePath}",
                      width: widget.size?.width ?? size.width - widget.animExtent,
                      height: widget.size ?.height ?? size.height - widget.animExtent,
                    ),
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

class AvatarAnimationColors{
  final Color begin ;
  final Color end ;
  AvatarAnimationColors({this.begin,this.end});
}