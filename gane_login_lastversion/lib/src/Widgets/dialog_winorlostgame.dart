import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';

final singleton = Singleton();

dialogWinOrLostGames(BuildContext contextContainer, String title, String buttonLeft, Function onAnimationCoin) async {


  /*return showAnimatedDialog(
    barrierDismissible: false,
    context: contextContainer,
    animationType: DialogTransitionType.slideFromBottomFade,
    curve: Curves.easeOutQuad,
    duration: Duration(milliseconds: 600),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6,sigmaY: 6),
        child:
        WillPopScope(
          onWillPop: () async => false,
          child: Material(
            type: MaterialType.transparency,
            //type: MaterialType.canvas,
            //color: CustomColors.backgroundalert,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 30, left: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.all(const Radius.circular(25))
                    ),
                    child: Stack(

                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(height: 15,),

                            Container(
                              //margin: EdgeInsets.only(top: 10,bottom: 10),
                              child: Image(
                                image: AssetImage("assets/images/logohome.png"),
                                width: double.infinity,
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only( left: 10,right: 10),
                              child: BorderedText(
                                strokeWidth: 7.0,
                                strokeColor: CustomColors.orangeback,
                                child: Text(
                                  title,
                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowtext, fontSize: 45.0,),
                                  maxLines: 1,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),

                            Container(
                                margin: EdgeInsets.only(left: 40,right: 40),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: CustomColors.orangeback1,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(23))),
                                child: Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    child: TextButton(
                                        key: Key('btnButtonLeft'),
                                        onPressed: () {
                                          if(title==Strings.wingame){
                                            onAnimationCoin();
                                          }
                                          int count = 3;
                                          Navigator.of(context).popUntil((_) => count-- <= 0);
                                          //Navigator.pop(context);
                                        },
                                        child: Text(buttonLeft,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: Strings.font_semibold,
                                                fontSize: 16,
                                                color: CustomColors.white))),
                                  );
                                })),

                            SizedBox(
                              height: 20,
                            ),

                          ],
                        ),

                      ],

                    )
                ),
              ],
            ),
          ),
        ),
      );
    },
  );*/

  showDialog(
      context: contextContainer,
      barrierDismissible: true,
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6,sigmaY: 6),
        child:
        WillPopScope(
          onWillPop: () async => false,
          child: Material(
            type: MaterialType.transparency,
            //type: MaterialType.canvas,
            //color: CustomColors.backgroundalert,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 30, left: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.all(const Radius.circular(25))
                    ),
                    child: Stack(

                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            SizedBox(height: 15,),

                            Container(
                              //margin: EdgeInsets.only(top: 10,bottom: 10),
                              child: Image(
                                image: AssetImage("assets/images/logohome.png"),
                                width: double.infinity,
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only( left: 10,right: 10),
                              child: BorderedText(
                                strokeWidth: 7.0,
                                strokeColor: CustomColors.orangeback,
                                child: Text(
                                  title,
                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowtext, fontSize: 45.0,),
                                  maxLines: 1,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 30,
                            ),

                            Container(
                                margin: EdgeInsets.only(left: 40,right: 40),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: CustomColors.orangeback1,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(23))),
                                child: Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    child: TextButton(
                                        key: Key('btnButtonLeft'),
                                        onPressed: () {
                                          if(title==Strings.wingame){
                                            onAnimationCoin();
                                          }
                                          int count = 3;
                                          Navigator.of(context).popUntil((_) => count-- <= 0);
                                          //Navigator.pop(context);
                                        },
                                        child: Text(buttonLeft,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: Strings.font_semibold,
                                                fontSize: 16,
                                                color: CustomColors.white))),
                                  );
                                })),

                            SizedBox(
                              height: 20,
                            ),

                          ],
                        ),

                      ],

                    )
                ),
              ],
            ),
          ),
        ),
      )
  );

}
