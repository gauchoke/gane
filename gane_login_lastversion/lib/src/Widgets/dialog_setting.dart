import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/UI/Home/editprofile.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/dialog_disableNoti.dart';
import 'package:gane/src/Widgets/dialog_logout.dart';
import 'package:page_transition/page_transition.dart';
import 'package:transition/transition.dart';


final singleton = Singleton();
double heighty = 0.0;
servicesManager servicemanager = servicesManager();
final notifierTapNotification = ValueNotifier(singleton.notifierSettingUser.value.data!.notificationStatus == 0 ? true : false);
var valor;

dialogSetting(BuildContext contextContainer) async {

  print(MediaQuery.of(contextContainer).size.height); ///724
  print(MediaQuery.of(contextContainer).devicePixelRatio); /// 3.0

  notifierTapNotification.value = singleton.notifierSettingUser.value.data!.notificationStatus == 0 ? true : false;
  print(notifierTapNotification.value);

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
                        margin: EdgeInsets.only(right: 15, left: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: CustomColors.white,
                            border: Border.all(
                              color: CustomColors.textError, //                   <--- border color
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.all(const Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
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
                                        'assets/images/ic_close_profile .svg',
                                        fit: BoxFit.contain,
                                        width: 35,
                                        height: 35,
                                        //color: CustomColors.greyplaceholder
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 15,),

                                  /// Setting account
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text(Strings.settingaccount,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontFamily: Strings.font_medium,
                                              fontSize: 19,
                                              color: CustomColors.orangesnack))
                                  ),

                                  SizedBox(height: 15,),

                                  /// User image
                                  Container(
                                    alignment: Alignment.center,
                                    child: Stack(

                                      children: [

                                        ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 2.5,top: 2.5),
                                          //alignment: Alignment.center,
                                          child: ClipOval(
                                            child: ValueListenableBuilder<Getprofile>(
                                                valueListenable: singleton.notifierUserProfile,
                                                builder: (context,value1,_){

                                                  return CachedNetworkImage(
                                                    width: 45,
                                                    height: 45,
                                                    imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                    //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                      width: 45,
                                                      height: 45,
                                                    ),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    useOldImageOnUrlChange: false,

                                                  );

                                                }

                                            ),

                                          ),
                                        ),

                                      ],

                                    ),
                                  ),

                                  SizedBox(height: 15,),

                                  /// User data
                                  Row(

                                    children: [

                                      /// Container space
                                      Container(
                                        margin: EdgeInsets.only(left: 20,right: 10),
                                        width: 20,
                                      ),

                                      /// User data
                                      ValueListenableBuilder<Getprofile>(
                                          valueListenable: singleton.notifierUserProfile,
                                          builder: (context,value1,_){

                                            return Expanded(
                                              child: Container(

                                                child: Column(

                                                  children: [

                                                    /// username
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      child: Text(value1.data!.user!.fullname!,
                                                        textScaleFactor: 1.0,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.textSwitch, fontSize: 11,),
                                                      ),
                                                    ),

                                                    SizedBox(height: 10,),

                                                    /// email
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      child: Text(value1.data!.user!.email!,
                                                        textScaleFactor: 1.0,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.textSwitch, fontSize: 11,),
                                                      ),
                                                    )

                                                  ],

                                                ),

                                              ),
                                            );

                                          }

                                      ),

                                      /// Edit button
                                      InkWell(
                                        onTap: (){
                                          /*Navigator.push(
                                            context,
                                            PageRouteBuilder<dynamic>(
                                              transitionDuration: const Duration(milliseconds: 400),
                                              reverseTransitionDuration: const Duration(milliseconds: 400),
                                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => EditProfile(),
                                              transitionsBuilder: (
                                                  BuildContext context,
                                                  Animation<double> animation,
                                                  Animation<double> secondaryAnimation,
                                                  Widget child,
                                                  ) {
                                                final Tween<Offset> offsetTween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
                                                final Animation<Offset> slideInFromTheRightAnimation = offsetTween.animate(animation);
                                                return SlideTransition(
                                                    position: slideInFromTheRightAnimation,
                                                    child: child
                                                );
                                              },
                                            ),
                                          );*/

                                          var time = 350;
                                          if(singleton.isIOS == false){
                                            time = utils.ValueDuration();
                                          }

                                          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child:EditProfile(),
                                              reverseDuration: Duration(milliseconds: time)
                                          ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10,right: 20),
                                          child: SvgPicture.asset(
                                            'assets/images/ic_edit.svg',
                                            fit: BoxFit.cover,
                                            width: 20,
                                            height: 20,
                                            //color: CustomColors.greyplaceholder
                                          ),
                                        ),
                                      ),

                                    ],

                                  ),

                                  SizedBox(height: 15,),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 10,bottom: 20),
                                  ),

                                  /// Notifications
                                  Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: Text(Strings.notifi,
                                        textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontFamily: Strings.font_bold,
                                              fontSize: 15,
                                              color: CustomColors.orangesnack),
                                              textAlign: TextAlign.start,
                                      )
                                  ),

                                  SizedBox(height: 10,),

                                  /// Setting notifications
                                  Row(

                                    children: [

                                      /// Notifications
                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.only(left: 35),
                                            child: Text(Strings.notifi1,
                                              textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontFamily: Strings.font_regular,
                                                    fontSize: 13,
                                                    color: CustomColors.textSwitch),
                                              textAlign: TextAlign.start,
                                            )
                                        ),
                                      ),

                                      /// Switch
                                      Container(
                                        margin: EdgeInsets.only(right: 25),
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: notifierTapNotification,
                                            builder: (context,value2,_){

                                              return FlutterSwitch(
                                                width: 50.0,
                                                height: 30.0,
                                                toggleSize: 30.0,
                                                value: value2,
                                                borderRadius: 17.0,
                                                padding: 2.0,
                                                toggleColor: value2== false ? CustomColors.grayTextemptyhome : CustomColors.orangeswitch,
                                                switchBorder: Border.all(
                                                  color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.orangeswitch,
                                                  width: 1.0,
                                                ),
                                                toggleBorder: Border.all(
                                                  color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.orangeswitch,
                                                  width: 1.0,
                                                ),
                                                activeColor: CustomColors.white,
                                                inactiveColor: CustomColors.white,
                                                onToggle: (val) {

                                                  valor = val;
                                                  dialogDisableNoti(contextContainer,disable);


                                                },
                                              );

                                            }

                                        ),
                                      ),



                                    ],

                                  ),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 10,bottom: 20),
                                  ),

                                  /// Legal
                                  Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: Text(Strings.moreinfo,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontFamily: Strings.font_bold,
                                            fontSize: 15,
                                            color: CustomColors.orangesnack),
                                        textAlign: TextAlign.start,
                                      )
                                  ),

                                  SizedBox(height: 25,),

                                  /// Polities
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.polities, title: Strings.tyc1,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: singleton.polities, title: Strings.tyc1,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.tyc1,style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.textSwitch, fontSize: 13.0,
                                              decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,

                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  /// Tyc
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.terms, title: Strings.terms_conditions,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: singleton.terms, title: Strings.terms_conditions,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.terms_conditions,style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.textSwitch, fontSize: 13.0,
                                              decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,
                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 30,bottom: 25),
                                  ),

                                  /// Contact us
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.contactus, title: Strings.contactus,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: singleton.contactus, title: Strings.contactus,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.contactus,style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 15.0,
                                              //decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,
                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  /// About us
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.about, title: Strings.aboutus,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child:TyC(url: singleton.about, title: Strings.aboutus,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.aboutus,style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 15.0,
                                              //decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,
                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 25,bottom: 30),
                                  ),

                                  /// LogOut
                                  InkWell(
                                    onTap: (){
                                      dialogLogout(contextContainer);
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(Strings.log_out ,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontFamily: Strings.font_bold,
                                              fontSize: 15,
                                              color: CustomColors.orangeswitch),
                                          textAlign: TextAlign.center,
                                        )
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  /// Versión
                                  Container(
                                    alignment: Alignment.center,
                                      child: Text("v." + singleton.packageInfo.version + "-" + singleton.packageInfo.buildNumber,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontFamily: Strings.font_medium,
                                            fontSize: 13,
                                            color: CustomColors.grayTextemptyhome),
                                        textAlign: TextAlign.center,
                                      )
                                  ),

                                  SizedBox(height: 25,),


                                ]),
                          ),
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
                        margin: EdgeInsets.only(right: 15, left: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: CustomColors.textError, //                   <--- border color
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.all(const Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
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
                                        'assets/images/ic_close_profile .svg',
                                        fit: BoxFit.contain,
                                        width: 35,
                                        height: 35,
                                        //color: CustomColors.greyplaceholder
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 15,),

                                  /// Setting account
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text(Strings.settingaccount,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontFamily: Strings.font_medium,
                                              fontSize: 19,
                                              color: CustomColors.orangesnack))
                                  ),

                                  SizedBox(height: 15,),

                                  /// User image
                                  Container(
                                    alignment: Alignment.center,
                                    child: Stack(

                                      children: [

                                        ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 2.5,top: 2.5),
                                          //alignment: Alignment.center,
                                          child: ClipOval(
                                            child: ValueListenableBuilder<Getprofile>(
                                                valueListenable: singleton.notifierUserProfile,
                                                builder: (context,value1,_){

                                                  return CachedNetworkImage(
                                                    width: 45,
                                                    height: 45,
                                                    imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                    //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                                    placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                      width: 45,
                                                      height: 45,
                                                    ),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    useOldImageOnUrlChange: false,

                                                  );

                                                }

                                            ),

                                          ),
                                        ),

                                      ],

                                    ),
                                  ),

                                  SizedBox(height: 15,),

                                  /// User data
                                  Row(

                                    children: [

                                      /// Container space
                                      Container(
                                        margin: EdgeInsets.only(left: 20,right: 10),
                                        width: 20,
                                      ),

                                      /// User data
                                      ValueListenableBuilder<Getprofile>(
                                          valueListenable: singleton.notifierUserProfile,
                                          builder: (context,value1,_){

                                            return Expanded(
                                              child: Container(

                                                child: Column(

                                                  children: [

                                                    /// username
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      child: Text(value1.data!.user!.fullname!,
                                                        textScaleFactor: 1.0,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.textSwitch, fontSize: 11,),
                                                      ),
                                                    ),

                                                    SizedBox(height: 10,),

                                                    /// email
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      child: Text(value1.data!.user!.email!,
                                                        textScaleFactor: 1.0,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.textSwitch, fontSize: 11,),
                                                      ),
                                                    )

                                                  ],

                                                ),

                                              ),
                                            );

                                          }

                                      ),

                                      /// Edit button
                                      InkWell(
                                        onTap: (){
                                          /*Navigator.push(
                                            context,
                                            PageRouteBuilder<dynamic>(
                                              transitionDuration: const Duration(milliseconds: 400),
                                              reverseTransitionDuration: const Duration(milliseconds: 400),
                                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => EditProfile(),
                                              transitionsBuilder: (
                                                  BuildContext context,
                                                  Animation<double> animation,
                                                  Animation<double> secondaryAnimation,
                                                  Widget child,
                                                  ) {
                                                final Tween<Offset> offsetTween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
                                                final Animation<Offset> slideInFromTheRightAnimation = offsetTween.animate(animation);
                                                return SlideTransition(
                                                    position: slideInFromTheRightAnimation,
                                                    child: child
                                                );
                                              },
                                            ),
                                          );*/

                                          var time = 350;
                                          if(singleton.isIOS == false){
                                            time = utils.ValueDuration();
                                          }

                                          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child:EditProfile(),
                                              reverseDuration: Duration(milliseconds: time)
                                          ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10,right: 20),
                                          child: SvgPicture.asset(
                                            'assets/images/ic_edit.svg',
                                            fit: BoxFit.cover,
                                            width: 20,
                                            height: 20,
                                            //color: CustomColors.greyplaceholder
                                          ),
                                        ),
                                      ),

                                    ],

                                  ),

                                  SizedBox(height: 15,),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 10,bottom: 20),
                                  ),

                                  /// Notifications
                                  Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: Text(Strings.notifi,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontFamily: Strings.font_bold,
                                            fontSize: 15,
                                            color: CustomColors.orangesnack),
                                        textAlign: TextAlign.start,
                                      )
                                  ),

                                  SizedBox(height: 10,),

                                  /// Setting notifications
                                  Row(

                                    children: [

                                      /// Notifications
                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.only(left: 35),
                                            child: Text(Strings.notifi1,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontFamily: Strings.font_regular,
                                                  fontSize: 13,
                                                  color: CustomColors.textSwitch),
                                              textAlign: TextAlign.start,
                                            )
                                        ),
                                      ),

                                      /// Switch
                                      Container(
                                        margin: EdgeInsets.only(right: 25),
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: notifierTapNotification,
                                            builder: (context,value2,_){

                                              return FlutterSwitch(
                                                width: 50.0,
                                                height: 30.0,
                                                toggleSize: 30.0,
                                                value: value2,
                                                borderRadius: 17.0,
                                                padding: 2.0,
                                                toggleColor: value2== false ? CustomColors.grayTextemptyhome : CustomColors.orangeswitch,
                                                switchBorder: Border.all(
                                                  color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.orangeswitch,
                                                  width: 1.0,
                                                ),
                                                toggleBorder: Border.all(
                                                  color: value2== false ? CustomColors.grayTextemptyhome : CustomColors.orangeswitch,
                                                  width: 1.0,
                                                ),
                                                activeColor: CustomColors.white,
                                                inactiveColor: CustomColors.white,
                                                onToggle: (val) {

                                                  valor = val;
                                                  dialogDisableNoti(contextContainer,disable);


                                                },
                                              );

                                            }

                                        ),
                                      ),



                                    ],

                                  ),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 10,bottom: 20),
                                  ),

                                  /// Legal
                                  Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: Text(Strings.moreinfo,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontFamily: Strings.font_bold,
                                            fontSize: 15,
                                            color: CustomColors.orangesnack),
                                        textAlign: TextAlign.start,
                                      )
                                  ),

                                  SizedBox(height: 25,),

                                  /// Polities
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.polities, title: Strings.tyc1,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: singleton.polities, title: Strings.tyc1,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.tyc1,style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.textSwitch, fontSize: 13.0,
                                              decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,

                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  /// Tyc
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.terms, title: Strings.terms_conditions,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: singleton.terms, title: Strings.terms_conditions,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.terms_conditions,style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.textSwitch, fontSize: 13.0,
                                              decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,
                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 30,bottom: 25),
                                  ),

                                  /// Contact us
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.contactus, title: Strings.contactus,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: singleton.contactus, title: Strings.contactus,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.contactus,style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 15.0,
                                              //decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,
                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  /// About us
                                  InkWell(
                                    onTap: (){
                                      //Navigator.push(context, Transition(child: TyC(url: singleton.about, title: Strings.aboutus,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child:TyC(url: singleton.about, title: Strings.aboutus,),
                                          reverseDuration: Duration(milliseconds: time)
                                      ));


                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 35,right: 35),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.aboutus,style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 15.0,
                                              //decoration: TextDecoration.underline,
                                              decorationColor: CustomColors.textSwitch,
                                            )),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Line
                                  Container(
                                    height: 1,
                                    color: CustomColors.graycountry,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: 35,right: 35,top: 25,bottom: 30),
                                  ),

                                  /// LogOut
                                  InkWell(
                                    onTap: (){
                                      dialogLogout(contextContainer);
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(Strings.log_out ,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontFamily: Strings.font_bold,
                                              fontSize: 15,
                                              color: CustomColors.orangeswitch),
                                          textAlign: TextAlign.center,
                                        )
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  /// Versión
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text("v." + singleton.packageInfo.version + "-" + singleton.packageInfo.buildNumber,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontFamily: Strings.font_medium,
                                            fontSize: 13,
                                            color: CustomColors.grayTextemptyhome),
                                        textAlign: TextAlign.center,
                                      )
                                  ),

                                  SizedBox(height: 25,),


                                ]),
                          ),
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

void disable(){

  var status = singleton.notifierSettingUser.value.data!.notificationStatus!;
  if(status==0){
    status = 1;
  }else{
    status = 0;
  }

  servicemanager.fetchSettingsNotifications(singleton.navigatorKey.currentContext!,status);
  notifierTapNotification.value = valor;

}


/// Logo
