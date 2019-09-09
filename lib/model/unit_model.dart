class UnitModel {

  final String unitName ;
  final String unitTitle ;
  final int type ; // 0: 中考词汇 1: 高考词汇 2: 商务口语 3: 生活口语
  final double score ;
  final int state ; // 0: 未解锁 1: 继续 2: 完成
  final int level ;
  final String partName ;
  final String partDec ;

  UnitModel({
    this.unitName,
    this.unitTitle,
    this.score,
    this.state,
    this.type,
    this.level,
    this.partName,
    this.partDec,
  });

  UnitModel.fromJson(Map<String,dynamic> json) : this(
    unitTitle:json["unitTitle"] ?? "",
    unitName:json["unitName"] ?? "",
    score:json["score"] ?? 0.0,
    state:json["state"] ?? -1,
    type:json["type"] ?? -1 ,
    level:json["level"] ?? 1,
    partName:json["partName"] ?? "",
    partDec:json["partDec"] ?? "",
  );

}