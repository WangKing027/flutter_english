import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/res/index.dart';
import 'package:flutter_mvvm/components/widget_gif.dart';
import 'package:flutter_mvvm/model/ai/sentence_model.dart';
import 'package:flutter_mvvm/model/ai/word_style_model.dart';


// 考核
class IntensiveAssessPart extends StatefulWidget {

  final SentenceModel model ;
  final bool scoreVisibly ; // 成绩是否可见
  final bool voiceVisibly ; // 音频播放部分是否可见（包括play,gif）
  final bool playVisibly ;  // 播放按钮是否可见（true：播放按钮  false：正在播放的gif）
  final Function onPlayPressed;
  final double score ; // 分数
  final String richTextRule ;   // 分割富文本的标识
  final List<WordStyleModel> resultData ; // 打分系统返回数据

  IntensiveAssessPart({
    Key key ,
    @required this.model,
    this.scoreVisibly = false ,
    this.voiceVisibly = true ,
    this.playVisibly = true ,
    this.onPlayPressed ,
    this.score = 0.0 ,
    this.richTextRule = "#",
    this.resultData ,
  }) :  assert(model != null),
        super(key:key);

  @override
  _IntensiveAssessPartState createState() => _IntensiveAssessPartState();

}

class _IntensiveAssessPartState extends State<IntensiveAssessPart>{

  EdgeInsetsGeometry _paddingEdgeInsets = EdgeInsets.only(left: Dimens.dimen_18dp,right: Dimens.dimen_18dp,top: Dimens.dimen_18dp,bottom: Dimens.dimen_65dp);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Dimens.dimen_65dp),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: Dimens.dimen_180dp
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - Dimens.dimen_40dp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.dimen_10dp),
                border: Border.all(
                    color: Colours.border_color,
                    width: Dimens.dimen_1dp,
                    style: BorderStyle.solid
                ),
                color: Colours.white_color,
              ),
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(child:
//                    widget.scoreVisibly ?
//                    Padding(
//                      padding: _paddingEdgeInsets,
//                      child: RichText(
//                        textDirection: TextDirection.ltr,
//                        textAlign:TextAlign.center,
//                        text: TextSpan(
//                          children: <TextSpan>[
//                             if(widget.resultData.isNotEmpty && widget.resultData.length > 0)
//                               for(WordStyleModel wordStyle in widget.resultData)
//                                 TextSpan(text: "${wordStyle.word}",
//                                   style: TextStyle(
//                                       color: wordStyle.color,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: Dimens.font_16sp,
//                                       height: 1.2,
//                                       decoration: wordStyle.decoration,
//                                       decorationStyle: wordStyle.decorationStyle,
//                                   ),
//                                 ),
//                          ],
//                        ),
//                      ),
//                    ) :
                    Padding(
                      padding: _paddingEdgeInsets,
                      child: Text(widget.model.originalSentenceEn,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimens.font_16sp,
                          color: Colours.black_color,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Positioned(child:
                    AnimatedOpacity(
                      opacity: widget.voiceVisibly ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      child: widget.playVisibly ?
                        CupertinoButton(
                          child: Image.asset('assets/images/gif/icon_play_gif_b_03.png', width: Dimens.dimen_45dp, height: Dimens.dimen_45dp),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            if(widget.onPlayPressed != null){
                               widget.onPlayPressed("sound");
                            }
                          },
                        ) : CupertinoButton(
                          padding:EdgeInsets.all(0),
                          child: GifWidget(customWidgetList: <CustomWidgetModel>[
                              for(int i = 0 ; i < 3 ; i ++)
                                CustomWidgetModel(
                                  childWidget:Image.asset(
                                    "assets/images/gif/icon_play_gif_b_0${i+1}.png",
                                    width: Dimens.dimen_45dp,
                                    height: Dimens.dimen_45dp,
                                  ),
                                ),
                            ],
                          ),
                          onPressed: null
                      ),
                    ),
                    left: Dimens.dimen_15dp, bottom: Dimens.dimen_15dp,
                  ),
                  Positioned(
                    child: AnimatedOpacity(
                      opacity: widget.scoreVisibly ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                          width: Dimens.dimen_46dp,
                          height: Dimens.dimen_46dp,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimens.dimen_23dp),
                              color: widget.score >= 60 ? Colours.green_color : Colours.fail_color ,
                              border: Border.all(color: Colors.white,width: Dimens.dimen_2dp,style: BorderStyle.solid),
                              boxShadow: <BoxShadow>[BoxShadow(color: Colours.shadow_color,blurRadius: 2.0,spreadRadius: 1.2,offset: Offset(1.0, 1.0))]
                          ),
                          child: Center(
                            child: Text(
                              "${widget.score.floor()}",
                              style: TextStyle(
                                fontSize: Dimens.font_23sp,
                                color: Colours.white_color,
                              ),
                            ),
                          )
                      ),
                      curve: Curves.ease,
                    ),
                    right: Dimens.dimen_20dp,bottom: -Dimens.dimen_23dp,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child:Text("")),
      ],
    );
  }

}