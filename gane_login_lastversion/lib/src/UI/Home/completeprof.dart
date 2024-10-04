import 'dart:io';
import 'dart:math';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/altanplan.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/profilecategories.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Campaigns/ganecampaignsdetail.dart';
import 'package:gane/src/UI/Home/RechargePlain/RechargePlainView.dart';
import 'package:gane/src/UI/Home/detailcategory.dart';
import 'package:gane/src/UI/Home/plansdetailsaltan.dart';
import 'package:gane/src/UI/Home/profileDetail.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_setting.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
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
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:transition/transition.dart';
import 'dart:math' as math;
import 'package:badges/badges.dart' as badges;


class CProfile extends StatefulWidget{

  final from;
  final VoidCallback? PointProfileCategorie;

  CProfile({this.from, this.PointProfileCategorie});

  _stateCProfile createState()=> _stateCProfile();
}

class _stateCProfile extends State<CProfile> with  TickerProviderStateMixin, WidgetsBindingObserver{

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
  var heightContainerDetailPlain = 35;

  late HomeProvider providerHome;



  @override
  void initState(){
    singleton.notifierHeightPlanGane.value = 100;
    //singleton.notifierHeightHeaderWallet1.value = 180.0;
    singleton.notifierHeightHeaderWallet1.value = 160.0;

    utils.heightViewWinPoint();
    //prefs.helCategories = "";


    //
    controllerAnima = AnimationController(duration: const Duration(seconds: 1), vsync: this,  );
    animationIn = Tween(
        begin: 0.0,
        end: 1.0
    ).animate( controllerAnima);


    controllerProgress = AnimationController(duration: const Duration(seconds: 1), vsync: this,  );
    animationProgress = Tween(
        begin: 0.0,
        end: 1.0
    ).animate( controllerProgress);

    controllerCategory = AnimationController(duration: const Duration(seconds: 1), vsync: this,  );
    animationCategory = Tween(
        begin: 0.0,
        end: 1.0
    ).animate( controllerCategory);


    controller = AnimationController(duration: const Duration(milliseconds: 1450), vsync: this,  );

    /// Free Text Animation
    animationWith = Tween(
        begin: 0.0,
        end: 1.6
    ).animate( CurvedAnimation(
        parent: controller,
        curve: Interval(0.0,1.0)
    ),);

    //prefs.helCategories="";
    if(prefs.helCategories!=""){
      notifierHelp.value = 3;
    }else{

      //notifierHelp.value = 0;
      //tapNextHelp();

      notifierHelp.value = 0;

      if(singleton.notifierUserProfile.value.data!.user!.userAltan! == false){
        controllerAnima.reverse();
        Future.delayed(const Duration(milliseconds: 250), () {
          controllerProgress.forward();
        });
        notifierHelp.value = notifierHelp.value + 1;
      }

    }


    launchFetch();

    WidgetsBinding.instance!.addPostFrameCallback((_){


      Future.delayed(const Duration(milliseconds: 650), () {
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
          /*if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }*/
          //singleton.notifierHeightHeaderWallet1.value = 180.0;
          singleton.notifierHeightHeaderWallet1.value = 160.0;
          singleton.notifierHeightPlanGane.value = 100.0;
        }
      });

      Future.delayed(const Duration(milliseconds: 650), () {
        _scrollViewController.jumpTo(_scrollViewController.position.minScrollExtent);

      });


      singleton.homeOrAnswer = "answer";

    });

