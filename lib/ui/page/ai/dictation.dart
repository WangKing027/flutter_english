import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mvvm/res/strings.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/components/ai/shared/widget_notice_text.dart';
import 'package:flutter_mvvm/components/ai/shared/widget_icon_play.dart';
import 'package:flutter_mvvm/viewmodel/ai/dictation_viewmodel.dart';

class Dictation extends StatefulWidget {

  @override
  State createState() => _DictationState();
}

class _DictationState extends BaseState<Dictation>{

  @override
  void initState() {
    rewriteScaffold = true ;
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
     return ProviderWidget<DictationViewModel>(
       initializeData: (model)=> model.initModelData(context) ,
       model: DictationViewModel(),
       builder:(ctx,model,child){
          if(model.viewState == ViewState.Loading){
             return ViewStateLoadingWidget();
          }
          return Scaffold(
            backgroundColor: Colours.background_color,
            appBar: AppBarWidget(
              currentProgress: model.getCurProgress() + 1,
              maxProgress: model.getMaxProgress(),
              onPausePressed: () => model.onPausePressed(),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                 Padding(
                     padding: EdgeInsets.only(top: Dimens.dimen_12dp),
                     child: NoticeTextWidget(text: Strings.string_dictation_title,height: Dimens.dimen_25dp,),
                 ),
                 Container(
                    alignment: Alignment.topCenter,
                    height: Dimens.dimen_45dp,
                    margin: EdgeInsets.only(top: Dimens.dimen_45dp),
                    child: IconPlayWidget(
                      playVisibly: model.getPlayVisibly(),
                      onPressed: (val) => model.onPlayPressed(val),
                    ),
                 ),
                 Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: Dimens.dimen_30dp),
                      child: PageView.builder(
                        itemBuilder: (cxt,index) => model.getCurChildPageWidget(index),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: model.getMaxProgress(),
                        scrollDirection: Axis.horizontal,
                        controller: model.getPageController(),
                      ),
                    ),
                 ),
              ],
            ),
          );
       }
     );
  }

}