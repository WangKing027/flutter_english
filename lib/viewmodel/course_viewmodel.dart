import 'package:flutter_mvvm/model/course_model.dart';
import 'dart:convert';
import 'package:flutter_mvvm/provider/view_state_list_model.dart';
import 'package:flutter/material.dart';

class CourseViewModel extends ViewStateListModel<CourseModel>{

  BuildContext _context ;
  CourseViewModel(BuildContext context){
    _context = context;
  }

  @override
  Future<List<CourseModel>> loadData() async {
    String value = await DefaultAssetBundle.of(_context).loadString("assets/json/course_list.json");
    List _jsonMap = json.decode(value);
    debugPrint("----JsonMap---$_jsonMap");
    List<CourseModel> _courseModelList = _jsonMap.map((item)=> CourseModel.fromJson(item)).toList();
    return Future.value(_courseModelList);
  }

}