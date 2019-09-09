import 'package:flutter_mvvm/model/ai/sentence_model.dart';

class DictationModel {

  final List<SentenceModel> dictation;
  final List<SentenceModel> wordLearn;

  DictationModel({this.dictation,this.wordLearn});

  DictationModel.fromJson(Map<String,dynamic> json):this(
    dictation : json["dictation"] != null ? List<SentenceModel>.from(json["dictation"].map((item) => SentenceModel.fromJson(item)).toList()) : [],
    wordLearn : json["wordLearn"] != null ? List<SentenceModel>.from(json["wordLearn"].map((item) => SentenceModel.fromJson(item)).toList()) : [],
  );

  Map<String,dynamic> toJson(){
    return {
      "wordLearn":wordLearn,
      "dictation":wordLearn
    };
  }

}