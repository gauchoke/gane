import 'dart:io';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gane/src/Models/altanplan.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/planaltandetail.dart';
import 'package:gane/src/Models/profilecategories.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/useraltam.dart';
import 'package:gane/src/Models/userpointlist.dart';
import 'package:gane/src/Models/userpointlist1.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Home/RechargePlain/RechargePlainView.dart';
import 'package:gane/src/UI/Home/detailcategory.dart';
import 'package:gane/src/UI/Home/editprofile.dart';
import 'package:gane/src/UI/Home/plansdetailsaltan.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_disableNoti.dart';
import 'package:gane/src/Widgets/dialog_logout.dart';
import 'package:gane/src/Widgets/dialog_redeem.dart';
import 'package:gane/src/Widgets/dialog_setting.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spring_button/spring_button.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:transition/transition.dart';
import 'dart:ui' as ui;
import 'package:badges/badges.dart' as badges;

class ProfileDetail extends StatefulWidget{

  final from;
  final VoidCallback? PointProfileCategorie;

  ProfileDetail({this.from, this.PointProfileCategorie});

  _stateProfileDetail createState()=> _stateProfileDetail();
}

class _stateProfileDetail extends State<ProfileDetail> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;

  final notifierHelp = ValueNotifier(0);

  late AnimationController controllerAnima;
  late Animation<double> animationIn;
  late AnimationController controllerProgress;
  late Animation<double> animationProgress;
  late AnimationController controllerCategory;
  late Animation<double> animationCategory;
  late AnimationController controller;
  late Animation<double> animationWith;

  double ratioScreen = 3.0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final notifierOpacity = ValueNotifier(0.0);
  final notifierHide = ValueNotifier(true);
  ScrollController _scrollViewController = new ScrollController();
  var heightContainerDetailPlain = 10;

  late HomeProvider providerHome;
  final notifierHeaderTab = ValueNotifier(0);

  final notifierTapNotification = ValueNotifier( false);
  var valor;


  @override
  void initState(){
    //singleton.notifierHeightPlanGane.value = 100;
    //singleton.notifierHeightHeaderWallet1.value = 180.0;

    singleton.notifierHeightHeaderWallet1.value = 150.0;

    /*utils.heightViewWinPoint();

    if(prefs.helCategories!=""){
      notifierHelp.value = 3;
    }else{

      if(singleton.notifierUserProfile.value.data!.user!.userAltan! == false){
        controllerAnima.reverse();
        Future.delayed(const Duration(milliseconds: 250), () {
          controllerProgress.forward();
        });
        notifierHelp.value = notifierHelp.value + 1;
      }

    }*/


    launchFetch();

    WidgetsBinding.instance!.addPostFrameCallback((_){

      /*Future.delayed(const Duration(milliseconds: 650), () {
        controllerAnima.forward();
        if(singleton.isOffline == false){
        }

        print(MediaQuery.of(context).size.width);
        print(MediaQuery.of(context).size.height);
        print(MediaQuery.of(context).devicePixelRatio);

      });

     _scrollViewController.addListener(() {
        if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
          singleton.notifierHeightHeaderWallet1.value = 90.0;
          singleton.notifierHeightPlanGane.value = 0.0;
        }

        if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {

          singleton.notifierHeightHeaderWallet1.value = 180.0;
          singleton.notifierHeightPlanGane.value = 100.0;
        }
      });

      singleton.notifierHeightHeaderWallet1.value = 180.0;

      Future.delayed(const Duration(milliseconds: 650), () {
        _scrollViewController.jumpTo(_scrollViewController.position.minScrollExtent);
      });*/

      _scrollViewController.addListener(() {
        if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
          singleton.notifierHeightHeaderWallet1.value = 90.0;
          singleton.notifierHeightPlanGane.value = 0.0;
        }

        if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {

          singleton.notifierHeightHeaderWallet1.value = 180.0;
          singleton.notifierHeightPlanGane.value = 100.0;
        }
      });

      singleton.notifierHeightHeaderWallet1.value = 180.0;



    });

    super.initState();
  }

  void launchFetch()async{
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        servicemanager.fetchUserProfile1(context);
        servicemanager.fetchValidateSegmentation(context);
        servicemanager.fetchSettings(context).then((value) {

          notifierTapNotification.value = singleton.notifierSettingUser.value.data!.notificationStatus == 0 ? true : false;
          print(notifierTapNotification.value);

        });
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }


  @override
  void dispose() {
    controllerAnima.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerHome =  Provider.of<HomeProvider>(context);
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                onWillPop: backHandle.callToast,
                child: Scaffold(
                    key: _scaffoldKey,
                    body: Stack(

                      children: [


                        _fields(context),

                        AppBar(launchFetch),

                        /// User Photo
                        ValueListenableBuilder<double>(
                            valueListenable: singleton.notifierHeightPlanGane,
                            builder: (context,value2,_){
                              print("Esto es value 2 $value2");
                              return Container(
                                margin: EdgeInsets.only(top: 125,),
                                //color: Colors.purple,
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width: MediaQuery.of(context).size.width,
                                      height: value2==0?value2:value2,
                                      child: Container(
                                        alignment: Alignment.center,

                                        child: Stack(

                                          children: [

                                            ClipOval(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius: const  BorderRadius.all( Radius.circular(57)),
                                                ),

                                                height: 77,
                                                width: 77,
                                              ),
                                            ),

                                            Container(
                                              margin: const EdgeInsets.only(left: 3.2,top: 3.2),
                                              child: ClipOval(
                                                child: ValueListenableBuilder<Getprofile>(
                                                    valueListenable: singleton.notifierUserProfile,
                                                    builder: (context,value1,_){


                                                      return value1.code==1 ? Container() : (value1.code==102 || value1.code==120) ? Container() :  CachedNetworkImage(
                                                        width: 70,
                                                        height: 70,
                                                         imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                        //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                                        placeholder: (context, url) => const Image(image: AssetImage('assets/images/ic_gane.png'),
                                                          width: 70,
                                                          height: 70,
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
                                  ),
                                ),
                              );


                            }

                        ),


                      ],

                    )
                ),
              )
          );

        }

    );
  }

  /// Fields List
  Widget _fields(BuildContext context){

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderWallet1,
        builder: (context,value2,_){

          return Container(
            margin: EdgeInsets.only(left: 5,right: 5,top: value2),
            color: CustomColors.graybackwallet,
            child:  Stack(
              alignment: Alignment.center,
              children: [

                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child:  Container(
                      //color: Colors.green,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,

                              children: <Widget>[

                                SizedBox(height: 40,),

                                /// User image
                                /*Container(
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

                            SizedBox(height: 15,),*/

                                /// User data
                                Row(

                                  children: [


                                    /// User data
                                    ValueListenableBuilder<Getprofile>(
                                        valueListenable: singleton.notifierUserProfile,
                                        builder: (context,value1,_){

                                          return value1.code==1 ? Container() : Expanded(
                                            child: Container(

                                              child: Column(

                                                children: [

                                                  /// username
                                                  Container(
                                                    padding: EdgeInsets.only(left: 30),
                                                    alignment: Alignment.center,
                                                    child: Text(value1.data!.user!.fullname!??"",
                                                      textScaleFactor: 1.0,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.textSwitch, fontSize: 11,),
                                                    ),
                                                  ),

                                                  SizedBox(height: 10,),

                                                  /// email
                                                  Container(
                                                    padding: EdgeInsets.only(left: 30),
                                                    alignment: Alignment.center,
                                                    child: Text(value1.data!.user!.email!??"",
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

                                        var time = 350;
                                        if(singleton.isIOS == false){
                                          time = utils.ValueDuration();
                                        }

                                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: EditProfile(),
                                            reverseDuration: Duration(milliseconds: time)
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(right: 15,left: 5),
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
                                  margin: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 20),
                                ),

                                /// Notifications
                                Container(
                                    padding: EdgeInsets.only(left: 15,right: 15),
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
                                          padding: EdgeInsets.only(left: 15),
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
                                      margin: EdgeInsets.only(right: 15),
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
                                                dialogDisableNoti(context,disable);

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
                                  margin: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 20),
                                ),

                                /// Legal
                                Container(
                                    padding: EdgeInsets.only(left: 15,right: 15),
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
                                    padding: EdgeInsets.only(left: 15,right: 15),
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
                                    padding: EdgeInsets.only(left: 15,right: 15),
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
                                  margin: EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 25),
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
                                    padding: EdgeInsets.only(left: 15,right: 15),
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
                                    padding: EdgeInsets.only(left: 15,right: 15),
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
                                  margin: EdgeInsets.only(left: 15,right: 15,top: 25,bottom: 30),
                                ),

                                /// LogOut
                                InkWell(
                                  onTap: (){
                                    dialogLogout(context);
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

            ),

          );

        }

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

  /// User haeder photo
  Widget UsePhoto(BuildContext context){

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 35),
      //%height: 103,
      //color: Colors.blue,
      child: Column(

        children: [

          ///UserImage
          InkWell(
            onTap: (){
              dialogSetting(context);
            },
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

                          return value1.code==1 ? Container() : CachedNetworkImage(
                            width: 45,
                            height: 45,
                            imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
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

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ClipOval(
                    child: SvgPicture.asset(
                      'assets/images/herradura.svg',
                      fit: BoxFit.cover,
                      width: 21,
                      height: 21,
                    ),
                  ),
                ),

              ],

            ),
          ),
        ],


      ),

    );

  }


}


///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  final VoidCallback launchFetch;

  AppBar(this.launchFetch);
  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderWallet1,
        builder: (context,value2,_){

          return AnimatedContainer(
            //color: Colors.green,
            height: value2,
            duration: Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width,

            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Stack(

                children: [

                  ///Background
                  Container(
                    //margin: EdgeInsets.only(left: 30),
                    //color: CustomColors.orange,
                      height: value2,
                      width: MediaQuery.of(context).size.width,
                      /*child: value2 > 90.0 ? SvgPicture.asset(
                      'assets/images/headerprofile.svg',
                      fit: BoxFit.fill,
                    ) : Image(
                      image: AssetImage("assets/images/headernew.png"),
                      fit: BoxFit.fill,
                    ),*/

                      child: ValueListenableBuilder<SegmentationCustom>(
                          valueListenable: singleton.notifierValidateSegmentation,
                          builder: (context,valueseg,_){

                            if(valueseg.code == 1 ){
                              return Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );
                            }else if(valueseg.code == 100){
                              return Container(
                                color: valueseg.data!.styles!.colorHeader!.toColors(),
                              );
                            }else if(valueseg.code == 102){
                              return value2 > 90.0 ? SvgPicture.asset(
                                'assets/images/headerprofile.svg',
                                fit: BoxFit.fill,
                              ) : Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );
                            }else{
                              return Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );
                            }

                          }

                      )

                  ),

                  Container(
                    child: Column(

                      children: [

                        /// Header
                        Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[


                              /// Back
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 37, left: 10),
                                  child: Container(
                                    child: SvgPicture.asset(
                                      'assets/images/back.svg',
                                      fit: BoxFit.contain,
                                      //color: CustomColors.black,
                                    ),
                                  ),
                                ),
                              ),

                              ///Logo
                              Container(
                                alignment: Alignment.topLeft,
                                //color: Colors.blue,
                                padding: EdgeInsets.only(top: 35,left: 20),
                                child:InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );
                                  },
                                  /*child: SvgPicture.asset(
                                      'assets/images/logohome.svg',
                                      fit: BoxFit.contain,
                                      width: 80,
                                      height: 42,
                                    ),*/
                                  child: ValueListenableBuilder<SegmentationCustom>(
                                      valueListenable: singleton.notifierValidateSegmentation,
                                      builder: (context,value2,_){
                                        return value2.code == 1 ? SvgPicture.asset(
                                          'assets/images/logohome.svg',
                                          fit: BoxFit.contain,
                                          width: 80,
                                          height: 42,
                                        ) :
                                        value2.code==100 ? CachedNetworkImage(
                                          imageUrl: value2.data!.styles!.logoHeader!,
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Image(
                                            image: AssetImage('assets/images/ic_gane.png'),
                                            color: CustomColors.graylines.withOpacity(0.6),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          useOldImageOnUrlChange: true,
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.contain,
                                          width: 80,
                                          height: 42,
                                        ) :
                                        SvgPicture.asset(
                                          'assets/images/logohome.svg',
                                          fit: BoxFit.contain,
                                          width: 80,
                                          height: 42,
                                        ) ;
                                      }

                                  ),

                                ),
                              ),

                              /// UserImage
                              /*Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5,right: 25,top: 35),
                                  //%height: 103,
                                  //color: Colors.blue,
                                  child: Column(

                                    children: [

                                      ///UserImage
                                      InkWell(
                                        onTap: (){
                                          //imagePicker.showDialog(context);

                                          dialogSetting(context);
                                        },
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

                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: ClipOval(
                                                child: SvgPicture.asset(
                                                  'assets/images/herradura.svg',
                                                  fit: BoxFit.cover,
                                                  width: 21,
                                                  height: 21,
                                                ),
                                              ),
                                            ),

                                          ],

                                        ),
                                      ),
                                    ],


                                  ),

                                ),
                              ),*/

                              Expanded(
                                child: Container(
                                  height: 10,
                                  //color: Colors.red,
                                ),
                              ),

                              ///Coins
                              /*SpringButton(
                                SpringButtonType.OnlyScale,
                                Container(
                                  padding: EdgeInsets.only(right: 10,top: 40 ),
                                  //color: Colors.red,
                                  child: ValueListenableBuilder<Userpoints>(

                                      valueListenable: singleton.notifierUserPoints,
                                      builder: (context,value,_){

                                        return Badge(
                                          position: BadgePosition.topEnd(end: value.code == 1 || value.code == 102 ? -4 : int.parse(value.data!.result!) < 10 ? 0 : -10,),
                                          toAnimate: true,
                                          animationType: BadgeAnimationType.scale,
                                          showBadge: value.code == 1 && value.code == 102 ? false :  true,
                                          badgeColor: CustomColors.blueBack,
                                          /*badgeContent: Text(
                                  //"9",
                                  singleton.formatter.format(double.parse(value.code == 1 || value.code == 102 ? "0" : value.data!.result!)),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                ),*/
                                          badgeContent: AnimatedFlipCounter(
                                            duration: Duration(milliseconds: 2000),
                                            /*value: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? int.parse(value.data!.result!) : ( double.parse(value.data!.result!) / 1000),
                                  fractionDigits: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? 0 : 1, // decimal precision
                                  suffix: value.code == 1 || value.code == 102 ? "" : int.parse(value.data!.result!) < 1000 ? "" : "K",*/

                                            value: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? int.parse(value.data!.result!) : ( double.parse(value.data!.result!) / 1000),
                                            fractionDigits: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? 0 : int.parse(value.data!.result!) > 9999 ? 0 : 1, // decimal precision
                                            suffix: value.code == 1 || value.code == 102 ? "" : int.parse(value.data!.result!) < 1000 ? "" : "K",

                                            textStyle: TextStyle(fontSize: value.code == 1 || value.code == 102 ? 9.0 : int.parse(value.data!.result!) < 1000 ? 9.0 : 8.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                          ),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/coins.svg',
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                            /*child: Container(
                                              child: Stack(
                                                alignment: Alignment.center,

                                                children: [

                                                  Image(
                                                    image: AssetImage("assets/images/circuloonline.png"),
                                                    fit: BoxFit.contain,
                                                    width: 30,
                                                    height: 30,
                                                    //color: "#00A86B".toColors(),
                                                  ),

                                                  Image(
                                                    image: AssetImage("assets/images/monedaonline.png"),
                                                    fit: BoxFit.contain,
                                                    width: 30,
                                                    height: 30,
                                                    color: "#00A86B".toColors(),
                                                  )

                                                ],

                                              ),
                                            )*/
                                        );

                                      }


                                  ),

                                ),
                                useCache: false,
                                onTap: (){

                                  /*Navigator.push(
                          context,
                          PageRouteBuilder<dynamic>(
                            transitionDuration: const Duration(milliseconds: 400),
                            reverseTransitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => MyWallet(),
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

                                  Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 1,)) );


                                },

                                //onTapDown: (_) => decrementCounter(),

                              ),*/

                              /// User image
                              /*InkWell(
                                onTap: (){
                                  //Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
                                  dialogSetting(context);
                                },
                                child: Container(
                                  //color: Colors.green,
                                  margin: EdgeInsets.only(right: 10, top: 40,),
                                  alignment: Alignment.topCenter,
                                  child: Stack(

                                    children: [

                                      ClipOval(
                                        child: Container(
                                          color: Colors.white,
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left: 1.2,top: 1.2),
                                        //alignment: Alignment.center,
                                        child: ClipOval(
                                          child: ValueListenableBuilder<Getprofile>(
                                              valueListenable: singleton.notifierUserProfile,
                                              builder: (context,value1,_){

                                                return value1.code==1 ? Container() : CachedNetworkImage(
                                                  width: 29,
                                                  height: 29,
                                                  imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                  //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                    width: 29,
                                                    height: 29,
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
                              ),*/

                              ///Notifications
                              SpringButton(
                                SpringButtonType.OnlyScale,
                                Container(
                                  padding: EdgeInsets.only(right: 15,top: 40,),
                                  //color: Colors.blue,
                                  child: ValueListenableBuilder<String>(
                                      valueListenable: singleton.notifierNotificationCount,
                                      builder: (context,value,_){

                                        /*return Badge(
                                          //position: BadgePosition.topEnd(top: 2,end: 0),
                                          position: BadgePosition.topEnd(end: -2,),
                                          toAnimate: true,
                                          animationType: BadgeAnimationType.scale,
                                          showBadge: value == "0" ? false : true,
                                          //showBadge: true,
                                          badgeColor: CustomColors.blueBack,
                                          badgeContent: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                            textScaleFactor: 1.0,
                                          ),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/notifications.svg',
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        );*/

                                        return badges.Badge(
                                          badgeContent: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                          ),
                                          showBadge: value == "0" ? false : true,
                                          badgeStyle: badges.BadgeStyle(
                                            badgeColor: CustomColors.blueBack,
                                          ),
                                          position: BadgePosition.topEnd(end: -2,),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/notifications.svg',
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        );

                                      }

                                  ),

                                ),
                                useCache: false,
                                onTap: (){

                                  /*Navigator.push(
                                    context,
                                    PageRouteBuilder<dynamic>(
                                      transitionDuration: const Duration(milliseconds: 400),
                                      reverseTransitionDuration: const Duration(milliseconds: 400),
                                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Notificationss(),
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

                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: Notificationss(),
                                      reverseDuration: Duration(milliseconds: time)
                                  ));

                                },


                              ),


                            ],
                          ),
                        ),

                        /// Data
                        Container(
                          padding: EdgeInsets.only(left: 20,right: 20,),
                          height: 103,
                          //color: Colors.red,
                          child: Column(

                            children: [

                              /*SizedBox(height: 5,),
                              /// username
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: ValueListenableBuilder<Getprofile>(
                                    valueListenable: singleton.notifierUserProfile,
                                    builder: (context,value1,_){

                                      return Text(value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.fullname!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 14,),
                                        textScaleFactor: 1.0,
                                      );

                                    }

                                ),
                              ),

                              SizedBox(height: 5,),

                              ///Progressbar
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                height: 12,
                                child: ValueListenableBuilder<TotalpointProfileCategories>(
                                    valueListenable: singleton.notifierPointsProfileCategories,
                                    builder: (context,value,_){

                                      return LiquidLinearProgressIndicator(
                                        value: (value.code == 1 || value.code == 102 || value.code == 120) ? 0.0 : ((value.data!.totalUser! * 100)/value.data!.point!)/100, // Defaults to 0.5.
                                        valueColor: AlwaysStoppedAnimation(CustomColors.blueBack), // Defaults to the current Theme's accentColor.
                                        backgroundColor: CustomColors.white.withOpacity(0.6), // Defaults to the current Theme's backgroundColor.
                                        borderColor: CustomColors.white.withOpacity(0.6),
                                        borderWidth: 0.0,
                                        borderRadius: 6.0,
                                        direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                        center: Text(""),
                                      );

                                    }

                                ),
                              ),

                              SizedBox(height: 5,),

                              ///Percentage
                              ValueListenableBuilder<TotalpointProfileCategories>(
                                  valueListenable: singleton.notifierPointsProfileCategories,
                                  builder: (context,value,_){

                                    return Container(

                                      child: Container(
                                        child: Text(singleton.formatter.format((value.data!.totalUser! * 100)/value.data!.point!) + "%",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 15,),
                                          textScaleFactor: 1.0,
                                        ),
                                      ),

                                    );

                                  }

                              ),*/

                              /// Money
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10,top: 5),
                                child: Text(Strings.myaccount,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.white, fontSize: 30,),
                                  textScaleFactor: 1.0,
                                ),
                              ),

                              SizedBox(height: 5,),




                            ],


                          ),

                        ),

                      ],

                    ),
                  ),



                ],

              ),
            ),


          );

        }

    );

  }

}

/// Color from String
class HexColor extends Color {

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