    super.initState();
  }

  /// Tap next help view
  void tapNextHelp(){

    //prefs.helCategories = "";

    notifierHide.value = false;

    if(notifierHelp.value==0){ /// Help coins
      controllerAnima.reverse();
      Future.delayed(const Duration(milliseconds: 250), () {
        controllerProgress.forward();
      });
      notifierHelp.value = notifierHelp.value + 1;

    }else if(notifierHelp.value==1){ /// Help progress
      controllerProgress.reverse();
      Future.delayed(const Duration(milliseconds: 250), () {
        controllerCategory.forward();
      });
      notifierHelp.value = notifierHelp.value + 1;

    }else if(notifierHelp.value==2){ /// Help Categories
      controllerCategory.reverse();
      Future.delayed(const Duration(milliseconds: 1000), () {
        notifierHelp.value = notifierHelp.value + 1;
        prefs.helCategories = "OK";
      });

    }

  }

  void launchFetch()async{
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        singleton.notifierCategoriesProfile.value = Profilecategories(code: 1,message: "No hay nada", status: false, );
        singleton.notifierUseraltanPlan.value = AltanPLane(code: 1,message: "No hay nada", status: false, data: DataAP(plan: Plan(missingDay: "0",gbAvailable: "0",gbUsed: "0",totalGd: "0"  ) ) );
        singleton.CategoriesProfilePages = 0;
        singleton.HallRoomPages = 0;
        singleton.notifierUserPoints.value = Userpoints(code: 1,message: "No hay nada", status: false, data: DataPU(result: "0") );
        singleton.notifierHallRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchCategoriesProfile(context,"borrar");
        servicemanager.fetchPointProfileCategories(context);
        servicemanager.fetchUserProfile1(context);
        servicemanager.fetchSettings(context);
        servicemanager.fetchPointUserPoints(context);
        servicemanager.fetchValidateSegmentation(context);
        servicemanager.fetchHallGain(context, "borrar");
        //servicemanager.fetchUserAltam(context);
        //singleton.notifierUseraltanPlan.value = AltanPLane(code: 1,message: "No hay nada", status: false, data: DataAP(plan: Plan(missingDay: "0",gbAvailable: "0",gbUsed: "0",totalGd: "0"  ) ) );
        //servicemanager.fetchUserAltanPlan(context);
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Reset Load
  void _onRefresh() async{
    _refreshController.refreshCompleted();
    launchFetch();
  }

  ///Load More
  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();


    if(singleton.notifierCategoriesProfile.value.data!.page! >= (singleton.CategoriesProfilePages + 1)){
      singleton.CategoriesProfilePages = singleton.CategoriesProfilePages + 1;
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          servicemanager.fetchCategoriesProfile(context,"agregar");

        }
      } on SocketException catch (_) {
        print('not connected');
        singleton.isOffline = true;
        //Navigator.pop(context);
        ConnectionStatusSingleton.getInstance().checkConnection();
      }
    }

    if(singleton.notifierHallRoom.value.data!.page! >= (singleton.HallRoomPages + 1)){
      singleton.HallRoomPages = singleton.HallRoomPages + 1;
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          servicemanager.fetchHallGain(context,"agregar");

        }
      } on SocketException catch (_) {
        print('not connected');
        singleton.isOffline = true;
        //Navigator.pop(context);
        ConnectionStatusSingleton.getInstance().checkConnection();
      }
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

                        AppBar(),

                        /// User Gane or No
                        /*ValueListenableBuilder<Getprofile>(
                            valueListenable: singleton.notifierUserProfile,
                            builder: (context,value2,_){
                              return value2.data!.user!.userAltan! == false ? Container(width: 0,height: 0,) : dataPlanGane(context);

                            }

                        ),*/


                        /*UsePhoto(context),*/

                        ///Help
                        ValueListenableBuilder<int>(
                            valueListenable: notifierHelp,
                            builder: (contexts,values,_){

                              return values>2 ? Container(color: Colors.green,width: 0,height: 0,):
                              ///Helps
                              Stack(

                                children: [


                                  ///White background and Holes
                                  ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        Colors.white.withOpacity(0.9), BlendMode.srcOut), // This one will create the magic

                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [

                                        ///White Background
                                        Container(
                                          decoration: BoxDecoration(
                                              color: CustomColors.white.withOpacity(0.9),
                                              backgroundBlendMode: BlendMode.dstOut), // This one will handle background + difference out
                                        ),

                                        ///Holes
                                        ValueListenableBuilder<Getprofile>(
                                              valueListenable: singleton.notifierUserProfile,
                                              builder: (context,valueP,_){

                                                return ValueListenableBuilder<int>(
                                                    valueListenable: notifierHelp,
                                                    builder: (contexts,value2,_){

                                                      return
                                                        ///Hole coins
                                                        value2 == 0 ? Align(
                                                          alignment: Alignment.topRight,
                                                          child: FadeTransition(
                                                            opacity: controllerAnima,
                                                            child: Container(
                                                              margin: const EdgeInsets.only(top: 165,left: 20,right: 20),
                                                              height: 100,
                                                              width: MediaQuery.of(context).size.width,
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius: BorderRadius.circular(15),
                                                              ),
                                                            ),
                                                          ),
                                                        ):
                                                        ///Hole progress
                                                        value2 == 1 ? Align(
                                                          alignment: Alignment.topRight,
                                                          child: FadeTransition(
                                                            opacity: controllerProgress,
                                                            child: Container(
                                                              margin: const EdgeInsets.only(left: 30,right: 30,top: 200),
                                                              height: 40,
                                                              width: MediaQuery.of(context).size.width,
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius: BorderRadius.circular(7),
                                                              ),
                                                            ),
                                                          ),
                                                        ):
                                                        ///Hole Categories
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: FadeTransition(
                                                            opacity: controllerCategory,
                                                            child: Stack(

                                                              children: [

                                                                /// Home categories text
                                                                /*Container(/// modificar con endpoint
                                                                  margin:  EdgeInsets.only(left: 30,right: 30,top: valueP.data!.user!.userAltan == false ? 180 : 270),//180
                                                                  height: 80,
                                                                  width: MediaQuery.of(context).size.width,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.red,
                                                                    borderRadius: BorderRadius.circular(7),
                                                                  ),
                                                                ),*/

                                                                Align(
                                                                  alignment: Alignment.topLeft,
                                                                  //left: 0,
                                                                  //top: MediaQuery.of(context).size.height / 3,
                                                                  child: Container(  /// modificar con endpoint
                                                                    //margin:  EdgeInsets.only(top: (MediaQuery.of(context).size.height >=535.0 && MediaQuery.of(context).size.height <=725.0) ? 268 : MediaQuery.of(context).size.height >725.0 ?  288 : MediaQuery.of(context).devicePixelRatio > 3.0 ? 66 : 280,left: 22),
                                                                    margin:  EdgeInsets.only(
                                                                        top: (
                                                                            /// User altan
                                                                            valueP.data!.user!.userAltan == true && MediaQuery.of(context).size.height >=535.0 && MediaQuery.of(context).size.height <=725.0) ? 378 :
                                                                        valueP.data!.user!.userAltan == true && MediaQuery.of(context).size.height >725.0 ?  398 :
                                                                        valueP.data!.user!.userAltan == true && MediaQuery.of(context).devicePixelRatio > 3.0 ? 86 :
                                                                        valueP.data!.user!.userAltan == true ? 390 :
                                                                            /// User No altan
                                                                        (valueP.data!.user!.userAltan == false && MediaQuery.of(context).size.height >=535.0 && MediaQuery.of(context).size.height <=725.0) ? 288 :
                                                                        valueP.data!.user!.userAltan == false && MediaQuery.of(context).size.height >725.0 ?  308 :
                                                                        valueP.data!.user!.userAltan == false && MediaQuery.of(context).devicePixelRatio > 3.0 ? 86 :
                                                                        300

                                                                        ,
                                                                        left: 22),
                                                                    height: MediaQuery.of(context).size.width/3 - 20 ,
                                                                    width: MediaQuery.of(context).size.width/3 - 20,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.red,
                                                                      borderRadius: BorderRadius.circular(7),
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],

                                                            ),
                                                          ),
                                                        )
                                                      ;

                                                    }

                                                );

                                              }

                                        ),


                                      ],
                                    ),

                                  ),

                                  ///Helps
                                  ValueListenableBuilder<int>(
                                      valueListenable: notifierHelp,
                                      builder: (contexts,value2,_){

                                        return
                                          /// Helps Coins
                                          value2 == 0 ? Positioned(
                                            top: MediaQuery.of(context).size.height/4,
                                            left: 0,
                                            right: 0,
                                            child: FadeTransition(
                                              opacity: controllerAnima,
                                              child: Container(
                                                //color: Colors.green,
                                                height: 230,

                                                child: Row(

                                                  children: [

                                                    ///Text
                                                    Expanded(
                                                      child: Container(
                                                        //color: Colors.red,
                                                        margin: EdgeInsets.only(top: 90,left: 20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,

                                                          children: [

                                                            ///Icon
                                                            Container(
                                                              child: SvgPicture.asset(
                                                                'assets/images/ic_ganehelp.svg',
                                                                fit: BoxFit.contain,
                                                              ),
                                                            ),

                                                            /// Text
                                                            Container(
                                                              padding: EdgeInsets.only(left: 10, right: 10),
                                                              child: Text(Strings.helprofile,
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayObtaincoins, fontSize: 14,),
                                                                textScaleFactor: 1.0,
                                                              ),
                                                            ),


                                                          ],

                                                        ),
                                                      ),
                                                    ),

                                                    ///Icon
                                                    Container(
                                                      margin: EdgeInsets.only(right: 50),
                                                      //color: Colors.yellow,
                                                      child: SvgPicture.asset(
                                                        'assets/images/ic_linea1.svg',
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),

                                                  ],

                                                ),

                                              ),
                                            ),
                                          ) :
                                          ///Helps Progress
                                          value2 == 1 ? Positioned(
                                            top: MediaQuery.of(context).size.height/3.3,
                                            left: 0,
                                            right: 0,
                                            child: FadeTransition(
                                              opacity: controllerProgress,
                                              child: Container(
                                                //color: Colors.green,
                                                height: 283,

                                                child: Column(

                                                  children: [

                                                    ///Icon
                                                    Container(
                                                      child: SvgPicture.asset(
                                                        'assets/images/ic_linea2.svg',
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),

                                                    ///Text
                                                    Expanded(
                                                      child: Container(
                                                        //color: Colors.red,
                                                        margin: EdgeInsets.only(right: 20,left: 20),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,

                                                          children: [

                                                            ///Icon
                                                            Container(
                                                              child: SvgPicture.asset(
                                                                'assets/images/ic_ganehelp.svg',
                                                                fit: BoxFit.contain,
                                                              ),
                                                            ),

                                                            /// Text
                                                            Container(
                                                              padding: EdgeInsets.only(left: 10, right: 10),
                                                              child: Text(Strings.helprofile1,
                                                                textAlign: TextAlign.left,
                                                                style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayObtaincoins, fontSize: 14,),
                                                                textScaleFactor: 1.0,
                                                              ),
                                                            ),


                                                          ],

                                                        ),
                                                      ),
                                                    ),

                                                  ],

                                                ),

                                              ),
                                            ),
                                          ) :
                                          ///Helps Categories
                                          ValueListenableBuilder<Getprofile>(
                                          valueListenable: singleton.notifierUserProfile,
                                              builder: (context,valueP,_){

                                                  return Positioned(/// modificar con endpoint
                                              //top: MediaQuery.of(context).size.height/2.9,
                                              top: valueP.data!.user!.userAltan == false ? MediaQuery.of(context).size.height/2.8 : MediaQuery.of(context).size.height/2.3,
                                              left: 0,
                                              right: 0,
                                              child: FadeTransition(
                                                opacity: controllerCategory,
                                                child: Container(
                                                  //color: Colors.green,
                                                  height: 200,

                                                  child: Column(

                                                    children: [

                                                      ///Icon
                                                      Container(
                                                        child: SvgPicture.asset(
                                                          'assets/images/ic_linea3.svg',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),

                                                    ],

                                                  ),

                                                ),
                                              ),
                                            );

                                              }

                                          );

                                      }

                                  ),

                                  ///Next Button
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 30,right: 20),
                                      child: SpringButton(
                                        SpringButtonType.OnlyScale,
                                        Container(
                                          width: 70,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: CustomColors.orangeback,
                                            borderRadius: BorderRadius.all(const Radius.circular(23)),
                                            border: Border.all(
                                              width: 1,
                                              color: CustomColors.orangeback,
                                            ),
                                          ),
                                          child: Container(
                                            //margin: EdgeInsets.only(top: 15,bottom: 15),
                                            child: Center(
                                              child: Container(
                                                child: SvgPicture.asset(
                                                  'assets/images/ic_ok.svg',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        useCache: false,
                                        onTap: (){

                                          notifierHide.value = false;

                                          if(notifierHelp.value==0){ /// Help coins
                                            controllerAnima.reverse();
                                            Future.delayed(const Duration(milliseconds: 250), () {
                                              controllerProgress.forward();
                                            });
                                            notifierHelp.value = notifierHelp.value + 1;

                                          }else if(notifierHelp.value==1){ /// Help progress
                                            controllerProgress.reverse();
                                            Future.delayed(const Duration(milliseconds: 250), () {
                                              controllerCategory.forward();
                                            });
                                            notifierHelp.value = notifierHelp.value + 1;

                                          }else if(notifierHelp.value==2){ /// Help Categories
                                            controllerCategory.reverse();
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              notifierHelp.value = notifierHelp.value + 1;
                                              prefs.helCategories = "OK";
                                            });

                                          }


                                        },

                                      ),
                                    ),
                                  ),

                                  /// Hide Button
                                  ValueListenableBuilder<bool>(
                                      valueListenable: notifierHide,
                                      builder: (contexts,values,_){

                                        return Visibility(
                                          visible: values,
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              padding: EdgeInsets.only(bottom: 31,left: 20),
                                              child: ArgonButton(
                                                height: 45,
                                                width: 120,
                                                borderRadius: 40.0,
                                                color: CustomColors.white,
                                                child: Container(

                                                  width: double.infinity,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    color: CustomColors.white,
                                                    borderRadius: BorderRadius.all(const Radius.circular(40)),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: CustomColors.orange,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,

                                                      children: <Widget>[


                                                        /// languaje
                                                        Expanded(
                                                          child: Container(
                                                            //color: Colors.red,
                                                            //margin: EdgeInsets.only(left: 10,right: 40),
                                                            child: AutoSizeText(
                                                              Strings.hide,
                                                              textAlign: TextAlign.center,
                                                              //maxLines: 1,
                                                              style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.greyborderbutton, fontSize: 14.0,),
                                                              textScaleFactor: 1.0,

                                                              //maxLines: 1,
                                                            ),
                                                          ),
                                                        ),

                                                      ],

                                                    ),
                                                  ),
                                                ),
                                                loader: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    //padding: EdgeInsets.all(10),
                                                    child: CircularProgressIndicator(
                                                      backgroundColor: CustomColors.greyborderbutton,
                                                      valueColor: AlwaysStoppedAnimation<Color>(CustomColors.greyborderbutton),
                                                    ),
                                                  ),
                                                ),
                                                onTap: (startLoading, stopLoading, btnState) {
                                                  if(btnState == ButtonState.Idle){
                                                    notifierHelp.value = 6;
                                                    prefs.helCategories = "OK";
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        );

                                      }

                                  ),

                                ],

                              );

                            }

                        ),

                        WinBond(context),

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

    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      color: CustomColors.graybackwallet,

      child: ValueListenableBuilder<double>(
          valueListenable: singleton.notifierHeightHeaderWallet1,
          builder: (context,value2,_){

            return ValueListenableBuilder<Getprofile>(
                valueListenable: singleton.notifierUserProfile,
                builder: (context,value3,_){

                  return Container(
                    //color: Colors.yellow,
                    //padding: EdgeInsets.only(left: 5,right: 5,top: 140),
                    //margin: EdgeInsets.only(top: value2==90?value2:value2+heightContainerDetailPlain),
                    margin: EdgeInsets.only(top: value2==90 ? value2 : value2),
                    child:

                    ValueListenableBuilder<Profilecategories>(
                        valueListenable: singleton.notifierCategoriesProfile,
                        builder: (context,value1,_){

                          return SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                            header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: StaggeredGridView.countBuilder(
                              controller: _scrollViewController,
                              //physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 3,
                              //itemCount: _tiles.length,
                              itemCount: value1.code == 1 ? 10 : value1.code == 102 ? 2 : value1.code == 120 ? 0 : value1.data!.result!.length + 2,
                              itemBuilder: (BuildContext context, int index) {
                                if(index==0){
                                  /// Header choose category
                                  return HeaderChooseCategory();

                                }else if(index==1){
                                  /// Poll Adver
                                  return pollAdvertaisment();

                                }else if(value1.code == 1){ /// PreLoad data
                                  return utils.PreloadindCategories();

                                }else if(value1.code == 102){ /// No data
                                  return Container(
                                    child: utils.emptyCategories('assets/images/emptycatego.svg'),
                                  );

                                }else{ /// Categories Item
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 230),
                                    columnCount: 3,
                                    child: ScaleAnimation(
                                      child: FadeInAnimation(
                                        child:_ItemCategory(context,value1.data!.result![index-2], index-2),
                                      ),
                                    ),
                                  );

                                }

                              } ,
                              staggeredTileBuilder: (int index) {
                                return index==0 ? const StaggeredTile.fit(4)  : index == 1 ? const StaggeredTile.fit(4) :  value1.code == 102 ? const StaggeredTile.count(4, 3) : const StaggeredTile.count(1, 1);
                              },
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 4.0,
                              padding: const EdgeInsets.all(4),
                            ),
                          );

                        }

                    ),
                  );

                }

            );

          }

      ),

    );
  }

  /// Poll Advertaisment
  Container pollAdvertaisment() {
    
    return Container(
      
      child: ValueListenableBuilder<Roomlook>(
          valueListenable: singleton.notifierHallRoom,
          builder: (context,value2,_){
            
            return (value2.code == 1 || value2.code == 102) ? Container() : StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              itemCount: value2.code == 1 ? 1 : value2.code == 102 ? 0 :  value2.data!.result!.length ,
              itemBuilder: (BuildContext context, int index) {

                if(value2.code == 1){
                  return utils.PreloadBanner();

                }else if(value2.code == 102){
                  return utils.emptyHomeNew(Strings.emptyhome1, "", "assets/images/emptyhome.svg");

                }else{

                  if(value2.data!.result!.isEmpty){
                    return Container();

                  }else {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 230),
                      columnCount: 3,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: _itemGane(value2.data!.result![index],index,_onRefresh),
                        ),
                      ),
                    );
                  }

                }


              } ,
              staggeredTileBuilder: (int index) {

                    if(value2.code == 1){ /// Loading
                      
                      return StaggeredTile.count(4, 1.2);

                    }else if(value2.code == 102){ /// No results

                      return const StaggeredTile.count(4, 0.1);

                    }else { /// Load data

                      /// Banner
                        return const StaggeredTile.count(4, 1.2);
                    }
                    
              },
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              padding: const EdgeInsets.all(4),


            );
            
          }
      ),
      
    );

  }

  /// Item
  Widget _ItemCategory(BuildContext context,Result categoryItem, int index){

    return GestureDetector(
      onTap: () {

        if(categoryItem.categoryStatus == "incomplete"){
          singleton.CategoryId = categoryItem.id!;
          singleton.CategoryIndex = index;

          //Navigator.push(context, Transition(child: CategoryDetail(category: categoryItem.name!,onAnimationCoin: onAnimationCoin,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

          /*Navigator.push(
            context,
            PageRouteBuilder<dynamic>(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => CategoryDetail(category: categoryItem.name!,onAnimationCoin: onAnimationCoin,),
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

          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child:CategoryDetail(category: categoryItem.name!,onAnimationCoin: onAnimationCoin,categoryItem: categoryItem),
              reverseDuration: Duration(milliseconds: time)
          ));

        }
      },
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      //onTapUp: (TapUpDetails details) => _onTapUp(details),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: CustomColors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        //shadowColor: CustomColors.shadowcategory,
        child: Center(
          child: Container(
            //color: CustomColors.red,
            padding: EdgeInsets.only(left: 5,right: 5),
            child: Stack(

              children: [

                ///Image
                /*CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Image(
                      image: AssetImage('assets/images/ic_gane.png'),
                      color: CustomColors.graylines.withOpacity(0.6),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                  /// Value coins
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                        padding: EdgeInsets.only(top: 7,bottom: 7),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            ///Value
                            Expanded(
                              child: Container(
                                color: Colors.blue,
                                child: Text("Educación",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.graycategory, fontSize: 14,),
                                ),
                              ),
                            ),

                          ],

                        ),
                      ),
                  ),*/

                ValueListenableBuilder<SegmentationCustom>(
                    valueListenable: singleton.notifierValidateSegmentation,
                    builder: (context,valueseg,_){

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          ///Image icon
                          CachedNetworkImage(
                            width: 42,
                            height: 42,
                            imageUrl: categoryItem.cImages!,
                            placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                              width: 42,
                              height: 42,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                            useOldImageOnUrlChange: false,
                            color: categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 : valueseg.code == 1 || valueseg.code == 102 ? HexColor(categoryItem.color!) : valueseg.code == 100 ? valueseg.data!.styles!.colorHeader!.toColors() : HexColor(categoryItem.color!),
                            //color: categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 : CustomColors.blueBack,

                          ),

                          ///Name category
                          Container(
                            //color: Colors.blue,
                            child: AutoSizeText(
                              categoryItem.name!.toUpperCase(),
                              //"kjhasdhjkhjkdashjkdashjkdaskjhgdsagjkhdsagjk".toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(fontFamily: Strings.font_boldFe, color: categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 : valueseg.code == 1 || valueseg.code == 102 ? HexColor(categoryItem.color!) : valueseg.code == 100 ? valueseg.data!.styles!.colorHeader!.toColors() : HexColor(categoryItem.color!), fontSize: 12.0,),//CustomColors.blueBack
                              textScaleFactor: 1.0,
                              //maxLines: 1,
                            ),
                          ),

                        ],
                      );

                    }

                )

              ],

            ),
          ),
        ),
      ),
    );

  }

  /// Data Plan Gane
  Widget dataPlanGane(BuildContext context){

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightPlanGane,
        builder: (context,value2,_){
          print("Esto es value 2 $value2");
          return Container(
            margin: EdgeInsets.only(top: 165,),
            //color: Colors.purple,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.only(left: 20,right: 20),
                width: MediaQuery.of(context).size.width,
                height: value2==0?value2:value2+heightContainerDetailPlain,
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.all(const Radius.circular(15)),
                  color: CustomColors.blueTwo.withOpacity(0.85),
                ),
                child: Container(
                  //color: Colors.purple,
                  child: Stack(

                    children: [

                      /// Title
                      Container(
                        //color: Colors.green,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(left: 5, right: 5,top: 10),
                        child: Text(Strings.plandetails,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 16,),
                          textScaleFactor: 1.0,
                        ),
                      ),

                      /// Data
                      Positioned(
                        bottom: 0,
                          left: 0,right: 0,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            //color: Colors.purple,
                            child: ValueListenableBuilder<AltanPLane>(
                                  valueListenable: singleton.notifierUseraltanPlan,
                                  builder: (context,valueAP,_){

                                    return Column(
                                      children: [

                                        /// Values SMS-Data
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.min,

                                          children: [

                                            /// Days
                                            /*Expanded(
                                              child: Container(
                                                height: 50,
                                                //color: Colors.yellow,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                  children: [

                                                    /// Total days
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        //color: Colors.red,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 5, right: 5,),
                                                        child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? "-" : singleton.formatter.format(double.parse(valueAP.data!.plan!.days!)) ,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 28,),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),

                                                    /// days
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        //color: Colors.green,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 2, right: 2,),
                                                        child: AutoSizeText(Strings.daysn,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 10,),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 1,
                                                          minFontSize: 6,
                                                        ),
                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),
                                            ),*/

                                            /// Gb totals o SMS
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                //color: Colors.yellow,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                  children: [

                                                    /// Total sms
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        //color: Colors.red,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 5, right: 5,),
                                                        /*child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                                        double.parse(valueAP.data!.plan!.totalGd!) > 999 ? singleton.formatter.format( double.parse(valueAP.data!.plan!.totalGd!)/1000 ) :
                                                        singleton.formatter.format(double.parse(valueAP.data!.plan!.totalGd!)) ,*/
                                                        child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                                        valueAP.data!.plan == null ? "0" : valueAP.data!.plan!.smsConvert!,
                                                        //double.parse(valueAP.data!.plan!.sms!) / 1000 > 1 ? (singleton.formatter1.format(double.parse(valueAP.data!.plan!.sms!)/1000) + Strings.datos3).replaceAll(".", ",") : singleton.formatter1.format(double.parse(valueAP.data!.plan!.sms!)),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 20,),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),

                                                    /// sms
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        //color: Colors.green,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 2, right: 2,),
                                                        /*child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? Strings.gbtotals :
                                                        double.parse(valueAP.data!.plan!.totalGd!) > 999 ? Strings.gbtotals :
                                                        Strings.gbtotals1,*/
                                                        child: AutoSizeText(Strings.sms,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 10,),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 1,
                                                          minFontSize: 6,
                                                        ),
                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),
                                            ),

                                            /// Gb Used o minutes
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                //color: Colors.yellow,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                  children: [

                                                    /// Total days
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        //color: Colors.red,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 5, right: 5,),
                                                        child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                                        valueAP.data!.plan == null ? "0" : valueAP.data!.plan!.minuteConvert!,
                                                        //double.parse(valueAP.data!.plan!.minute!) / 1000 > 1 ? (singleton.formatter1.format(double.parse(valueAP.data!.plan!.minute!)/1000) + Strings.datos3).replaceAll(".", ",") : singleton.formatter1.format(double.parse(valueAP.data!.plan!.minute!)) ,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 22,),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ),

                                                    /// minutes
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        //color: Colors.green,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 2, right: 2,),
                                                        //child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? Strings.gbused :  double.parse(valueAP.data!.plan!.gbUsed!) > 999 ? Strings.gbused : Strings.gbused1,
                                                        child: AutoSizeText(Strings.minutes,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 10,),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 1,
                                                          minFontSize: 6,
                                                        ),
                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),
                                            ),

                                            /// Gb Availiable
                                            Expanded(
                                             child:  Container(
                                               height: 50,
                                               //color: Colors.yellow,
                                               child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.center,

                                                 children: [

                                                   /// Total days
                                                   Expanded(
                                                     flex: 2,
                                                     child: Container(
                                                       //color: Colors.green,
                                                       alignment: Alignment.center,
                                                       padding: EdgeInsets.only(left: 5, right: 5,),
                                                       child: AutoSizeText(
                                                         valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                                         valueAP.data!.plan == null ? "0" :  valueAP.data!.plan!.gbConvert!,
                                                         //double.parse(valueAP.data!.plan!.gb!) > 999 ? singleton.formatter.format( double.parse(valueAP.data!.plan!.gb!)/1024 ) + Strings.datos1:
                                                         //singleton.formatter1.format(double.parse(valueAP.data!.plan!.gb!)) + Strings.datos2,
                                                         //singleton.formatter1.format( double.parse(valueAP.data!.plan!.gb!)/1000 ) + Strings.datos1,
                                                         textAlign: TextAlign.center,
                                                         style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 20,),
                                                         textScaleFactor: 1.0,
                                                         //maxLines: 1,
                                                       ),
                                                     ),
                                                   ),

                                                   /// days
                                                   Expanded(
                                                     flex: 1,
                                                     child: Container(
                                                       //color: Colors.red,
                                                       alignment: Alignment.center,
                                                       //alignment: Alignment(0.0, -1.0),
                                                       padding: EdgeInsets.only(left: 2, right: 2,),
                                                       //child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? Strings.datos + Strings.datos1 :  double.parse(valueAP.data!.plan!.gbAvailable!) > 999 ? Strings.datos+ Strings.datos1 : Strings.datos+ Strings.datos2,
                                                         child: AutoSizeText(Strings.datos,
                                                           textAlign: TextAlign.center,
                                                         style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 10,),
                                                         textScaleFactor: 1.0,
                                                         maxLines: 1,
                                                         minFontSize: 6,
                                                       ),
                                                     ),
                                                   ),

                                                 ],

                                               ),
                                             ),
                                           ),

                                            /// Gb Reduce
                                            Expanded(
                                              child:  Container(
                                                height: 50,
                                                //color: Colors.yellow,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                  children: [

                                                    /// Total days
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        //color: Colors.green,
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 5, right: 5,),
                                                        child: AutoSizeText(
                                                          valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                                          valueAP.data!.plan == null ? "0" :  valueAP.data!.plan!.gbRedConvert!,
                                                          //double.parse(valueAP.data!.plan!.gb_red!) > 999 ? singleton.formatter.format( double.parse(valueAP.data!.plan!.gb_red!)/1000 )  + Strings.datos1:
                                                          //singleton.formatter1.format(double.parse(valueAP.data!.plan!.gb_red!)) + Strings.datos2,
                                                          //singleton.formatter1.format( double.parse(valueAP.data!.plan!.gb_red!)/1000 )  + Strings.datos1,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 20,),
                                                          textScaleFactor: 1.0,
                                                          //maxLines: 1,
                                                        ),
                                                      ),
                                                    ),

                                                    /// days
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        //color: Colors.red,
                                                        alignment: Alignment.center,
                                                        //alignment: Alignment(0.0, -1.0),
                                                        padding: EdgeInsets.only(left: 2, right: 2,),
                                                        //child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? Strings.datos + Strings.datos1 :  double.parse(valueAP.data!.plan!.gbAvailable!) > 999 ? Strings.datos+ Strings.datos1 : Strings.datos+ Strings.datos2,
                                                          child: AutoSizeText(Strings.velredu,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 10,),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 1,
                                                          minFontSize: 6,
                                                        ),
                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),
                                            ),


                                          ],

                                        ),

                                        SizedBox(height: 10,),

                                        /// Buttons
                                        Container(
                                          //width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(6),bottomLeft:  Radius.circular(6)),
                                              color: CustomColors.bluereloadaccount
                                          ),
                                          height: 35,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [

                                              /// Detail
                                              Expanded(
                                                  child: InkWell(
                                                    onTap: (){

                                                      var time = 350;
                                                      if(singleton.isIOS == false){
                                                        time = utils.ValueDuration();
                                                      }

                                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PlansDetalsAltan(),
                                                          reverseDuration: Duration(milliseconds: time)
                                                      )).then((value){
                                                        launchFetch();
                                                      });

                                                    },

                                                    child:Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                                          color: CustomColors.bluereloadaccountbuttons
                                                      ),
                                                      child: Center(
                                                        child: Text(Strings.SEEDETAIL,
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: Strings.font_semiboldFe,
                                                              fontSize: 16
                                                          ),),
                                                      ),
                                                    ),

                                                  ),
                                              ),
                                              

                                              SizedBox(width: 3,),

                                              /// Reload account
                                              Expanded(
                                                child: InkWell(
                                                    onTap: (){

                                                      var time = 350;
                                                      if(singleton.isIOS == false){
                                                        time = utils.ValueDuration();
                                                      }

                                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: RechargePlainView(),
                                                          reverseDuration: Duration(milliseconds: time)
                                                      )).then((value){
                                                        launchFetch();
                                                      });

                                                    },

                                                  child:Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            color: CustomColors.bluereloadaccountbuttons
                                                        ),
                                                        child: Center(
                                                          child: Text(Strings.rechargeAccount,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontFamily: Strings.font_semiboldFe,
                                                                fontSize: 16
                                                            ),),
                                                        ),
                                                      ),

                                                  ),
                                              ),
                                              


                                            ],

                                          ),
                                        )


                                      ],
                                    );

                                  }

                            ),
                          ),
                      ),

                    ],

                  ),
                )

              ),
            ),
          );


        }

    );

  }

  /// Obtain offset
  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;

    singleton.notifierHeightViewWinPoints.value = y + 80;


    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());
    notifierOpacity.value = 0.0;
    /*singleton.notifierOffsetTapCategory.value = [x-20,y];
    if(x>=250){
      singleton.notifierOffsetInitialTapCategory.value = [x-70,y];
    }else singleton.notifierOffsetInitialTapCategory.value = [x-20,y];*/

    singleton.valuenotifierOffsetTapCategory = [];
    singleton.valuenotifierOffsetInitialTapCategory = [];

    singleton.valuenotifierOffsetTapCategory.add(x-20);
    singleton.valuenotifierOffsetTapCategory.add(y);

    if(x>=250){
      singleton.valuenotifierOffsetInitialTapCategory.add(x-70);
    }else{
      singleton.valuenotifierOffsetInitialTapCategory.add(x-20);
    }
    singleton.valuenotifierOffsetInitialTapCategory.add(y);


  }

  /// Run coin animation
  void onAnimationCoin(){

    singleton.notifierOffsetTapCategory.value = [singleton.valuenotifierOffsetTapCategory[0],singleton.valuenotifierOffsetTapCategory[1]];
    singleton.notifierOffsetInitialTapCategory.value = [singleton.valuenotifierOffsetInitialTapCategory[0],singleton.valuenotifierOffsetInitialTapCategory[1]];

    /// add points to animate header icon
    var value = singleton.notifierCategoriesProfile.value.data!.result![singleton.CategoryIndex]!.points!;
    utils.addUserPoint(value);
    utils.addUserPointAnimation();

    Future.delayed(const Duration(milliseconds: 4000), () {
      //singleton.notifierOffsetTapCategory.value = [MediaQuery.of(context).size.width/2 + 30,125];
      singleton.notifierOffsetTapCategory.value = [MediaQuery.of(context).size.width-100,40];

    });


    Future.delayed(const Duration(milliseconds: 4150), () {
      notifierOpacity.value = 1.0;
    });

    Future.delayed(const Duration(milliseconds: 5200), () {
      notifierOpacity.value = 0.0;
      print(singleton.notifierPointsProfile.value);
      singleton.notifierPointsProfile.value = singleton.notifierPointsProfile.value + singleton.notifierCategoriesProfile.value.data!.result![singleton.CategoryIndex]!.points!.toDouble();
      print(singleton.notifierPointsProfile.value);
      utils.heightViewWinPoint();

    });


    Future.delayed(const Duration(milliseconds: 5200), () {
      servicemanager.fetchPointProfileCategories(context);
      servicemanager.fetchPointUserPoints(context);
      servicemanager.fetchUserAltam(context);
    });

  }

  /// Win Bond
  Widget WinBond(BuildContext context){

    return ValueListenableBuilder<List>(
        valueListenable: singleton.notifierOffsetTapCategory,
        builder: (context,value1,_){

          return ValueListenableBuilder<double>(
              valueListenable: singleton.notifierHeightViewWinPoints,
              builder: (context,value10,_){

                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: value10,
                  //color: Colors.yellow,
                  child: ValueListenableBuilder<double>(
                      valueListenable: notifierOpacity,
                      builder: (context,value,_){

                        return Opacity(
                            opacity: value,
                            child: Stack(

                              children: [

                                ValueListenableBuilder<Profilecategories>(
                                    valueListenable: singleton.notifierCategoriesProfile,
                                    builder: (context,value,_){

                                      return ValueListenableBuilder<List>(
                                          valueListenable: singleton.notifierOffsetInitialTapCategory,
                                          builder: (context,value2,_){

                                            return Container(
                                              margin: EdgeInsets.only(top: value2[1],left: value2[0]),
                                              child: BorderedText(
                                                strokeWidth: 10.0,
                                                strokeColor: CustomColors.orangeswitch,
                                                child: Text(
                                                  '+' + singleton.formatter.format((value.code == 1 || value.code == 102 || value.code == 120) ? 0 : value.data!.result![singleton.CategoryIndex]!.points!.toDouble()),
                                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 40.0,),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            );

                                          }

                                      );

                                    }

                                ),

                                AnimatedContainer(
                                  duration: Duration(milliseconds: 1550),
                                  curve: Curves.fastOutSlowIn,
                                  margin: EdgeInsets.only(top: value1[1],left: value1[0]),
                                  /*child: Image(
                                    width: 70,
                                    height: 70,
                                    image: AssetImage("assets/images/coins.png"),
                                    fit: BoxFit.contain,
                                  ),*/
                                    child: SvgPicture.asset(
                                      'assets/images/coins.svg',
                                      fit: BoxFit.contain,
                                      width: 40,
                                      height: 40,
                                    )
                                ),

                              ],

                            )
                        );

                      }


                  ),
                );

              }

          );

        }

    );

  }

  /// header User info
  Widget Header(BuildContext context){

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(const Radius.circular(20)),
        color: CustomColors.blueText,

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,

        children: [

          ///Icon
          InkWell(
            onTap: (){
              //widget.PointProfileCategorie();

              Navigator.pop(context, true);
              //Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                'assets/images/ic_close.svg',
                fit: BoxFit.contain,
                //color: CustomColors.greyplaceholder

              ),
            ),
          ),

          /// username
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ValueListenableBuilder<Getprofile>(
                valueListenable: singleton.notifierUserProfile,
                builder: (context,value1,_){

                  return Text(value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.fullname!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 18,),
                    textScaleFactor: 1.0,
                  );

                }

            ),
          ),

          SizedBox(height: 10,),

          ///UserImage, Points
          Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [


                ///UserImage
                Stack(
                  children: [

                    ClipOval(
                      child: Container(
                        color: Colors.white,
                        height: 65,
                        width: 65,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 2.5,top: 2.5),
                      child: ClipOval(
                        child: ValueListenableBuilder<Getprofile>(
                            valueListenable: singleton.notifierUserProfile,
                            builder: (context,value1,_){

                              return CachedNetworkImage(
                                width: 60,
                                height: 60,
                                imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                  width: 60,
                                  height: 60,
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

                ///Points
                Container(
                  //color: Colors.red,
                  child: Row(

                    children: [

                      ///Image Coins
                      Container(
                        padding: EdgeInsets.only(right: 5,left: 5),
                        //color: Colors.red,
                        child: Image(
                          width: 40,
                          height: 40,
                          image: AssetImage("assets/images/coins.png"),
                          fit: BoxFit.contain,
                        ),
                      ),

                      ///Value Coins
                      Column(

                        children: [

                          ///Count Points
                          ValueListenableBuilder<double>(
                              valueListenable: singleton.notifierPointsProfile,
                              builder: (context,value,_){

                                return Container(
                                  child: Text(singleton.formatter.format(value),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 25,),
                                    textScaleFactor: 1.0,
                                  ),
                                );

                              }

                          ),

                          /// Points
                          Container(
                            child: Text(Strings.points,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.white, fontSize: 12,),
                              textScaleFactor: 1.0,
                            ),
                          ),


                        ],

                      )

                    ],

                  ),
                ),


              ],

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
                      style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 15,),
                      textScaleFactor: 1.0,
                    ),
                  ),

                );

              }

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
                    valueColor: AlwaysStoppedAnimation(CustomColors.orangeback), // Defaults to the current Theme's accentColor.
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

          SizedBox(height: 10,),

        ],

      ),

    );

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

    );

  }


}


