import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

dialogBlur(BuildContext contextContainer, String title, String message,
    String buttonLeft, String buttonRight, String module) async {


  return showDialog(
    context: contextContainer,

    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6,sigmaY: 6),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.all(const Radius.circular(25))),
                  child: Column(children: <Widget>[

                    Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Image(
                          image: AssetImage("assets/images/ic_alert.png"),
                          width: 80.0,
                          height:80.0,
                        )
                    ),

                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(title,
                            style: TextStyle(
                                fontFamily: Strings.font_bold,
                                fontSize: 16,
                                color: CustomColors.black))),

                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10),
                        child: Text(message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: Strings.font_regular,
                                fontSize: 15,
                                color: CustomColors.blueunderline))),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: <Widget>[
                        module == "telf" ? Container() : Expanded(
                            child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: CustomColors.reddelete,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(15))),
                                child: Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    child: TextButton(
                                        key: Key('btnButtonLeft'),
                                        onPressed: () {


                                          Navigator.pop(context);

                                        },
                                        child: Text(buttonLeft,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: Strings.font_bold,
                                                fontSize: 16,
                                                color: CustomColors.white))),
                                  );
                                }))),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    color: CustomColors.blueback,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(15))),
                                child: Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    child: TextButton(
                                        key: Key('btnButtonRightt'),
                                        onPressed: () {


                                          if(module == "notifications"){
                                            //SystemSetting.goto(SettingTarget.NOTIFICATION);
                                            Navigator.pop(context);
                                            openAppSettings();
                                          }else if(module == "camera" || module == "video"){
                                            //AppSettings.openAppSettings();
                                            Navigator.pop(context);
                                            openAppSettings();
                                          }else if(module == "gps"){
                                            //SystemSetting.goto(SettingTarget.WIFI);
                                            //AppSettings.openAppSettings();
                                            Navigator.pop(context);
                                            openAppSettings();
                                          }else if(module == "telf"){
                                            //SystemSetting.goto(SettingTarget.NOTIFICATION);
                                            utils.requestPermission(singleton.permission);
                                            openAppSettings();
                                          }

                                        },
                                        child: Text(buttonRight,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: Strings.font_bold,
                                                fontSize: 16,
                                                color: CustomColors.white))),
                                  );
                                })))
                      ],
                    ),

                  ])
              ),
            ],
          ),
        ),
      );
    },
  );

}
