import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_mvvm/animation/bar.dart';

class ChartAnimationPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _ChartAnimationPageState();

}

class _ChartAnimationPageState extends State<ChartAnimationPage> with TickerProviderStateMixin{
  final random = Random();
  int dataSet = 50;

  AnimationController _controller ;

  // method 1:
//  double _currentHeight ;
//  double _startHeight ;
//  double _endHeight ;

  // method 2:
//  Tween<double> tween ;

  List<Color> _colors = [
    Colors.red,Colors.blue,
    Colors.blueAccent,Colors.grey,
    Colors.orange,Colors.brown,
    Colors.amber,Colors.cyan,
    Colors.deepPurple,Colors.blueGrey,
  ];

//  BarTween tween ;

  BarChartTween chartTween ;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 300))
        ..addListener((){
          setState(() {
              // a + (b - a)*t
//              _currentHeight = ui.lerpDouble(_startHeight, _endHeight, _controller.value);
          });
        });
//    _currentHeight = 0.0;
//    _startHeight = 0.0 ;
//    _endHeight = dataSet.toDouble();
//    tween = Tween<double>(begin: 0.0,end: dataSet.toDouble());

//    tween = BarTween(Bar(barHeight: 0.0,color: Colors.orange), Bar(barHeight: 50.0,color: Colors.yellow));

    chartTween = BarChartTween(BarChart.lerp(BarChart.random(random), BarChart.random(random), _controller.value),
        BarChart.lerp(BarChart.random(random), BarChart.random(random), _controller.value));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _changeData(){
    setState(() {
//      _startHeight = _currentHeight; // change old current height to start height
//      dataSet = random.nextInt(100);
//      _endHeight = dataSet.toDouble();
//      _controller.forward(from: 0.0);

//      dataSet = random.nextInt(100);
//      tween = Tween<double>(
//        begin: tween.evaluate(_controller),
//        end: dataSet.toDouble(),
//      );
//      _controller.forward(from: 0.0);
      
//      tween = BarTween(tween.evaluate(_controller), Bar(barHeight: random.nextDouble() * 100,color: _colors[random.nextInt(_colors.length -1)]));
//      _controller.forward(from: 0.0);

       chartTween = BarChartTween(chartTween.evaluate(_controller),
           BarChart.lerp(BarChart.random(random,), BarChart.random(random,), _controller.value));
       _controller.forward(from: 0.0);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          size: Size(200.0, 100.0),
//          painter: BarChartPainter(barHeight: _currentHeight),
//          painter: BarChartPainter(animation: tween.animate(_controller)),
//          painter: BarChartPainter(animation: tween.animate(_controller),),
           painter: BarChartListPainter(animation: chartTween.animate(_controller)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

// method 2
//class BarChartPainter extends CustomPainter {
//  static const barWidth = 10.0 ;
//
//  final Animation animation ;
//
//  BarChartPainter({this.animation})
//      : assert(animation !=null),
//        super(repaint:animation);
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final Paint _paint = Paint()
//      ..color = Colors.blue[400]
//      ..style = PaintingStyle.fill ;
//    final double barHeight = animation.value ;
//
//    canvas.drawRect(
//        Rect.fromLTWH((size.width - barWidth) / 2,
//            size.height - barHeight, barWidth, barHeight)
//        , _paint);
//  }
//
//  @override
//  bool shouldRepaint(BarChartPainter old) {
//    return false;
//  }
//
//}

//  method 1
//class BarChartPainter extends CustomPainter {
//  static const barWidth = 10.0 ;
//
//  final double barHeight ;
//
//  BarChartPainter({this.barHeight});
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final Paint _paint = Paint()
//        ..color = Colors.blue[400]
//        ..style = PaintingStyle.fill ;
//
//    canvas.drawRect(
//        Rect.fromLTWH((size.width - barWidth) / 2,
//            size.height - barHeight, barWidth, barHeight)
//        , _paint);
//  }
//
//  @override
//  bool shouldRepaint(BarChartPainter old) {
//    return barHeight != old.barHeight;
//  }
//
//}