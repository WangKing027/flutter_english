import 'package:flutter_mvvm/base/route_factory.dart';
import 'package:flutter_mvvm/ui/page/ai/intensive_learning.dart';
import 'package:flutter_mvvm/components/ai/shared/pause_dialog.dart';
import 'package:flutter_mvvm/provider/view_state_obj_model.dart';
import 'package:flutter_mvvm/base/audio_player_factory.dart';
import 'package:flutter_mvvm/model/ai/sentence_model.dart';
import 'package:flutter_mvvm/model/ai/common_model.dart';
import 'package:flutter_mvvm/base/route_page_builder.dart';
import 'package:flutter_mvvm/ui/page/ai/dialogue_preview.dart';
import 'package:flutter_mvvm/base/base_channel.dart';
import 'package:flutter_mvvm/utils/log_utils.dart';
import 'package:flutter_mvvm/utils/time_utils.dart';
import 'package:flutter_mvvm/res/strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:convert';
import 'dart:async';

/*
 * DialogueViewModel层
 * 逻辑和事件处理
 */
class DialogueViewModel extends ViewStateObjModel<CommonModel> with BaseChannel{
  BottomState _bottomState = BottomState.BottomNav ;
  bool _bottomNavLeftVisibly = true ,
       _bottomNavRightVisibly = true ,
       _bottomNavGifVisibly = false ,
       _rippleClickable = true ,
       _itemClickable = true ;
  int _maxProgress = 0 , _curProgress = 0 ;
  String _rippleNotice = Strings.string_click_wave_stop_record;
  List<SentenceModel> _sentenceList = [];
  BuildContext _context ;
  Timer _timer ;

  // 自定义初始化方法
  initModelData(BuildContext context) async {
    // 重写initializeData的方法,进行事件的EventChannel/MethodChannel的注册
    // eventChannel 此时可以直接调用eventChannel发送event
    // methodChannel 直接调用methodChannel调用native方法
    registerEventChannel();
    registerMethodChannel();

    _context = context ;
    setLoading(loading: false);
    data = await loadData();
    _maxProgress = data.sentences.length ;
    _curProgress = 0 ;
    // 按次数添加音频个数,首次添加一个
    _addModelToList();
  }

  @override
  void dispose() {
    _stopCountDown();
    disposeSubscription();
    // 此时不可dispose，只有退出整个app的时候dispose audioPlayer
    // audioPlayerFactory.dispose();
    super.dispose();
  }

  @override
  Future<CommonModel> loadData() async {
    String value = await DefaultAssetBundle.of(_context).loadString("assets/zip/dialogue.json");
    var _json = json.decode(value);
    LogUtils.d(tag: "loadData",msg: "$_json");
    var _commModel = CommonModel.fromJson(_json);
    return Future.value(_commModel);
  }

  // 监听event事件流
  @override
  void onEventListener(event) {
    super.onEventListener(event);
  }

  // 监听native call flutter
  @override
  Future<dynamic> onPlatformCallHandler(MethodCall call) async {
    return super.onPlatformCallHandler(call);
  }

  // 点击暂停
  @override
  void onPausePressed() async {
    debugPrint("[onPausePressed] --- 暂停");
    bool _playing = false ;
    _stopCountDown();
    if(audioPlayerFactory.playState() == AudioPlayerState.PLAYING){
       _playing = true ;
       bool _result = await audioPlayerFactory.pauseAudio();
       if(_result){
          _bottomNavGifVisibly = false ;
          notifyListeners();
       }
    }
    showDialog(
      context: _context,
      builder: (BuildContext context) => PausePage(),
    ).then((item){
      if(item == PausePageAction.again){// 再来一次
        showToast("重来");
        MyRouteFactory.pushReplaceFade(context: _context, page: DialoguePreview());
      } else if(item == PausePageAction.continueLearning){// 继续
        showToast("继续");
        if(_playing){
           audioPlayerFactory.resumeAudio();
        } else {
          if(_sentenceList.length < data.sentences.length){
             _startCountDown();
          }
        }
      } else { // 退出
        showToast("退出");
        audioPlayerFactory.stopAudio().then((val){
          Navigator.of(_context).pop();
        });
      }
    });
  }

  @override
  int getMaxProgress() => _maxProgress ;

  @override
  int getCurProgress() => _curProgress + 1;

  // 获取句子集合的数据
  List<SentenceModel> getSentenceList() => _sentenceList ;

