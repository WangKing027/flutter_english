import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CheckBoxWidget extends StatefulWidget{

  final Widget checkedWidget;
  final Widget unCheckWidget;
  final double boxSize ;
  final Function callback ;
  final EdgeInsetsGeometry padding ;

  CheckBoxWidget({
        Key key,
        @required this.checkedWidget,
        @required this.unCheckWidget,
        this.boxSize,
        this.callback,
        this.padding,
      }): assert(checkedWidget != null ),
          assert(unCheckWidget != null),
          super(key:key);

  @override
  State<StatefulWidget> createState() => _CheckBoxWidgetState();

}

class _CheckBoxWidgetState extends State<CheckBoxWidget>{

  bool _isChecked = false ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(0.0),
      child: SizedBox(
        width: widget.boxSize ?? 30.0,
        height: widget.boxSize ?? 30.0,
        child: CupertinoButton(
          padding: const EdgeInsets.all(0.0),
          child: _isChecked ? widget.checkedWidget : widget.unCheckWidget,
          onPressed: (){
            setState(() {
              _isChecked = !_isChecked ;
            });
            if(widget.callback != null){
              widget.callback(_isChecked);
            }
          },
        ),
      ),
    );
  }

}