import 'package:flutter/material.dart';
import 'view_state.dart';

class ViewStateModel with ChangeNotifier{
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;
  /// 默认是Loading状态,在构造方法中初始化
  ViewState _viewState ;
  /// 错误信息
  String _errorMessage ;

  ViewStateModel({ViewState viewState}):_viewState = viewState ?? ViewState.Loading ;

  ViewState get viewState => _viewState ;

  set viewState(ViewState viewState){
    _viewState = viewState ;
    notifyListeners();
  }

  String get errorMessage => _errorMessage ;

  void setLoading({bool loading = true}){
    _errorMessage = null ;
    viewState = loading ? ViewState.Loading : ViewState.LoadComplete;
  }

  void setLoadEnd({bool loadEnd = true}){
     _errorMessage = null ;
     viewState = loadEnd ? ViewState.LoadEnd : ViewState.Loading ;
  }

  void setEmpty(){
    _errorMessage = null ;
    viewState = ViewState.Empty ;
  }

  void setNoLogin(){
    _errorMessage = null ;
    viewState = ViewState.NoLogin;
  }

  void setError({bool netError = true, String errorMessage = "网络加载失败，稍后重试~"}){
     _errorMessage = errorMessage ;
     viewState = netError ? ViewState.NetError : ViewState.SystemError ;
  }

  @override
  String toString() => "ViewStateModel(viewState: $_viewState , errroMessage: $_errorMessage)";

  void handleCatch(Error e, StackTrace s){
    debugPrint('error--->\n' + e.toString());
    debugPrint('statck--->\n' + s.toString());
    setError(errorMessage: e.toString());
  }

  @override
  void notifyListeners() {
    if(!_disposed){
       super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true ;
    super.dispose();
  }
}