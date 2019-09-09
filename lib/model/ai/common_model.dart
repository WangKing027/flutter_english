import 'package:flutter_mvvm/model/ai/dictation_model.dart';
import 'package:flutter_mvvm/model/ai/sentence_model.dart';
import 'package:flutter_mvvm/model/ai/word_model.dart';
import 'package:flutter_mvvm/utils/string_utils.dart';

class CommonModel{

  final String image ;
  final int unitNum;               // 单元
  final String unitTitle;          // 标题

  List<SentenceModel> sentences;
  List<WordModel> words ;
  DictationModel dictations ;  // 听写的Model

  String _fullRelativePath ;// 资源完整路径

  String get fullRelativePath => _fullRelativePath ?? "";

  set fullRelativePath(String path) => _fullRelativePath = path ;

  CommonModel({
    this.image,
    this.sentences,
    this.words,
    this.unitNum,
    this.unitTitle,
    this.dictations,
  });

  CommonModel.fromJson(Map<String, dynamic> json)
      : this(
      unitNum: json["unitNum"] != null ? StringUtils.trimValue(json["unitNum"]) : -1,
      unitTitle: json["unitTitle"] != null ? StringUtils.trimValue(json["unitTitle"]) : "",
      image: json["image"] != null ? json["image"] : "",
      sentences: json["sentences"] != null
          ? List<SentenceModel>.from(json["sentences"]
          .map((item) => SentenceModel.fromJson(item))
          .toList())
          : null,
      words:json["words"] != null ? List<WordModel>.from(json["words"].map((item) => WordModel.fromJson(item)).toList()) : null
  );

  Map<String, dynamic> toJson() {
    return {
      "image": image,
      "unitNum": unitNum,
      "unitTitle": unitTitle,
      "sentences": sentences,
      "fullRelativePath":_fullRelativePath,
      "words":words
    };
  }

}