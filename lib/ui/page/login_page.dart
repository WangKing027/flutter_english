import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm/base/base_state.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/components/widget_check_box.dart';
import 'package:flutter_mvvm/viewmodel/login_viewmodel.dart';
import 'package:flutter_mvvm/components/widget_custom_input.dart';
import 'package:flutter_mvvm/provider/provider_widget.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LoginPageState();

}

class _LoginPageState extends BaseState<LoginPage> with SingleTickerProviderStateMixin{

  LoginViewModel _loginViewModel ;
  PageController _pageController ;
  String _phone = "";

  @override
  void initState() {
    removeAppBar = true ;
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return ProviderWidget<LoginViewModel>(
      model: LoginViewModel(),
      initializeData: (model) => model.initializeData(),
      builder: (ctx,model,child){
         if(model.viewState == ViewState.Loading){
            return ViewStateLoadingWidget();
         }
         return PageView.builder(
           itemBuilder: (ctx,index){
             if(index == 0){
               return _PhoneFrag(callback: _confirmCodeCallBack,);
             }
             return _PasswordFrag(phone: _phone,callback: _backCallBack,);
           },
           physics: NeverScrollableScrollPhysics(),
           controller: _pageController,
           itemCount: 2,
         );
      },
    );
  }

  void _confirmCodeCallBack(_phone){
    this._phone = _phone;
    _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _backCallBack() => Navigator.of(context).pop();

}

class _PhoneFrag extends StatelessWidget {

  static String _phone = "";
  final Function callback ;

  _PhoneFrag({Key key,this.callback})
      : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
           Positioned(
             child: CupertinoButton(
               child: Text("关闭",style: TextStyle(color: HexColor("#999999"),fontSize: 14.0),),
               onPressed: () => Navigator.of(context).pop(),
             ),
             top: MediaQueryData.fromWindow(ui.window).padding.top,right: 30.0,
           ),
           Positioned(
             child: Text("Hi，\n欢迎来到翻转英语！",style: TextStyle(color: HexColor("#333333"),fontSize: 24.0,fontWeight: FontWeight.bold),),
             left: 40.0,top: 80.0 + MediaQueryData.fromWindow(ui.window).padding.top,
           ),
          Positioned(
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor("C8C8C8"),width: 1.0,style: BorderStyle.solid),),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor("C8C8C8"),width: 1.0,style: BorderStyle.solid),),
                hintText: "请输入手机号",
                hintStyle: TextStyle(color: HexColor("#C8C8C8"),fontSize: 18.0,),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[0-9]")),//限制只能输入字母
                LengthLimitingTextInputFormatter(11), //限制长度最大为30
              ],
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
              cursorColor: Colors.orange,
              onChanged:(value){
                _phone = value ;
                debugPrint("---onChanged---$value , phone--$_phone");
              },
            ),
            left: 40.0,right: 40.0,top: 200.0 + MediaQueryData.fromWindow(ui.window).padding.top,
          ),
          Positioned(
            child: SizedBox(
              width: 295.0,
              height: 60.0,
              child: ClipRRect(
                child: CupertinoButton(
                    padding: const EdgeInsets.all(0.0),
                    color: HexColor("#FEDC32"),
                    child: Center(
                      child: Text("获取验证码",style: TextStyle(
                        color: HexColor("#333333"),
                        fontSize: 18.0,
                      ),),
                    ),
                    onPressed: (){
                      if(_phone == null || _phone.length != 11){
                        showToast("--请输入正确手机号--$_phone");
                      } else {
                        if(callback != null){
                           callback(_phone);
                        }
                      }
                    }
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            left:(MediaQuery.of(context).size.width - 295) / 2,
            top: 284.0 + MediaQueryData.fromWindow(ui.window).padding.top,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CheckBoxWidget(
                  checkedWidget: Image.asset("assets/images/img_protocol.png",width: 16.0,height: 16.0,),
                  unCheckWidget: Image.asset("assets/images/img_protocol.png",width: 16.0,height: 16.0,),
                  boxSize: 16.0,
                  padding: const EdgeInsets.only(right: 10.0),
                  callback: (checked){
                  },
                ),
                Text("我已经阅读并同意",style: TextStyle(color: HexColor("#999999"),fontSize: 14.0),),
                Text("使用条款和隐私政策",style: TextStyle(color: HexColor("#FEDC32"),fontSize: 14.0),),
              ],
            ),
            left: 40.0,top: 360.0 + MediaQueryData.fromWindow(ui.window).padding.top,
          ),
          Positioned(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    child: Text("————  微信快捷登录  ————",style: TextStyle(color: HexColor("#C8C8C8"),fontSize: 12.0),),
                    padding: const EdgeInsets.only(bottom: 10.0),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset("assets/images/img_wechat_login.png",width: 52.0,height: 52.0,),
                    onPressed: (){
                      showToast("--调用微信登录--");
                    },
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width - 80.0,
              height: 80.0,
            ),
            bottom: 40.0,
            left: 40.0,
          ),
        ],
      ),
    );
  }
}

class _PasswordFrag extends StatelessWidget {
  final String phone ;
  final VoidCallback callback;

  _PasswordFrag({
    Key key,
    this.phone,
    this.callback,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0,top: MediaQueryData.fromWindow(ui.window).padding.top),
          child: CupertinoButton(
            padding: const EdgeInsets.all(0.0),
            child: Image.asset("assets/images/btn_nav_return_back.png",width: 20.0,height: 20.0,),
            onPressed: () => callback != null ? callback() : "",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0,top: 30.0),
          child: Text("输入验证码",style: TextStyle(color: HexColor("#363740"),fontSize: 22.0,fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40.0,top: 28.0),
          child: RichText(text: TextSpan(
            children: <TextSpan>[
              TextSpan(text:"已发送验证码至",style:TextStyle(color: HexColor("#333333"),fontSize: 14.0),),
              TextSpan(text: " +86 $phone",style: TextStyle(color: HexColor("#999999"),fontSize: 14.0),),
            ],
          ),textAlign: TextAlign.center,),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomInputWidget(
              property: CustomInputProperty(
                textLength: 4,
                fontSize: 36.0,
                spaceWidth: 30.0,
                borderSide: BorderSide(color: Colors.red,width: 1.0,style: BorderStyle.solid),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


