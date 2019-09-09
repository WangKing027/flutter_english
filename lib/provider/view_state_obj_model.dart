import 'view_state_model.dart';

abstract class ViewStateObjModel<T> extends ViewStateModel {

  T data ;

  Future<T> loadData() ;

  initializeData() async {
    setLoading(loading: true);
    await refresh(initialize: true);
  }

  refresh({bool initialize = false}) async {
    try{
      T _data = await loadData();
      if(_data == null){
        setEmpty();
      } else {
        data = _data ;
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

  int getMaxProgress ()=> 1;

  int getCurProgress()=> 0 ;

  void onPausePressed(){}

}