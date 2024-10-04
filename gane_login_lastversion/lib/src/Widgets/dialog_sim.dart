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

dialogSIM(BuildContext contextContainer, double x, double y) async {

  print("Height screen: "+MediaQuery.of(contextContainer).size.height.toString()); ///724

  /*return showAnimatedDialog(
    barrierDismissible: false,
    context: contextContainer,
    animationType: DialogTransitionType.slideFromBottomFade,
    curve: Curves.easeOutQuad,
    duration: Duration(milliseconds: 600),
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0,sigmaY: 0),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Material(
              type: MaterialType.transparency,
              child:  Stack(
                alignment: Alignment.center,
                children: [


                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:  Container(
                        //width: 192,
                        //alignment: Alignment.center,
                        //margin: EdgeInsets.only(left: 15,top: MediaQuery.of(contextContainer).size.height - y <= 100 ? y - 120 : y ),
                        margin: EdgeInsets.only(left: 15,top: y -250),
                        padding: EdgeInsets.all(15),
                        //width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: CustomColors.white, //                   <--- border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(const Radius.circular(11)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image(
                          image: AssetImage("assets/images/img_card_gane.png"),
                          fit: BoxFit.contain,
                          width: 192,
                        ),
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
        filter: ImageFilter.blur(sigmaX: 0,sigmaY: 0),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Material(
              type: MaterialType.transparency,
              child:  Stack(
                alignment: Alignment.center,
                children: [


                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child:  Container(
                        //width: 192,
                        //alignment: Alignment.center,
                        //margin: EdgeInsets.only(left: 15,top: MediaQuery.of(contextContainer).size.height - y <= 100 ? y - 120 : y ),
                        margin: EdgeInsets.only(left: 15,top: y -250),
                        padding: EdgeInsets.all(15),
                        //width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: CustomColors.white, //                   <--- border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(const Radius.circular(11)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image(
                          image: AssetImage("assets/images/img_card_gane.png"),
                          fit: BoxFit.contain,
                          width: 192,
                        ),
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

