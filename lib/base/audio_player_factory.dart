import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm/utils/log_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:async';
import 'dart:io';

// 实例化单例对象供外部调用
var audioPlayerFactory = _AudioPlayerFactory();

class _AudioPlayerFactory {

  AudioPlayer _audioPlayer;
  AudioCache _audioCache;
  Function _audioPlayStateListener ;
  StreamSubscription _subscription ;
  StreamSubscription _errorSubscription ;

  static _AudioPlayerFactory _instance ;
  static _AudioPlayerFactory get instance => _instance ;
  factory _AudioPlayerFactory() => _getInstance();
  static _AudioPlayerFactory _getInstance(){
     if(_instance == null){
        _instance = _AudioPlayerFactory._internal();
     }
     return _instance;
  }

  _AudioPlayerFactory._internal(){
     _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
     // AudioPlayer.logEnabled = true; // 开启AudioPlayer的Log打印
     _audioPlayer.setReleaseMode(ReleaseMode.RELEASE);
     _errorSubscription = _audioPlayer.onPlayerError.listen(_onErrorListener);
     _audioCache = AudioCache(fixedPlayer: _audioPlayer);
  }

  void _onErrorListener(error) => LogUtils.d(tag: "PlayerError",msg: "$error");

  void _onPlayStateListener(state) => _audioPlayStateListener(state);

  AudioPlayerState playState () => _audioPlayer?.state ;

  // 播放音频 isLocal = true , path = filePath , isLocal = false ,path = Https
  Future<bool> playAudio({@required String path,Function listenPlayState ,bool isLocal = true}) async {
     if(_audioPlayer == null){
       showToast("AudioPlayer为空~");
       return Future.value(false);
     }
     if(playState() == AudioPlayerState.PLAYING){
        await _audioPlayer.stop();
     }
     if(path.isEmpty){
        showToast("播放音频路径不可为空");
        return Future.value(false);
     }
     if(!isLocal){
        if(!path.startsWith("http") || !path.startsWith("https")){
           showToast("音频路径必须为RemoteUrl");
           return Future.value(false);
        }
     } else {
       File file = File(path);
       bool exist = await file.exists();
       if(!exist){
         showToast("音频路径不存在");
         return Future.value(false);
       }
     }

     _subscription?.cancel();
     if(listenPlayState != null){
       _subscription = _audioPlayer.onPlayerStateChanged.listen(_onPlayStateListener);
       _audioPlayStateListener = listenPlayState ;
     }

     int _result = await _audioPlayer.play(path,isLocal: isLocal);
     return Future.value(_result == 1);
  }

  // 播放assets音频资源，prefix assets一级目录，assetsAudio 音频资源名带后缀
  Future<bool> playAssetAudio({@required String assetAudio , String prefix  = "", Function listenPlayCompletion}) async {
     if(assetAudio.isEmpty){
        showToast("音频资源文件名为空");
        return Future.value(false);
     }
     if(_audioCache == null){
        showToast("AudioCache为空~");
        return Future.value(false);
     }

     _subscription?.cancel();
     _subscription = _audioPlayer.onPlayerCompletion.listen((state){
        if(listenPlayCompletion != null){
           listenPlayCompletion();
        }
     });
     if(prefix.isNotEmpty && !prefix.endsWith("/")){
        prefix = "$prefix/";
     }
     String fileName = "$prefix$assetAudio";
     debugPrint("[playAssetAudio]:    fileName = $fileName");
     await _audioCache.play(fileName);
     return Future.value(true);
  }

  Future<bool> stopAudio() async {
     int _result = await _audioPlayer.stop();
     return Future.value(_result == 1);
  }

  Future<bool> pauseAudio() async {
     int _result = await _audioPlayer.pause();
     return Future.value(_result == 1);
  }

  Future<bool> resumeAudio() async {
     int _result = await _audioPlayer.resume();
     return Future.value(_result == 1);
  }

  Future<bool> dispose() async {
     _subscription?.cancel();
     _errorSubscription?.cancel();
     _audioCache?.clearCache();
     if(playState() == AudioPlayerState.PLAYING){
        await stopAudio();
     }
     await _audioPlayer.release();
     await _audioPlayer.dispose();
     return Future.value(true);
  }

}