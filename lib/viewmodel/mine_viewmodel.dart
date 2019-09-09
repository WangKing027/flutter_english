import 'package:flutter_mvvm/model/mine_model.dart';
import 'dart:convert';
import 'package:flutter_mvvm/provider/view_state_obj_model.dart';
import 'package:flutter/material.dart';

class MineViewModel extends ViewStateObjModel<MineModel>{

  MineModel model ;
  BuildContext _context ;
  MineViewModel(BuildContext context)
      :_context = context;

  @override
  Future<MineModel> loadData() async {
    String value = await DefaultAssetBundle.of(_context).loadString("assets/json/mine_data.json");
    var _json = json.decode(value);
    debugPrint("---json---$_json");
    model = MineModel.fromJson(_json);
    return Future.value(model);
  }

  void clickNote(){
     if(model != null){
        model.noteCount += 1 ;
     }
     notifyListeners();
  }

  void clickNewWords(){
    if(model != null){
      model.newWordsCount += 2 ;
    }
    notifyListeners();
  }

}