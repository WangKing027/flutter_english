import 'package:flutter_mvvm/components/ai/shared/wave.dart';
import 'package:flutter_mvvm/components/ai/shared/wave_config.dart';
import 'package:flutter_mvvm/utils/color_utils.dart';
import 'package:flutter_mvvm/res/index.dart';
import 'package:flutter/material.dart';


class RecordRippleWidget extends StatefulWidget {

  final String noticeText ;
  final VoidCallback onPressed;
  final bool clickable ;

  RecordRippleWidget({
    Key key,
    this.noticeText = Strings.string_click_wave_stop_record,
    this.clickable = true,
    @required this.onPressed,
  })
    : assert(onPressed != null),
      super(key : key);

  @override
  State<StatefulWidget> createState() => _RecordRippleWidgetState();

}

class _RecordRippleWidgetState extends State<RecordRippleWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.clickable){
           widget.onPressed();
        }
      },
      child: SizedBox(
        height: Dimens.dimen_100dp,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
               child:Align(
                 alignment: Alignment.center,
                 child: Text(
                   widget.noticeText,
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: Dimens.font_14sp,
                     color: Colours.navy_blue_color,
                   ),
                 ),
               ),
            ),
            WaveWidget(
              config: CustomConfig(
                durations: [3500,1400],
                heightPercentages: [0.25,0.28],
                gradients: [
                  [HexColor("#0FCCAD"),HexColor("#87E5D6")],
                  [HexColor("#87E5D6"),HexColor("#0FCCAD")]
                ],
                gradientEnd: Alignment.topLeft,
                gradientBegin: Alignment.bottomRight,

              ),
              waveAmplitude: 0.3,
              wavePhase:10.0,
              waveFrequency:2.0,
              backgroundColor: Colors.transparent,
              size: Size(MediaQuery.of(context).size.width, Dimens.dimen_45dp)
            )
          ],
        ),
      ),
    );
  }
}