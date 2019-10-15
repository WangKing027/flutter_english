import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_mvvm/components/ai/widget_bottom_btn.dart';
import 'package:flutter_mvvm/model/ai/sentence_model.dart';
import 'package:flutter_mvvm/components/ai/shared/widget_animated_gif.dart';
import 'package:flutter_mvvm/base/audio_player_factory.dart';
import 'package:flutter_mvvm/utils/object_utils.dart';
import 'package:flutter_mvvm/utils/time_utils.dart';
import 'dart:async';


// 听写
class DictationGapPart extends StatefulWidget {

  final SentenceModel dictationModel ;
  final List<SentenceModel> sentenceList ;
  final Function audioCallBack , btnCallBack , gifCallBack ;

  DictationGapPart({
    Key key ,
    this.dictationModel ,
    this.sentenceList ,
    this.audioCallBack ,
    this.btnCallBack ,
    this.gifCallBack ,
  }) : assert(dictationModel != null) ,
       super(key:key) ;

  @override
  State<StatefulWidget> createState() => _DictationGapPartState();

}

class _DictationGapPartState extends State<DictationGapPart> {

  // 区分富文本标志
  final String _label = "#";
  // 字体大小
  final double _fontSize = Dimens.font_16sp ;
  // 正确颜色
  final Color _correctColor = Colours.pass_color;
  // 错误颜色
  final Color _wrongColor = Colours.red_color;
  // 正常颜色
  final Color _blackColor = Colours.black_color;

  List<SentenceModel> _sentenceList ;

  List<List<String>> _answerList ;
  List<TextModel> _userInputList = [];
  String _inputText = "";

  String _sentenceEn , _originalSentenceEn ;
  SentenceModel _wrongSentenceModel;
  int _answerCount ;

  FocusNode _focusNode ;
  Timer _downTimer ;

  bool _showInput = false ,
      _hideBottom = true ,
      _startDelay = true ;     // 是否显示TextFiled
  int _curTextFiledIndex = 0 ; // 选中的TextFiled

  String _btnText = Strings.string_submit;

  void initAnswerList(){
    for(int i =0 ; i < _answerCount ; i ++){
      _userInputList.add(TextModel(textColor: _blackColor,value: "",index: i));
    }
  }

  @override
  void initState() {
    super.initState();
    _sentenceEn = widget.dictationModel ?.sentenceEn ?? "";
    _originalSentenceEn = widget.dictationModel ?.originalSentenceEn ?? "";
    _answerList = widget.dictationModel ?.answers ?? [];

    debugPrint("【sentenceEn】: $_sentenceEn , 【orginalSentenceEn】: $_originalSentenceEn");

    _answerCount = _answerList.length;
    initAnswerList();
    _focusNode = FocusNode();
    _sentenceList = widget.sentenceList ?? [];

    _focusNode.addListener(focusListener);
  }

  @override
  void dispose() {
    _focusNode?.removeListener(focusListener);
    _focusNode?.dispose();
    disposeTimer();
    super.dispose();
  }

  void focusListener(){
    if(bottomBtnVisibly() && !_focusNode.hasFocus){
       textFiledVisible(visible: false);
    }
  }

  // 是否输入完全
  bool bottomBtnVisibly(){
    int _count = 0 ;
    for(TextModel model in _userInputList){
      if(model.value.length > 0){
        _count += 1 ;
      }
    }
    return _count == _answerCount ;
  }

  // 键盘提交按钮
  void onSubmitted(text){
     if(null == text || ((text is String) && text.trim().toString().length == 0)){
        showToast("提交内容不可为空~");
        return;
     }

     setState(() {
       _userInputList[_curTextFiledIndex].value = text;
       _userInputList[_curTextFiledIndex].isShow = true ;
       _inputText = "";
     });

     if(_curTextFiledIndex == _userInputList.length -1){
        textFiledVisible(visible: false);
     } else {
       if(bottomBtnVisibly()){
         textFiledVisible(visible: false);
       } else {
         FocusScope.of(context).requestFocus(_focusNode);
         setState(() { // 自动获取第二个焦点
           _curTextFiledIndex += 1;
         });
       }
     }
  }

