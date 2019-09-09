import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
export 'view_state.dart';
export 'view_state_widget.dart';

/// T
class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {

  final Widget Function(BuildContext context,T model,Widget child) builder ;
  final T model ;
  final Widget child ;
  final Function(T) initializeData;

  ProviderWidget({Key key,
    @required this.builder,
    @required this.model,
    this.child,
    @required this.initializeData})
      : assert(model != null),
        assert(builder != null),
        assert(initializeData != null),
        super(key :key);

  @override
  State<StatefulWidget> createState()  => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier> extends State<ProviderWidget<T>> {
  T _model ;

  @override
  void initState() {
    _model = widget.model ;
    if(widget.initializeData != null){
       widget.initializeData(_model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      builder: (ctx) => _model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}


/// A,B
class ProviderWidget2<A extends ChangeNotifier,B extends ChangeNotifier> extends StatefulWidget{

  final Widget Function(BuildContext context,A modelA,B modelB,Widget child) builder ;
  final A modelA ;
  final B modelB ;
  final Widget child;
  final Function(A,B) initializeData;

  ProviderWidget2({Key key,
  @required this.builder,
  @required this.modelA,
  @required this.modelB,
  @required this.initializeData,
  this.child})
      : assert(builder != null),
        assert(modelA != null),
        assert(modelB != null),
        assert(initializeData != null),
        super(key : key);

  @override
  State<StatefulWidget> createState() => _ProviderWidget2State<A,B>();

}

class _ProviderWidget2State<A extends ChangeNotifier,B extends ChangeNotifier> extends State<ProviderWidget2<A,B>>{

  A _modelA ;
  B _modelB ;

  @override
  void initState() {
    _modelA = widget.modelA ;
    _modelB = widget.modelB ;
    if(widget.initializeData != null){
       widget.initializeData(_modelA,_modelB);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<A>.value(value:_modelA),
        ChangeNotifierProvider<B>.value(value: _modelB),
      ],
      child: Consumer2<A,B>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

/// A,B,C
class ProviderWidget3<A extends ChangeNotifier,B extends ChangeNotifier,C extends ChangeNotifier> extends StatefulWidget{

  final Widget Function(BuildContext context,A modelA,B modelB,C modelC, Widget child) builder ;
  final A modelA ;
  final B modelB ;
  final C modelC ;
  final Widget child ;
  final Function(A,B,C) initializeData ;

  ProviderWidget3({Key key,
    @required this.builder,
    @required this.modelA,
    @required this.modelB,
    @required this.modelC,
    this.child,
    @required this.initializeData})
      : assert(builder != null),
        assert(modelA != null),
        assert(modelB != null),
        assert(modelC != null),
        assert(initializeData != null),
        super(key : key);

  @override
  State<StatefulWidget> createState() => _ProviderWidget3State<A,B,C>();

}

class _ProviderWidget3State<A extends ChangeNotifier,B extends ChangeNotifier ,C extends ChangeNotifier> extends State<ProviderWidget3<A,B,C>>{

  A _modelA ;
  B _modelB ;
  C _modelC ;

  @override
  void initState() {
    _modelA = widget.modelA;
    _modelB = widget.modelB;
    _modelC = widget.modelC ;
    if(widget.initializeData != null){
       widget.initializeData(_modelA , _modelB, _modelC);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
       providers: [
         ChangeNotifierProvider<A>.value(value: _modelA),
         ChangeNotifierProvider<B>.value(value: _modelB),
         ChangeNotifierProvider<C>.value(value: _modelC)
       ],
      child: Consumer3<A,B,C>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

/// ...

