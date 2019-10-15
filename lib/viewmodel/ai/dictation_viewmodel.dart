import 'package:flutter_mvvm/base/audio_player_factory.dart';
import 'package:flutter_mvvm/model/ai/common_model.dart';
import 'package:flutter_mvvm/model/ai/sentence_model.dart';
import 'package:flutter_mvvm/provider/view_state_obj_model.dart';
import 'package:flutter_mvvm/ui/page/ai/intensive_learning.dart';
import 'package:flutter_mvvm/base/route_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/components/ai/shared/pause_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_mvvm/utils/log_utils.dart';
import 'package:flutter_mvvm/utils/time_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_mvvm/components/ai/part/dictation_gap_part.dart';
import 'dart:convert';
import 'dart:async';


class DictationViewModel extends ViewStateObjModel<CommonModel>{

  BuildContext _context ;
  int _maxProgress = 0 , _curProgress = 0 ;
  PageController _pageController = PageController() ;
  List<DictationGapPart> _gapPartList = [];
  bool _playVisibly = true ;
  SentenceModel _delayModel ;
  List<SentenceModel> _sentenceList ;
  Timer _timer ;
  CommonModel _wrongCommonModel ; // 作听写错误的集合

  // 自定义初始化方法
  initModelData(BuildContext context) async {
    // 重写initializeData的方法,进行事件的EventChannel/MethodChannel的注册
    _context = context ;
    setLoading(loading: false);
    data = await loadData();
    _sentenceList = data.sentences ?? [];
    _parseGapPartPage();
    // 初始化错题集合
    _wrongCommonModel = CommonModel();
    _wrongCommonModel.sentences = [] ;

    _maxProgress = _sentenceList.length ;
    _curProgress = 0 ;
    notifyListeners();

    // 播放音频
    playZipAudio(_sentenceList[_curProgress].sentenceEnAuidio);
  }

  @override
  Future<CommonModel> loadData() async {
    String value = await DefaultAssetBundle.of(_context).loadString("assets/zip/dictation.json");
    List _json = json.decode(value);
    LogUtils.d(tag: "loadData",msg: "$_json");
    List<SentenceModel> sentences = _json.map((item) => SentenceModel.fromJson(item)).toList();
    var _commModel = CommonModel(sentences: sentences);
    return Future.value(_commModel);
  }

  // 解析数据生成听写子页面
  void _parseGapPartPage(){
     if(null != _sentenceList && _sentenceList.isNotEmpty){
        for(SentenceModel sentence in _sentenceList){
            _gapPartList.add(DictationGapPart(
              dictationModel: sentence,
              sentenceList: List<SentenceModel>(),
              audioCallBack: audioCallBack,
              btnCallBack: btnCallBack,
              gifCallBack: gifCallBack,
            ),);
        }
     }
  }

  @override
  void dispose() {
    _disposeTimer();
    _pageController?.dispose();
    super.dispose();
  }

  // play button visibly
  bool getPlayVisibly() => _playVisibly ;

  // 播放句子
  void audioCallBack(startDelay,sentence){
    if(sentence is SentenceModel){
      _delayModel = sentence ;
    } else {
      _delayModel = null ;
    }
    playZipAudio(_sentenceList[_curProgress].sentenceEnAuidio,startDelay: startDelay);

  }

  // 按钮回调
  void btnCallBack(sentence){
    _disposeTimer();
    if(null != sentence && sentence is SentenceModel){
      _wrongCommonModel.sentences.add(sentence);
    }
    if(_curProgress >= _maxProgress - 1){
      if(_wrongCommonModel.sentences.isNotEmpty){ // 有听写错误
         audioPlayerFactory.stopAudio().then((val){
           MyRouteFactory.pushReplaceFade(
             context: _context,
             page: IntensiveLearning(model: _wrongCommonModel,),
           );
         });
      } else { // 无听写错误

      }
    } else { // 正常切换页面
      _animToPage();
    }
  }

  // Gif是否Visible
  void gifCallBack(showGif){
     _playVisibly = !showGif ;
     notifyListeners();
  }

  @override
  int getMaxProgress() => _maxProgress ;

  @override
  int getCurProgress() => _curProgress ;

  @override
  void onPausePressed() async {
    debugPrint("[onPausePressed] --- 暂停");
    bool _playing = false ;
    if(audioPlayerFactory.playState() == AudioPlayerState.PLAYING){
      _playing = true ;
      bool _result = await audioPlayerFactory.pauseAudio();
      if(_result){
        _playVisibly = true ;
        notifyListeners();
      }
    }
    showDialog(
      context: _context,
      builder: (BuildContext context) => PausePage(),
    ).then((item){
      if(item == PausePageAction.again){// 再来一次
        showToast("重来");
        MyRouteFactory.pushReplaceFade(context: _context,page: IntensiveLearning());
      } else if(item == PausePageAction.continueLearning){// 继续
        showToast("继续");
        if(_playing){
          audioPlayerFactory.resumeAudio();
        }
      } else { // 退出
        showToast("退出");
        audioPlayerFactory.stopAudio().then((val){
          Navigator.of(_context).pop();
        });
      }
    });
  }

  PageController getPageController() => _pageController ;

  Widget getCurChildPageWidget(int index) => _gapPartList[index];

  // 播放按钮点击
  void onPlayPressed(val){
    _disposeTimer();
    playZipAudio(_sentenceList[_curProgress].sentenceEnAuidio);
  }

  // 播放zip文件夹内的音频
  void playZipAudio(String audioName , {bool startDelay = false }){
      audioPlayerFactory.playAssetAudio(
          assetAudio: "$audioName",
          prefix: "zip/",
          listenPlayCompletion: (){
             if(startDelay){
               _startDelayPlay();
             }
          }
      );
  }

  // 滑动到下一页
  void _animToPage(){
    if (_curProgress <= _maxProgress - 1) {
        _curProgress += 1 ;
    }
    LogUtils.m("[animatedToPage]: ---currentProgress = $_curProgress ,--maxProgress = $_maxProgress");
    if (_curProgress >= 0 && _curProgress <= _maxProgress - 1) {
      _pageController.animateToPage(_curProgress, duration: Duration(milliseconds: 300), curve: Curves.ease).then((val) {
         playZipAudio(_sentenceList[_curProgress].sentenceEnAuidio);
      });
    }
  }

  // 开始延迟1s 调转
  void _startDelayPlay() {
    _timer = TimeUtils.startTime(startText: 1, callBack: () {
       btnCallBack(_delayModel);
    });
  }

  // 销毁定时器
  void _disposeTimer() {
    _delayModel = null ;
    _timer?.cancel();
  }

}