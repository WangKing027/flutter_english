import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

class ViewStateWidget extends StatelessWidget {

  final String message ;
  final Widget btnText ;
  final Widget image ;
  final VoidCallback onPressed;

  ViewStateWidget({Key key,
    this.message,
    this.btnText,
    this.image,
    @required this.onPressed})
      :super(key:key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image,
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 60.0),
            child: Text(
              message ?? "网络加载失败，稍后重试~",
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.grey),
            ),
          ),
          ViewStateButton(child: btnText,onPressed: onPressed,),
        ],
      ),
    );
  }
}

class ViewStateButton extends StatelessWidget {

  final Widget child ;
  final VoidCallback onPressed ;

  ViewStateButton({Key key,
    this.child,
    @required this.onPressed})
      :super(key:key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ?? Text("重试", style: TextStyle(wordSpacing: 5),),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}

/// 页面加载中
class ViewStateLoadingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget btnText;
  final VoidCallback onPressed;

  const ViewStateEmptyWidget({Key key,
    this.image,
    this.message,
    this.btnText,
    @required this.onPressed})
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ??
          const Icon(
            Icons.hourglass_empty,
            size: 100,
            color: Colors.grey,
          ),
      message: message ?? "暂无数据",
      btnText: btnText ?? Text("重试", style: TextStyle(letterSpacing: 5),),
    );
  }
}

/// 骨架屏
class ViewStateSkeletonList extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final int length;
  final IndexedWidgetBuilder builder;

  ViewStateSkeletonList(
      {this.length: 6, //一般屏幕长度够用
        this.padding = const EdgeInsets.all(7),
        @required this.builder});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        period: Duration(milliseconds: 1200),
        baseColor: isDark ? Colors.grey[700] : Colors.grey[350],
//        highlightColor: isDark ? Colors.grey[500] : Color.alphaBlend(
//          theme.accentColor.withAlpha(20), Colors.grey[100],),
        highlightColor: isDark ? Colors.grey[500] : Colors.grey[200],
        child: Padding(
          padding: padding,
          child: Column(
            children: List.generate(length, (index) => builder(context, index)),
          ),
        ),
      ),
    );
  }
}

/// 骨架屏 元素背景 ->形状及颜色
class SkeletonDecoration extends BoxDecoration {
  SkeletonDecoration({
    isCircle: false,
    isDark: false,
  }) : super(
    color: !isDark ? Colors.grey[350] : Colors.grey[700],
    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
  );
}
