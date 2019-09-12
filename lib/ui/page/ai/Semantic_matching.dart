import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/viewmodel/ai/semantic_viewmodel.dart';
import 'package:flutter_mvvm/components/ai/widget_app_bar.dart';
import 'package:flutter_mvvm/components/ai/shared/widget_notice_text.dart';
import 'package:flutter_mvvm/components/ai/shared/widget_icon_play.dart';
import 'package:flutter_mvvm/components/ai/part/semantic_word_match_part.dart';

class SemanticMatching extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _SemanticMatchingState();

}

class _SemanticMatchingState extends BaseState<SemanticMatching>{

  @override
  void initState() {
    rewriteScaffold = true;
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    return ProviderWidget<SemanticViewModel>(
      model: SemanticViewModel(),
      initializeData: (model) => model.initializeData(),
      builder: (ctx,model,child){
        if(model.viewState == ViewState.Loading){
          return ViewStateLoadingWidget();
        }
        return Scaffold(
          backgroundColor: Colours.background_color,
          appBar: AppBarWidget(
            currentProgress: model.getCurProgress(),
            maxProgress: model.getMaxProgress(),
            onPausePressed: () => model.onPausePressed(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Dimens.dimen_12dp),
                child: NoticeTextWidget(text: Strings.string_word_match_title,height: Dimens.dimen_25dp,),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: Dimens.dimen_45dp,
                margin: EdgeInsets.only(top: Dimens.dimen_45dp),
                child: IconPlayWidget(
                  playVisibly: true,
                  onPressed: (val) => model.onPlayPressed(val),
                ),
              ),
              Expanded(
               child: PageView.builder(
                 itemBuilder: (ctx,index){
                    return SemanticWordMatchPart(
                       cacheExtent: 50.0,
                       builder: (ctx,index){
                         return Container(
                           width: MediaQuery.of(context).size.width - 40.0,
                           height: 50.0,
                           margin: const EdgeInsets.only(left: 20.0,right: 20.0),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(8.0),
                             color: Colors.white,
                           ),
                           alignment: Alignment.center,
                           child: Text("我是第 $index",style: TextStyle(fontSize: 20.0,color: Colors.black),),
                         );
                       },
                      itemCount: 3,
                      rightIndex: 0,
                      onPressed: (index){

                      },
                    );
                 },
                 itemCount: model.getMaxProgress(),
                 controller: model.getController(),
                 physics: NeverScrollableScrollPhysics(),
               ),
              ),
            ],
          ),
        );
      },
    );
  }

}