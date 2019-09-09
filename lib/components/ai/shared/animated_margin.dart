import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';


class AnimatedMargin extends ImplicitlyAnimatedWidget {

  final EdgeInsetsGeometry margin;
  final Widget child ;

  /// The [margin], [curve], and [duration] arguments must not be null.
  /// [margin] 里的参数必须 大于等于0
  AnimatedMargin({
    Key key,
    @required this.margin,
    @required this.child,
    Curve curve = Curves.linear,
    @required Duration duration,
    Duration reverseDuration,
  })
    : assert(child !=  null),
      super(key:key,curve: curve, duration: duration, reverseDuration: reverseDuration);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin));
  }

  @override
  _AnimatedMarginState createState() => _AnimatedMarginState();

}

class _AnimatedMarginState extends AnimatedWidgetBaseState<AnimatedMargin>{

  EdgeInsetsGeometryTween _margin;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _margin = visitor(_margin, widget.margin, (dynamic value) => EdgeInsetsGeometryTween(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _margin.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<EdgeInsetsGeometryTween>('margin', _margin, defaultValue: null));
  }
}