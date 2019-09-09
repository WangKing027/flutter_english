import 'view_state_model.dart';

abstract class ViewStateListModel<T> extends  ViewStateModel {

  List<T> dataList = [] ;

  Future<List<T>> loadData() ;

  initializeData() async {
    setLoading(loading: true);
    await refresh(initialize: true);
  }

  refresh({bool initialize = false}) async {
    try{
      List<T> _dataList = await loadData();
      if(_dataList.isEmpty){
         setEmpty();
      } else {
        dataList = _dataList ;
        if(initialize){
           setLoading(loading: false);
        } else {
          notifyListeners();
        }
      }
    } catch(e,s){
      handleCatch(e,s);
    }
  }
}