  // item是否可点击
  bool isClickable() => _itemClickable ;

  // 设置item为正常状态
  void _initChatItemIsNormal(){
    for(SentenceModel model in _sentenceList){
      if(model.isReading){
        model.isReading = false ;
      }
    }
  }

  // item点击事件
  void onChatItemPressed(int index){
     _initChatItemIsNormal();
     _sentenceList[index].isReading = true ;
     _curProgress = index ;
     _playSentenceAudio(fileName: "${_sentenceList[_curProgress].sentenceEnAuidio}");
  }

  //获取底部状态
  BottomState getBottomState() => _bottomState;

  //点击底部导航
  void onBottomNavPressed(type){
    debugPrint("[onBottomNavPressed] --- type: $type");
    _stopCountDown();
    switch(type){
      case Strings.string_tag_previous:
        _curProgress -= 1 ;
        if(_curProgress < 0){
           _curProgress = 0 ;
        }
        onChatItemPressed(_curProgress);

        break;
      case Strings.string_tag_sound:
        _playSentenceAudio(fileName:"${_sentenceList[_curProgress].sentenceEnAuidio}");

        break;
      case Strings.string_tag_record:
        _bottomState = BottomState.RecordRipple;
        _rippleNotice = Strings.string_click_wave_stop_record ;
        notifyListeners();
        audioPlayerFactory.playAssetAudio(assetAudio: "record_down.wav",prefix: "audio/");

        break;
      case Strings.string_tag_next:
        _curProgress += 1 ;
        if(_curProgress > _maxProgress){
           _curProgress = _maxProgress;
        }
        if(_curProgress == _maxProgress){
          MyRouteFactory.pushReplaceFade(context: _context,page: IntensiveLearning());
        } else {
          _addModelToList();
        }
       
        break;
    }
  }

  // 左边导航
  bool bottomNavLeftVisibly() => _bottomNavLeftVisibly ;

  // 右边导航
  bool bottomNavRightVisibly() => _bottomNavRightVisibly ;

  // 底部gif显示
  bool bottomNavGifVisibly() => _bottomNavGifVisibly ;

  // 点击水波纹
  void onRipplePressed(){
    _rippleNotice = Strings.string_click_wave_audio_parse ;
    _rippleClickable = false ;
    audioPlayerFactory.playAssetAudio(assetAudio: "record_up.wav",prefix: "audio/");
    notifyListeners();
    // 模拟打分操作
    Future.delayed(Duration(milliseconds: 4000),(){
       _rippleClickable = true ;
       _bottomState = BottomState.BottomNav ;
       notifyListeners();
       showToast("Greate!");
    });
  }

  // 水波纹是否可点击
  bool getRippleClickable() => _rippleClickable;

  // 水波纹上方文案
  String getRippleNotice() => _rippleNotice ;

  // 播放句子音频
  void _playSentenceAudio({String fileName}) async {
    _bottomNavGifVisibly = true;
    notifyListeners();
    bool _result = await audioPlayerFactory.playAssetAudio(
        assetAudio: "${_sentenceList[_curProgress].sentenceEnAuidio}",
        prefix: "zip/",
        listenPlayCompletion: (){
          _bottomNavGifVisibly = false ;
          notifyListeners();
          if(_sentenceList.length < data.sentences.length){
             _startCountDown();
          } else {
            _stopCountDown();
          }
        }
    );
    if(!_result){
       _bottomNavGifVisibly = false ;
       notifyListeners();
    }
  }

  // 倒计时3s 音频播放
  void _startCountDown(){
    _timer = TimeUtils.startTime(startText: 3,endText: 1,callBack:(){
        onBottomNavPressed(Strings.string_tag_next);
     });
  }

  // 停止循环音频播放
  void _stopCountDown() => _timer?.cancel();

  // 添加单句子对象到列表中
  void _addModelToList(){
    if(_curProgress <= _sentenceList.length - 1){
      onChatItemPressed(_curProgress);
      return;
    }
    SentenceModel _model = data.sentences[_curProgress];
    if(_sentenceList.length < data.sentences.length){
      _initChatItemIsNormal();
      _model.isReading = true ;
      _sentenceList.add(_model);
    }
    _playSentenceAudio(fileName: "${_model.sentenceEnAuidio}");
  }

}

enum BottomState{
  BottomNav, //底部导航
  RecordRipple,//录音水波纹
  EmptyView, // 空白
}