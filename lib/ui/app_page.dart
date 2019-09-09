import 'package:flutter/material.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/ui/frag/learn_frag.dart';
import 'package:flutter_mvvm/ui/frag/course_frag.dart';
import 'package:flutter_mvvm/ui/frag/mine_frag.dart';
import 'package:flutter_mvvm/provider/provider_widget.dart';
import 'package:flutter_mvvm/viewmodel/course_viewmodel.dart';
import 'package:flutter_mvvm/viewmodel/learn_viewmodel.dart';
import 'package:flutter_mvvm/viewmodel/mine_viewmodel.dart';

class AppPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AppPageState();

}

class _AppPageState extends BaseState<AppPage> with SingleTickerProviderStateMixin{

  TabController _tabController ;

  @override
  void initState() {
    appBarVisibly = true ;
    removeAppBar = true ;
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return ProviderWidget3<LearnViewModel,CourseViewModel,MineViewModel>(
       modelA: LearnViewModel(),
       modelB: CourseViewModel(context),
       modelC: MineViewModel(context),
       initializeData: (model1,model2,model3){
         model1.initializeData();
         model2.initializeData();
         model3.initializeData();
       },
       builder: (ctx,model1,model2,model3,child){
         return Scaffold(
           body: TabBarView(
             children: <Widget>[
               LearnFrag(callback: () => _tabController.animateTo(1),),
               CourseFrag(),
               MineFrag(),
             ],
             controller: _tabController,
             physics: NeverScrollableScrollPhysics(),
           ),
           bottomNavigationBar: Material(
             color: Colors.white,
             elevation: 2.0,
             child: TabBar(
               tabs: <Widget>[
                 Tab(child:_TabView(text: "学习",icon: Icons.add,),),
                 Tab(child:_TabView(text: "课程",icon: Icons.stop,),),
                 Tab(child:_TabView(text: "我的",icon: Icons.refresh,),),
               ],
               controller: _tabController,
               unselectedLabelColor: Colors.black12,
               labelColor: Colors.orange,
               indicatorColor: Colors.transparent,
             ),
           ),
         );
       },
    );
  }
}

class _TabView extends StatelessWidget{

  final String text ;
  final IconData icon ;
  _TabView({this.text,this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(icon ?? Icons.add),
        Text(text??"",textAlign: TextAlign.center,),
      ],
    );
  }

}
