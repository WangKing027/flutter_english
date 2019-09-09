export 'package:flutter_mvvm/model/event_bus_model.dart';

//定义一个top-level变量，页面引入该文件后可以直接使用bus
var eventBus = new EventBus();

typedef void EventCallBack(arg);

class EventBus {

  EventBus._internal();

  static EventBus _singleton = new EventBus._internal();

  factory EventBus() => _singleton ;

  var _eMap = new Map<Object,List<EventCallBack>>();

  void on(eventName,EventCallBack f){
    if(eventName == null || f == null) return ;
    _eMap[eventName] ??= new List<EventCallBack>();
    _eMap[eventName].add(f);
  }

  void off(eventName,[EventCallBack f]){
    var _list = _eMap[eventName];
    if(eventName == null || _list == null) return ;
    if(f == null){
      _eMap[eventName] = null ;
    } else {
      _list.remove(f);
    }
  }

  void fire(eventName,arg){
    var _list = _eMap[eventName];
    if (_list == null) return;
    int len = _list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      _list[i](arg);
    }
  }
}

enum EventType{
  Progress,// 进度条事件
  Sentence, // 句子事件
  Avatar, // 头像事件
  WordMatch, // 单词匹配事件
  WordSentenceLearnAssess, // 词句学习考核部分事件
  ItemClick,// item 点击事件
  BottomAnimationIndex,
}