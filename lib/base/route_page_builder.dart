import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 透明度变化的路由方法
class FadeRoutePage<T> extends PageRouteBuilder<T>{
  final Widget child ;
  final Duration duration ;
  final Curve curve ;
  FadeRoutePage({@required this.child,this.duration,this.curve = Curves.easeIn})
      : assert(child != null),
        super(
          pageBuilder:(ctx,anim1,anim2) => child,
          transitionDuration:duration ?? Duration(milliseconds: 300),
          transitionsBuilder:(ctx,anim1,anim2,child){
            return FadeTransition(
              opacity: Tween<double>(begin: 0.4,end:1.0)
                  .animate(CurvedAnimation(parent: anim1, curve: curve)),
              child: child,
            );
          }
        );
}

// 缩放变化的路由方法
class ScaleRoutePage<T> extends PageRouteBuilder<T> {
  final Widget child ;
  final Duration duration ;
  final Alignment alignment ;
  final Curve curve ;
  ScaleRoutePage({@required this.child,this.duration,this.alignment,this.curve = Curves.easeIn})
      : assert(child != null),
        super(
          pageBuilder:(ctx,anim1,anim2) => child,
          transitionDuration:duration ?? Duration(milliseconds: 300),
          transitionsBuilder:(ctx,anim1,anim2,child){
            return ScaleTransition(
              alignment: alignment ?? Alignment.center,
              scale: Tween<double>(begin: 0.0,end: 1.0)
                  .animate(CurvedAnimation(parent: anim1, curve: curve)),
              child: child,
            );
          }
      );
}

// 旋转变化的路由方法
class RotationRoutePage<T> extends PageRouteBuilder<T> {
  final Widget child ;
  final Duration duration ;
  final Alignment alignment ;
  final Curve curve ;
  RotationRoutePage({@required this.child,this.duration,this.alignment,this.curve = Curves.easeIn})
      : assert(child !=null),
        super(
            pageBuilder:(ctx,anim1,anim2) => child ,
            transitionDuration:duration ?? Duration(milliseconds: 300),
            transitionsBuilder:(ctx,anim1,anim2,child){
               return RotationTransition(
                 turns: Tween<double>(begin:0.4,end:1.0)
                     .animate(CurvedAnimation(parent: anim1, curve: curve)),
                 child: child,
                 alignment: alignment ?? Alignment.center,
               );
            }
        );
}

// X轴 平移动画的路由方法
class SlideXRoutePage<T> extends PageRouteBuilder<T>{
  final Widget child ;
  final Duration duration ;
  final bool bottomIn ;
  final Curve curve ;
  SlideXRoutePage({@required this.child,this.duration,this.bottomIn = true,this.curve = Curves.easeIn})
    : assert(child != null),
      super(
        pageBuilder:(ctx,anim1,anim2) => child,
        transitionDuration:duration ?? Duration(milliseconds: 300),
        transitionsBuilder:(ctx,anim1,anim2,child){
          return SlideTransition(
             position: Tween<Offset>(begin: bottomIn ? Offset(0.0,1.0) : Offset(0.0,-1.0),
                 end: Offset.zero).animate(CurvedAnimation(parent: anim1, curve: curve)),
             child: child,
          );
        }
      );
}

// Y轴 平移动画的路由方法
class SlideYRoutePage<T> extends PageRouteBuilder<T>{
  final Widget child ;
  final Duration duration ;
  final bool leftIn ;
  final Curve curve ;
  SlideYRoutePage({@required this.child,this.duration,this.leftIn = true,this.curve = Curves.easeIn})
      : assert(child != null),
        super(
          pageBuilder:(ctx,anim1,anim2) => child,
          transitionDuration:duration ?? Duration(milliseconds: 300),
          transitionsBuilder:(ctx,anim1,anim2,child){
            return SlideTransition(
              position: Tween<Offset>(begin: leftIn ? Offset(-1.0,0.0) : Offset(1.0,0.0),
                  end: Offset.zero).animate(CurvedAnimation(parent: anim1, curve: curve)),
              child: child,
            );
          }
      );
}

// 组合动画路由方法
class CombinationRoutePage<T> extends PageRouteBuilder<T>{
  final Widget child ;
  final Duration duration ;
  final Alignment scaleAlignment ;
  final Curve curve ;
  CombinationRoutePage({@required this.child,this.duration,this.scaleAlignment,this.curve = Curves.easeIn})
    : assert(child != null),
      super(
        pageBuilder:(cxt,anim1,anim2) => child,
        transitionDuration:duration ?? Duration(milliseconds: 300),
        transitionsBuilder:(ctx,anim1,anim2,child){
          return FadeTransition(
            opacity: Tween<double>(begin: 0.3,end: 1.0)
                .animate(CurvedAnimation(parent: anim1, curve: curve)),
            child: ScaleTransition(
                alignment: scaleAlignment ?? Alignment.center,
                scale: Tween<double>(begin: 0.1,end: 1.0)
                    .animate(CurvedAnimation(parent: anim1, curve: curve)),
                child: child,
            ),
          );
        }
      );
}

//... 自定义各种组合动画
