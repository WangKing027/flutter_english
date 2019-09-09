import 'package:flutter/material.dart';

class WordStyleModel {
  final String word ;
  final Color color ;
  final TextDecoration decoration;
  final TextDecorationStyle decorationStyle;
  final dynamic data ;

  WordStyleModel({this.word,this.color,this.data,this.decoration,this.decorationStyle});

}

/// 原生返回的数据
class NativeRecordResult {
  final double pronAccuracy ;     //发音精准度，取值范围[-1, 100]，当取-1时指完全不匹配
  final double pronFluency ;      //发音流利度，取值范围[0, 1]，当为词模式时，取值无意义
  final double pronCompletion ;   //发音完整度，取值范围[0, 1]，当为词模式时，取值无意义
  final String audioUrl ;
  final List<EvaluationWord> words ;

  NativeRecordResult({
    this.pronAccuracy,
    this.pronFluency,
    this.pronCompletion,
    this.audioUrl,
    this.words
  });

  NativeRecordResult.fromJson(Map<dynamic,dynamic> json):this(
    pronFluency : json["pronFluency"] !=null ? json["pronFluency"] : -2.0,
    pronAccuracy : json["pronAccuracy"] != null ? json["pronAccuracy"] : -1.0,
    pronCompletion : json["pronCompletion"] != null ? json["pronCompletion"] :-1.0,
    audioUrl : json["audioUrl"] != null ? json["audioUrl"] : "",
    words : json["words"] != null ? List<EvaluationWord>.from(json["words"].map((item) => EvaluationWord.fromJson(item)).toList()) : [],
  );

  Map<String,dynamic> toJson(){
    return {
      "pronFluency":pronFluency,
      "pronAccuracy":pronAccuracy,
      "pronCompletion":pronCompletion,
      "audioUrl":audioUrl,
      "words":words,
    };
  }
}


class EvaluationWord {
  final int beginTime ;             // 当前单词语音起始时间点，单位为ms
  final int endTime ;               // 当前单词语音终止时间点，单位为ms
  final double pronAccuracy ;       // 单词发音准确度，取值范围[-1, 100]，当取-1时指完全不匹配
  final double pronFluency ;        // 单词发音流利度，取值范围[0, 1]
  final String word ;               // 当前词
  final int matchTag ;              // 当前词与输入语句的匹配情况，0：匹配单词、1：新增单词、2：缺少单词

  EvaluationWord({this.beginTime,this.endTime,this.pronAccuracy,this.pronFluency,this.word,this.matchTag});

  EvaluationWord.fromJson(Map<dynamic,dynamic> json):this(
    beginTime : json["beginTime"] != null ? json["beginTime"] : 0,
    endTime : json["endTime"] != null ? json["endTime"] : 0,
    pronFluency : json["pronFluency"] != null ? json["pronFluency"] : 0.0,
    pronAccuracy : json["pronAccuracy"] != null ? json["pronAccuracy"] : 0.0,
    word : json["word"] != null ? json["word"] : "",
    matchTag : json["matchTag"] != null ? json["matchTag"] : 0.0,
  );

  Map<String, dynamic> toJson(){
    return {
      "beginTime":beginTime,
      "endTime":endTime,
      "pronFluency":pronFluency,
      "pronAccuracy":pronAccuracy,
      "word":word,
      "matchTag":matchTag
    };
  }

}