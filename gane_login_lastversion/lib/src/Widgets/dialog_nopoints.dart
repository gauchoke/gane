import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';

final singleton = Singleton();
servicesManager servicemanager = servicesManager();


dialogNoWinPoints(BuildContext contextContainer, String title, String message,
    String buttonLeft,String rightLeft, Function resumeVideo, points) async {


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


                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 15, left: 10,right: 10),
                              child: Text(title,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontFamily: Strings.font_bold,
                                      fontSize: 14,
                                      color: CustomColors.orangeback))
                          ),

                          Container(
                            //color: Colors.red,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                            child: Text(message,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontFamily: Strings.font_medium,
                                    fontSize: 13,
                                    color: CustomColors.blacktextmax)),
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

                                                singleton.Gane1RoomPages = 0;
                                                singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );

                                                if(singleton.GaneOrMira == "mira"){
                                                  servicemanager.fetchMiraRoom(context, "borrar");
                                                }else
                                                  servicemanager.fetchGaneRoom(context, "borrar");

                                                int count = 0;
                                                Navigator.of(context).popUntil((_) => count++ >= 2);
                                              },
                                              child: Text(buttonLeft,
                                                  textAlign: TextAlign.center,textScaleFactor: 1.0,
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
                                          color: CustomColors.orangeback2,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(18))),
                                      child: Builder(builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnButtonLeft'),
                                              onPressed: () {
                                                if(singleton.format==1){
                                                  resumeVideo();
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text(rightLeft,
                                                  textAlign: TextAlign.center,textScaleFactor: 1.0,
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


                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 15, left: 10,right: 10),
                              child: Text(title,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontFamily: Strings.font_bold,
                                      fontSize: 14,
                                      color: CustomColors.orangeback))
                          ),

                          Container(
                            //color: Colors.red,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                            child: Text(message,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontFamily: Strings.font_medium,
                                    fontSize: 13,
                                    color: CustomColors.blacktextmax)),
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

                                                singleton.Gane1RoomPages = 0;
                                                singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );

                                                if(singleton.GaneOrMira == "mira"){
                                                  servicemanager.fetchMiraRoom(context, "borrar");
                                                }else
                                                  servicemanager.fetchGaneRoom(context, "borrar");

                                                int count = 0;
                                                Navigator.of(context).popUntil((_) => count++ >= 2);
                                              },
                                              child: Text(buttonLeft,
                                                  textAlign: TextAlign.center,textScaleFactor: 1.0,
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
                                          color: CustomColors.orangeback2,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(18))),
                                      child: Builder(builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnButtonLeft'),
                                              onPressed: () {
                                                if(singleton.format==1){
                                                  resumeVideo();
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: Text(rightLeft,
                                                  textAlign: TextAlign.center,textScaleFactor: 1.0,
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