  // 底部按钮点击
  void onBottomBtnPressed(){
      if(null != widget.gifCallBack){
         widget.gifCallBack(false);
      }
      // 提交
      if(_btnText == Strings.string_submit){
        bool _isRight = true ;
        setState(() {
          _btnText = Strings.string_continue;
          _isRight = isCorrect(); // 渲染Widget,提交匹配答案
          _hideBottom = false ;
        });

        if(_isRight){//正确
          playAudio("correct.mp3", (){
            if(widget.audioCallBack != null){
              widget.audioCallBack(_startDelay,_wrongSentenceModel);
            }
          });
        } else { //错误
          _wrongSentenceModel = getWrongSentence();
          playAudio("wrong.wav", (){
            startTimer((){
              playAudio("correct.mp3", (){
                if(widget.audioCallBack != null){
                   widget.audioCallBack(_startDelay,_wrongSentenceModel);
                }
              });
            });
          });
        }
      } else if(_btnText == Strings.string_continue){//继续
        disposeTimer();
        _startDelay = false ;
        if(widget.btnCallBack != null){
          widget.btnCallBack(_wrongSentenceModel);
        }
      }
  }

  // 播放音频
  void playAudio(String audio,Function callBack){
    audioPlayerFactory.playAssetAudio(
        assetAudio: audio,
        prefix: "/audio",
        listenPlayCompletion:callBack,
    );
  }

  // 回答是否正确
  bool isCorrect(){
    bool _result = true ;
    if(_userInputList.length > 0){
      for(TextModel model in _userInputList){
        List<String> _rightList = _answerList[_userInputList.indexOf(model)];
        List<String> _correctList = getCorrectResultList(_rightList);
        String _inputValue = ObjectUtil.toLowerCaseRemoveSpace(model.value);
        if(!_correctList.contains(_inputValue)){ // 错误文本
            _result = false ;
            model.textColor = _wrongColor;
            model.value = model.value ;
            model.isInput = false;
        } else {
           model.textColor = _correctColor;//  正确文本
           model.value = _rightList[0] ;
           model.isInput = false;
        }
      }
    }
    return _result ;
  }

  // 获取正确答案
  List<String> getCorrectResultList(List<String> rightList){
    List<String> _result = [] ;
    for(String srt in rightList){
      srt = ObjectUtil.toLowerCaseRemoveSpace(srt);
      _result.add(srt);
    }
    return _result;
  }

  // visible： true[隐藏]  false[显示]
  void textFiledVisible({bool visible = true}){
    visible = !visible ;
    setState(() {
      _showInput = visible;
    });
  }

  // 错误句子
  SentenceModel getWrongSentence(){
    for(SentenceModel sentence in _sentenceList){
      if(sentence.originalSentenceEn == _originalSentenceEn){
        return sentence ;
      }
    }
    return null;
  }

  // 销毁定时器
  void disposeTimer() => _downTimer?.cancel();

  // 开始定时器
  void startTimer(Function callback){
    _downTimer = TimeUtils.startTime(startText: 3,callBack:(){
      showCorrectResult();
      callback();
    });
  }

  // 显示正确答案
  void showCorrectResult(){
    disposeTimer();
    setState(() {
      for(TextModel mode in _userInputList){
        if(mode.textColor == _wrongColor){
          mode.value = (_answerList[_userInputList.indexOf(mode)])[0];
          mode.textColor = _correctColor;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          top: 0,left: 0,right: 0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: Dimens.dimen_30dp
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - Dimens.dimen_40dp,
              padding: EdgeInsets.only(left: Dimens.dimen_30dp,right: Dimens.dimen_30dp,top: Dimens.dimen_16dp,bottom:Dimens.dimen_16dp),
              margin: EdgeInsets.only(left: Dimens.dimen_20dp, right: Dimens.dimen_20dp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colours.border_color,
                      width: Dimens.dimen_1dp,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(Dimens.dimen_13dp)
              ),
              child: Text.rich(TextSpan(children: getInlineSpanList(),),),
            ),
          ),
        ),
        Positioned(
          bottom: 0,left: 0,right: 0,
          child: Offstage(
            offstage: _showInput , // false:显示 true:隐藏
            child: Container(
              height: Dimens.dimen_50dp,
              decoration: BoxDecoration(
                  color: Colours.white_color,
                  border: Border(top: BorderSide(color: Colours.light_gray_color,width: Dimens.dimen_1dp,style: BorderStyle.solid),)
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  maxHeight: Dimens.dimen_50dp,
                ),
                child: TextField(
                  focusNode: _focusNode,
                  controller: TextEditingController.fromValue(TextEditingValue(
                    text: _inputText,
                    selection: TextSelection.fromPosition(
                      TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: _inputText.length,
                      ),
                    ),
                  )),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colours.white_color
                  ),
                  autofocus: true,
                  keyboardAppearance: Brightness.light,
                  cursorColor: Colours.light_navy_blue_color,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-z,A-Z]")),//限制只能输入字母
                    LengthLimitingTextInputFormatter(30), //限制长度最大为30
                  ],
                  textInputAction:TextInputAction.send,
                  textAlign: TextAlign.left,//文本对齐方式
                  style: TextStyle( //输入文本的样式
                      fontSize: _fontSize,
                      color: Colours.black_color,
                      textBaseline: TextBaseline.alphabetic

                  ),
                  onSubmitted: onSubmitted,
                  onChanged: (t){
                    setState(() {
                      _inputText = t;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,left: 0,right: 0,
          child: Offstage(
            offstage: !(bottomBtnVisibly() && !(_focusNode.hasFocus) && _hideBottom),// false:显示 true: 隐藏
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: BottomBtnWidget(onPressed: onBottomBtnPressed, text: _btnText),
            ),
          ),
        ),
      ],
    );
  }

