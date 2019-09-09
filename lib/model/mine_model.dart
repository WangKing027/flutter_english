
class MineModel {

  final String userName ;
  final String id ;
   bool isVip ;
   int newWordsCount ;
   int noteCount ;
  final List<MineItem> mineListItems ;

  MineModel({
     this.userName,
     this.isVip,
     this.id,
     this.newWordsCount,
     this.noteCount,
     this.mineListItems,
  });

  MineModel.fromJson(Map<String,dynamic> json) : this(
      userName : json["userName"] ?? "",
      isVip : json["isVip"] ?? false ,
      id : json["id"] ?? "",
      newWordsCount : json["newWordsCount"] ?? 0,
      noteCount : json["noteCount"] ?? 0,
      mineListItems : json["mineListItems"] != null ? List<MineItem>.from(json["mineListItems"].map((item) => MineItem.fromJson(item)).toList()) : [],
  );

}

class MineItem {
  final String icon ;
  final String text ;

  MineItem({this.icon,this.text});

  MineItem.fromJson(Map<String,dynamic> json):this(
    icon:json["icon"] ?? "assets/images/icon_item_open_vip.png",
    text:json["text"] ?? "",
  );

}