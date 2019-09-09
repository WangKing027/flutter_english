import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/components/widget_custom_appbar.dart';

class SliverFixPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SliverFixPageState();

}

class _SliverFixPageState extends BaseState<SliverFixPage> with TickerProviderStateMixin{
  final double _expandHeight = 300.0 ;
  ScrollController _scrollController , _listController;
  bool _singleScrollable = false , _listScrollable = true ;
  final double _paddingTop = 100.0 ;

  @override
  void initState() {
    appBarVisibly = true ;
    removeAppBar = true ;
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0);
    _scrollController.addListener((){
       double _scrollPixels = _scrollController.position.pixels;
       debugPrint("---scrollControllerPixel: $_scrollPixels");
//       if(_scrollPixels >= _paddingTop){
//          _switchScrollEnable(listScrollable: true);
//       }
    });
    _listController = ScrollController(initialScrollOffset: 0);
    _listController.addListener((){
      double _listPixels = _listController.position.pixels;
      debugPrint("---listControllerPixel: $_listPixels");
    });
  }

  void _switchScrollEnable({bool singleScrollable = false, bool listScrollable = false}){
     setState(() {
       _singleScrollable = singleScrollable;
       _listScrollable = listScrollable ;
     });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _listController?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
           child: Image.asset("assets/images/img_college_words.png",
             width: MediaQuery.of(context).size.width,
             fit: BoxFit.cover,
             height: _expandHeight,
           ),
           top: 0,left: 0,right: 0,
        ),
        Positioned(
          child: CustomAppBarWidget(
            actions: <Widget>[
              CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: (){
                  showToast("我的单词本");
                },
                child: Image.asset("assets/images/btn_nav_vacabulary.png",
                  width: 22.0,
                  height: 22.0,
                ),
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: (){
                  showToast("我的笔记");
                },
                child: Image.asset("assets/images/icon_notes.png",
                  width: 22.0,
                  height: 22.0,
                ),
              ),
            ],
          ),
          top: 0,left: 0,right: 0,
        ),
        Positioned(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQueryData.fromWindow(ui.window).padding.top + 56.0),
            child: SingleChildScrollView(
              physics: _singleScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
              controller: _scrollController,
              padding: EdgeInsets.only(top: _paddingTop,),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: HexColor("#FFFEFC"),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ListView.builder(
                    physics: _listScrollable ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                    controller: _listController,
                    itemBuilder: (ctx,index){
                       return Container(
                         child: Text("----$index Item---"),
                         width: MediaQuery.of(context).size.width,
                         height: 50.0,
                         alignment: Alignment.center,
                         color: Colors.blue.withOpacity((index + 1)/20),
                       );
                    },
                    itemCount: 20,
                  ),
                ),
              ),
            ),
          ),
          top:0,left: 0,right: 0,bottom: 0,
        ),
      ],
    );
  }

}