  List<InlineSpan> getInlineSpanList(){
    List<InlineSpan> _textSpanList = [] ;
    int _inputId = -1 ; // 输入框对应的id 与 跟答案数据的下标一一对应
    if(_sentenceEn.isNotEmpty){
      if(_sentenceEn.contains(_label)){
        List<String> sentenceEnList = _sentenceEn.split(_label);
        if(sentenceEnList.length > 0){
          for(int i = 0 ; i < sentenceEnList.length ; i ++){
            if(i > 0 && i.isOdd){// 是非第一位置且为奇数位为关键字
              if(_inputId < _answerCount - 1){
                 _inputId += 1;
              }
              _textSpanList.add(getWidgetSpan(_userInputList[_inputId]));
            } else{
              _textSpanList.add(getTextSpan(sentenceEnList[i], false));
            }
          }
        }
      } else {
        _textSpanList.add(getTextSpan(_sentenceEn, false));
      }
    }
    return _textSpanList ;
  }

  InlineSpan getTextSpan(String specialText , bool isSpecial,{ richColor = Colours.black_color}){
    return TextSpan(
      text: specialText,
      style: TextStyle(
        color: isSpecial ? richColor : Colours.black_color,
        fontWeight: FontWeight.w500,
        fontSize: _fontSize,
        height: 1.4,
      ),
    );
  }

  InlineSpan getWidgetSpan(TextModel model){
    return model.isShow ?
    TextSpan(
        text:formatText(model),
        style: TextStyle(
          color: model.textColor,
          fontWeight: FontWeight.w500,
          fontSize: _fontSize,
          height: 1.4,
          decoration: model.isInput ? TextDecoration.underline : null ,
          decorationStyle: model.isInput ? TextDecorationStyle.solid : null ,
        ),
        recognizer: TapGestureRecognizer()..onTap = (){
          textFiledVisible(visible: true);
          FocusScope.of(context).requestFocus(_focusNode);
          _curTextFiledIndex = model.index ;
          if(model.value != null && model.value.replaceAll(" ", "").trim().length > 0){
            setState(() {
              _inputText = model.value;
            });
          }
        }
    ) :
    WidgetSpan(
      child: GestureDetector(
        child: Container(
          width: Dimens.dimen_40dp,
          height: Dimens.dimen_20dp,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colours.light_navy_blue_color,width: Dimens.dimen_2dp,style: BorderStyle.solid)),
          ),
          child: _curTextFiledIndex == model.index ? Align(
            alignment: Alignment.center,
            child: AnimatedGifWidget(
              builder: ()=> gifWidgets(),
              duration: 1000,
            ),
          ) : Text(""),
        ),
        onTap: (){
          textFiledVisible(visible: true);
          FocusScope.of(context).requestFocus(_focusNode);
          _curTextFiledIndex = model.index ;
        },
      ),
    );
  }

  List<Widget> gifWidgets(){
    List<Widget> list = [];
    list.add(cursorView(color:Colours.light_navy_blue_color));
    list.add(cursorView(color: Colors.transparent));
    return list ;
  }

  Widget cursorView({Color color}){
    return Text("|",
      style: TextStyle(
        color: color,
        fontSize: Dimens.font_16sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String formatText(TextModel model){
    if(model.isInput && model.value.trim().length < 4){
      return "  ${model.value}  ";
    }
    return model.value;
  }

}

class TextModel{
  Color textColor ;
  String value ;
  int index;
  bool isShow ;
  bool isInput ;
  TextModel({this.textColor, this.value,this.index,this.isShow = false,this.isInput = true});
}
