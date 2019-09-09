import 'package:flutter_mvvm/model/ai/word_style_model.dart';
import 'package:flutter/material.dart';

class EventProgress {// 进度条-事件
   dynamic data ;
   @required int progress ;    // 当前进度
   EventProgress({this.data,this.progress = 0});
}

// 音频状态-事件
class EventAudioPlayerState {
  String state ;            // 音频状态
  EventAudioPlayerState({this.state});
}

// 头像渐变-事件
class EventAvatar{
  dynamic state ;
  bool change ;         // true : 开启动画 false: 关闭动画
  EventAvatar({this.state,this.change});
}

// 词句学习-事件
class EventSentenceLearn{
  bool showGifVoice ;                   //是否显示Gif
  bool showScore ;                      //是否隐藏成绩
  bool voiceVisibly;                    //是否隐藏喇叭
  double score ;                        //分数
  @required int position ;              //在pageList中的位置
  int time ;                            //播放次数
  List<WordStyleModel> data ;           //单词成绩数据
  EventSentenceLearn({this.showGifVoice = false ,this.position,this.data,this.score = 0.0,this.time = -1,this.voiceVisibly = true,this.showScore = false});
}

//// 录音音频解析中-事情(禁止点击)
//class EventRecord {
//  bool clickable ;
//  dynamic data ;
//  EventRecord({this.clickable = true ,this.data});
//}

// 是否可点击
class EventClick {
  bool clickable ;
  dynamic data ;
  EventClick({this.clickable = true ,this.data});
}

class EventBottomAnimationIndex {
  int index ;
  dynamic data ;
  EventBottomAnimationIndex({this.index,this.data});
}
