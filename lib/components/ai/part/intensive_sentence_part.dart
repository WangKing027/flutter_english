import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm/res/index.dart';
import 'package:flutter_mvvm/model/ai/sentence_model.dart';
import 'package:flutter_mvvm/model/ai/word_style_model.dart';

// 句子学习
class IntensiveSentencePart extends StatelessWidget{

  final SentenceModel model ;
  final String richTextRule ;

  IntensiveSentencePart({
    Key key,
    @required this.model,
    this.richTextRule = "#",
  }) :  assert(model != null),
        super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Dimens.dimen_65dp),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: Dimens.dimen_180dp,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - Dimens.dimen_40dp,
              alignment: Alignment.center,
              padding: EdgeInsets.all(Dimens.dimen_18dp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.dimen_10dp),
                border: Border.all(
                    color: Colours.border_color,
                    width: Dimens.dimen_1dp,
                    style: BorderStyle.solid),
                color: Colours.white_color,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _getWidgetList(),
              ),
            ),
          ),
        ),
        Expanded(child: Text("")),
      ],
    );
  }

  List<Widget> _getWidgetList(){
    List<Widget> _result = [] ;
    if(model.sentenceEn.isNotEmpty){
      _result.add(Text.rich(
        TextSpan(
          children: _getChildren(model.sentenceEn),
        ),
        textAlign: TextAlign.center,
      ));
    }
    if(model.sentenceCn.isNotEmpty){
      _result.add(Container(height: Dimens.dimen_6dp,),);
      _result.add(Text(
        model.sentenceCn,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Dimens.font_15sp,
          color: Colours.black_color,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
      ));
    }
    return _result ;
  }

  List<TextSpan> _getChildren(String sentence) {
    List<TextSpan> _list = [];
    if (sentence.isNotEmpty) {
      if (sentence.contains(richTextRule)) {
        List<String> _wordList = sentence.split(richTextRule);
        if (_wordList.length > 0) {
          for (int i = 0; i < _wordList.length; i++) {
            WordStyleModel word = _getWordStyle(_wordList[i],
                isUnderlineWord(i) ? Colours.orange_color : Colours.black_color,
                decoration:
                isUnderlineWord(i) ? TextDecoration.underline : null,
                decorationStyle: TextDecorationStyle.dashed);
            _list.add(_getTextSpan(word)); // 是非第一位置且为奇数位为关键字
          }
        }
      } else {
        WordStyleModel word = _getWordStyle(sentence, Colours.black_color);
        _list.add(_getTextSpan(word));
      }
    }
    return _list;
  }

  TextSpan _getTextSpan(WordStyleModel wordStyle) {
    return TextSpan(
      text: wordStyle.word,
      style: TextStyle(
        color: wordStyle.color,
        fontWeight: FontWeight.w500,
        fontSize: Dimens.font_16sp,
        height: 1.2,
        decoration: wordStyle.decoration,
        decorationStyle: wordStyle.decorationStyle,
      ),
    );
  }

  WordStyleModel _getWordStyle(String text, Color color,
      {TextDecoration decoration, TextDecorationStyle decorationStyle}) =>
      WordStyleModel(
          word: text,
          color: color,
          decorationStyle: decorationStyle,
          decoration: decoration);

  bool isUnderlineWord(int index) => index > 0 && index.isOdd;

}