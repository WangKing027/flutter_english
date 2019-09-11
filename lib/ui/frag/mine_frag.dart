import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/viewmodel/mine_viewmodel.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/ui/page/login_page.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:ui' as ui;
import 'package:flutter_mvvm/provider/provider_widget.dart';
import 'package:flutter_mvvm/provider/view_state.dart';
import 'package:flutter_mvvm/provider/view_state_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mvvm/base/route_factory.dart';

class MineFrag extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MineFragState();

}

class _MineFragState extends State<MineFrag> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true ;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    MineViewModel model = Provider.of<MineViewModel>(context);
    return Scaffold(
      body: _builder(context,model),
    );
//    return Scaffold(
//      body: ProviderWidget<MineViewModel>(
//          model: MineViewModel(context),
//          initializeData: (model) => model.initializeData(),
//          builder: (ctx,model,child){
//            if(model.viewState == ViewState.Loading){
//              return ViewStateLoadingWidget();
//            } else {
//              return _getMainWidget(model);
//            }
//          },
//      ),
//    );
  }

  Widget _builder(BuildContext context , MineViewModel model){
    if(model.viewState == ViewState.Loading){
      return ViewStateLoadingWidget();
    } else {
      return _getMainWidget(model);
    }
  }

  Widget _getMainWidget(MineViewModel model) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 20.0,right: 20.0,top: MediaQueryData.fromWindow(ui.window).padding.top),
        width: MediaQuery.of(context).size.width - 40.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25.0,bottom: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text("我的",style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#333333"),
                  ),textAlign: TextAlign.center,),
                ],
              ),
            ),
            CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child:Stack(
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                color: HexColor("#FCD148"),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: Image.asset("assets/images/img_avatar.png",width: 76.0,height: 76.0,),
                              ),
                            ),
                            top: 0.0,left: 0.0,
                          ),
                          Positioned(
                            child: Image.asset("assets/images/icon_me_novip.png",width: 30.0,height: 30.0,),
                            right: 0.0,bottom: 0.0,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text("游客用户",style: TextStyle(color: HexColor("#333333"),fontSize: 20.0,fontWeight: FontWeight.bold),),
                          Text("翻转ID：${model.data.id}",style: TextStyle(color: HexColor("#666666"),fontSize: 14.0,),),
                        ],
                      ),
                    ),
                    Expanded(child: Text("")),
                    Image.asset("assets/images/btn_arrow_right.png",width: 20.0,height: 20.0,)
                  ],
                ),
                onPressed: (){
                  MyRouteFactory.pushSlideY(context: context,page: LoginPage());
                }
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  CupertinoButton(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: 160.0,height: 100.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Image.asset("assets/images/img_bg_me_word.png",width: 160.0,height: 100.0,),
                            left: 0.0,right: 0.0,top: 0.0,bottom: 0.0,
                          ),
                          Positioned(
                            child: Text("我的生词本",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0),
                            ),
                            left: 20.0,top: 10.0,),
                          Positioned(
                            child: Text("${model.data.newWordsCount}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0),
                            ),
                            left: 20.0,bottom: 15.0,
                          ),
                        ],
                      ),
                    ),
                    onPressed: (){
                      showToast("我的生词本");
                      model.clickNewWords();
                    },
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                      width: 160.0,height: 100.0,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            child: Image.asset("assets/images/img_bg_me_note.png",width: 160.0,height: 100.0,),
                            left: 0.0,right: 0.0,top: 0.0,bottom: 0.0,
                          ),
                          Positioned(
                            child: Text("我的笔记",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0),
                            ),
                            left: 20.0,top: 10.0,),
                          Positioned(
                            child: Text("${model.data.noteCount}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0),
                            ),
                            left: 20.0,bottom: 15.0,
                          ),
                        ],
                      ),
                    ),
                    onPressed: (){
                      showToast("我的笔记");
                      model.clickNote();
                    },
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: model.data.isVip,
              child: Container(
                height: 38.0,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 10.0,),
                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [HexColor("#FEBA48"),HexColor("#FCD148"),]),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("开通VIP会员，无限学习",style: TextStyle(color: Colors.white,fontSize: 14.0),),
                    Expanded(child: Text("")),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: 55.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: HexColor("#FEAA02"),
                        ),
                        child: Center(
                          child: Text("开通",style: TextStyle(color: Colors.white,fontSize: 14.0),),
                        ),
                      ),
                      onPressed: (){
                        showToast("开通VIP");
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: (model.data.mineListItems.length * 60 + 20.0).toDouble(),
              child: ListView.separated(
                separatorBuilder:(ctx,index){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: HexColor("#C8C8C8"),
                  );
                },
                itemCount: model.data.mineListItems.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx,index){
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    child: InkWell(
                      onTap: (){
                        showToast("${model.data.mineListItems[index].text}");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image.asset("${model.data.mineListItems[index].icon}",width: 18.0,height: 18.0,),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text("${model.data.mineListItems[index].text}",style: TextStyle(color: HexColor("#333333"),fontSize: 16.0),),
                          ),
                          Expanded(child: Text("")),
                          Image.asset("assets/images/btn_arrow_right.png",width: 16.0,height: 16.0,),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}