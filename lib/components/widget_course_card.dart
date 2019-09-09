import 'package:flutter/material.dart';
import 'package:flutter_mvvm/model/course_model.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/components/widget_level.dart';

class CourseCardWidget extends StatefulWidget {

  final CourseModel model ;
  final Function onPressed ;
  final String heroTag ;
  CourseCardWidget({Key key,this.model,@required this.onPressed,this.heroTag ="test1"})
    : assert(model != null),
      assert(onPressed != null),
      super(key:key);

  @override
  State<StatefulWidget> createState() => _CourseCardWidgetState();

}

class _CourseCardWidgetState extends State<CourseCardWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[BoxShadow(color: HexColor("#E5E0D7"),blurRadius: 1.0,spreadRadius: 0.6,offset: Offset(2.0, 4.0),),],
      ),
      child: FlatButton(
        padding: const EdgeInsets.all(0.0),
        onPressed: (){
          widget.onPressed(widget.model);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 172.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipRRect(
                child: Hero(
                    tag: widget.heroTag,
                    child: Image.asset(widget.model.courseIcon ?? "assets/images/img_business_oval_1.png",width: 130.0,height: 172.0,),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 15.0,top: 25.0,bottom: 20.0,right: 20.0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Text(widget.model.courseName ?? "",style: TextStyle(color: HexColor("#333333"),fontSize: 20.0,fontWeight: FontWeight.bold),),
                        top: 0,left: 0,
                      ),
                      Positioned(
                        child: Text(
                          widget.model.courseDec ?? "",
                          style: TextStyle(
                            color: HexColor("#999999"),
                            fontSize: 14.0,
                            height: 1.2,
                          ),
                          softWrap: true,
                        ),
                        top: 28.0,left: 0.0,right: 0.0,
                      ),
                      Positioned(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 15.0,
                          child: LevelWidget(
                            levelSpan: LevelSpan(
                              bgColor: HexColor(widget.model.courseLevel!=null ? widget.model.courseLevel > 1 ? "#12E293" : "#7FBFFF" :"#7FBFFF"),
                              level: "A${widget.model.courseLevel ?? 1}",
                            ),
                            textSpan: LevelTextSpan(
                              text: "${widget.model.courseNum ?? "0"} 人学习",
                              style: TextStyle(color: HexColor("#C8C8C8"),fontSize: 10.0),
                            ),
                          ),
                        ),
                        bottom: 0.0,left: 0.0,
                      ),
                    ],
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