///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
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
                              /*return Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );*/
                              return SvgPicture.asset(
                                'assets/images/headerprofile.svg',
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
                              return SvgPicture.asset(
                                'assets/images/headerprofile.svg',
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

                                  Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 4,)) );


                                },

                                //onTapDown: (_) => decrementCounter(),

                              ),*/

                              /// User image
                              InkWell(
                                onTap: (){
                                  //Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
                                  //dialogSetting(context);
                                  var time = 350;
                                  if(singleton.isIOS == false){
                                    time = utils.ValueDuration();
                                  }
                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: ProfileDetail(),
                                      reverseDuration: Duration(milliseconds: time)
                                  ));

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

                                                return CachedNetworkImage(
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
                              ),

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
                          padding: EdgeInsets.only(left: 20,right: 20,top: 5),
                          height: 93,
                          //height: 103,
                          //color: Colors.red,
                          child: Column(

                            children: [

                              ///UserImage
                              /*InkWell(
                                onTap: (){
                                  //imagePicker.showDialog(context);
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
                                          'assets/images/icono5.svg',
                                          fit: BoxFit.cover,
                                          width: 27,
                                          height: 27,
                                        ),
                                      ),
                                    ),

                                  ],

                                ),
                              ),*/

                              SizedBox(height: 5,),

                              /// username
                              /*Container(
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
                              ),*/
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(Strings.encuesta,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 31,),
                                  textScaleFactor: 1.0,
                                )
                              ),


                              Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(Strings.encuesta1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 13.5,),
                                    textScaleFactor: 1.0,
                                  )
                              ),

                              SizedBox(height: 5,),

                              ///Progressbar
                              /*Container(
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

/// Item CompleteProfile
class HeaderChooseCategory extends StatelessWidget {
  final singleton = Singleton();
   HeaderChooseCategory();

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Container(
        //color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start ,

          children: [

            /// Height pre header choose category
            /*ValueListenableBuilder<Getprofile>(
                valueListenable: singleton.notifierUserProfile,
                builder: (context,value3,_){

                  return ValueListenableBuilder<double>(
                      valueListenable: singleton.notifierHeightHeaderWallet1,
                      builder: (context,valueHeight,_){

                        //return SizedBox(height: value3.data!.user!.userAltan! == true ?  valueHeight == 90 ? 0 : 80 : 5,);
                        return SizedBox(height: 15,);

                      }

                  );

                }

            ),

            SizedBox(height: 15,),*/

            /// Choose category
            /*Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(Strings.choosecategory,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 16,),
                textScaleFactor: 1.0,
              ),
            ),
            

            /// Obtain coins
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                // color: Colors.amber,
                child: /*RichText(
                  text: new TextSpan(
                    style: new TextStyle(
                      fontSize: 14.0,
                      //color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: Strings.obtainpoints,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayObtaincoins, fontSize: 14.0,
                      )),
                      new TextSpan(text: Strings.obtainpoints1,style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangeback, fontSize: 14.0,
                      )),
                      new TextSpan(text: Strings.obtainpoints2,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayObtaincoins, fontSize: 14.0,
                      )),

                    ],
                  ),
                ),*/
                Text(Strings.obtainpoints ,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.orangesnack, fontSize: 14,),
                  textScaleFactor: 1.0,
                ),

              ),
            ),*/

            SizedBox(height: 5,),

            ValueListenableBuilder<TotalpointProfileCategories>(
              valueListenable: singleton.notifierPointsProfileCategories,
              builder: (context,value,_){

                var bb1 = (MediaQuery.of(context).size.width- 65);

                if(value.code==100){
                  if(value.data!.point! != 0){
                    var bb = 0.0;
                    bb = (value.code == 1 || value.code == 102 || value.code == 120) ? 0 : (value.data!.totalUser! * 100)/value.data!.point!/100;
                    var ancho = (MediaQuery.of(context).size.width- 65);
                    //var bb1 = bb * ancho + 5;
                    bb1 = ancho - (bb * ancho)  ;
                  }
                }


                return Container(
                  margin: EdgeInsets.only(right: bb1,),
                  alignment: Alignment.centerRight,
                  //color: CustomColors.red,
                  child: ValueListenableBuilder<SegmentationCustom>(
                      valueListenable: singleton.notifierValidateSegmentation,
                      builder: (context,value2,_){

                        /*return SvgPicture.asset(
                          'assets/images/pruebaonline.svg',
                          fit: BoxFit.cover,
                          color: value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.blueback : value2.data!.styles!.colorHeader!.toColors(),
                        );*/
                        return Stack(
                          alignment: Alignment.center,

                          children: [

                            Image(
                              image: AssetImage("assets/images/circuloonline.png"),
                              fit: BoxFit.contain,
                              width: 30,
                              height: 30,
                            ),

                            SvgPicture.asset(
                              'assets/images/pruebaonline.svg',
                              fit: BoxFit.contain,
                              width: 25,
                              height: 25,
                              color: value2.code == 1 ? CustomColors.blueback : value2.code == 100 ? value2.data!.styles!.colorHeader!.toColors() : CustomColors.blueback,
                            )

                          ],

                        );

                      }

                  ),
                );

              }

            ),

            ///Progressbar
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: CustomColors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                //side: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child:
              Container(
                //margin: EdgeInsets.only(left: 20,right: 20),
                //height: 16,
                height: 20,
                child: ValueListenableBuilder<TotalpointProfileCategories>(
                    valueListenable: singleton.notifierPointsProfileCategories,
                    builder: (context,value,_){

                      if(value.code==100){

                        var bb1 = (MediaQuery.of(context).size.width- 65);

                        if(value.code==100){
                          if(value.data!.point! != 0){
                            var bb = 0.0;
                            bb = (value.code == 1 || value.code == 102 || value.code == 120) ? 0 : (value.data!.totalUser! * 100)/value.data!.point!/100;
                            var ancho = (MediaQuery.of(context).size.width- 65);
                            //var bb1 = bb * ancho + 5;
                            bb1 = ancho - (bb * ancho)  ;
                          }
                        }

                        return Stack(
                          children: [

                            /*SvgPicture.asset(
                            'assets/images/J.svg',
                            fit: BoxFit.cover,
                            height: 100,
                          ),*/

                            /// Bar
                            Container(
                              /*decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: CustomColors.gradientBarProgress,
                              begin: FractionalOffset.centerLeft,
                              end: FractionalOffset.centerRight
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                        ),*/
                              child: ValueListenableBuilder<SegmentationCustom>(
                                  valueListenable: singleton.notifierValidateSegmentation,
                                  builder: (context,value2,_){

                                    return LiquidLinearProgressIndicator(
                                      value: (value.code == 1 || value.code == 102 || value.code == 120) ? 0.0 : ((value.data!.totalUser! * 100)/value.data!.point!)/100, // Defaults to 0.5.
                                      valueColor: AlwaysStoppedAnimation(value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.bluebar : value2.data!.styles!.colorHeader!.toColors()), // Defaults to the current Theme's accentColor.
                                      //backgroundColor: Colors.transparent,
                                      backgroundColor: value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.bluebar1 : value2.data!.styles!.colorHeader!.toColors(),
                                      borderColor: CustomColors.white,
                                      borderWidth: 1.0,
                                      borderRadius: 9.0,
                                      direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                      /*center:Text(
                              (value.code == 1 || value.code == 102 || value.code == 120) ? "0" : singleton.formatter.format(value.data!.totalUser!),
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 12,),
                          ),*/

                                    );

                                  }

                              ),
                            ),

                            /// Value
                            Container(
                              width: MediaQuery.of(context).size.width- 65,
                              //height: 20,
                              margin: EdgeInsets.only(right: bb1,top: 2.3),
                              //color: Colors.red,
                              child: Text(
                                value.data!.totalUser!.toString(),
                                //(value.code == 1 || value.code == 102 || value.code == 120) ? "0" : singleton.formatter.format(value.data!.totalUser!),
                                textAlign: TextAlign.right,
                                textScaleFactor: 1.0,
                                style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 12,),
                              ),
                            ),

                          ],
                        );
                      }else{
                        return Container();
                      }

                      /*var bb = 0.0;
                      bb = (value.code == 1 || value.code == 102 || value.code == 120) ? 0 : (value.data!.totalUser! * 100)/value.data!.point!/100;
                      var bb1 = bb * MediaQuery.of(context).size.width;
                      var ancho = MediaQuery.of(context).size.width  ;
                      bb1 = 360;
                      var adi = 65;
                      if(ancho - bb1 < 65){
                        adi = 0;
                      }



                      return Container(
                        /*decoration: BoxDecoration(
                          color: CustomColors.bluebar1.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                        ),*/
                        child: Stack(

                          children: [

                            /*StepProgressIndicator(
                              totalSteps: 40,
                              currentStep: 40,
                              size: 20,
                              //padding: math.pi / 15,
                              selectedColor: CustomColors.bluebar,
                              unselectedColor: CustomColors.bluebar,
                              roundedEdges: Radius.circular(9),
                            ),*/

                            Image(
                              image: AssetImage("assets/images/backbar.png"),
                              fit: BoxFit.cover,
                              height: 20,
                            ),

                            LiquidLinearProgressIndicator(
                              value: (value.code == 1 || value.code == 102 || value.code == 120) ? 0.0 : ((value.data!.totalUser! * 100)/value.data!.point!)/100, // Defaults to 0.5.
                              valueColor: AlwaysStoppedAnimation(CustomColors.blueBack,), // Defaults to the current Theme's accentColor.
                              //backgroundColor: CustomColors.grayTabBar1, // Defaults to the current Theme's backgroundColor.
                              backgroundColor: CustomColors.bluebar1.withOpacity(0.5),
                              borderColor: CustomColors.white,
                              borderWidth: 1.0,
                              borderRadius: 9.0,
                              direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                              center: Container(
                                padding: EdgeInsets.only(
                                    right: ancho > bb1 ? ancho - bb1 - adi : 0,
                                    left: ancho >= bb1 ? 0 : ancho - bb1 - adi,
                                ),
                                color: Colors.red,
                                child: Text(
                                  (value.code == 1 || value.code == 102 || value.code == 120) ? "0" : singleton.formatter.format(value.data!.totalUser!),
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 12,),
                                ),
                              ),

                            )


                          ],
                        ),
                      );*/

                    }

                ),
              ),
            ),

            //SizedBox(height: 5,),
            ///Percentage
            ValueListenableBuilder<TotalpointProfileCategories>(
                valueListenable: singleton.notifierPointsProfileCategories,
                builder: (context,value,_){

                  if(value.code==100){
                    return Container(

                      child: Container(
                        padding: EdgeInsets.only(right: 5),
                        alignment: Alignment.centerRight,
                        //color: Colors.red,
                        child: ValueListenableBuilder<SegmentationCustom>(
                            valueListenable: singleton.notifierValidateSegmentation,
                            builder: (context,value2,_){

                              return Text(
                                //singleton.formatter.format((value.data!.totalUser! * 100)/value.data!.point!) + "%",
                                singleton.formatter.format(value.data!.point!),
                                textAlign: TextAlign.right,
                                style: TextStyle(fontFamily: Strings.font_boldFe, color: value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.blueback : value2.data!.styles!.colorHeader!.toColors(), fontSize: 13,),
                                textScaleFactor: 1.0,
                              );

                            }

                        ),
                      ),

                    );
                  }else{
                    return Container();
                  }


                }

            ),

          ],

        ),

      ),
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

