import 'package:flutter/material.dart';
import 'package:flutter_mvvm/ui/demo/charst_animation_page.dart';
import 'package:flutter_mvvm/ui/demo/sliver_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_mvvm/ui/demo/sliver_fix_page.dart';
import 'package:flutter_mvvm/ui/page/splash_page.dart';
import 'package:flutter_mvvm/ui/demo/wallet_page.dart';
import 'package:flutter_mvvm/ui/demo/hero_page.dart';
import 'package:flutter_mvvm/utils/screen_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    setDesignWHD(375.0, 667.0,); // 设置适配尺寸: 设计稿宽高基于 375 * 667
    return OKToast(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.white,
          backgroundColor: Colors.white
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
      position: ToastPosition.bottom,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SplashPage())),
              child: Text("FlippedEnglish"),
            ),
//            RaisedButton(
//              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AppPage(),)),
//              child: Text("翻转英语"),
//            ),
            RaisedButton(
              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ChartAnimationPage())),
              child: Text("矩形树状图动画"),
            ),
            RaisedButton(
              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SliverPage())),
              child: Text("Sliver一大家子"),
            ),
            RaisedButton(
              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SliverFixPage())),
              child: Text("Sliver Fix Demo"),
            ),
//            RaisedButton(
//              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => WalletPage())),
//              child: Text("Wallet UI"),
//            ),
//            RaisedButton(
//              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => HeroPage())),
//              child: Text("Hero"),
//            ),
          ],
        ),
      ),
    );
  }
}
