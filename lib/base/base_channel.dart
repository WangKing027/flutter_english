import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm/res/app_config.dart';
import 'package:flutter_mvvm/utils/log_utils.dart';

var eventChannel =  _EventChannelFactory();
var methodChannel = _MethodChannelFactory();

class BaseChannel {

  StreamSubscription eventSubscription;

  // 注册Event事件监听
  void registerEventChannel() => eventSubscription = eventChannel.channel.receiveBroadcastStream().listen(onEventListener, onError: onEventError);

  void onEventListener(event) => LogUtils.d(tag: "onEventListener",msg: "$event");

  void onEventError(error) => LogUtils.d(tag: "onEventError",msg: "$error");

  // 注册Method事件监听
  void registerMethodChannel() => methodChannel.channel.setMethodCallHandler(onPlatformCallHandler);

  // native call flutter
  Future<dynamic> onPlatformCallHandler(MethodCall call) async {
    String methodName = call?.method ?? "";
    return Future.value(methodName);
  }

  // 销毁Event事件流
  void disposeSubscription() => eventSubscription?.cancel();

}


// EventChannel
class _EventChannelFactory {

  EventChannel _eventChannel ;

  static _EventChannelFactory _instance ;

  factory _EventChannelFactory() => _getInstance();

  static _EventChannelFactory _getInstance(){
    if(_instance == null){
      _instance = new _EventChannelFactory._internal();
    }
    return _instance ;
  }

  _EventChannelFactory._internal(){
    _eventChannel = new EventChannel(AppConfig.EVENT_CHANNEL);
  }

  EventChannel get channel => _eventChannel ?? new EventChannel(AppConfig.EVENT_CHANNEL);

}

// MethodChannel
class _MethodChannelFactory {

  MethodChannel _methodPlatform;

  static _MethodChannelFactory _instance;

  factory _MethodChannelFactory() => _getInstance();

  static _MethodChannelFactory get instance => _getInstance();

  static _MethodChannelFactory _getInstance() {
    if (_instance == null) {
      _instance = new _MethodChannelFactory._internal();
    }
    return _instance;
  }

  _MethodChannelFactory._internal() {
    _methodPlatform = new MethodChannel(AppConfig.METHOD_CHANNEL);
  }

  MethodChannel get channel => _methodPlatform ?? new MethodChannel(AppConfig.METHOD_CHANNEL);
}