import 'package:flutter_mvvm/provider/view_state_obj_model.dart';
import 'package:flutter_mvvm/model/ai/common_model.dart';
import 'package:flutter/material.dart';

class SemanticViewModel extends ViewStateObjModel<CommonModel>{
  int _curProgress = 0 ,
      _maxProgress = 10;
  PageController _pageController = PageController();

  @override
  Future<CommonModel> loadData() {
    return Future.value(CommonModel());
  }

  @override
  int getCurProgress() => _curProgress ;

  @override
  int getMaxProgress() => _maxProgress ;

  @override
  void onPausePressed() {
    super.onPausePressed();
  }

  // 获取ScrollController
  PageController getController() => _pageController ;

  // 点击播放按钮
  void onPlayPressed(val){

  }


}