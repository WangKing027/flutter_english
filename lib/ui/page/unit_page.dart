import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/model/course_model.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/components/widget_level.dart';
import 'package:flutter_mvvm/components/widget_unit_item.dart';
import 'package:flutter_mvvm/provider/provider_widget.dart';
import 'package:flutter_mvvm/viewmodel/unit_viewmodel.dart';
import 'package:flutter_mvvm/ui/page/part_page.dart';
import 'package:flutter_mvvm/model/unit_model.dart';


class UnitPage extends StatefulWidget{

  final CourseModel model ;
  final String heroTag ;
  UnitPage({this.model,this.heroTag = "hero_tag_unit_page"});

  @override
  State<StatefulWidget> createState() => _UnitPageState();
}

class _UnitPageState extends BaseState<UnitPage> with TickerProviderStateMixin{
  ScrollController _controller ;
  double _titleColorOpacity = 0.0 ;
  double _expandedHeight = 265.0 ;
  double _padding = 24.0 ;

  @override
  void initState() {
    appBarVisibly = true ;
    removeAppBar = true ;
    super.initState();
    _controller = ScrollController(initialScrollOffset: 10.0);
    _controller.addListener(_scrollListener);
  }

  void _scrollListener(){
    double _movePixel = _controller.position.pixels ;
    debugPrint("---scrollContorller: $_movePixel");
    if(_movePixel != null){
       if(_movePixel >= _expandedHeight){
          _titleColorOpacity = 1.0 ;
       } else if(_movePixel <= 0){
         _titleColorOpacity = 0.0 ;
       } else {
         _titleColorOpacity = _movePixel / _expandedHeight ;
       }
       setState((){});
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#FFFEFC"),
      body: ProviderWidget<UnitViewModel>(
        model: UnitViewModel(context),
        initializeData: (model) => model.initializeData(),
        builder: (ctx,model,child){
          if(model.viewState == ViewState.Loading){
             return ViewStateLoadingWidget();
          } else {
            return CustomScrollView(
              controller: _controller,
              slivers: <Widget>[
                GaussSliverAppBarWidget(
                  expandedHeight: _expandedHeight,
                  titleColorOpacity: _titleColorOpacity,
                  name: widget.model.courseName,
                  image: Hero(
                     tag: widget.heroTag,
                     child: Image.asset(
                       widget.model.courseIcon,
                       width: MediaQuery.of(context).size.width,
                       fit: BoxFit.cover,
                       height: _expandedHeight + MediaQueryData.fromWindow(ui.window).padding.top,
                     ),
                  ),
                  child:Stack(
                    children: <Widget>[
                      Positioned(
                        child: _getTitleWidget(),
                        top: 0, bottom: 0, left: 0, right: 0,
                      ),
                      Positioned(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40.0,
                          color: HexColor("#000000").withOpacity(0.2),
                          child: Padding(
                            padding: EdgeInsets.only(left: _padding,right: _padding),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text("上次学习: Unit6 早睡早起",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.all(0.0),
                                  child:Container(
                                    width: 70.0,
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 1.0),
                                    ),
                                    child: Center(
                                      child: Text("继续",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed:(){
                                    debugPrint("---继续---");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        bottom: 0, left: 0, right: 0,
                      ),
                    ],
                  ),
                ),
                SliverList(
                   delegate: SliverChildBuilderDelegate(
                         (ctx,index) {
                       if(index == 0){
                         return SizedBox(
                           width: MediaQuery.of(context).size.width,
                           height: 60.0,
                           child: Padding(
                             padding: EdgeInsets.only(left: _padding),
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
                         child: UnitItemWidget(
                           model: model.dataList[index - 1],
                           onPressed: (UnitModel model){
                             if(model.state == 0){
                               showToast("尚未解锁,请接着完成课程~");
                             } else {
                               Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => PartPage(model: model,)));
                             }
                           },
                         ),
                       );
                     },
                     childCount: model.dataList.length + 1,
                   ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _getTitleWidget(){
    return Padding(
      padding: EdgeInsets.only(left: _padding,right: _padding,top: MediaQueryData.fromWindow(ui.window).padding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(widget.model.courseName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(widget.model.courseDec,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      height: 1.2,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ClipRRect(
              child: Image.asset(
                widget.model.courseIcon,
                width: 80.0,
                height: 106.0,
              ),
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        ],
      ),
    );
  }

}

/// 拥有高斯模糊的SliverAppBar
class GaussSliverAppBarWidget extends StatelessWidget {

  final double expandedHeight ;
  final double titleColorOpacity ;
  final Widget child ;
  final Widget image ;
  final String name ;

  GaussSliverAppBarWidget({Key key,
    @required this.expandedHeight,
    @required this.titleColorOpacity,
    this.name,
    this.image,
    @required this.child,
  })  : assert(expandedHeight != null),
        assert(titleColorOpacity != null && titleColorOpacity >=0.0 && titleColorOpacity <= 1.0),
        assert(child != null),
        super(key:key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: HexColor("#D7B15E"),
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.white,opacity: 1.0,size: 24.0),
      elevation: 6.0,
      centerTitle: true,
      title: Text(name ?? "生活口语1",
        style: TextStyle(
          color: Colors.white.withOpacity(titleColorOpacity),
          fontSize: 20.0,
        ),
      ),
      pinned: true,
      floating: false,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=>Navigator.of(context).pop(),
      ),
      expandedHeight:expandedHeight,
      actions: <Widget>[],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            image ?? Image.asset(
              "assets/images/img_college_words.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              height: expandedHeight,
            ),
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 16.0,sigmaY: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: expandedHeight + MediaQueryData.fromWindow(ui.window).padding.top ,
                color: Colors.black.withOpacity(0.1),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: expandedHeight,
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}