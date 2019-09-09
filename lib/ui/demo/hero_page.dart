import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HeroPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _HeroPageState();

}


class _HeroPageState extends State<HeroPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: EdgeInsets.only(top: 100.0),
        child: ListView.builder(
          itemBuilder: (ctx,index){
            return FlatButton(
              color: Colors.transparent,
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 80.0,
                child: Container(
                  color: Colors.blue.withOpacity(index / 19),
                  child: Hero(tag: "_$index", child: Text("")),
                ),
              ),
              onPressed: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) =>
                      Hero2(tag: "_$index",color: Colors.blue.withOpacity(index / 19),
                      ),
                  ),
                );
              },
            );

            return Hero(
              tag: "_$index",
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child:CupertinoButton(
                    padding: EdgeInsets.all(0.0),
                    child: Container(
                      color: Colors.blue.withOpacity(index / 19),
                      child: Text("测试Hero Tag: $index"),
                    ),
                    onPressed: (){
                       Navigator.push(context,
                           MaterialPageRoute(builder: (ctx) =>
                               Hero2(tag: "_$index",color: Colors.blue.withOpacity(index / 19),
                               ),
                           ),
                       );
                    }
                ),
              ),
            );
          },
          itemCount: 20,
        ),
      ),
    );
  }
}


class Hero2 extends StatelessWidget{

  final String tag ;
  final Color color ;
  Hero2({this.tag,this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisSize: MainAxisSize.max,
         children: <Widget>[
           GestureDetector(
             child : SizedBox(
               width: MediaQuery.of(context).size.width,
               height: 200.0,
               child:Hero(
                 tag: tag,
                 child: Container(
                   alignment: Alignment.center,
                   color: color,
                 ),
               ),
             ),
             onTap: (){
               Navigator.of(context).pop();
             },
           ),
           SizedBox(
             width: MediaQuery.of(context).size.width,
             height: 120.0,
             child: Center(
               child: Text("Hero 第二个页面"),
             ),
           ),
         ],
       )
    );
  }

}