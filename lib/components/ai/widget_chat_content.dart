import 'package:flutter/material.dart';
import 'package:flutter_mvvm/res/dimens.dart';
import 'package:flutter_mvvm/res/colors.dart';

class ChatContentWidget extends StatefulWidget {

  final bool forceApply ;  // 优先级最大，强制改变颜色
  final Color bgColor ; // 背景色
  final Color normalTextColor ; // 正常句子颜色
  final String normalText ; // 正常句子
  final Color richTextColor ; // 富文本部分颜句子色
  final String richText ; // 含富文本句子
  final bool distinctRichText ; // 是否区分富文本
  final String richTextRule ; // 区分富文本字符串规则
  final Function onPressed ;
  final bool clickable ;

  ChatContentWidget({
    Key key,
    this.forceApply = false,
    this.bgColor = Colors.white,
    this.normalTextColor = Colours.black_color,
    this.richTextColor = Colours.green_color,
    this.distinctRichText = false,
    @required this.normalText ,
    this.richText = "",
    this.richTextRule = "#",
    this.onPressed,
    this.clickable = false ,
  })
    : assert(normalText.isNotEmpty),
      super(key:key);

  @override
  State<StatefulWidget> createState() => _ChatContentWidgetState();

}

class _ChatContentWidgetState extends State<ChatContentWidget> with SingleTickerProviderStateMixin{

  AnimationController _controller ;
  Animation<double> _animation ;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    _animation = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.addListener(_animationListener);
    _controller.forward();
  }

  void _animationListener(){
    setState(() {

    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_animationListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: (){
           if(widget.clickable){
              if(widget.onPressed != null){
                 widget.onPressed();
              }
           }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: Dimens.dimen_54dp,
            maxWidth: Dimens.dimen_200dp,
            minWidth: Dimens.dimen_100dp,
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              top: Dimens.dimen_4dp,
              bottom: Dimens.dimen_8dp,
              left: Dimens.dimen_15dp,
              right: Dimens.dimen_10dp,
            ),
            decoration: BoxDecoration(
              color: widget.forceApply ? Colours.light_blue_color : widget.bgColor,
              borderRadius: BorderRadius.circular(Dimens.dimen_10dp),
            ),
            child: RichText(
              softWrap: true,
              textDirection: TextDirection.ltr,
              text: TextSpan(
                children:_getChildren(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _getChildren() {
    String text;
    if (widget.distinctRichText) {
      text = widget.richText;
    } else {
      text = widget.normalText;
    }
    List<TextSpan> _list = [];
    if (text.isNotEmpty) {
      if (text.contains(widget.richTextRule)) {
        List<String> _wordList = text.split(widget.richTextRule);
        if (_wordList.length > 0) {
          for (int i = 0; i < _wordList.length; i++) {
            // 是非第一位置且为奇数位为关键字
            _list.add(_getTextSpan(_wordList[i], (i > 0 && i.isOdd)));
          }
        }
      } else {
        _list.add(_getTextSpan(text, false));
      }
    }
    return _list;
  }

  TextSpan _getTextSpan(String word, bool isSpec) {
    return TextSpan(
        text: word,
        style: TextStyle(
          color: widget.forceApply ? Colours.white_color : (isSpec ? widget.richTextColor : Colours.black_color),
          fontWeight: FontWeight.w500,
          fontSize: Dimens.font_14sp,
          height: 1.4,
        ));
  }

}