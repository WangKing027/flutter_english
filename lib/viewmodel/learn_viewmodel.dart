import 'package:flutter_mvvm/provider/view_state_obj_model.dart';
import 'package:flutter_mvvm/model/learn_model.dart';
import 'package:flutter_mvvm/model/course_model.dart';

class LearnViewModel extends ViewStateObjModel<LearnModel>{

  LearnModel model ;

  @override
  Future<LearnModel> loadData() async {
    model = LearnModel(courseModels: []);
    return Future.value(model);
  }

  addCourseToLearnModel(CourseModel course){
    model.courseModels.add(course);
    notifyListeners();
  }

}
