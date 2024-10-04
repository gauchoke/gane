import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:spring_button/spring_button.dart';


final singleton = Singleton();
double heighty = 0.0;
servicesManager servicemanager = servicesManager();
final notifierTapNotification = ValueNotifier(true);
final prefs = SharePreference();

dialogLoadImage(BuildContext contextContainer, Function camera, Function gallery) async {

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



                              SizedBox(height: 20,),

                              /// sure logout
                              Container(
                                //color: Colors.green,
                                margin: EdgeInsets.only(left: 15,right: 15),
                                  //alignment: Alignment.center,
                                  child: Text(Strings.deleteuser,
                                    textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontFamily: Strings.font_medium,
                                          fontSize: 15,
                                          color: CustomColors.greyplaceholder),
                                    textAlign: TextAlign.center,
                                  )
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
                                                      Strings.deleteuser1,
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

                                          /*prefs.authToken ="0";
                                          singleton.notifierVisibleButtoms.value = 1;
                                          Future.delayed(const Duration(seconds: 1), () {
                                            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
                                          });*/

                                          singleton.notifierValueYButtons.value = 0;
                                          /*utils.openProgress(context);
                                          servicemanager.fetchLogout(context);*/
                                          disable();
                                          Navigator.pop(context);
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
              child: InkWell(
                onTap: (){
                  utils.stopLoading();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child:  Opacity(
                  opacity: 1.0,
                  child:  Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    //margin: EdgeInsets.only(left: 35, right: 35),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.only(left: 15,right: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(28),topLeft:  Radius.circular(28)),
                            ),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[

                                //Title
                                Container(
                                  margin:  EdgeInsets.only(top: 30,bottom: 30),
                                  child: Text(Strings.choosesource,style: TextStyle(letterSpacing: 0.5,fontFamily: Strings.font_bold, fontSize: 18, color: CustomColors.orangeswitch),textScaleFactor: 1.0,),

                                ),

                                //Camera
                                InkWell(
                                  onTap: (){
                                    camera();
                                    //_listener.openCamera();
                                  },
                                  child: Container(

                                    margin: EdgeInsets.only(left: 10,right: 10),

                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: CustomColors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.transparent, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        //margin: EdgeInsets.only(top: 5,bottom: 5),

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: <Widget>[


                                            Container(
                                              //margin: EdgeInsets.only(left: 40,top: 40),
                                              child: SvgPicture.asset(
                                                'assets/images/icono2.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),


                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(Strings.camera,
                                                  style: TextStyle(
                                                    fontFamily: Strings.font_medium,
                                                    fontSize: 16,
                                                    color: CustomColors.grayalert1,),
                                                  textScaleFactor: 1.0,
                                                  textAlign: TextAlign.center),
                                            ),


                                          ],

                                        ),
                                      ),
                                    ),


                                  ),
                                ),

                                //Video
                                InkWell(
                                  onTap: (){
                                    gallery();
                                    //_listener.openGallery();
                                  },
                                  child: Container(

                                    margin: EdgeInsets.only(left: 10,right: 10, top: 20),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: CustomColors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.transparent, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5,bottom: 5),

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: <Widget>[


                                            Container(
                                              //margin: EdgeInsets.only(left: 40,top: 40),
                                              child: SvgPicture.asset(
                                                'assets/images/icono12.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),


                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(Strings.gallery,
                                                  style: TextStyle(
                                                    fontFamily: Strings.font_medium,
                                                    fontSize: 16,
                                                    color: CustomColors.grayalert1,),
                                                  textScaleFactor: 1.0,
                                                  textAlign: TextAlign.start),
                                            ),


                                          ],

                                        ),
                                      ),
                                    ),


                                  ),
                                ),

                                SizedBox(height: 20,)
                                //Cancel
                                /*Container(
                              margin: EdgeInsets.only(left: 30, right: 30, top: 35, bottom: 30),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                //color: _stateLogin && _stateContinue ? CustomColors.blueorders : Colors.transparent,
                                //border: _stateLogin && _stateContinue ? Border.all(color: CustomColors.transparent, width: 1) : Border.all(color: CustomColors.grayborder, width: 1),
                                  color: CustomColors.blueback,
                                  borderRadius: BorderRadius.all(const Radius.circular(20.0))),
                              child: Builder(builder: (BuildContext context) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Visibility(
                                        child: Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnContinueLogin'),
                                              onPressed: () {
                                                dismissDialog();
                                                //Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, duration: Duration(milliseconds: 200) , child: SocioNO()));

                                              },
                                              child: Text(Strings.cancel,
                                                  style: TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontFamily: Strings.font_medium,
                                                      fontSize: 16,
                                                      color:  CustomColors.white)
                                              )),
                                        )),
                                  ],
                                );
                              })),*/


                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              )
          )
        ),
      )
  );


}


