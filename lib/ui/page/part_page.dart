import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/components/widget_level.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/components/widget_part_item.dart';
import 'package:flutter_mvvm/model/unit_model.dart';
import 'package:flutter_mvvm/ui/page/ai/dialogue_preview.dart';
import 'package:flutter_mvvm/ui/page/ai/intensive_learning.dart';

class PartPage extends StatefulWidget {

  final UnitModel model ;
  PartPage({Key key,this.model}):
      assert(model != null),
      super(key:key);

  @override
  State<StatefulWidget> createState() => _PartPageState();

}

class _PartPageState extends BaseState<PartPage> with SingleTickerProviderStateMixin{
  ScrollController _controller ;
  final double _expandHeight = 240.0;
  double _paddingTop ;
  double _titleColorOpacity = 0.0 ;

  @override
  void initState() {
    appBarVisibly = true ;
    removeAppBar = true ;
    super.initState();
    _paddingTop = MediaQueryData.fromWindow(ui.window).padding.top;
    _controller = ScrollController(initialScrollOffset: 0);
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
    super.dispose();
  }

  void _scrollListener(){
    double _movePixel = _controller.position.pixels ;
    if(_movePixel != null){
      if(_movePixel >= _expandHeight){
        _titleColorOpacity = 1.0 ;
      } else if(_movePixel <= 0){
        _titleColorOpacity = 0.0 ;
      } else {
        _titleColorOpacity = _movePixel / _expandHeight ;
      }
      setState((){});
    }
  }

  List<Map<String,Object>> _getListModel(){
    var _result = [
      {
        "partName":"对话初览",
        "partEnName":"Dialogue Preview",
        "routePage":DialoguePreview(),
      },
      {
        "partName":"词句学习",
        "partEnName":"Intensive Learning",
        "routePage":IntensiveLearning(),
      },
      {
        "partName":"词义配对",
        "partEnName":"Multiple",
        "routePage":DialoguePreview(),
      },
      {
        "partName":"无字幕跟读",
        "partEnName":"Dialogue Retelling",
        "routePage":DialoguePreview(),
      },
      {
        "partName":"情景模拟",
        "partEnName":"RolePlay",
        "routePage":DialoguePreview(),
      },
      {
        "partName":"听写",
        "partEnName":"Dictation",
        "routePage":DialoguePreview(),
      }
    ] ;
    return _result;
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
       body: CustomScrollView(
         anchor: 0.0,
         controller: _controller,
         slivers: <Widget>[
           SliverAppBar(
             centerTitle: true,
             leading: CupertinoButton(
               child: Icon(
                 Icons.arrow_back_ios,
                 color: Colors.white,
               ),
               onPressed: ()=>Navigator.of(context).pop(),
               padding: const EdgeInsets.all(0.0),
             ),
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
             title: Text(
               widget.model.partName,
               style: TextStyle(
                 color: Colors.white.withOpacity(_titleColorOpacity),
                 fontSize: 20.0,
                 fontWeight: FontWeight.w500,
               ),
             ),
             pinned: true,
             backgroundColor: HexColor("#666666"),
             expandedHeight: _expandHeight,
             flexibleSpace: FlexibleSpaceBar(
               collapseMode: CollapseMode.parallax,
               background: Stack(
                 children: <Widget>[
                   Image.asset("assets/images/img_college_words.png",
                     width: MediaQuery.of(context).size.width,
                     fit: BoxFit.cover,
                     height: _expandHeight + _paddingTop,
                   ),
                   BackdropFilter(
                     filter: ui.ImageFilter.blur(sigmaX: 4.0,sigmaY: 4.0),
                     child: Container(
                       width: MediaQuery.of(context).size.width,
                       height: _expandHeight + _paddingTop ,
                       padding: EdgeInsets.only(left: 25.0,right: 25.0,top: _paddingTop + 56.0),
                       color: HexColor("#666666").withOpacity(0.7),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         mainAxisSize: MainAxisSize.max,
                         children: <Widget>[
                           Padding(
                             child: Text(widget.model.partName,
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 26.0,
                                 fontWeight: FontWeight.w500,
                               ),
                             ),
                             padding: const EdgeInsets.only(top: 20.0),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 15.0,bottom: 20.0),
                             child: Text(widget.model.partDec,
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 14.0,
                                 height: 1.2,
                               ),
                             ),
                           ),
                           LevelWidget(
                               levelSpan: LevelSpan(
                                 level: "A${widget.model.level}",
                                 bgColor: HexColor(widget.model.level!=null ? widget.model.level > 1 ? "#12E293" : "#7FBFFF" :"#7FBFFF"),
                               ),
                               textSpan: LevelTextSpan(
                                 text: widget.model.unitTitle,
                                 style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 15.0,
                                 ),
                                 padding: EdgeInsets.only(left: 10.0),
                               ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
           SliverList(
             delegate: SliverChildBuilderDelegate(
                   (ctx,index){
                 if(index == 0){
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("单元目录",
                            style: TextStyle(
                              color: HexColor("#999999"),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    );
                 }
                 return Padding(
                   padding: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 20.0,),
                   child: PartItemWidget(
                     partName: _getListModel()[index -1]["partName"],
                     partEnName: _getListModel()[index -1]["partEnName"],
                     state: index,
                     onPressed: (){
                        Navigator.push(context, FadeRoutePage(child: _getListModel()[index -1]["routePage"]));
                     },
                   ),
                 );
               },
               childCount: 6,
             ),
           ),
         ],
       ),
    );
  }



}
