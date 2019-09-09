
enum ViewState {
  Loading, /// 加载中
  LoadComplete,/// 加载完成
  LoadEnd, /// 加载到底
  Empty,   /// 无数据
  NoLogin, /// 未登录
  NetError,/// 网络/数据异常
  SystemError /// 系统异常
}