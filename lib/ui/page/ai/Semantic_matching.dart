import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/viewmodel/ai/semantic_viewmodel.dart';
import 'package:flutter_mvvm/components/ai/widget_app_bar.dart';
import 'package:flutter_mvvm/components/ai/shared/widget_notice_text.dart';
import 'package:flutter_mvvm/components/ai/shared/widget_icon_play.dart';

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
            currentProgress: 1,
            maxProgress: 10,
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
                  onPressed: (val){

                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}