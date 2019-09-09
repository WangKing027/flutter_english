import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';

class PartItemWidget extends StatelessWidget{

  final Function onPressed ;
  final int state ;
  final String partName ;
  final String partEnName ;
  PartItemWidget({
      Key key,
      this.onPressed,
      this.state,
      @required this.partName,
      @required this.partEnName,
  }) : assert(partName.isNotEmpty),
       assert(partEnName.isNotEmpty),
       super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[BoxShadow(color: HexColor("#000000").withOpacity(0.06),spreadRadius: 6.0,blurRadius: 8.0)]
      ),
      child: FlatButton(
          onPressed: (){
            if(onPressed != null){
               onPressed();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(partName,
                      style: TextStyle(
                        color: HexColor("#333333"),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(partEnName,
                      style: TextStyle(
                        color: HexColor("#999999"),
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
                _getIconWidget(),
              ],
            ),
          ),
      ),
    );
  }

  Widget _getIconWidget(){
    if(state == 1){
       return Image.asset("assets/images/btn_course_done.png",width: 45.0,height: 45.0,);
    } else if(state == 2){
      return Image.asset("assets/images/btn_course_go.png",width: 45.0,height: 45.0,);
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Image.asset("assets/images/icon_lock.png",width: 24.0,height: 24.0,),
      );
    }
  }

}