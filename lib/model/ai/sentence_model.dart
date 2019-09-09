import 'package:flutter_mvvm/utils/string_utils.dart';
import 'package:flutter_mvvm/model/ai/word_model.dart';

class SentenceModel {
  final int speakerId;
  final String sentenceEn;
  final String sentenceCn;
  final String originalSentenceEn;
  final String sentenceEnAuidio;
  final List<WordModel> words;
  final List<List<String>> answers; // 听写答案部分
  final String avatar;

  String fullAvatar;
  String nickname;

  int _position; // 记录所在位置
  bool _isReading; // 记录是否正在阅读

  String userAudio;

  int get position => _position ?? -1;

  set position(int index) => _position = index;

  bool get isReading => _isReading ?? false;

  set isReading(bool isRead) => _isReading = isRead;

  SentenceModel(
      {this.speakerId,
        this.sentenceEn,
        this.sentenceCn,
        this.originalSentenceEn,
        this.sentenceEnAuidio,
        this.userAudio,
        this.words,
        this.answers,
        this.avatar,
        this.fullAvatar,
        this.nickname});

  SentenceModel.fromJson(Map<String, dynamic> json)
      : this(
      speakerId: json["speakerId"] != null ? json["speakerId"] : -1,
      sentenceEn: json["sentenceEn"] != null ? StringUtils.trimValue(json["sentenceEn"]) : "",
      sentenceCn: json["sentenceCn"] != null ? StringUtils.trimValue(json["sentenceCn"]) : "",
      originalSentenceEn: json["originalSentenceEn"] != null
          ? StringUtils.trimValue(json["originalSentenceEn"])
          : "",
      sentenceEnAuidio: json["sentenceEnAuidio"] != null
          ? StringUtils.trimValue(json["sentenceEnAuidio"])
          : "",
      words: json["words"] != null
          ? List<WordModel>.from(json["words"]
          .map((item) => WordModel.fromJson(item))
          .toList())
          : null,
      avatar: json["avatar"] != null ? json["avatar"] : "",
      fullAvatar: json["fullAvatar"] != null ? json["fullAvatar"] : "",
      userAudio: json["userAudio"] != null ? json["userAudio"] : "",
      nickname: json["nickname"] != null ? json["nickname"] : "",
      answers:
      json["answer"] != null ? parseJsonArray(json["answer"]) : []);

  Map<String, dynamic> toJson() {
    return {
      "speakerId": speakerId,
      "sentenceEn": sentenceEn,
      "sentenceCn": sentenceCn,
      "originalSentenceEn": originalSentenceEn,
      "sentenceEnAuidio": sentenceEnAuidio,
      "position": _position,
      "isReading": _isReading,
      "avatar": avatar,
      "fullAvatar": fullAvatar,
      "nickname": nickname,
      "words": words,
      "answer": answers,
      "userAudio": userAudio,
    };
  }

  static List<List<String>> parseJsonArray(List<dynamic> jsonArray) {
    return parseJson(jsonArray);
  }

  static List<List<String>> parseJson(jsonArray) {
    List<List<String>> _doubleArray = [];
    if (jsonArray is List) {
      for (dynamic items in jsonArray) {
        if (items is List) {
          List<String> itemArray = [];
          for(dynamic item in items){
            if(item is String){
              itemArray.add(StringUtils.trimValue(item));
            }
          }
          _doubleArray.add(itemArray);
        }
      }
    }
    return _doubleArray;
  }

}