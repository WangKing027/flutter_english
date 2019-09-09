import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';

/// Sliver的测试Demo
class SliverPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SliverPageState();

}

class _SliverPageState extends BaseState<SliverPage> with TickerProviderStateMixin{

  final double _expandHeight = 240.0;
  double _paddingTop ;

  @override
  void initState() {
    appBarVisibly = true ;
    removeAppBar = true ;
    super.initState();
    _paddingTop = MediaQueryData.fromWindow(ui.window).padding.top;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return Builder(builder: (cxt){
      return Scaffold(
        backgroundColor: HexColor("#FFFEFC"),
        body:CustomScrollView(
          anchor: 0.0,
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
                "hahha",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              pinned: true,
              backgroundColor: Colors.blue.withOpacity(0.1),
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
                      filter: ui.ImageFilter.blur(sigmaX: 0.0,sigmaY: 0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: _expandHeight + _paddingTop ,
                        color: Colors.white.withOpacity(0.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((ctx,index){
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 130.0,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.red.withOpacity(0.1),
                    child: Text("我是SliverList $index"),
                  ),
                );
              },
                childCount: 1,),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _getSizeBox(1),
                      _getSizeBox(2),
                      _getSizeBox(3),
                      _getSizeBox(4),
                      _getSizeBox(5),
                      _getSizeBox(6),
                      _getSizeBox(7),
                      _getSizeBox(8),
                      _getSizeBox(9),
                      _getSizeBox(10),
                      _getSizeBox(11),
                      _getSizeBox(12),
                      _getSizeBox(13),
                      _getSizeBox(14),
                      _getSizeBox(15),
                      _getSizeBox(16),
                      _getSizeBox(17),
                      _getSizeBox(18),
                      _getSizeBox(19),
                      _getSizeBox(20),
                    ],
                  ),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),

            SliverGrid.count(
              crossAxisCount: 4,
              children: <Widget>[
                _getSizeBox(1),
                _getSizeBox(2),
                _getSizeBox(3),
                _getSizeBox(4),
                _getSizeBox(5),
                _getSizeBox(6),
                _getSizeBox(7),
                _getSizeBox(8),
                _getSizeBox(9),
                _getSizeBox(10),
              ],
            ),

            SliverFillViewport(
              delegate: SliverChildListDelegate.fixed(
                  <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text("我是SliverFillViewport"),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    )
                  ]
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.only(left: 20.0,right: 20.0,top: 40.0,bottom: 40.0),
              sliver: SliverFillViewport(
                delegate: SliverChildListDelegate.fixed(
                    <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text("我是SliverPadding 里的 SliverFillViewport"),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      )
                    ]
                ),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: true,
              child: Container(
                alignment: Alignment.center,
                color: Colors.cyan.withOpacity(0.5),
                child: Text("我是SliverFillRemaining 1"),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: true,
              child: Container(
                alignment: Alignment.center,
                color: Colors.cyan.withOpacity(0.9),
                child: Text("我是SliverFillRemaining 2"),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            var snackBar = SnackBar(
              content: Text("我是SnackBar"),
              backgroundColor: Colors.orange,
              elevation: 2.0,
              behavior: SnackBarBehavior.fixed,
              shape: Border.all(color: Colors.white,width: 1.0,style: BorderStyle.solid),
              action: SnackBarAction(label: "取消", onPressed: (){
                showToast("---SnackBarAction---");
              }),
            );
            Scaffold.of(cxt).showSnackBar(snackBar);
          },
          child: Icon(Icons.refresh),
        ),
      );
    });
  }

  Widget _getSizeBox(int index,{int max = 20 }){
    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: Container(
        alignment: Alignment.center,
        color: Colors.deepPurple.withOpacity( index / max),
        child: Text("$index"),
      ),
    );
  }


}

class SliverBottomWidget extends StatelessWidget with PreferredSizeWidget{
  final BuildContext context ;
  SliverBottomWidget(BuildContext context):this.context = context ;

  @override
  Size get preferredSize => Size(MediaQuery.of(context).size.width, 60.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      color: Colors.transparent,
    );
  }

}