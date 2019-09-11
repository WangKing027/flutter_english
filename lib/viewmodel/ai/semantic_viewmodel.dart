import 'package:flutter_mvvm/provider/view_state_obj_model.dart';
import 'package:flutter_mvvm/model/ai/common_model.dart';

class SemanticViewModel extends ViewStateObjModel<CommonModel>{

  @override
  Future<CommonModel> loadData() {
    return Future.value(CommonModel());
  }
}