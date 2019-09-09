import 'package:flutter_mvvm/provider/view_state_list_model.dart';
import 'package:flutter_mvvm/model/unit_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class UnitViewModel extends ViewStateListModel<UnitModel>{

  BuildContext _context ;
  UnitViewModel(BuildContext context):_context = context ;

  @override
  Future<List<UnitModel>> loadData() async {
     String value = await DefaultAssetBundle.of(_context).loadString("assets/json/unit_senior_list.json");
     List _jsonMap = json.decode(value);
     debugPrint("---jsonMap: $_jsonMap");
     List<UnitModel> _list = _jsonMap.map((item) => UnitModel.fromJson(item)).toList();
     return Future.value(_list);
  }
}
