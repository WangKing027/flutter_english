import 'dart:math';
import 'dart:ui' show lerpDouble;
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

List<Color> _colors = [
  Colors.red,Colors.blue,
  Colors.blueAccent,Colors.grey,
  Colors.orange,Colors.brown,
  Colors.amber,Colors.cyan,
  Colors.deepPurple,Colors.blueGrey,
];

class BarChart {

  final List<Bar> barList ;
  static const barCount = 5 ;

  BarChart({this.barList})
      : assert(barList != null);

  factory BarChart.empty(){
    return BarChart(
      barList: List.filled(barCount,
          Bar(barHeight: 0.0,color: Colors.transparent)),
    );
  }

  factory BarChart.random(Random random,{int barCount = barCount}){
    final Color color = _colors[random.nextInt(_colors.length -1)];
    return BarChart(
      barList: List.generate(barCount,
              (i)=> Bar(barHeight: random.nextDouble() * 100,color: color)),
    );
  }

  static BarChart lerp(BarChart begin,BarChart end, double t){
    final int count = max(begin.barList.length, end.barList.length);
    return BarChart(
        barList: List.generate(count, (i) =>
            Bar.lerp(begin._barOrNull(i) ?? begin.barList[i].collapsed , end._barOrNull(i) ?? end.barList[i].collapsed , t)),
    );
//    final bars = <Bar>[] ;
//    final int bMax = begin.barList.length ;
//    final int eMax = end.barList.length ;
//    var b = 0 , e = 0;
//    while(b + e < bMax + eMax){
//      if (b < bMax && (e == eMax || begin.barList[b] < end.barList[e])) {
//        bars.add(Bar.lerp(begin.barList[b], begin.barList[b].collapsed, t));
//        b++;
//      } else if (e < eMax && (b == bMax || end.barList[e] < begin.barList[b])) {
//        bars.add(Bar.lerp(end.barList[e].collapsed, end.barList[e], t));
//        e++;
//      } else {
//        bars.add(Bar.lerp(begin.barList[b], end.barList[e], t));
//        b++;
//        e++;
//      }
//    }
//    return BarChart(barList: bars);
  }

  Bar _barOrNull(int index) => (index < barList.length ? barList[index] : null);

}

class BarChartTween extends Tween<BarChart>{

  BarChartTween(BarChart begin,BarChart end) : super(begin:begin,end:end);

  @override
  BarChart lerp(double t) => BarChart.lerp(begin, end, t);

}

class BarChartListPainter extends CustomPainter {

  static const barWidthFaction = 0.75;

  final Animation<BarChart> animation ;

  BarChartListPainter({this.animation})
      : assert(animation != null),
        super(repaint:animation);

  @override
  void paint(Canvas canvas, Size size) {
     final Paint _paint = Paint()
         ..style = PaintingStyle.fill;

     final BarChart barChart = animation.value ;
     final double barDistance = size.width / (1 + barChart.barList.length);
     final double barWidth = barDistance * barWidthFaction ;
     double x = barDistance - barWidth / 2 ;

     for(Bar bar in barChart.barList){
        drawBar(canvas, bar, x, barWidth, size, _paint);
        x += barDistance ;
     }

  }

  void drawBar(Canvas canvas, Bar bar,double x,double width, Size size,Paint paint){
     paint.color = bar.color ;
     canvas.drawRect(
         Rect.fromLTWH(x, size.height - bar.barHeight ,width , bar.barHeight)
         , paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}

///----------------------------------------------

// 建立自定义插值
class Bar {

  final double barHeight ;
  final double barWidth ;
  final double x ;
  final Color color ;

  Bar({this.barHeight,this.color,this.barWidth,this.x});

  Bar get collapsed => Bar(barHeight: 0,color: color,barWidth: 0,x: x);

  static Bar lerp(Bar begin,Bar end, double t){
    if(begin == null && end == null)
      return null;
    return Bar(
      barHeight:lerpDouble(begin.barHeight, end.barHeight, t),
      color: Color.lerp(begin.color, end.color, t),
    );
  }
}

// 建立补间
class BarTween extends Tween<Bar>{

  BarTween(Bar begin,Bar end):super(begin:begin,end:end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);

}

// 建立对应的Painter
class BarChartPainter extends CustomPainter {
  static const barWidth = 10.0 ;

  final Animation<Bar> animation ;

  BarChartPainter({this.animation})
      : assert(animation !=null),
        super(repaint:animation);

  @override
  void paint(Canvas canvas, Size size) {
     final double barHeight = animation.value.barHeight ;
     final Color barColor = animation.value.color;

     final Paint _paint = Paint()
         ..color = barColor ?? Colors.blue[400]
         ..style = PaintingStyle.fill;

     canvas.drawRect(Rect.fromLTWH((size.width - barWidth)/2,
         size.height - barHeight ,
         barWidth, barHeight),
         _paint );
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    return false;
  }
}
