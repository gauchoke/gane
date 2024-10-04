import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:spring_button/spring_button.dart';


final singleton = Singleton();
double heighty = 0.0;
servicesManager servicemanager = servicesManager();
final notifierTapNotification = ValueNotifier(true);
final prefs = SharePreference();
final notifierTapDeleteNotification = ValueNotifier(false);
String state = "inactive";

dialogDeleteNoification(BuildContext contextContainer, Function deleteNotification, int itemdelete, int itemdelete1) async {

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
                      alignment: Alignment.bottomCenter,
                      child:  Container(
                        //alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 30, left: 30,bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: CustomColors.white,
                            border: Border.all(
                              color: CustomColors.textError, //                   <--- border color
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.all(const Radius.circular(30)),
                        ),
                        child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[


                              SizedBox(height: 15,),

                              /// Alert
                              Container(
                                padding: EdgeInsets.only(left: 20,right: 20),
                                  alignment: Alignment.topLeft,
                                  child: Text(Strings.deletenoti,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontFamily: Strings.font_regular,
                                          fontSize: 13,
                                          color: CustomColors.grayButton))
                              ),

                              SizedBox(height: 15,),

                              /// sure delete
                              Container(
                                  padding: EdgeInsets.only(left: 20,right: 20),
                                  alignment: Alignment.center,
                                  child: Text(Strings.deletenoti1,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontFamily: Strings.font_bold,
                                          fontSize: 15,
                                          color: CustomColors.orangeback))
                              ),

                              SizedBox(height: 20,),

                              /// Switch
                              Container(
                                  padding: EdgeInsets.only(left: 20,right: 20),
                                  child: Row(

                                    children: [

                                      /// Switch
                                      Container(
                                        //margin: EdgeInsets.only(right: 25),
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: notifierTapDeleteNotification,
                                            builder: (context,value2,_){

                                              return FlutterSwitch(
                                                width: 50.0,
                                                height: 30.0,
                                                toggleSize: 30.0,
                                                value: value2,
                                                borderRadius: 17.0,
                                                padding: 2.0,
                                                toggleColor: value2== false ? CustomColors.grayTextemptyhome : CustomColors.blueBack,
                                                switchBorder: Border.all(
                                                  color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.blueBack,
                                                  width: 1.0,
                                                ),
                                                toggleBorder: Border.all(
                                                  color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.blueBack,
                                                  width: 1.0,
                                                ),
                                                activeColor: CustomColors.white,
                                                inactiveColor: CustomColors.white,
                                                onToggle: (val) {
                                                  var status = val;
                                                  notifierTapDeleteNotification.value = val;

                                                  if(val==false){
                                                    state = "inactive";
                                                  }else state = "active";
                                                },
                                              );

                                            }

                                        ),
                                      ),

                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.only(left: 10,right: 20),
                                            alignment: Alignment.topLeft,
                                            child: Text(Strings.deletenoti2,
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontFamily: Strings.font_regular,
                                                    fontSize: 13,
                                                    color: CustomColors.grayButton))
                                        ),
                                      ),

                                    ],

                                  ),
                              ),

                              SizedBox(height: 20,),

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
                                            color: CustomColors.graybackhome,
                                            borderRadius: BorderRadius.all(const Radius.circular(30)),
                                            border: Border.all(
                                              width: 1,
                                              color: CustomColors.graybackhome,
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
                                                      Strings.activate2,
                                                      textScaleFactor: 1.0,
                                                      textAlign: TextAlign.center,
                                                      //maxLines: 1,
                                                      style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.grayalert1, fontSize: 14.0,),
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
                                          Navigator.pop(context);
                                        },

                                        //onTapDown: (_) => decrementCounter(),

                                      ),
                                    ),

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
                                                      Strings.deletenoti3,
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

                                          utils.openProgress(context);
                                          servicemanager.fetchDeleteNotifications(context, itemdelete,itemdelete1, state, deleteNotification);

                                        },

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                  ],

                                ),
                              ),

                              SizedBox(height: 15,),

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
                      alignment: Alignment.bottomCenter,
                      child:  Container(
                        //alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 30, left: 30,bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: CustomColors.textError, //                   <--- border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(const Radius.circular(30)),
                        ),
                        child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[


                              SizedBox(height: 15,),

                              /// Alert
                              Container(
                                  padding: EdgeInsets.only(left: 20,right: 20),
                                  alignment: Alignment.topLeft,
                                  child: Text(Strings.deletenoti,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontFamily: Strings.font_regular,
                                          fontSize: 13,
                                          color: CustomColors.grayButton))
                              ),

                              SizedBox(height: 15,),

                              /// sure delete
                              Container(
                                  padding: EdgeInsets.only(left: 20,right: 20),
                                  alignment: Alignment.center,
                                  child: Text(Strings.deletenoti1,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontFamily: Strings.font_bold,
                                          fontSize: 15,
                                          color: CustomColors.orangeback))
                              ),

                              SizedBox(height: 20,),

                              /// Switch
                              Container(
                                padding: EdgeInsets.only(left: 20,right: 20),
                                child: Row(

                                  children: [

                                    /// Switch
                                    Container(
                                      //margin: EdgeInsets.only(right: 25),
                                      child: ValueListenableBuilder<bool>(
                                          valueListenable: notifierTapDeleteNotification,
                                          builder: (context,value2,_){

                                            return FlutterSwitch(
                                              width: 50.0,
                                              height: 30.0,
                                              toggleSize: 30.0,
                                              value: value2,
                                              borderRadius: 17.0,
                                              padding: 2.0,
                                              toggleColor: value2== false ? CustomColors.grayTextemptyhome : CustomColors.blueBack,
                                              switchBorder: Border.all(
                                                color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.blueBack,
                                                width: 1.0,
                                              ),
                                              toggleBorder: Border.all(
                                                color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.blueBack,
                                                width: 1.0,
                                              ),
                                              activeColor: CustomColors.white,
                                              inactiveColor: CustomColors.white,
                                              onToggle: (val) {
                                                var status = val;
                                                notifierTapDeleteNotification.value = val;

                                                if(val==false){
                                                  state = "inactive";
                                                }else state = "active";
                                              },
                                            );

                                          }

                                      ),
                                    ),

                                    Expanded(
                                      child: Container(
                                          padding: EdgeInsets.only(left: 10,right: 20),
                                          alignment: Alignment.topLeft,
                                          child: Text(Strings.deletenoti2,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontFamily: Strings.font_regular,
                                                  fontSize: 13,
                                                  color: CustomColors.grayButton))
                                      ),
                                    ),

                                  ],

                                ),
                              ),

                              SizedBox(height: 20,),

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
                                            color: CustomColors.graybackhome,
                                            borderRadius: BorderRadius.all(const Radius.circular(30)),
                                            border: Border.all(
                                              width: 1,
                                              color: CustomColors.graybackhome,
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
                                                      Strings.activate2,
                                                      textScaleFactor: 1.0,
                                                      textAlign: TextAlign.center,
                                                      //maxLines: 1,
                                                      style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.grayalert1, fontSize: 14.0,),
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
                                          Navigator.pop(context);
                                        },

                                        //onTapDown: (_) => decrementCounter(),

                                      ),
                                    ),

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
                                                      Strings.deletenoti3,
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

                                          utils.openProgress(context);
                                          servicemanager.fetchDeleteNotifications(context, itemdelete,itemdelete1, state, deleteNotification);

                                        },

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                  ],

                                ),
                              ),

                              SizedBox(height: 15,),

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
