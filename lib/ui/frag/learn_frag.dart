import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/ui/page/login_page.dart';
import 'package:flutter_mvvm/components/widget_label_item.dart';
import 'package:flutter_mvvm/components/widget_go_login.dart';
import 'package:flutter_mvvm/components/widget_course_card.dart';
import 'package:flutter_mvvm/provider/provider_widget.dart';
import 'package:flutter_mvvm/viewmodel/learn_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mvvm/ui/page/unit_page.dart';

class LearnFrag extends StatefulWidget {

  final VoidCallback callback ;

  LearnFrag({this.callback});

  @override
  State<StatefulWidget> createState() => _LearnFragState();

}

class _LearnFragState extends State<LearnFrag> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true ;

  @override
  Widget build(BuildContext context) {
     super.build(context);
     LearnViewModel model = Provider.of<LearnViewModel>(context);
     return Scaffold(
        body: _builder(context,model),
     );
//     return Scaffold(
//        body: ProviderWidget<LearnViewModel>(
//            model: LearnViewModel(),
//            initializeData: (model) => model.initializeData(),
//            builder: (ctx,model,child){
//              if(model.viewState == ViewState.Loading){
//                 return ViewStateLoadingWidget();
//              } else {
//                return _getMainWidget();
//              }
//            },
//        ),
//     );
  }

  Widget _builder(BuildContext context,LearnViewModel model){
    if(model.viewState == ViewState.Loading){
       return ViewStateLoadingWidget();
    } else {
      return _getMainWidget(model);
    }
  }

  Widget _getMainWidget (LearnViewModel model){
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 20.0,right: 20.0,top: MediaQueryData.fromWindow(ui.window).padding.top),
        width: MediaQuery.of(context).size.width - 40.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25.0,bottom: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("学习",style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#333333"),
                  ),textAlign: TextAlign.center,),
                  CupertinoButton(
                    child: Image.asset("assets/images/img_nosignin_protrail.png",width: 35.0,height: 35.0,),
                    onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LoginPage())),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 80.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      padding: EdgeInsets.only(left: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(colors: [HexColor("#FBECCB"),HexColor("#F8F0D2")]),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text("来翻转英语 学",style: TextStyle(
                            color: HexColor("#666666"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            textBaseline: TextBaseline.alphabetic,
                          ),textAlign: TextAlign.center,),
                          Text("优质",style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            textBaseline: TextBaseline.alphabetic,
                          ),textAlign: TextAlign.center,),
                          Text("课程",style: TextStyle(
                            color: HexColor("#666666"),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            textBaseline: TextBaseline.alphabetic,
                          ),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                    left: 0,right: 0,bottom: 0,
                  ),
                  Positioned(
                    child: Image.asset("assets/images/bitmap_2.png",width: 48.0,height: 53.0,),
                    bottom: 0,right: 25.0,
                  ),
                  Positioned(
                    child: Image.asset("assets/images/bitmap_1.png",width: 58.0,height: 70.0,),
                    bottom: 0,right: 60.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
              child: LabelItemWidget(labelText: "今日免费体验",),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 130.0,
              child: ListView.separated(
                separatorBuilder: (ctx,index){
                  return Container(width: 7.0,height: 15.0,);
                },
                itemBuilder: (ctx,index){
                  return Container(
                    width: 130.0,
                    height: 130.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          width: 130.0,
                          height: 90.0,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: ClipRRect(
                                  child: Image.asset("assets/images/bitmap_2.png",width: 130.0,height: 90.0,fit: BoxFit.cover,),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  width: 22.0,
                                  height: 12.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.0),
                                    color: HexColor("#7FBFFF"),
                                  ),
                                  child: Center(
                                    child: Text("AI",style: TextStyle(color: Colors.white,fontSize: 9.0),),
                                  ),
                                ),
                                top: 5.0,left: 5.0,
                              ),
                            ],
                          ),
                        ),
                        Text("早餐怎么吃？",style: TextStyle(color: HexColor("#666666"),fontSize: 13.0,height: 1.2,),textAlign: TextAlign.left,),
                        Text("生活口语1",style: TextStyle(color: HexColor("#999999"),fontSize: 12.0,height: 1.0,),textAlign: TextAlign.left,)
                      ],
                    ),
                  );
                },
                itemCount: 6,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
              child: LabelItemWidget(labelText: "我的课程",labelBtnText: "添加课程",callback: () => widget.callback != null ? widget.callback() : null,),
            ),
            Offstage(
              child: GoLoginWidget(tipImageUrl: "assets/images/img_no_couse.png",callback: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => LoginPage()));
              },),
              offstage: model.model.courseModels != null ? model.model.courseModels.length > 0 : false ,
            ),
            Offstage(
              offstage: model.model.courseModels != null ? model.model.courseModels.length <= 0 : true,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200.0 * model.model.courseModels.length,
                child: ListView.separated(
                  itemCount: model.model.courseModels.length,
                  separatorBuilder: (ctx,index) => Container(width: 30.0,height: 15.0,),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx,index){
                    return CourseCardWidget(
                      model: model.model.courseModels[index],
                      onPressed: (model) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => UnitPage(model: model,))),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}