import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_mvvm/model/ai/word_model.dart';
import 'package:flutter_mvvm/res/index.dart';

// 单词学习
class IntensiveWordPart extends StatelessWidget {

  final WordModel model ;
  final bool isAssets ;

  IntensiveWordPart({
    Key key,
    @required this.model,
    this.isAssets = true,
  })
    : assert(model != null),
      super(key:key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _getChildren()
      ),
    );
  }

  List<Widget> _getChildren(){
    List<Widget> _result = [] ;
    _result.add(Container(
        margin: EdgeInsets.only(top: Dimens.dimen_65dp,bottom: Dimens.dimen_18dp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.dimen_9dp),
          child: isAssets ? Image.asset(model.wordImgUrl,width: Dimens.dimen_225dp, height: Dimens.dimen_150dp,)
                : Image.file(File(model.wordImgUrl), width: Dimens.dimen_225dp, height: Dimens.dimen_150dp,),
        )
    ));
    if(model.wordEn.isNotEmpty){
      _result.add(_getWordWidget(model.wordEn ?? ""));
      _result.add(_getSpaceWidget(Dimens.dimen_3dp));
    }
    if(model.wordPh.isNotEmpty){
      _result.add(_getSoundMarkWidget(model.wordPh ?? ""));
      _result.add(_getSpaceWidget(Dimens.dimen_5dp));
    }
    if(model.wordCn.isNotEmpty){
      _result.add(_getChWidget(model.wordCn));
    }
    if(!isAssets){
      var file = File(model.wordImgUrl);
      file.exists().then((exist){
        if(!exist){
          showToast("图片文件不存在");
        }
      });
    }
    return _result ;
  }

  Widget _getWordWidget(String text){
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colours.orange_color,
        fontWeight: FontWeight.w500,
        fontSize: Dimens.font_25sp,
      ),
    );
  }

  Widget _getSoundMarkWidget(String text){
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colours.black_color,
        fontWeight: FontWeight.normal,
        fontSize: Dimens.font_14sp,
      ),
    );
  }

  Widget _getChWidget(String text){
    return Padding(
      padding: EdgeInsets.only(left: Dimens.dimen_55dp,right: Dimens.dimen_55dp),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colours.black_color,
          fontWeight: FontWeight.normal,
          fontSize: Dimens.font_17sp,
        ),
      ),
    );
  }

  Widget _getSpaceWidget(double height){
    return Container(
      width: Dimens.dimen_10dp,
      height: height,
    );
  }

}