/// Item
class _itemGane extends StatelessWidget {

  _itemGane(this.item, this.index, this.relaunch);

  final VoidCallback relaunch;
  final ResultSL item;
  final int index;
  final singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int randomNumber = random.nextInt(10);
    final maxWidth = (MediaQuery.of(context).size.width / 3) - 35;
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: CustomColors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: CustomColors.white, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      //color: backgroundColor,
      child: InkWell(
        onTap: () {
          singleton.GaneOrMira = "gane";
          singleton.itemSelected = index;
          singleton.idSecuence = item.id!;
          singleton.idAds = item.ads![0]!.id!;
          singleton.format = item.ads![0]!.formatValue!;
          singleton.notifierPointsGaneRoom.value = item.ads![0]!.pointsAds!;

          singleton.isOnNotificationView = false;

          if(item.ads![0]!.formatValue == 3){ /// Poll
            singleton.notifierQuestionAds.value = item.ads![0]!.questionAds!;

          }else{
            singleton.notifierQuestionAds.value = <QuestionAds>[];
          }

          var time = 350;
          if(singleton.isIOS == false){
            time = utils.ValueDuration();
          }

          singleton.itemSequence = item;

          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: GaneCampaignDetail(item: item,relaunch: relaunch,),
              reverseDuration: Duration(milliseconds: time)
          )).then((value) {
            if(value=="relaunch"){
            }

          });


        },
        child: Center(
          child: Stack(

            children: [

              ///Image
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: item.ads![0]!.formatValue == 1 ? item.ads![0]!.adImages! : item.ads![0]!.lgImages!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Image(
                  image: AssetImage('assets/images/ic_gane.png'),
                  color: CustomColors.graylines.withOpacity(0.6),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),

              /// Value coins
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(top: 1,bottom: 1,left: 3),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                    ),
                    color: CustomColors.orangeback1,
                    //color: "#00A86B".toColors()
                  ),
                  child: Row(

                    //mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// Points
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          //color: Colors.blue,
                          child: AutoSizeText(
                            singleton.formatter.format(utils.valuePointsAds(item)),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(fontFamily: Strings.font_black, color: CustomColors.white, fontSize: 18,),
                            textScaleFactor: 1.0,
                            //maxLines: 1,
                          ),
                        ),
                      ),

                      SizedBox(width: 3,),

                      ///Icon
                      Container(

                        padding: EdgeInsets.only(bottom: 3),
                        child: SvgPicture.asset(
                          'assets/images/coins.svg',
                          fit: BoxFit.contain,
                          width: 16,
                          height: 16,
                        ),

                        /*child: Container(
                            child: Stack(
                              alignment: Alignment.center,

                              children: [

                                Image(
                                  image: AssetImage("assets/images/circuloonline.png"),
                                  fit: BoxFit.contain,
                                  width: 16,
                                  height: 16,
                                  //color: "#00A86B".toColors(),
                                ),

                                Image(
                                  image: AssetImage("assets/images/monedaonline.png"),
                                  fit: BoxFit.contain,
                                  width: 16,
                                  height: 16,
                                  color: "#00A86B".toColors(),
                                )

                              ],

                            ),
                          )*/


                      ),

                      SizedBox(width: 3,),

                    ],

                  ),
                ),
              ),

              /// Top Points
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  //color: Colors.lightBlueAccent,
                  color: CustomColors.black.withOpacity(0.20),
                  height: 7,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: item.ads!.length,
                      itemBuilder: (BuildContext context, int index){

                        return Container(
                          margin: EdgeInsets.only(right: 3),
                          width: 3.0,
                          height: 3.0,
                          decoration: new BoxDecoration(
                            color: index==0 ? CustomColors.white : CustomColors.white.withOpacity(0.7),
                            //color: CustomColors.graydots,
                            shape: BoxShape.circle,
                          ),
                        );

                      },

                    ),
                  ),
                ),
              ),

            ],

          ),
        ),
      ),
    );
  }


  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 2),
      pageBuilder: (context, animation, secondaryAnimation) =>  GaneCampaignDetail(item: item,relaunch: relaunch,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}