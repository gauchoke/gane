import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:spring_button/spring_button.dart';
import 'package:gane/src/Utils/utils.dart';


final singleton = Singleton();
double heighty = 0.0;
servicesManager servicemanager = servicesManager();
final notifierTapNotification = ValueNotifier(true);
final prefs = SharePreference();

dialogUpdateVersion(BuildContext contextContainer, Function update) async {

  print(MediaQuery.of(contextContainer).size.height); ///724
  print(MediaQuery.of(contextContainer).devicePixelRatio); /// 3.0

  if(MediaQuery.of(contextContainer).devicePixelRatio == 3.0){
    heighty = 20.0;
  }else if(MediaQuery.of(contextContainer).devicePixelRatio < 3.0){
    heighty = 80.0;
  }


  /*return showAnimatedDialog(
    barrierDismissible: false,
    context: contextContainer,
    animationType: DialogTransitionType.slideFromBottomFade,
    curve: Curves.easeOutQuad,
    duration: Duration(milliseconds: 600),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3,sigmaY: 3),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Material(
              type: MaterialType.transparency,
              child:  Stack(
                alignment: Alignment.center,
                children: [

                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child:  Container(
                        //alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 20, left: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: CustomColors.white, //                   <--- border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(const Radius.circular(30)),
                        ),
                        child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[


                              SizedBox(height: 30,),

                              /// sure logout
                              Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  alignment: Alignment.center,
                                  child: Text(Strings.updateversion,
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: Strings.font_bold,
                                          fontSize: 20,
                                          color: CustomColors.blueBack))
                              ),


                              SizedBox(height: 15,),

                              /// Buttons
                              Container(

                                height: 60,
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [

                                    SizedBox(width: 20,),

                                    Expanded(
                                      child: SpringButton(
                                        SpringButtonType.OnlyScale,
                                        Container(
                                          width: double.infinity,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: CustomColors.orangeback,
                                            borderRadius: BorderRadius.all(const Radius.circular(30)),
                                            border: Border.all(
                                              width: 1,
                                              color: CustomColors.orangeback,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: <Widget>[

                                                /// languaje
                                                Expanded(
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      Strings.updateversion1,
                                                      textScaleFactor: 1.0,
                                                      textAlign: TextAlign.center,
                                                      //maxLines: 1,
                                                      style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 14.0,),
                                                      //maxLines: 1,
                                                    ),
                                                  ),
                                                ),

                                              ],

                                            ),
                                          ),
                                        ),
                                        useCache: false,
                                        onTap: (){
                                          update();
                                        },

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                  ],

                                ),
                              ),

                              SizedBox(height: 25,),

                            ]),
                      ),
                    ),
                  ),


                ],

              )
          ),
        ),
      );
    },
  );*/

  showDialog(
      context: contextContainer,
      barrierDismissible: true,
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3,sigmaY: 3),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Material(
              type: MaterialType.transparency,
              child:  Stack(
                alignment: Alignment.center,
                children: [

                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child:  Container(
                        //alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 20, left: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: CustomColors.white, //                   <--- border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(const Radius.circular(30)),
                        ),
                        child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[


                              SizedBox(height: 30,),

                              /// sure logout
                              Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  alignment: Alignment.center,
                                  child: Text(Strings.updateversion,
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: Strings.font_bold,
                                          fontSize: 20,
                                          color: CustomColors.blueBack))
                              ),


                              SizedBox(height: 15,),

                              /// Buttons
                              Container(

                                height: 60,
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [

                                    SizedBox(width: 20,),

                                    Expanded(
                                      child: SpringButton(
                                        SpringButtonType.OnlyScale,
                                        Container(
                                          width: double.infinity,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: CustomColors.orangeback,
                                            borderRadius: BorderRadius.all(const Radius.circular(30)),
                                            border: Border.all(
                                              width: 1,
                                              color: CustomColors.orangeback,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: <Widget>[

                                                /// languaje
                                                Expanded(
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      Strings.updateversion1,
                                                      textScaleFactor: 1.0,
                                                      textAlign: TextAlign.center,
                                                      //maxLines: 1,
                                                      style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 14.0,),
                                                      //maxLines: 1,
                                                    ),
                                                  ),
                                                ),

                                              ],

                                            ),
                                          ),
                                        ),
                                        useCache: false,
                                        onTap: (){
                                          update();
                                        },

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                  ],

                                ),
                              ),

                              SizedBox(height: 25,),

                            ]),
                      ),
                    ),
                  ),


                ],

              )
          ),
        ),
      )
  );

}

void _changePushState(bool value) {

}

/// Logo
