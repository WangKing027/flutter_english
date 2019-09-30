import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'log_utils.dart';

class FileUtils {

  // sd卡目录
  static Future<String> getSdCardRootPath() async {
    try {
      String sdCardRootPath = (await getExternalStorageDirectory()).path;
      return sdCardRootPath;
    } catch (err) {
      LogUtils.m("getSdCardRootPath (error) sd卡目录: $err");
    }
    return null;
  }

  // 临时目录
  static Future<String> getCacheRootPath() async {
    try {
      String cacheRootPath = (await getTemporaryDirectory()).path;
      return cacheRootPath;
    } catch (err) {
      LogUtils.m("getCacheRootPath (error) 临时目录: $err");
    }
    return null;
  }

  // 文档目录
  static Future<String> getAppDataRootPath() async {
    try {
      String appDataRootPath = (await getApplicationDocumentsDirectory()).path;
      return appDataRootPath;
    } catch (err) {
      LogUtils.m("getAppDataRootPath (error) 文档目录: $err");
    }
    return null;
  }

  static File _getFileFromPath(String path)=> File(path);

  // 读取Json
  static Future<dynamic> readJSON(String path) async {
    try {
      final File file = _getFileFromPath(path);
      String str = await file.readAsString();
      return json.decode(str);
    } catch (err) {
      LogUtils.m("readJSON (error) 读取Json: $err , path = $path");
    }
  }

  // 写入Json
  static writeJSON(Object obj) async {
    try {
      final String path = await getCacheRootPath();
      File file = new File(path);
      return file.writeAsString(json.encode(obj));
    } catch (err) {
      LogUtils.m("writeJSON (error) 写入Json: $err , obj = $obj");
    }
  }

  // 创建指定文件夹
  static Future<File> createFile(String path) async {
    try{
      File file = _getFileFromPath(path);
      bool exists = await file.exists();
      if(exists){
         return Future.value(file) ;
      }
      return Future.value(file);
    } catch(err){
      LogUtils.m("createFile (error) 创建指定文件夹: $err , path = $path");
      return Future.value(null);
    }
  }

}
