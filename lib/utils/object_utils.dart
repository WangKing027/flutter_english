import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/colors.dart';
import 'package:flutter_mvvm/model/ai/word_style_model.dart';

class ObjectUtil {

  /*
 * 格式化原生录音打分结果为WordStyleModel类型
 * 0 - 40   red
 * 40 - 80  black
 * 80 - 100 green
 */
  static List<String> _symbolList = [",","，","!","?","！","？",".","。"];
  static List<String> _abbreviationList = ["'","‘","`","’"];

  static List<WordStyleModel> formatNativeResultToWordStyleModel({String originalSentenceEn,NativeRecordResult result}) {
      List<WordStyleModel> _endResult = [] ;// 最终展示的结果
      if(originalSentenceEn == null){
         throw new FlutterError("originalSentenceEn 不能为空~");
      }
      if(result == null || result.words == null || result.words.length == 0){
        _getOriginalSection(_endResult, originalSentenceEn, 0, originalSentenceEn.length);
        return _endResult ;
      }
      List<EvaluationWord> evaluationWords = result.words;// 匹配的单词数组
      String saveOriginalSentenceEn = originalSentenceEn ; //保存原始句子
      List<String> _originalWords = _getOriginalWords(originalSentenceEn); // 获取原始单词的集合
      originalSentenceEn = originalSentenceEn.toLowerCase();  // 原始句子小写化
      int _resortIndex = 0, _count = 0 , _matchIndex = 0, _pointer = 0;
      int _matchCount = _getMatchCount(evaluationWords);  // 记录匹配上的单词总数
      for(EvaluationWord evalWord in evaluationWords){
         if(evalWord.matchTag == 0){ // 匹配到数据
            _resortIndex = originalSentenceEn.indexOf(evalWord.word);// 匹配到的单词所在句子中的起点位置
            if(_resortIndex == -1){
              _count += 1 ;
              _matchIndex += 1 ;
              if(_matchIndex == _matchCount){ // 最后一个是匹配上的数字
                _getOriginalSection(_endResult,saveOriginalSentenceEn, _pointer, _pointer + originalSentenceEn.length);
              }
              continue;
            } else {
              _matchIndex += 1 ;
            }
            String _startSub = "";
            if(_resortIndex != 0){
               _startSub = originalSentenceEn.substring(0,_resortIndex); //截取非匹配到的部分
            }
            originalSentenceEn = originalSentenceEn.substring(_resortIndex + evalWord.word.length,originalSentenceEn.length);
            if(_startSub.length != 0){
              _getOriginalSection(_endResult, saveOriginalSentenceEn, _pointer, _pointer + _startSub.length);
              _pointer += _startSub.length ;
            }
            _endResult.add(_getWordStyleModelWithScore(evalWord,_originalWords));//截取匹配到的部分
            if(_matchCount == _matchIndex){
               _pointer += evalWord.word.length ;
              _getOriginalSection(_endResult,saveOriginalSentenceEn, _pointer, _pointer + originalSentenceEn.length);
            } else {
              _pointer += evalWord.word.length ;
            }
           _resortIndex = 0 ;
         } else {
           _count += 1 ;
         }
      }
      if(_count == evaluationWords.length){
          _getOriginalSection(_endResult, saveOriginalSentenceEn, 0, saveOriginalSentenceEn.length);
      }
      return _endResult ;
  }

  static WordStyleModel _getWordStyleModelWithScore(EvaluationWord word,List<String> _originalWords){
    WordStyleModel _model;
    String _showWord = _getOriginalWord(_originalWords,word.word);
    int _score = ((word.pronAccuracy + (math.max(0, word.pronFluency)) * 100) ~/ 2); //四舍五入
    if(_score < 40){
      _model = new WordStyleModel(word: _showWord,color: Colours.red_color);
    } else if(_score >= 40 && _score < 80){
      _model = new WordStyleModel(word: _showWord,color: Colours.black_color);
    } else {
      _model = new WordStyleModel(word: _showWord,color: Colours.pass_color);
    }
    debugPrint("--匹配到的单词： $_showWord , --分数：$_score");
    return _model ;
  }

  static int _getMatchCount(List<EvaluationWord> evaluationWords){
     int _result = 0 ;
     for(EvaluationWord evaluationWord in evaluationWords){
        if(evaluationWord.matchTag == 0){
           _result += 1;
        }
     }
     return _result ;
  }

  // 原始单词和截取的单词比较
  static String _getOriginalWord(List<String> _originalWords,String word){
    String _showWord = word;
    bool _isMatch = false ; // 是否匹配上,匹配上是正常的单词,没匹配上再比较缩写单词
    for(String originalWord in _originalWords){
      if(word.trim() == originalWord.toLowerCase().trim()){
        _showWord = originalWord;
        _isMatch = true ;
        _originalWords.remove(originalWord);//成功匹配上了把单词从原始单词数组中移除
        break;
      }
    }
    if(!_isMatch){
       for(String originalWord in _originalWords){
         debugPrint("原始单词: $originalWord---包括---${containerAbbreviation(originalWord)}");
         if(containerAbbreviation(originalWord)){ //单词包括符号'
//           int _index = originalWord.indexOf(abbreviation());
           for(int i = 0 ; i < originalWord.length ; i ++ ){
              String _letter = originalWord.substring(i,i + 1);
              if(_letter.toLowerCase().trim() == word.trim()){
//                 if(i < _index){
//                   _showWord = _letter;
//                 } else {
//                   _showWord = "’$_letter";
//                 }
                 _showWord = _letter;
                 break;
              }
           }
           break;
         }
       }
    }
    return _showWord ;
  }

  static void _getOriginalSection(List<WordStyleModel> endResult,String originalSentenceEn,int startIndex,int endIndex){
      String _result = originalSentenceEn.substring(startIndex,endIndex); //获取截取的句子
//      if(isAbbreviationSymbol(_result)){//是上撇符号 '
//         return;
//      }
      for(int i= 0 ; i < _result.length ; i ++){
         String _letter = _result.substring(i,i + 1);
         if(isSymbol(_letter)){
            endResult.add(new WordStyleModel(word: _letter,color: Colours.black_color));
         } else {
           endResult.add(new WordStyleModel(word: _letter,color: Colours.red_color));
         }
      }
  }

  // 获取除去标点符合的单词集合
  static List<String> _getOriginalWords(String originalSentenceEn){
    originalSentenceEn = originalSentenceEn.replaceAll(",", " ");
    originalSentenceEn = originalSentenceEn.replaceAll("!", " ");
    originalSentenceEn = originalSentenceEn.replaceAll("?", " ");
    originalSentenceEn = originalSentenceEn.replaceAll(".", " ");
    return originalSentenceEn.split(" ") ;
  }

  //句子小写并且除去空格
  static String toLowerCaseRemoveSpace(String text){
     String _result = "";
     if(text != null && text.length > 0){
        _result = text.toLowerCase();
        _result = _result.replaceAll(" ", "");
     }
     return _result;
  }

  //判断是不是符号
  static bool isSymbol(String str) => _symbolList.contains(str);

  //判断是不是缩写单词的'
  static bool isAbbreviationSymbol(String str) => _abbreviationList.contains(str);

  static bool containerAbbreviation(String str) => str.contains(abbreviation());

  static String abbreviation() => "’";

}