import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/viewmodel/ai/dialogue_viewmodel.dart';
import 'package:flutter_mvvm/components/ai/widget_bottom_nav.dart';
import 'package:flutter_mvvm/components/ai/widget_record_ripple.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/components/ai/widget_avatar.dart';
import 'package:flutter_mvvm/components/ai/widget_chat_content.dart';


class DialoguePreview extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _DialoguePreviewState();

}

class _DialoguePreviewState extends BaseState<DialoguePreview> {

  @override
  void initState() {
    rewriteScaffold = true ;
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    return ProviderWidget<DialogueViewModel>(
        initializeData: (model) => model.initModelData(context),
        model: DialogueViewModel(),
        builder: (ctx,model,child){
          if(model.viewState == ViewState.Loading){
             return ViewStateLoadingWidget();
          }
          return Scaffold(
            backgroundColor: Colours.background_color,
            appBar: AppBarWidget(
              maxProgress: model.getMaxProgress(),
              currentProgress: model.getCurProgress(),
              onPausePressed:() => model.onPausePressed(),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: ListView.separated(
                      separatorBuilder:(ctx,index){
                        return SizedBox(height: Dimens.dimen_10dp,);
                      },
                      itemBuilder: (ctx,index){
                        if(index == 0){
                          return Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: Dimens.dimen_3dp, top: Dimens.dimen_3dp),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimens.dimen_10dp),
                                child: Image.asset("assets/images/pic.png",
                                  width: Dimens.dimen_245dp,
                                  height: Dimens.dimen_168dp,
                                ),
                              ),
                            ),
                          );
                        }
                        if(model.getSentenceList()[index - 1].speakerId.isOdd){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              AvatarWidget(
                                imagePath: "assets/images/doctor.png",
                                isLocal: true,
                                startAnimation: false,
                                animExtent: 0.0,
                                size: Size(48.0, 48.0),
                                animationColors: AvatarAnimationColors(begin: HexColor("#D9EFED"),end: HexColor("#DFF0EE")),
                                padding: EdgeInsets.only(left: Dimens.dimen_12dp,right: Dimens.dimen_12dp),
                              ),
                              ChatContentWidget(
                                normalText: model.getSentenceList()[index - 1].originalSentenceEn,
                                richText: model.getSentenceList()[index - 1].sentenceEn,
                                forceApply: model.getSentenceList()[index - 1].isReading,
                                bgColor: model.getSentenceList()[index - 1].speakerId.isOdd ? Colours.light_navy_blue_color : Colours.white_color,
                                onPressed:(){
                                  model.onChatItemPressed(index -1);
                                },
                                clickable: model.isClickable(),
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ChatContentWidget(
                                normalText: model.getSentenceList()[index - 1].originalSentenceEn,
                                richText: model.getSentenceList()[index - 1].sentenceEn,
                                forceApply: model.getSentenceList()[index - 1].isReading,
                                bgColor: model.getSentenceList()[index - 1].speakerId.isOdd ? Colours.light_navy_blue_color : Colours.white_color,
                                onPressed:(){
                                  model.onChatItemPressed(index -1);
                                },
                                clickable: model.isClickable(),
                              ),
                              AvatarWidget(
                                imagePath: "assets/images/doctor.png",
                                isLocal: true,
                                startAnimation: false,
                                animExtent: 0.0,
                                size: Size(48.0, 48.0),
                                animationColors: AvatarAnimationColors(begin: HexColor("#D9EFED"),end: HexColor("#DFF0EE")),
                                padding: EdgeInsets.only(left: Dimens.dimen_12dp,right: Dimens.dimen_12dp),
                              ),
                            ],
                          );
                        }
                      },
                      itemCount: model.getSentenceList().length + 1,
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                ),
                if(model.getBottomState() == BottomState.BottomNav)
                  BottomNavWidget(
                    maxPageCount: model.getMaxProgress(),
                    currentPagePosition: model.getCurProgress(),
                    onNavPressed: (type) => model.onBottomNavPressed(type),
                    leftNavVisibly: model.bottomNavLeftVisibly(),
                    rightNavVisibly: model.bottomNavRightVisibly(),
                    gifVisibly: model.bottomNavGifVisibly(),
                  )
                else if(model.getBottomState() == BottomState.RecordRipple)
                  RecordRippleWidget(
                    onPressed: model.onRipplePressed,
                    clickable: model.getRippleClickable(),
                    noticeText: model.getRippleNotice(),
                  )
                else
                  Container(
                    height: Dimens.dimen_100dp,
                    alignment: Alignment.center,
                    child: Text("Recording"),
                  )
              ],
            ),
          );
        },
    );
  }
}