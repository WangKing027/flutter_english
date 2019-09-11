import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'dart:async';
import 'package:flutter_mvvm/ui/app_page.dart';
import 'package:flutter_mvvm/base/route_factory.dart';

class SplashPage extends StatefulWidget {

  SplashPage({Key key})
    : super(key:key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();

}

class _SplashPageState extends BaseState<SplashPage> with SingleTickerProviderStateMixin{

  AnimationController _controller ;
  Animation<double> _animation ;
  bool _animationFinish = false ;
  int _downCont = 5 ;
  Timer _timer ;

  @override
  void initState() {
    appBarVisibly = true ;
    removeAppBar = true ;
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 800));
    _animation = Tween<double>(begin: 0.1,end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.addListener((){
      setState(() {
      });
    });
    _controller.addStatusListener((state){
//       if(state == AnimationStatus.completed){
//         if(_animationFinish){
//            _controller.stop(canceled: true);
//         } else {
//           _controller.reverse();
//           _animationFinish = true;
//         }
//       } else if(state == AnimationStatus.dismissed){
//         _controller.forward();
//       }
    });
    _controller.forward();

    _timer = Timer.periodic(Duration(milliseconds: 1000),(timer){
        _downCont -= 1 ;
        setState(() {});
        if(_downCont <= 0){
           timer.cancel();
           MyRouteFactory.pushReplaceSlideY(context: context,page: AppPage());
        }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer ?.cancel();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: ScaleTransition(
                    scale: _animation,
                    child: Image.asset("assets/splash/img_splash.png",
                      width: 240.0,
                      height: 260.0,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 40.0),
                child: Image.asset("assets/splash/img_startup_logo.png",
                  width: 158.0,
                  height: 56.0,
                ),
              ),
            ],
          ),
          top: 0,right: 0,left: 0,bottom: 0,
        ),
        Positioned(
          child: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.white,width: 1.0,style: BorderStyle.solid),
              ),
              child: Text("跳过 | $_downCont s",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
            onPressed: (){
              _timer?.cancel();
              MyRouteFactory.pushReplaceSlideY(context: context,page: AppPage());
            },
          ),
          top: MediaQueryData.fromWindow(ui.window).padding.top,right: 10.0,
        ),
      ],
    );
  }

}