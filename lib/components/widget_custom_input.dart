import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter/services.dart';

/// TODO url: https://www.jianshu.com/p/70faaf9722b1
class CustomInputWidget extends StatefulWidget {

  final CustomInputProperty property ;
  final Function onChanged ;
  final Function onSubmitted ;
  CustomInputWidget({Key key,
    this.property,
    this.onChanged,
    this.onSubmitted,
  }) : assert(property != null ),
        super(key : key);

  @override
  State<StatefulWidget> createState() => _CustomInputWidget();

}

class _CustomInputWidget extends State<CustomInputWidget>{

  var customBorder ;

  @override
  void initState() {
    super.initState();
    customBorder = _CustomUnderLineBorder(
       textLength: widget.property.textLength ?? 1,
       spaceWidth: widget.property.spaceWidth ?? 0,
       textWidth : (widget.property.widgetWidth - (widget.property.textLength - 1) * widget.property.spaceWidth) / widget.property.textLength,
       border: widget.property.borderSide ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.property.widgetWidth,
      height: widget.property.widgetHeight ,
      child: TextField(
        cursorColor: widget.property.cursorColor,
        decoration: InputDecoration(
          border: widget.property.isNoBorder ? InputBorder.none : null ,
          filled: widget.property.filled,
          fillColor: widget.property.fillColor,
          enabledBorder: customBorder,
          focusedBorder: customBorder,
          contentPadding: EdgeInsets.all(0.0),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.property.textLength),
        ],
        style: TextStyle(
          fontSize: widget.property.fontSize,
          letterSpacing: widget.property.spaceWidth + customBorder.textWidth - calcTrueTextSize(widget.property.fontSize),
          color: widget.property.textColor,
        ),
        onChanged:(v){
          if(widget.onChanged != null){
            widget.onChanged(v);
          }
        },
        onSubmitted: (v){
          if(widget.onSubmitted != null){
            widget.onSubmitted(v);
          }
        },
      ),
    );
  }

  // 测量单个数字实际长度
  double calcTrueTextSize(double textSize) {
    var paragraph = ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: textSize))
      ..addText("0");
    var p = paragraph.build()
      ..layout(ui.ParagraphConstraints(width: double.infinity));
    return p.minIntrinsicWidth;
  }

}

class CustomInputProperty{
  final Color cursorColor ;
  final bool isNoBorder ;
  final bool filled ;
  final Color fillColor ;
  final double fontSize ;
  final Color textColor ;
  final int textLength ;
  final BorderSide borderSide;
  final double spaceWidth ;
  final double widgetWidth ;
  final double widgetHeight ;
  CustomInputProperty({
     this.cursorColor = Colors.orange, /// 光标颜色
     this.isNoBorder = false , /// 去除所有border
     this.filled = true , /// 是否填充
     this.fillColor = Colors.white, /// 填充颜色
     this.borderSide,
     this.spaceWidth = 40,
     this.fontSize = 20.0,
     this.textLength = 1,
     this.textColor = Colors.black,
     this.widgetWidth = 300.0,
     this.widgetHeight = 80.0,
  });
}

///
///  [_ _ _]
///
class _CustomUnderLineBorder extends UnderlineInputBorder{

  final int textLength ;
  final BorderSide border ;
  final double spaceWidth ;
  final double textWidth ;

  final BorderSide _borderSide = BorderSide(color: Colors.orange,width: 1.0,style: BorderStyle.solid);

  _CustomUnderLineBorder({
    this.border ,
    this.textLength = 1,
    this.spaceWidth = 0,
    this.textWidth = 100.0,
  });

  @override
  void paint(Canvas canvas,
      Rect rect,
      {double gapStart,
        double gapExtent = 0.0,
        double gapPercentage = 0.0,
        TextDirection textDirection
      }) {

    Path path = Path();
    path.moveTo(rect.bottomLeft.dx , rect.bottomLeft.dy);
    path.lineTo(rect.bottomLeft.dx + (spaceWidth + textWidth) * textLength, rect.bottomRight.dy);

    path = dashPath(path, dashArray: CircularIntervalList<double>([
      textWidth,spaceWidth
    ]));
    canvas.drawPath(path, border?.toPaint() ?? _borderSide.toPaint());
  }

}