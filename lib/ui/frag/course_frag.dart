import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/viewmodel/course_viewmodel.dart';
import 'package:flutter_mvvm/components/widget_course_card.dart';
import 'dart:ui' as ui;
import 'package:flutter_mvvm/provider/provider_widget.dart';
import 'package:flutter_mvvm/ui/page/unit_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mvvm/base/route_factory.dart';

class CourseFrag extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CourseFragState();

}

class _CourseFragState extends State<CourseFrag> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true ;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    CourseViewModel model = Provider.of<CourseViewModel>(context);
    return Scaffold(
       body: _builder(model),
    );
//    return Scaffold(
//       body: ProviderWidget<CourseViewModel>(
//         model: CourseViewModel(context),
//         initializeData: (model) => model.initializeData(),
//         builder: (ctx,model,child){
//            if(model.viewState == ViewState.Loading){
//               return ViewStateLoadingWidget();
//            } else {
//              return ListView.separated(
//                 separatorBuilder: (ctx,index){
//                   if(index == 0){
//                     return Text("");
//                   }
//                   return Container(width: 30.0,height: 15.0,);
//                 },
//                 itemBuilder: (ctx,index){
//                   if(index == 0){
//                     return Container(
//                       margin: EdgeInsets.only(left: 20.0,right: 20.0,top: MediaQueryData.fromWindow(ui.window).padding.top),
//                       width: MediaQuery.of(context).size.width - 40.0,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           Text("课程",style: TextStyle(
//                             fontSize: 30.0,
//                             fontWeight: FontWeight.bold,
//                             color: HexColor("#333333"),
//                           ),textAlign: TextAlign.center,),
//                         ],
//                       ),
//                     );
//                   }
//                   return Container(
//                     margin: EdgeInsets.only(left: 20.0,right: 20.0,),
//                     width: MediaQuery.of(context).size.width - 40.0,
//                     child: CourseCardWidget(model: model.dataList[index - 1],),
//                   );
//                 },
//                 itemCount: (model.dataList?.length ?? 0) + 1,
//               );
//            }
//         },
//       ),
//    );
  }

  Widget _builder(CourseViewModel model){
    if(model.viewState == ViewState.Loading){
       return ViewStateLoadingWidget();
     } else {
      return ListView.separated(
        separatorBuilder: (ctx, index) {
          if (index == 0) {
            return Text("");
          }
          return Container(width: 30.0, height: 15.0,);
        },
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: MediaQueryData
                  .fromWindow(ui.window)
                  .padding
                  .top),
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 40.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("课程", style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#333333"),
                  ), textAlign: TextAlign.center,),
                ],
              ),
            );
          }
          return Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0,),
            width: MediaQuery
                .of(context)
                .size
                .width - 40.0,
            child: CourseCardWidget(
              model: model.dataList[index - 1],
              heroTag: "hero_tag_test_course_$index",
              onPressed: (model) => MyRouteFactory.pushCombination(context: context,page: UnitPage(model: model,heroTag: "hero_tag_test_course_$index",))
            ),
          );
        },
        itemCount: (model.dataList?.length ?? 0) + 1,
      );
    }
  }
}


