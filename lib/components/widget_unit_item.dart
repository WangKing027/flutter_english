import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/components/widget_level.dart';
import 'package:flutter_mvvm/components/widget_rating_bar.dart';
import 'package:flutter_mvvm/model/unit_model.dart';

class UnitItemWidget extends StatelessWidget {

  final UnitModel model ;
  final Function onPressed ;
  UnitItemWidget({Key key,
    this.model,
    this.onPressed,
  })  : assert(model != null),
        super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[BoxShadow(color: HexColor("#000000").withOpacity(0.06),spreadRadius: 6.0,blurRadius: 8.0)]
      ),
      child: FlatButton(
          padding: const EdgeInsets.all(0.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Stack(
              overflow:Overflow.visible,
              children: <Widget>[
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: LevelWidget(
                              levelSpan: LevelSpan(
                                level: "A${model.level}",
                                bgColor: HexColor("#7FBFFF"),
                              ),
                              textSpan: LevelTextSpan(
                                text: model.unitName,
                                style: TextStyle(
                                  color: HexColor("#333333"),
                                  fontSize: 15.0,
                                ),
                                padding: const EdgeInsets.only(left: 10.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(model.unitTitle,
                              style: TextStyle(
                                color: HexColor("#333333"),
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Text(""),),
                      Offstage(
                        child: RatingBarWidget(
                          style: RatingBarStyle(
                            count: 5,
                            score: model.score,
                          ),
                        ),
                        offstage: model.state == 0,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: _getWidgetFromType(),
                  bottom: _bottom(),right: 0.0,
                ),
              ],
            ),
          ),
          onPressed: (){
            if(onPressed != null){
               onPressed(model);
            }
          },
      ),
    );
  }

  //type:  0: 中考词汇 1: 高考词汇 2: 商务口语 3: 生活口语
  //state: 0: 未解锁 1: 继续 2: 完成
  Widget _getWidgetFromType(){
     if(model.state == 0){
        if(model.type == 0 || model.type == 1){
           return Image.asset(
             "assets/images/btn_arrow_right.png",
             width: 20.0,
             height: 20.0,
           );
        } else {
          return Image.asset(
            "assets/images/icon_unit_locked.png",
            width: 70.0,
            height: 70.0,
          );
        }
     } else if(model.state == 1){
       return Image.asset(
         "assets/images/icon_unit_begin.png",
         width: 70.0,
         height: 70.0,
       );
     } else {
       return Image.asset(
         "assets/images/icon_unit_well_done.png",
         width: 70.0,
         height: 70.0,
       );
     }
  }

  double _bottom(){
    if(model.state == 0){
      if(model.type == 0 || model.type == 1){
         return 50.0;
      }
    }
    return -20.0;
  }


}