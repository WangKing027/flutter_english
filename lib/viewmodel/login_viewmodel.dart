import 'package:flutter_mvvm/provider/view_state_obj_model.dart';

class LoginViewModel extends ViewStateObjModel<String>{

  @override
  Future<String> loadData() {
     return Future.value("");
  }
}