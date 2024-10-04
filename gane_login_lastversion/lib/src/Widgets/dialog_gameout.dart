import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';

final singleton = Singleton();
servicesManager servicemanager = servicesManager();


dialogGameOut(BuildContext contextContainer, String title, String buttonLeft,String rightLeft, Function resumeVideo) async {


  /*return showAnimatedDialog(
    barrierDismissible: false,
    context: contextContainer,
    animationType: DialogTransitionType.slideFromBottomFade,
    curve: Curves.easeOutQuad,
    duration: Duration(milliseconds: 600),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6,sigmaY: 6),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Material(
            type: MaterialType.transparency,
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
                    child: Column(

                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[

                          SizedBox(
                            height: 10,
                          ),

                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 15, left: 10,right: 10),
                              child: Text(title,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontFamily: Strings.font_bold,
                                      fontSize: 15,
                                      color: CustomColors.orangeback))
                          ),


                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 15,right: 15),
                            child: Row(

                              children: [

                                Expanded(
                                  child: Container(

                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: CustomColors.grayButton,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(18))),
                                      child: Builder(builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnButtonLeft'),
                                              onPressed: () {

                                                //Navigator.pop(context);
                                                int count = 0;
                                                Navigator.of(context).popUntil((_) => count++ >= 2);
                                              },
                                              child: Text(buttonLeft,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontFamily: Strings.font_semibold,
                                                      fontSize: 14,
                                                      color: CustomColors.white))),
                                        );
                                      })),
                                ),

                                SizedBox(width: 15,),

                                Expanded(
                                  child: Container(

                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: CustomColors.orangeback1,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(18))),
                                      child: Builder(builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnButtonLeft'),
                                              onPressed: () {
                                                resumeVideo();
                                                Navigator.pop(context);
                                              },
                                              child: Text(rightLeft,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontFamily: Strings.font_semibold,
                                                      fontSize: 14,
                                                      color: CustomColors.white))),
                                        );
                                      })),
                                )

                              ],

                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                        ])
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
        child: WillPopScope(
          onWillPop: () async => false,
          child: Material(
            type: MaterialType.transparency,
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
                    child: Column(

                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: <Widget>[

                          SizedBox(
                            height: 10,
                          ),

                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 15, left: 10,right: 10),
                              child: Text(title,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontFamily: Strings.font_bold,
                                      fontSize: 15,
                                      color: CustomColors.orangeback))
                          ),


                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 15,right: 15),
                            child: Row(

                              children: [

                                Expanded(
                                  child: Container(

                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: CustomColors.grayButton,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(18))),
                                      child: Builder(builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnButtonLeft'),
                                              onPressed: () {

                                                //Navigator.pop(context);
                                                int count = 0;
                                                Navigator.of(context).popUntil((_) => count++ >= 2);
                                              },
                                              child: Text(buttonLeft,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontFamily: Strings.font_semibold,
                                                      fontSize: 14,
                                                      color: CustomColors.white))),
                                        );
                                      })),
                                ),

                                SizedBox(width: 15,),

                                Expanded(
                                  child: Container(

                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: CustomColors.orangeback1,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(18))),
                                      child: Builder(builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnButtonLeft'),
                                              onPressed: () {
                                                resumeVideo();
                                                Navigator.pop(context);
                                              },
                                              child: Text(rightLeft,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontFamily: Strings.font_semibold,
                                                      fontSize: 14,
                                                      color: CustomColors.white))),
                                        );
                                      })),
                                )

                              ],

                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),

                        ])
                ),
              ],
            ),
          ),
        ),
      )
  );


}
