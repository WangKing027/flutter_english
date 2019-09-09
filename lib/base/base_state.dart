import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
export 'package:flutter_mvvm/provider/provider_widget.dart';
export 'package:oktoast/oktoast.dart';
import 'package:flutter_mvvm/utils/log_utils.dart';
export 'package:flutter_mvvm/base/route_page_builder.dart';
export 'package:flutter_mvvm/components/ai/widget_app_bar.dart';
export 'package:flutter_mvvm/model/event_bus_model.dart';
export 'package:flutter_mvvm/base/event_bus.dart';
import 'package:flutter_mvvm/base/audio_player_factory.dart';
export 'package:flutter_mvvm/res/index.dart';
import 'package:audioplayers/audioplayers.dart';

/// 结合MVVM模式实现的BaseState
abstract class BaseState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver{
  WidgetsBinding widgetsBinding ;
  bool _appBarVisibly = true ;
  bool _engrossedStatusBar = true ;
  bool _removeAppBar = false ;
  bool _rewriteScaffold = false ;

  /// 构建子级页面
  Widget buildPage(BuildContext context);

  /// 是否使用统一Scaffold
  set rewriteScaffold(bool rewrite) => _rewriteScaffold = rewrite ;

  ///  设置AppBar
  PreferredSizeWidget getAppBar() => null ;

  ///  设置AppBar的Visibly
  set appBarVisibly(bool visibly) => _appBarVisibly = visibly ;

  /// 设置是否支持沉侵式
  set supportFitWindowInfo(bool fit) => _engrossedStatusBar = fit;

  /// 设置将AppBar设置为null
  set removeAppBar(bool remove) => _removeAppBar = remove ;

  @override
  void initState() {
    super.initState();
    var _appBar = getAppBar();
    if(_appBar == null){
       if(_appBarVisibly){
         if(_engrossedStatusBar){
           if (Platform.isAndroid) {
             // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
             SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
             SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
             return;
           }
         }
         SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
       } else {
         SystemChrome.setEnabledSystemUIOverlays([]);
       }
    }
    widgetsBinding = WidgetsBinding.instance ;
    widgetsBinding.addObserver(this);
  }

  /*
   * 生命周期：Inactive
   */
  void appLifecycleStateInactive(){}

  /*
   * 生命周期：Paused
   */
  void appLifecycleStatePaused(){}

  /*
   * 生命周期：Resume
   */
  void appLifecycleStateResume(){}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LogUtils.m("[AppLifeState]  state = $state");
    if (state == AppLifecycleState.paused) {
      appLifecycleStatePaused();
      if(audioPlayerFactory.playState() == AudioPlayerState.PLAYING) {
        audioPlayerFactory.pauseAudio();
      }
    } else if (state == AppLifecycleState.resumed) {
      appLifecycleStateResume();
      if(audioPlayerFactory.playState() == AudioPlayerState.PAUSED) {
        audioPlayerFactory.resumeAudio();
      }
    } else if(state == AppLifecycleState.inactive){
      appLifecycleStateInactive();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _rewriteScaffold ?
    buildPage(context) :
    Scaffold(
      appBar: _removeAppBar ? null : getAppBar() ?? AppBar(title: Text("默认Bar"),),
      backgroundColor: Colors.white,
      body: buildPage(context),
    );
  }

}