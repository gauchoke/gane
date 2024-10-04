import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
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

dialogBanner(BuildContext contextContainer, Function launchCallOrWhat) async {

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
                        margin: EdgeInsets.only(right: 30, left: 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.all(const Radius.circular(30)),
                        ),
                        child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(

                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 10,),
                                  child: SvgPicture.asset(
                                    'assets/images/ic_close_mira.svg',
                                    fit: BoxFit.cover,
                                    width: 30,
                                    height: 30,

                                    //color: CustomColors.greyplaceholder
                                  ),
                                ),
                              ),

                              /// Order your SIM
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(Strings.ordersim,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontFamily: Strings.font_bold,
                                          fontSize: 20,
                                          color: CustomColors.orangesnack))
                              ),

                              SizedBox(height: 20,),

                              /// Buttons
                              Container(

                                //height: 60,
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [

                                    SizedBox(width: 20,),

                                    Expanded(
                                      child: SpringButton(
                                        SpringButtonType.OnlyScale,
                                        Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: <Widget>[

                                                Container(
                                                  child: SvgPicture.asset(
                                                    'assets/images/callbutton.svg',
                                                    fit: BoxFit.contain,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),

                                                SizedBox(height: 5,),

                                                /// Call
                                                Container(
                                                  child: AutoSizeText(
                                                    Strings.ordersim1,
                                                    textScaleFactor: 1.0,
                                                    textAlign: TextAlign.center,
                                                    //maxLines: 1,
                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.grayalert1, fontSize: 14.0,),
                                                    //maxLines: 1,
                                                  ),
                                                ),

                                              ],

                                            ),
                                          ),
                                        ),
                                        useCache: false,
                                        onTap: (){
                                          launchCallOrWhat(singleton.notifierBannerAltan.value.data!.item!.callingCode!+singleton.notifierBannerAltan.value.data!.item!.sms!);
                                          //Navigator.pop(context);
                                          //utils.callOrWebView(singleton.notifierBannerAltan.value.data!.item!.callingCode!+singleton.notifierBannerAltan.value.data!.item!.sms!);
                                        },

                                        //onTapDown: (_) => decrementCounter(),

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                    Expanded(
                                      child: SpringButton(
                                        SpringButtonType.OnlyScale,
                                        Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: <Widget>[

                                                Container(
                                                  child: SvgPicture.asset(
                                                    'assets/images/whatsappbutton.svg',
                                                    fit: BoxFit.contain,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),

                                                SizedBox(height: 5,),

                                                /// Call
                                                Container(
                                                  child: AutoSizeText(
                                                    Strings.ordersim2,
                                                    textScaleFactor: 1.0,
                                                    textAlign: TextAlign.center,
                                                    //maxLines: 1,
                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.grayalert1, fontSize: 14.0,),
                                                    //maxLines: 1,
                                                  ),
                                                ),

                                              ],

                                            ),
                                          ),
                                        ),
                                        useCache: false,
                                        onTap: (){
                                          launchCallOrWhat("https://wa.me/"+singleton.notifierBannerAltan.value.data!.item!.callingCode!+singleton.notifierBannerAltan.value.data!.item!.whatsapp!);
                                          //launchCallOrWhat("https://wa.me/+573044313041");
                                          //Navigator.pop(context);
                                        },

                                        //onTapDown: (_) => decrementCounter(),

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
                        margin: EdgeInsets.only(right: 30, left: 30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.all(const Radius.circular(30)),
                        ),
                        child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Container(

                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 10,),
                                  child: SvgPicture.asset(
                                    'assets/images/ic_close_mira.svg',
                                    fit: BoxFit.cover,
                                    width: 30,
                                    height: 30,

                                    //color: CustomColors.greyplaceholder
                                  ),
                                ),
                              ),

                              /// Order your SIM
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(Strings.ordersim,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontFamily: Strings.font_bold,
                                          fontSize: 20,
                                          color: CustomColors.orangesnack))
                              ),

                              SizedBox(height: 20,),

                              /// Buttons
                              Container(

                                //height: 60,
                                child: Row(

                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [

                                    SizedBox(width: 20,),

                                    Expanded(
                                      child: SpringButton(
                                        SpringButtonType.OnlyScale,
                                        Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: <Widget>[

                                                Container(
                                                  child: SvgPicture.asset(
                                                    'assets/images/callbutton.svg',
                                                    fit: BoxFit.contain,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),

                                                SizedBox(height: 5,),

                                                /// Call
                                                Container(
                                                  child: AutoSizeText(
                                                    Strings.ordersim1,
                                                    textScaleFactor: 1.0,
                                                    textAlign: TextAlign.center,
                                                    //maxLines: 1,
                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.grayalert1, fontSize: 14.0,),
                                                    //maxLines: 1,
                                                  ),
                                                ),

                                              ],

                                            ),
                                          ),
                                        ),
                                        useCache: false,
                                        onTap: (){
                                          launchCallOrWhat(singleton.notifierBannerAltan.value.data!.item!.callingCode!+singleton.notifierBannerAltan.value.data!.item!.sms!);
                                          //Navigator.pop(context);
                                          //utils.callOrWebView(singleton.notifierBannerAltan.value.data!.item!.callingCode!+singleton.notifierBannerAltan.value.data!.item!.sms!);
                                        },

                                        //onTapDown: (_) => decrementCounter(),

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                    Expanded(
                                      child: SpringButton(
                                        SpringButtonType.OnlyScale,
                                        Container(
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: <Widget>[

                                                Container(
                                                  child: SvgPicture.asset(
                                                    'assets/images/whatsappbutton.svg',
                                                    fit: BoxFit.contain,
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ),

                                                SizedBox(height: 5,),

                                                /// Call
                                                Container(
                                                  child: AutoSizeText(
                                                    Strings.ordersim2,
                                                    textScaleFactor: 1.0,
                                                    textAlign: TextAlign.center,
                                                    //maxLines: 1,
                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.grayalert1, fontSize: 14.0,),
                                                    //maxLines: 1,
                                                  ),
                                                ),

                                              ],

                                            ),
                                          ),
                                        ),
                                        useCache: false,
                                        onTap: (){
                                          launchCallOrWhat("https://wa.me/"+singleton.notifierBannerAltan.value.data!.item!.callingCode!+singleton.notifierBannerAltan.value.data!.item!.whatsapp!);
                                          //launchCallOrWhat("https://wa.me/+573044313041");
                                          //Navigator.pop(context);
                                        },

                                        //onTapDown: (_) => decrementCounter(),

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
