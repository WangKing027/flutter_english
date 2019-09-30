import 'package:audio_recorder/audio_recorder.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_mvvm/utils/time_utils.dart';
import 'package:flutter_mvvm/utils/file_utils.dart';
import 'package:flutter_mvvm/utils/log_utils.dart';
import 'package:simple_permissions/simple_permissions.dart';


// 实例化单例对象供外部调用
var audioRecorderFactory = _AudioRecorderFactory();

class _AudioRecorderFactory {
  String _path ;

  static _AudioRecorderFactory _instance ;
  static _AudioRecorderFactory getInstance(){
    if(_instance == null){
       _instance = _AudioRecorderFactory._internal();
    }
    return _instance ;
  }
  factory _AudioRecorderFactory() => getInstance();

  _AudioRecorderFactory._internal(){
     _path = "";
  }

  Future<String> startRecord() async {
     bool hasPermissions = await checkPermission();
     LogUtils.m("[startRecord] --- hasPermissions: $hasPermissions");
     try{
       if(hasPermissions){
         var _time = TimeUtils.getCurrentMilliseconds();
         if(_path.isEmpty){
           _path = await FileUtils.getCacheRootPath();
         }
         String _audioPath = "$_path/$_time";
         await AudioRecorder.start(path: _audioPath,audioOutputFormat: AudioOutputFormat.AAC);
         bool _isRecording = await AudioRecorder.isRecording;
         LogUtils.m("[startRecord] --- isRecording: $_isRecording , audioPath: $_audioPath");
         return Future.value(_audioPath);
       } else {
         bool _result = await requestPermission();
         if(!_result){
            showToast("尚未设置录音权限，请去赋予权限~");
         }
         return Future.value("");
       }
     } on Exception catch(e){
       LogUtils.m("[startRecord] ---> ${e.toString()}");
       return Future.value("");
     }
  }

  Future<String> stopRecord() async {
    bool _isRecording = await AudioRecorder.isRecording;
    Recording _recording = await AudioRecorder.stop();
    LogUtils.m("[stopRecord] --- isRecording: $_isRecording ,audioPath: ${_recording.path}");
    return Future.value(_recording.path);
  }

  Future<bool> checkPermission() async {
     bool hasRead = await SimplePermissions.checkPermission(Permission.ReadExternalStorage);
     if(hasRead){
        bool hasRecord = await SimplePermissions.checkPermission(Permission.RecordAudio);
        if(hasRecord){
           return Future.value(true);
        }
     } else {
       bool granted = await requestPermission();
       if(!granted){
          SimplePermissions.openSettings();
       }
     }
     return Future.value(false);
  }

  Future<bool> requestPermission() async {
     // List<Permission> _permissions = [Permission.RecordAudio,Permission.ReadExternalStorage];
     var result = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
     if(result == PermissionStatus.authorized){
        var _res = await SimplePermissions.requestPermission(Permission.RecordAudio);
        if(_res == PermissionStatus.authorized){
           return Future.value(true);
        }
     }
     return Future.value(false);
  }

}