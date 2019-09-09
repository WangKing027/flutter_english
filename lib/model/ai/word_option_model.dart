import 'package:flutter_mvvm/utils/string_utils.dart';

class WordOptionModel {

  final String content;
  final bool isRight;

  bool _clickRight ; // 记录操作结果
  int _position ; //  记录操作位置

  bool get clickRight => _clickRight ?? false ;

  set clickRight(bool right) => _clickRight = right ;

  int get position => _position ?? -1;

  set position(int index) => _position = index ;

  WordOptionModel({
    this.content,
    this.isRight,
  });

  WordOptionModel.fromJson(Map<String,dynamic> json) : this(
    content: StringUtils.trimValue(json['content']),
    isRight: json['isRight'],
  );

  Map<String,dynamic> toJson(){
    return {
      'content':content,
      'isRight':isRight,
      'clickRight':_clickRight,
      'position':_position
    };
  }

}