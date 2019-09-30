
/// 模块化数据
/// 1.包括词句学习，句子学习、单词学习、考核句子、听写、等部分
/// 2.在处理数据阶段定好页面类型
class ModuleModel <T>{
  final PageModuleType type ;
  final String audio ;
  final int evaluationTime ;
  T data ;

  ModuleModel({
    this.type,
    this.data,
    this.audio,
    this.evaluationTime = -1,
  });

  int _time ;
  set time(int time) => _time = time ;
  get time => _time != null ? _time : evaluationTime ;

  String _recordAudio ;
  set recordAudio(String path) => _recordAudio = path ;
  get recordAudio => _recordAudio == null ? "" : _recordAudio ;
}

enum PageModuleType {
  PageSentence,// 句子学习页面
  PageWord,// 单词学习页面
  PageAssess // 考核页面
}