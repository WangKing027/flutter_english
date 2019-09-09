import 'package:flutter_mvvm/model/ai/word_option_model.dart';
import 'package:flutter_mvvm/utils/string_utils.dart';

class WordModel {
  final String wordEn;
  final String wordCn;
  final String wordPh;
  final String wordImg;
  final String wordAudio;
  final List<WordOptionModel> options;

  String _wordImgUrl ; // 单词学习配图完整路径
  String get wordImgUrl => _wordImgUrl ?? "";
  set wordImgUrl(String imgUrl) => _wordImgUrl = imgUrl ;

  WordModel.fromJson(Map json)
      : wordEn = StringUtils.trimValue(json['wordEn']),
        wordCn = StringUtils.trimValue(json['wordCn']),
        wordPh = StringUtils.trimValue(json['wordPh']),
        wordImg = StringUtils.trimValue(json['wordImg']),
        wordAudio = StringUtils.trimValue(json['wordAudio']),
        options = json['options'] != null ? List<WordOptionModel>.from(json['options'].map((item) => WordOptionModel.fromJson(item)).toList()) : null ;

  Map<String,dynamic> toJson(){
    return {
      "wordEn":wordEn,
      "wordCn":wordCn,
      "wordPh":wordPh,
      "wordImg":wordImg,
      "wordAudio":wordAudio,
      "wordImgUrl":wordImgUrl,
      "options":options
    };
  }

}