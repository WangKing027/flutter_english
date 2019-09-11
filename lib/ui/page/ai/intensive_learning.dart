import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/res/colors.dart';
import 'package:flutter_mvvm/model/ai/module_model.dart';
import 'package:flutter_mvvm/viewmodel/ai/intensive_viewmodel.dart';
import 'package:flutter_mvvm/components/ai/widget_app_bar.dart';
import 'package:flutter_mvvm/components/ai/widget_bottom_nav.dart';
import 'package:flutter_mvvm/components/ai/widget_record_ripple.dart';
import 'package:flutter_mvvm/components/ai/widget_record_button.dart';
import 'package:flutter_mvvm/components/ai/widget_bottom_btn.dart';
import 'package:flutter_mvvm/components/ai/shared/animated_upward.dart';
import 'package:flutter_mvvm/components/ai/part/intensive_sentence_part.dart';
import 'package:flutter_mvvm/components/ai/part/intensive_word_part.dart';
import 'package:flutter_mvvm/components/ai/part/intensive_assess_part.dart';

class IntensiveLearning extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _IntensiveLearningState();

}

class _IntensiveLearningState extends BaseState<IntensiveLearning> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    rewriteScaffold = true ;
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    return ProviderWidget<IntensiveViewModel>(
      model: IntensiveViewModel(),
      initializeData: (model) => model.initModelData(context),
      builder: (ctx,model,child){
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: PageView.builder(
                  itemBuilder: (ctx,index) {
                    ModuleModel module = model.getPageViewDataToIndex(index);
                    if(module.type == PageModuleType.PageSentence){
                       return IntensiveSentencePart(model: module.data);
                    } else if(module.type == PageModuleType.PageWord){
                      return IntensiveWordPart(model: module.data);
                    } else if(module.type == PageModuleType.PageAssess){
                      return IntensiveAssessPart(
                        model: module.data,
                        onPlayPressed: (val) => model.onBottomNavPressed(val),
                        playVisibly: model.assessPlayVisibly(),
                        voiceVisibly: model.assessVoiceVisibly(),
                        scoreVisibly: model.assessScoreVisibly(),
                        score: model.assessScore(),
                      );
                    }
                    return Text("");
                  },
                  itemCount: model.getPageViewCount(),
                  physics: NeverScrollableScrollPhysics(),
                  controller: model.getController(),
                ),
              ),
              if(model.getBottomState() == BottomState.BottomNav)
                BottomNavWidget(
                  maxPageCount: model.getMaxProgress(),
                  currentPagePosition: model.getCurProgress() + 1,
                  onNavPressed: (type) => model.onBottomNavPressed(type),
                  leftNavVisibly: model.bottomNavLeftVisibly(),
                  rightNavVisibly: model.bottomNavRightVisibly(),
                  gifVisibly: model.bottomNavGifVisibly(),
                )
              else if(model.getBottomState() == BottomState.RecordRipple)
                RecordRippleWidget(
                  onPressed: () => model.onRipplePressed(),
                  clickable: model.getRippleClickable(),
                  noticeText: model.getRippleNotice(),
                )
              else if(model.getBottomState() == BottomState.RecordButton)
                AnimatedUpWard(
                  animHeight: Dimens.dimen_100dp,
                  child: RecordButtonWidget(
                    widgetHeight: Dimens.dimen_100dp,
                    padding: EdgeInsets.only(bottom: Dimens.dimen_27dp,top: Dimens.dimen_18dp),
                    onPressed:() => model.onPressedRecordBtn(),
                  ),
                )
              else if(model.getBottomState() == BottomState.ButtonContinue)
                BottomBtnWidget(
                  text: "继续",
                  onPressed:()=> model.onPressedContinueBtn(),
                )
              else
                Container(
                  child: Text(""),
                )
            ],
          ),
        );
      },
    );
  }

}