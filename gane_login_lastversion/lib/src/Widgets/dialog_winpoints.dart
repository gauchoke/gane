import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:lottie/lottie.dart';

final singleton = Singleton();




dialogWinPoints(BuildContext contextContainer, String title, String message, String buttonLeft, Function onAnimationCoin, points) async {


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


                        Positioned(
                          left: 0.7,
                          right: 0.7,
                          bottom: 3.8,
                          top: 3.8,
                          child: Container(
                            //color: Colors.red,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 14,right: 14),
                            alignment: Alignment.center,
                            child: Lottie.asset(
                              'assets/images/wincoins.json',
                              repeat: true,
                              //width: MediaQuery.of(context).size.width,
                              //height: MediaQuery.of(context).size.width -55,
                              fit:BoxFit.fitWidth,
                            ),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            TextButton(
                              onPressed: () {
                                onAnimationCoin();
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 10,),
                                child: Image(
                                  image: AssetImage("assets/images/ic_close1.png"),
                                  width: 44.0,
                                  height:44.0,
                                ),
                              ),
                            ),

                            SizedBox(height: 5,),

                            Container(
                              //margin: EdgeInsets.only(top: 10,bottom: 10),
                              child: Image(
                                image: AssetImage("assets/images/bannergane.png"),
                                width: double.infinity,
                              ),
                            ),

                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 10, left: 10,right: 10),
                                child: Text(title,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontFamily: Strings.font_bold,
                                        fontSize: 22,
                                        color: CustomColors.orangeback))
                            ),

                            Container(
                              //color: Colors.red,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                              child: RichText(
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(text: Strings.greatwin1,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                    )),
                                    new TextSpan(text: singleton.formatter.format(double.parse(points)),style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangelight, fontSize: 12.0,
                                    )),
                                    new TextSpan(text: " puntos",style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangelight, fontSize: 12.0,
                                    )),
                                    new TextSpan(text: singleton.format==1 ? Strings.greatwin2 : singleton.format==4 ? Strings.greatwin4: singleton.format==3 ? Strings.greatwin5 : Strings.greatwin3,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                    )),

                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                                margin: EdgeInsets.only(left: 40,right: 40),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: CustomColors.blueBack,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(23))),
                                child: Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    child: TextButton(
                                        key: Key('btnButtonLeft'),
                                        onPressed: () {
                                          onAnimationCoin();
                                          Navigator.pop(context);
                                        },
                                        child: Text(buttonLeft,
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: Strings.font_semibold,
                                                fontSize: 16,
                                                color: CustomColors.white))
                                    ),
                                  );
                                })
                            ),

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


                        Positioned(
                          left: 0.7,
                          right: 0.7,
                          bottom: 3.8,
                          top: 3.8,
                          child: Container(
                            //color: Colors.red,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 14,right: 14),
                            alignment: Alignment.center,
                            child: Lottie.asset(
                              'assets/images/wincoins.json',
                              repeat: true,
                              //width: MediaQuery.of(context).size.width,
                              //height: MediaQuery.of(context).size.width -55,
                              fit:BoxFit.fitWidth,
                            ),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            TextButton(
                              onPressed: () {
                                onAnimationCoin();
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 10,),
                                child: Image(
                                  image: AssetImage("assets/images/ic_close1.png"),
                                  width: 44.0,
                                  height:44.0,
                                ),
                              ),
                            ),

                            SizedBox(height: 5,),

                            Container(
                              //margin: EdgeInsets.only(top: 10,bottom: 10),
                              child: Image(
                                image: AssetImage("assets/images/bannergane.png"),
                                width: double.infinity,
                              ),
                            ),

                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 10, left: 10,right: 10),
                                child: Text(title,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontFamily: Strings.font_bold,
                                        fontSize: 22,
                                        color: CustomColors.orangeback))
                            ),

                            Container(
                              //color: Colors.red,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                              child: RichText(
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                                text: new TextSpan(
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(text: Strings.greatwin1,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                    )),
                                    new TextSpan(text: singleton.formatter.format(double.parse(points)),style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangelight, fontSize: 12.0,
                                    )),
                                    new TextSpan(text: " puntos",style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangelight, fontSize: 12.0,
                                    )),
                                    new TextSpan(text: singleton.format==1 ? Strings.greatwin2 : singleton.format==4 ? Strings.greatwin4: singleton.format==3 ? Strings.greatwin5 : Strings.greatwin3,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                    )),

                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                                margin: EdgeInsets.only(left: 40,right: 40),
                                height: 45,
                                decoration: BoxDecoration(
                                    color: CustomColors.blueBack,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(23))),
                                child: Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    child: TextButton(
                                        key: Key('btnButtonLeft'),
                                        onPressed: () {
                                          onAnimationCoin();
                                          Navigator.pop(context);
                                        },
                                        child: Text(buttonLeft,
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: Strings.font_semibold,
                                                fontSize: 16,
                                                color: CustomColors.white))
                                    ),
                                  );
                                })
                            ),

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
