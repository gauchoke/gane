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
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gane/src/Models/altanplan.dart';
import 'package:gane/src/Models/altanplane1.dart';
import 'package:gane/src/Models/bannerWall.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/planaltandetail.dart';
import 'package:gane/src/Models/planaltandetail1.dart';
import 'package:gane/src/Models/profilecategories.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/useraltam.dart';
import 'package:gane/src/Models/userpointlist.dart';
import 'package:gane/src/Models/userpointlist1.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Home/RechargePlain/RechargePlainView.dart';
import 'package:gane/src/UI/Home/detailcategory.dart';
import 'package:gane/src/UI/Home/pidechip.dart';
import 'package:gane/src/UI/Home/plansdetailsaltan.dart';
import 'package:gane/src/UI/Home/profileDetail.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_redeem.dart';
import 'package:gane/src/Widgets/dialog_setting.dart';
import 'package:intl/intl.dart';
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
import 'package:transition/transition.dart';
import 'dart:ui' as ui;
import 'package:badges/badges.dart' as badges;


class ProfileUserView extends StatefulWidget{

  final from;
  final VoidCallback? PointProfileCategorie;

  ProfileUserView({this.from, this.PointProfileCategorie});

  _stateProfileUserView createState()=> _stateProfileUserView();
}

class _stateProfileUserView extends State<ProfileUserView> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;

  final notifierHelp = ValueNotifier(0);
  /*late AnimationController controllerAnima;
  late Animation<double> animationIn;
  late AnimationController controllerProgress;
  late Animation<double> animationProgress;
  late AnimationController controllerCategory;
  late Animation<double> animationCategory;
  late AnimationController controller;
  late Animation<double> animationWith;*/



  double ratioScreen = 3.0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final notifierOpacity = ValueNotifier(0.0);
  final notifierHide = ValueNotifier(true);
  ScrollController _scrollViewController = new ScrollController();
  var heightContainerDetailPlain = 10;

  late HomeProvider providerHome;
  final notifierHeaderTab = ValueNotifier(0);
  final notifierShowDetails = ValueNotifier(true);


  @override
  void initState(){
    //singleton.notifierHeightPlanGane.value = 100;
    //singleton.notifierHeightHeaderWallet1.value = 180.0;

    singleton.notifierHeightHeaderWallet1.value = 150.0;

   /* utils.heightViewWinPoint();

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


      Future.delayed(const Duration(milliseconds: 650), () {
        //controllerAnima.forward();
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
          singleton.notifierHeightHeaderWallet1.value = 180.0;
          singleton.notifierHeightPlanGane.value = 100.0;
        }
      });

      singleton.notifierHeightHeaderWallet1.value = 180.0;

      Future.delayed(const Duration(milliseconds: 650), () {
        _scrollViewController.jumpTo(_scrollViewController.position.minScrollExtent);

      });


    });

    super.initState();
  }

  /// Tap next help view
  void tapNextHelp(){

    //prefs.helCategories = "";

    notifierHide.value = false;

    if(notifierHelp.value==0){ /// Help coins
      //controllerAnima.reverse();
      Future.delayed(const Duration(milliseconds: 250), () {
        //controllerProgress.forward();
      });
      notifierHelp.value = notifierHelp.value + 1;

    }else if(notifierHelp.value==1){ /// Help progress
      //controllerProgress.reverse();
      Future.delayed(const Duration(milliseconds: 250), () {
        //controllerCategory.forward();
      });
      notifierHelp.value = notifierHelp.value + 1;

    }else if(notifierHelp.value==2){ /// Help Categories
      //controllerCategory.reverse();
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
        singleton.notifierUserPoints.value = Userpoints(code: 1,message: "No hay nada", status: false, data: DataPU(result: "0") );



        servicemanager.fetchUserProfile1(context);
        servicemanager.fetchSettings(context);
        servicemanager.fetchPointUserPoints(context);
        servicemanager.fetchListPointsUser1(context, "borrar");
        servicemanager.fetchValidateSegmentation(context);

        //servicemanager.fetchCategoriesProfile(context,"borrar");
        //servicemanager.fetchPointProfileCategories(context);
        //servicemanager.fetchAltanPlansDetails(context);


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

  /*/// Reset Load
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


  }*/

  /// Reset Load
  void _onRefresh() async{
    singleton.UserPointsPages = 0;
    _refreshController.refreshCompleted();
    launchFetch();
  }

  ///Load More
  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();

    if(singleton.notifierListUserPoints1.value.code == 100){

      //if(singleton.notifierListUserPoints.value.data!.page! >= (singleton.UserPointsPages + 1)){
      if(singleton.notifierListUserPoints1.value.data!.totalPages! >= (singleton.UserPointsPages + 1)){
        singleton.UserPointsPages = singleton.UserPointsPages + 1;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            //servicemanager.fetchListPointsUser(context,"agregar");
            servicemanager.fetchListPointsUser1(context,"agregar");
          }
        } on SocketException catch (_) {
          print('not connected');
          singleton.isOffline = true;
          //Navigator.pop(context);
          ConnectionStatusSingleton.getInstance().checkConnection();
        }
      }

    }

    /*if(provider.notifierLookRoomss.code == 100){

      if(provider.notifierLookRoomss.data!.page! >= (singleton.Gane1RoomPages + 1)){
        singleton.Gane1RoomPages = singleton.Gane1RoomPages + 1;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            Future callUser = servicemanager.fetchGaneRoom(context,"agregar");
            await callUser.then((data) {
              if (data.code == 100) {

                Roomlook notifierGaneRoom = provider.notifierLookRoomss;
                notifierGaneRoom.data!.result!.addAll(data.data!.result!);
                provider.notifierLookRoomss = Roomlook(code: 1,message: "No hay nada", status: false, );
                provider.notifierLookRoomss = notifierGaneRoom;

                //provider.notifierLookRoomss.data!.result!.addAll(data.data!.result!);
                print(provider.notifierLookRoomss);
              }

            }, onError: (error) {
            });

          }
        } on SocketException catch (_) {
          print('not connected');
          singleton.isOffline = true;
          //Navigator.pop(context);
          ConnectionStatusSingleton.getInstance().checkConnection();
        }
      }

    }*/


  }

  @override
  void dispose() {
    //controllerAnima.dispose();
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

                        /// User Gane or No
                        /* ValueListenableBuilder<Getprofile>(
                            valueListenable: singleton.notifierUserProfile,
                            builder: (context,value2,_){
                              return value2.data!.user!.userAltan! == false ? Container(width: 0,height: 0,) : dataPlanGane(context);

                            }

                        ),*/


                        /*UsePhoto(context),*/

                        ///Help
                        /*ValueListenableBuilder<int>(
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
                                                            margin: const EdgeInsets.only(left: 30,right: 30,top: 110),
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
                                                              Container(/// modificar con endpoint
                                                                margin:  EdgeInsets.only(left: 30,right: 30,top: valueP.data!.user!.userAltan == false ? 180 : 270),//180
                                                                height: 80,
                                                                width: MediaQuery.of(context).size.width,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.red,
                                                                  borderRadius: BorderRadius.circular(7),
                                                                ),
                                                              ),

                                                              Align(
                                                                alignment: Alignment.topLeft,
                                                                //left: 0,
                                                                //top: MediaQuery.of(context).size.height / 3,
                                                                child: Container(  /// modificar con endpoint
                                                                  //margin:  EdgeInsets.only(top: (MediaQuery.of(context).size.height >=535.0 && MediaQuery.of(context).size.height <=725.0) ? 268 : MediaQuery.of(context).size.height >725.0 ?  288 : MediaQuery.of(context).devicePixelRatio > 3.0 ? 66 : 280,left: 22),
                                                                  margin:  EdgeInsets.only(
                                                                      top: (
                                                                          /// User altan
                                                                          valueP.data!.user!.userAltan == true && MediaQuery.of(context).size.height >=535.0 && MediaQuery.of(context).size.height <=725.0) ? 358 :
                                                                      valueP.data!.user!.userAltan == true && MediaQuery.of(context).size.height >725.0 ?  378 :
                                                                      valueP.data!.user!.userAltan == true && MediaQuery.of(context).devicePixelRatio > 3.0 ? 66 :
                                                                      valueP.data!.user!.userAltan == true ? 370 :
                                                                      /// User No altan
                                                                      (valueP.data!.user!.userAltan == false && MediaQuery.of(context).size.height >=535.0 && MediaQuery.of(context).size.height <=725.0) ? 268 :
                                                                      valueP.data!.user!.userAltan == false && MediaQuery.of(context).size.height >725.0 ?  288 :
                                                                      valueP.data!.user!.userAltan == false && MediaQuery.of(context).devicePixelRatio > 3.0 ? 66 :
                                                                      280

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
                                                height: 210,

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
                                                height: 263,

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
                                                width: 100,
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

                        WinBond(context),*/

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
      margin: EdgeInsets.only(left: 15,right: 15),
      color: CustomColors.graybackwallet,

      child: ValueListenableBuilder<double>(
          valueListenable: singleton.notifierHeightHeaderWallet1,
          builder: (context,value2,_){

            return ValueListenableBuilder<Getprofile>(
                valueListenable: singleton.notifierUserProfile,
                builder: (context,value3,_){

                  return Container(
                    //color: Colors.yellow,
                    margin: EdgeInsets.only(top: value2==90?value2:value2+heightContainerDetailPlain,bottom: 10),
                    child:

                    /*ValueListenableBuilder<Profilecategories>(
                        valueListenable: singleton.notifierCategoriesProfile,
                        builder: (context,value1,_){

                          return Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: CustomColors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              child: Stack(
                                children: [

                                  /// Header tabs
                                  headerTab(context),

                                  //PlanMonis(context),

                                  /// Table tabbar
                                  ValueListenableBuilder<int>(
                                      valueListenable: notifierHeaderTab,
                                      builder: (context,valuetab, _){

                                        return valuetab == 0 ?  /// Saldo
                                        Container(
                                          padding: EdgeInsets.only(top: 50),
                                          child: Container(
                                            child: ValueListenableBuilder<PlansAltanDetails1>(
                                                valueListenable: singleton.notifierPlansDetailsAltan1,
                                                builder: (context,value1,_){

                                                  return SingleChildScrollView(
                                                    controller: _scrollViewController,
                                                    child: ListView.builder(
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: value1.code == 1 ? 9 : value1.code == 102 ? 2 : value1.data!.plans!.length+1,
                                                      itemBuilder: (BuildContext context, int index){

                                                        if(value1.code==1){ ///preloading
                                                          return utils.PreloadingSubCategories();

                                                        }else if(value1.code==102){ ///No data

                                                          if(index==0){
                                                            return PlanMonis(context);
                                                          }else{

                                                            if(singleton.notifierUserProfile.value.data!.user!.userAltan! == false){
                                                              return InkWell(
                                                                onTap: (){
                                                                  var time = 350;
                                                                  if(singleton.isIOS == false){
                                                                    time = utils.ValueDuration();
                                                                  }
                                                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                                                                      reverseDuration: Duration(milliseconds: time)
                                                                  )).then((value) {
                                                                  });
                                                                },
                                                                child: ValueListenableBuilder<BannerWallet>(
                                                                    valueListenable: singleton.notifierBannerAltan,
                                                                    builder: (context,valueBanner,_){


                                                                      return Card(
                                                                        margin: EdgeInsets.all(10),
                                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                        color: CustomColors.white,
                                                                        elevation: 0,
                                                                        shape: RoundedRectangleBorder(
                                                                          side: BorderSide(color: Colors.transparent, width: 1),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: Image.network(
                                                                          valueBanner.data!.item!.photoUrl!,
                                                                          fit: BoxFit.cover,
                                                                          height: 100,
                                                                          frameBuilder: (_, image, loadingBuilder, __) {
                                                                            if (loadingBuilder == null) {
                                                                              return const SizedBox(
                                                                                child: Center(
                                                                                    child: CircularProgressIndicator(
                                                                                      color: Color(0xFFFF4D00),
                                                                                    )
                                                                                ),
                                                                              );
                                                                            }
                                                                            return image;
                                                                          },
                                                                          loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                                                            if (loadingProgress == null) return image;
                                                                            return SizedBox(
                                                                              child: Center(
                                                                                child: CircularProgressIndicator(
                                                                                  value: loadingProgress.expectedTotalBytes != null
                                                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                      : null,
                                                                                  color: Color(0xFFFF4D00),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          errorBuilder: (_, __, ___) =>
                                                                              SvgPicture.asset(
                                                                                'assets/images/ic_gane.svg',
                                                                                fit: BoxFit.contain,

                                                                              ),
                                                                        ),
                                                                      );

                                                                    }

                                                                ),
                                                              );
                                                            }else
                                                              return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");
                                                          }

                                                        }else{/// Item

                                                          if(index==0){
                                                            return PlanMonis(context);
                                                          } else{

                                                            /*return Container(
                                                              color: CustomColors.grayBackDetailPlan,
                                                              margin: EdgeInsets.only(left: 10,right: 10),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                crossAxisAlignment: CrossAxisAlignment.start,

                                                                children: [

                                                                  //SizedBox(height: 20,),

                                                                  /// Name
                                                                  value1.data!.plans![index-1].name! == "" ? Container(height: 0,): Container(

                                                                    child:Html(
                                                                      data: value1.data!.plans![index-1].name!,
                                                                      style: {
                                                                        "b": Style(
                                                                          fontSize: FontSize(27.0),
                                                                          fontFamily: Strings.font_bold,
                                                                          color: HexColor(value1.data!.plans![index-1].color!),
                                                                        ),
                                                                        "p": Style(
                                                                          fontSize: FontSize(17.0),
                                                                          fontFamily: Strings.font_medium,
                                                                          color: CustomColors.black,
                                                                        ),
                                                                      },
                                                                    ),
                                                                  ),

                                                                  SizedBox(height: value1.data!.plans![index-1].name! == "" ? 15 : 0,),

                                                                  /// PLan Details SMS, Data
                                                                  Container(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [


                                                                        /// SMS
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
                                                                                    child: AutoSizeText(value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index-1].smsConvert!,
                                                                                      //double.parse(value1.data!.plans![index].sms!) / 1000 > 1 ? (singleton.formatter1.format(double.parse(value1.data!.plans![index].sms!)/1000) + Strings.datos3).replaceAll(".", ",") : singleton.formatter1.format(double.parse(value1.data!.plans![index].sms!)) ,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.black, fontSize: 20,),
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
                                                                                    child: AutoSizeText(Strings.sms,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
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
                                                                                    child: AutoSizeText(value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index-1].minuteConvert!,
                                                                                      //double.parse(value1.data!.plans![index].min!) / 1000 > 1 ? (singleton.formatter1.format(double.parse(value1.data!.plans![index].min!)/1000)+ Strings.datos3).replaceAll(".", ",") : singleton.formatter1.format(double.parse(value1.data!.plans![index].min!)),
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.black, fontSize: 20,),
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
                                                                                      style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
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
                                                                                      value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index-1].gbConvert!,
                                                                                      //double.parse(value1.data!.plans![index].gb!) > 999 ? singleton.formatter.format( double.parse(value1.data!.plans![index].gb!)/1000 )+ Strings.datos1 :
                                                                                      //singleton.formatter1.format(double.parse(value1.data!.plans![index].gb!))+ Strings.datos2,
                                                                                      //singleton.formatter1.format( double.parse(value1.data!.plans![index].gb!)/1000 )+ Strings.datos1,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.black, fontSize: 20,),
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
                                                                                      style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
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
                                                                                      value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index-1].gbRedConvert!,
                                                                                      //double.parse(value1.data!.plans![index].gbRed!) > 999 ? singleton.formatter.format( double.parse(value1.data!.plans![index].gbRed!)/1000 ) + Strings.datos1:
                                                                                      //singleton.formatter1.format(double.parse(value1.data!.plans![index].gbRed!))+ Strings.datos2,
                                                                                      //singleton.formatter1.format( double.parse(value1.data!.plans![index].gbRed!)/1000 ) + Strings.datos1,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.black, fontSize: 20,),
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
                                                                                      style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
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
                                                                  ),

                                                                  SizedBox(height: 15,),

                                                                  /// Vigency
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 10,right: 10),
                                                                    child: RichText(
                                                                      textScaleFactor: 1.0,
                                                                      text: new TextSpan(
                                                                        style: new TextStyle(
                                                                          fontSize: 15.0,
                                                                          //color: Colors.black,
                                                                        ),
                                                                        children: <TextSpan>[
                                                                          new TextSpan(text: Strings.vigencia,style: TextStyle(fontFamily: Strings.font_semiboldFe, color: HexColor(value1.data!.plans![index-1].color!), fontSize: 10.0,
                                                                          )),
                                                                          new TextSpan(text: value1.data!.plans![index-1].expireDate! == "" ? "" : DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index-1].expireDate!).toLocal()).toUpperCase() ,style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blacktyc, fontSize: 10.0,
                                                                          )),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  SizedBox(height: 20,),

                                                                  Container(
                                                                    height: 1, color: CustomColors.grayTabBar,
                                                                  )


                                                                ],

                                                              ),
                                                            );*/

                                                            return ValueListenableBuilder<bool>(
                                                                  valueListenable: notifierShowDetails,
                                                                  builder: (context,valueDetail,_){

                                                                    return valueDetail == false ? SizedBox(height: 0,) : Container(
                                                                      color: index%2 == 0 ? CustomColors.grayBackDetailPlan : CustomColors.white,
                                                                      margin: EdgeInsets.only(left: 10,right: 10),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,

                                                                        children: [

                                                                          ///Reload and date
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [

                                                                                /// Reload
                                                                                Expanded(
                                                                                  child: AutoSizeText(Strings.reload+ (index).toString(),
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15,),
                                                                                    textScaleFactor: 1.0,
                                                                                    maxLines: 1,
                                                                                    minFontSize: 6,
                                                                                  ),
                                                                                ),

                                                                                /// Date
                                                                                Expanded(
                                                                                  child: AutoSizeText(
                                                                                    value1.data!.plans![index-1].createdDate!  == "" ? "-" :
                                                                                    DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index-1].createdDate!).toLocal()),
                                                                                    textAlign: TextAlign.right,
                                                                                    style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                    textScaleFactor: 1.0,
                                                                                    maxLines: 1,
                                                                                    minFontSize: 6,
                                                                                  ),
                                                                                ),


                                                                              ],
                                                                            ),
                                                                          ),

                                                                          ///Expirate date
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [

                                                                                /// Reload
                                                                                Expanded(
                                                                                  child: AutoSizeText(Strings.expireddate,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                    textScaleFactor: 1.0,
                                                                                    maxLines: 1,
                                                                                    minFontSize: 6,
                                                                                  ),
                                                                                ),

                                                                                /// Date
                                                                                Expanded(
                                                                                  child: AutoSizeText(
                                                                                    value1.data!.plans![index-1].createdDate!  == "" ? "-" :
                                                                                    DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index-1].createdDate!).toLocal()),
                                                                                    textAlign: TextAlign.right,
                                                                                    style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                    textScaleFactor: 1.0,
                                                                                    maxLines: 1,
                                                                                    minFontSize: 6,
                                                                                  ),
                                                                                ),


                                                                              ],
                                                                            ),
                                                                          ),

                                                                          SizedBox(height: 15 ),

                                                                          /// Name
                                                                          value1.data!.plans![index-1].name! == "" ? Container(height: 0,): Container(
                                                                            margin: EdgeInsets.all(10),
                                                                            color: CustomColors.grayBackDetailPlan,
                                                                            child:Html(
                                                                              data: value1.data!.plans![index-1].name!,
                                                                              style: {
                                                                                "b": Style(
                                                                                    fontSize: FontSize(27.0),
                                                                                    fontFamily: Strings.font_bold,
                                                                                    color: HexColor(value1.data!.plans![index-1].color!),
                                                                                    alignment: Alignment.center,textAlign: TextAlign.center
                                                                                ),
                                                                                "p": Style(
                                                                                    fontSize: FontSize(17.0),
                                                                                    fontFamily: Strings.font_medium,
                                                                                    color: CustomColors.black,
                                                                                    alignment: Alignment.center,textAlign: TextAlign.center
                                                                                ),
                                                                              },
                                                                            ),
                                                                          ),

                                                                          SizedBox(height: value1.data!.plans![index-1].name! == "" ? 15 : 5,),

                                                                          /// PLan Details SMS, Data
                                                                          Container(
                                                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                                                            child: Column(

                                                                              children: [

                                                                                ///SMS
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// SMS
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.sms,
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.sms!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.sms!.value!,
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 5),

                                                                                ///Minutes
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// Minutes
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.minutes1,
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.minute!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.minute!.value!,
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 5,),

                                                                                /// GB full
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// GB full
                                                                                    Expanded(
                                                                                      flex: 3,
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.datosfull,
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.gbFull!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.gbFull!.value!,
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 5,),

                                                                                /// GB full reducida
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// GB full
                                                                                    Expanded(
                                                                                      flex: 3,
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.velredufull,
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.velRed!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.velRed!.value!,

                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 10,),

                                                                              ],

                                                                            ),
                                                                          ),

                                                                          SizedBox(height: 15,),

                                                                          /// Saldo recarga title
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                            child: AutoSizeText(Strings.balancereload+ (index).toString(),
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15,),
                                                                              textScaleFactor: 1.0,
                                                                              maxLines: 1,
                                                                              minFontSize: 6,
                                                                            ),
                                                                          ),

                                                                          SizedBox(height: 10,),

                                                                          /// PLan Details SMS, Data  Saldos
                                                                          Container(
                                                                            margin: EdgeInsets.symmetric(horizontal: 10),
                                                                            child: Column(

                                                                              children: [

                                                                                ///SMS
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// SMS
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.sms,
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.sms!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.sms!.value!,
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 5),

                                                                                ///Minutes
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// Minutes
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.minutes1,
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.minute!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.minute!.value!,
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 5,),

                                                                                /// GB full
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// GB full
                                                                                    Expanded(
                                                                                      flex: 3,
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.datosfull,
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.gbFull!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.gbFull!.value!,
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 5,),

                                                                                /// GB full reducida
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [

                                                                                    /// GB full
                                                                                    Expanded(
                                                                                      flex: 3,
                                                                                      child: Container(
                                                                                        //color: Colors.red,
                                                                                        child: AutoSizeText(
                                                                                          //Strings.velredufull,
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.velRed!.name!,
                                                                                          textAlign: TextAlign.left,
                                                                                          textScaleFactor: 1.0,
                                                                                          //maxLines: 1,
                                                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                          //maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                    ///Value
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        child: AutoSizeText(
                                                                                          value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.velRed!.value!,

                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                          textScaleFactor: 1.0,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),

                                                                                SizedBox(height: 10,),

                                                                              ],

                                                                            ),
                                                                          ),

                                                                          SizedBox(height: 20,),

                                                                        ],

                                                                      ),
                                                                    );

                                                                  }

                                                            );

                                                          }


                                                        }


                                                      },

                                                    ),
                                                  );

                                                }

                                            ),
                                          ),
                                        ) :
                                        Container(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 50),
                                            child: ValueListenableBuilder<Userpointlist1>(
                                                valueListenable: singleton.notifierListUserPoints1,
                                                builder: (context,value1,_){

                                                  return  Container(
                                                    //color: Colors.green,
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(15.0),
                                                        topRight: Radius.circular(15.0),
                                                      ),
                                                      color: CustomColors.graybackwallet,

                                                    ),
                                                    child: SmartRefresher(
                                                      enablePullDown: true,
                                                      enablePullUp: true,
                                                      footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                                                      header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, distance: 30, offset: 0,),
                                                      controller: _refreshController,
                                                      onRefresh: _onRefresh,
                                                      onLoading: _onLoading,
                                                      child: value1.code == 102 ?

                                                      Container(
                                                        //margin: EdgeInsets.only(top: 30),
                                                        child: utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg"),
                                                      ) :

                                                      ListView.builder(
                                                        controller: _scrollViewController,
                                                        padding: EdgeInsets.only(top: 0,left: 0,right: 0,),
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: value1.code == 1 ? 6 : value1.code == 102 ? 1 : value1.code == 120 ? 0 : value1.data!.items!.length ,
                                                        itemBuilder: (BuildContext context, int index){

                                                          if(value1.code == 1){
                                                            return utils.PreloadingPlane1();

                                                          }else if(value1.code == 102){
                                                            return utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg");

                                                          }else{

                                                            return itemPoints(value1.data!.items![index],index, context);

                                                          }


                                                        },

                                                      ),

                                                    ),
                                                  );

                                                }

                                            ),
                                          ),
                                        ) ; /// Monis History

                                      }
                                  )



                                ],
                              ),
                            ),
                          );

                        }

                    ),*/

                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: CustomColors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        child: Stack(
                          children: [

                            /// Header tabs
                            headerTab(context),

                            /// Table tabbar
                            ValueListenableBuilder<int>(
                                valueListenable: notifierHeaderTab,
                                builder: (context,valuetab, _){

                                  /*return valuetab == 0 ?  /// Saldo
                                  Container(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Container(
                                      child: ValueListenableBuilder<AltanPLane1>(
                                          valueListenable: singleton.notifierUseraltanPlan1,
                                          builder: (context,value1,_){

                                            return SingleChildScrollView(
                                              controller: _scrollViewController,
                                              child: ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                                                scrollDirection: Axis.vertical,
                                                itemCount:  value1.code == 1 ? 9 : value1.code == 102 ? 2 : value1.data!.plans!.isEmpty ?  2 : value1.data!.plans!.length+1,
                                                itemBuilder: (BuildContext context, int index){

                                                  if(value1.code==1){ ///preloading
                                                    return utils.PreloadingSubCategories();

                                                  }else if(value1.code==102){ ///No data

                                                    if(index==0){
                                                      return PlanMonis(context);
                                                    }else{

                                                      if(singleton.notifierUserProfile.value.data!.user!.userAltan! == false){
                                                        return InkWell(
                                                          onTap: (){
                                                            var time = 350;
                                                            if(singleton.isIOS == false){
                                                              time = utils.ValueDuration();
                                                            }
                                                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                                                                reverseDuration: Duration(milliseconds: time)
                                                            )).then((value) {
                                                            });
                                                          },
                                                          child: ValueListenableBuilder<BannerWallet>(
                                                              valueListenable: singleton.notifierBannerAltan,
                                                              builder: (context,valueBanner,_){


                                                                return Card(
                                                                  margin: EdgeInsets.all(10),
                                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                  color: CustomColors.white,
                                                                  elevation: 0,
                                                                  shape: RoundedRectangleBorder(
                                                                    side: BorderSide(color: Colors.transparent, width: 1),
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                  child: Image.network(
                                                                    valueBanner.data!.item!.photoUrl!,
                                                                    fit: BoxFit.cover,
                                                                    height: 100,
                                                                    frameBuilder: (_, image, loadingBuilder, __) {
                                                                      if (loadingBuilder == null) {
                                                                        return const SizedBox(
                                                                          child: Center(
                                                                              child: CircularProgressIndicator(
                                                                                color: Color(0xFFFF4D00),
                                                                              )
                                                                          ),
                                                                        );
                                                                      }
                                                                      return image;
                                                                    },
                                                                    loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                                                      if (loadingProgress == null) return image;
                                                                      return SizedBox(
                                                                        child: Center(
                                                                          child: CircularProgressIndicator(
                                                                            value: loadingProgress.expectedTotalBytes != null
                                                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                : null,
                                                                            color: Color(0xFFFF4D00),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorBuilder: (_, __, ___) =>
                                                                        SvgPicture.asset(
                                                                          'assets/images/ic_gane.svg',
                                                                          fit: BoxFit.contain,

                                                                        ),
                                                                  ),
                                                                );

                                                              }

                                                          ),
                                                        );
                                                      }else
                                                        return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");
                                                    }

                                                  }else{/// Item

                                                    if(index==0){
                                                      return PlanMonis(context);
                                                    } else{
                                                        return ValueListenableBuilder<bool>(
                                                            valueListenable: notifierShowDetails,
                                                            builder: (context,valueDetail,_){

                                                              if(value1.data!.plans!.isEmpty){
                                                                if(singleton.notifierUserProfile.value.data!.user!.userAltan! == false){
                                                                  return InkWell(
                                                                    onTap: (){
                                                                      var time = 350;
                                                                      if(singleton.isIOS == false){
                                                                        time = utils.ValueDuration();
                                                                      }
                                                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                                                                          reverseDuration: Duration(milliseconds: time)
                                                                      )).then((value) {
                                                                      });
                                                                    },
                                                                    child: ValueListenableBuilder<BannerWallet>(
                                                                        valueListenable: singleton.notifierBannerAltan,
                                                                        builder: (context,valueBanner,_){


                                                                          return Card(
                                                                            margin: EdgeInsets.all(10),
                                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                            color: CustomColors.white,
                                                                            elevation: 0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(color: Colors.transparent, width: 1),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Image.network(
                                                                              valueBanner.data!.item!.photoUrl!,
                                                                              fit: BoxFit.cover,
                                                                              height: 100,
                                                                              frameBuilder: (_, image, loadingBuilder, __) {
                                                                                if (loadingBuilder == null) {
                                                                                  return const SizedBox(
                                                                                    child: Center(
                                                                                        child: CircularProgressIndicator(
                                                                                          color: Color(0xFFFF4D00),
                                                                                        )
                                                                                    ),
                                                                                  );
                                                                                }
                                                                                return image;
                                                                              },
                                                                              loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                                                                if (loadingProgress == null) return image;
                                                                                return SizedBox(
                                                                                  child: Center(
                                                                                    child: CircularProgressIndicator(
                                                                                      value: loadingProgress.expectedTotalBytes != null
                                                                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                          : null,
                                                                                      color: Color(0xFFFF4D00),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              errorBuilder: (_, __, ___) =>
                                                                                  SvgPicture.asset(
                                                                                    'assets/images/ic_gane.svg',
                                                                                    fit: BoxFit.contain,

                                                                                  ),
                                                                            ),
                                                                          );

                                                                        }

                                                                    ),
                                                                  );
                                                                }else {
                                                                  return valueDetail == false ? SizedBox(height: 0,) : utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");
                                                                }

                                                              }else {
                                                                  return valueDetail == false ? SizedBox(height: 0,) : Container(
                                                                    color: index%2 == 0 ? CustomColors.grayBackDetailPlan : CustomColors.white,
                                                                    margin: EdgeInsets.only(left: 10,right: 10),
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,

                                                                      children: [

                                                                        ///Reload and date
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [

                                                                              /// Reload
                                                                              Expanded(
                                                                                child: AutoSizeText(Strings.reload+ (index).toString(),
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15,),
                                                                                  textScaleFactor: 1.0,
                                                                                  maxLines: 1,
                                                                                  minFontSize: 6,
                                                                                ),
                                                                              ),

                                                                              /// Date
                                                                              Expanded(
                                                                                child: AutoSizeText(
                                                                                  value1.data!.plans![index-1].createdDate!  == "" ? "-" :
                                                                                  //DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index-1].createdDate!).toLocal()),
                                                                                  value1.data!.plans![index-1].createdDate!,
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                  textScaleFactor: 1.0,
                                                                                  maxLines: 1,
                                                                                  minFontSize: 6,
                                                                                ),
                                                                              ),


                                                                            ],
                                                                          ),
                                                                        ),

                                                                        ///Expirate date
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [

                                                                              /// Reload
                                                                              Expanded(
                                                                                child: AutoSizeText(Strings.expireddate,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                  textScaleFactor: 1.0,
                                                                                  maxLines: 1,
                                                                                  minFontSize: 6,
                                                                                ),
                                                                              ),

                                                                              /// Date
                                                                              Expanded(
                                                                                child: AutoSizeText(
                                                                                  value1.data!.plans![index-1].createdDate!  == "" ? "-" :
                                                                                  //DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index-1].createdDate!).toLocal()),
                                                                                  value1.data!.plans![index-1].createdDate!,
                                                                                  textAlign: TextAlign.right,
                                                                                  style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                  textScaleFactor: 1.0,
                                                                                  maxLines: 1,
                                                                                  minFontSize: 6,
                                                                                ),
                                                                              ),


                                                                            ],
                                                                          ),
                                                                        ),

                                                                        SizedBox(height: 15 ),

                                                                        /// Name
                                                                        value1.data!.plans![index-1].name! == "" ? Container(height: 0,): Container(
                                                                          margin: EdgeInsets.all(10),
                                                                          color: CustomColors.grayBackDetailPlan,
                                                                          child:Html(
                                                                            data: value1.data!.plans![index-1].name!,
                                                                            style: {
                                                                              "b": Style(
                                                                                  fontSize: FontSize(27.0),
                                                                                  fontFamily: Strings.font_bold,
                                                                                  color: HexColor(value1.data!.plans![index-1].color!),
                                                                                  alignment: Alignment.center,textAlign: TextAlign.center
                                                                              ),
                                                                              "p": Style(
                                                                                  fontSize: FontSize(17.0),
                                                                                  fontFamily: Strings.font_medium,
                                                                                  color: CustomColors.black,
                                                                                  alignment: Alignment.center,textAlign: TextAlign.center
                                                                              ),
                                                                            },
                                                                          ),
                                                                        ),

                                                                        SizedBox(height: value1.data!.plans![index-1].name! == "" ? 15 : 5,),

                                                                        /// PLan Details SMS, Data
                                                                        Container(
                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                          child: Column(

                                                                            children: [

                                                                              ///SMS
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// SMS
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.sms,
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.sms!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.sms!.value!,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 5),

                                                                              ///Minutes
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// Minutes
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.minutes1,
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.minute!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.minute!.value!,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 5,),

                                                                              /// GB full
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// GB full
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.datosfull,
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.gbFull!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.gbFull!.value!,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 5,),

                                                                              /// GB full reducida
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// GB full
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.velredufull,
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.velRed!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.velRed!.value!,

                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 10,),

                                                                            ],

                                                                          ),
                                                                        ),

                                                                        SizedBox(height: 15,),

                                                                        /// Saldo recarga title
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                          child: AutoSizeText(Strings.balancereload+ (index).toString(),
                                                                            textAlign: TextAlign.left,
                                                                            style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15,),
                                                                            textScaleFactor: 1.0,
                                                                            maxLines: 1,
                                                                            minFontSize: 6,
                                                                          ),
                                                                        ),

                                                                        SizedBox(height: 10,),

                                                                        /// PLan Details SMS, Data  Saldos
                                                                        Container(
                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                          child: Column(

                                                                            children: [

                                                                              ///SMS
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// SMS
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.sms,
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.sms!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.sms!.value!,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 5),

                                                                              ///Minutes
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// Minutes
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.minutes1,
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.minute!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.minute!.value!,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 5,),

                                                                              /// GB full
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// GB full
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.datosfull,
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.gbFull!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.gbFull!.value!,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 5,),

                                                                              /// GB full reducida
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [

                                                                                  /// GB full
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      //color: Colors.red,
                                                                                      child: AutoSizeText(
                                                                                        //Strings.velredufull,
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.velRed!.name!,
                                                                                        textAlign: TextAlign.left,
                                                                                        textScaleFactor: 1.0,
                                                                                        //maxLines: 1,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                        //maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                  ///Value
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerRight,
                                                                                      child: AutoSizeText(
                                                                                        value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.velRed!.value!,

                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                        textScaleFactor: 1.0,
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),

                                                                              SizedBox(height: 10,),

                                                                            ],

                                                                          ),
                                                                        ),

                                                                        SizedBox(height: 20,),

                                                                      ],

                                                                    ),
                                                                  );
                                                              }
                                                            }

                                                        );

                                                    }


                                                  }


                                                },

                                              ),
                                            );

                                          }

                                      ),
                                    ),
                                  ) :
                                  Container(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 50),
                                      child: ValueListenableBuilder<Userpointlist1>(
                                          valueListenable: singleton.notifierListUserPoints1,
                                          builder: (context,value1,_){

                                            return  Container(
                                              //color: Colors.green,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(15.0),
                                                  topRight: Radius.circular(15.0),
                                                ),
                                                color: CustomColors.graybackwallet,

                                              ),
                                              child: SmartRefresher(
                                                enablePullDown: true,
                                                enablePullUp: true,
                                                footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                                                header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, distance: 30, offset: 0,),
                                                controller: _refreshController,
                                                onRefresh: _onRefresh,
                                                onLoading: _onLoading,
                                                child: value1.code == 102 ?

                                                Container(
                                                  //margin: EdgeInsets.only(top: 30),
                                                  child: utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg"),
                                                ) :

                                                ListView.builder(
                                                  controller: _scrollViewController,
                                                  padding: EdgeInsets.only(top: 0,left: 0,right: 0,),
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: value1.code == 1 ? 6 : value1.code == 102 ? 1 : value1.code == 120 ? 0 : value1.data!.items!.length ,
                                                  itemBuilder: (BuildContext context, int index){

                                                    if(value1.code == 1){
                                                      return utils.PreloadingPlane1();

                                                    }else if(value1.code == 102){
                                                      return utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg");

                                                    }else{

                                                      return itemPoints(value1.data!.items![index],index, context);

                                                    }


                                                  },

                                                ),

                                              ),
                                            );

                                          }

                                      ),
                                    ),
                                  ) ; /// Monis History*/

                                  if(valuetab == 0){ /// Saldo
                                    return singleton.notifierUserProfile.value.data!.user!.userAltan! == false ?
                                    Container(
                                      padding: EdgeInsets.only(top: 50),
                                      child: SingleChildScrollView(
                                        controller: _scrollViewController,
                                        child: Column(
                                          children: [
                                            PlanMonis(context),
                                            InkWell(
                                              onTap: (){
                                                var time = 350;
                                                if(singleton.isIOS == false){
                                                  time = utils.ValueDuration();
                                                }
                                                Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                                                    reverseDuration: Duration(milliseconds: time)
                                                )).then((value) {
                                                });
                                              },
                                              child: ValueListenableBuilder<BannerWallet>(
                                                  valueListenable: singleton.notifierBannerAltan,
                                                  builder: (context,valueBanner,_){


                                                    return Card(
                                                      margin: EdgeInsets.all(10),
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      color: CustomColors.white,
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(color: Colors.transparent, width: 1),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Image.network(
                                                        valueBanner.data!.item!.photoUrl!,
                                                        fit: BoxFit.cover,
                                                        height: 100,
                                                        width: MediaQuery.of(context).size.width,
                                                        frameBuilder: (_, image, loadingBuilder, __) {
                                                          if (loadingBuilder == null) {
                                                            return const SizedBox(
                                                              child: Center(
                                                                  child: CircularProgressIndicator(
                                                                    color: Color(0xFFFF4D00),
                                                                  )
                                                              ),
                                                            );
                                                          }
                                                          return image;
                                                        },
                                                        loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                                          if (loadingProgress == null) return image;
                                                          return SizedBox(
                                                            child: Center(
                                                              child: CircularProgressIndicator(
                                                                value: loadingProgress.expectedTotalBytes != null
                                                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                    : null,
                                                                color: Color(0xFFFF4D00),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        errorBuilder: (_, __, ___) =>
                                                            SvgPicture.asset(
                                                              'assets/images/ic_gane.svg',
                                                              fit: BoxFit.contain,

                                                            ),
                                                      ),
                                                    );

                                                  }

                                              ),
                                            )
                                          ],

                                        ),
                                      ),
                                    ):
                                    Container(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Container(
                                        child: ValueListenableBuilder<AltanPLane1>(
                                            valueListenable: singleton.notifierUseraltanPlan1,
                                            builder: (context,value1,_){

                                              return SingleChildScrollView(
                                                controller: _scrollViewController,
                                                child: ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                                                  scrollDirection: Axis.vertical,
                                                  itemCount:  value1.code == 1 ? 9 : value1.code == 102 ? 2 : value1.data!.plans!.isEmpty ?  2 : value1.data!.plans!.length+1,
                                                  itemBuilder: (BuildContext context, int index){

                                                    if(value1.code==1){ ///preloading
                                                      return utils.PreloadingSubCategories();

                                                    }else if(value1.code==102){ ///No data

                                                      if(index==0){
                                                        return PlanMonis(context);
                                                      }else{

                                                        if(singleton.notifierUserProfile.value.data!.user!.userAltan! == false){
                                                          return InkWell(
                                                            onTap: (){
                                                              var time = 350;
                                                              if(singleton.isIOS == false){
                                                                time = utils.ValueDuration();
                                                              }
                                                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                                                                  reverseDuration: Duration(milliseconds: time)
                                                              )).then((value) {
                                                              });
                                                            },
                                                            child: ValueListenableBuilder<BannerWallet>(
                                                                valueListenable: singleton.notifierBannerAltan,
                                                                builder: (context,valueBanner,_){


                                                                  return Card(
                                                                    margin: EdgeInsets.all(10),
                                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                    color: CustomColors.white,
                                                                    elevation: 0,
                                                                    shape: RoundedRectangleBorder(
                                                                      side: BorderSide(color: Colors.transparent, width: 1),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: Image.network(
                                                                      valueBanner.data!.item!.photoUrl!,
                                                                      fit: BoxFit.cover,
                                                                      height: 100,width: MediaQuery.of(context).size.width,
                                                                      frameBuilder: (_, image, loadingBuilder, __) {
                                                                        if (loadingBuilder == null) {
                                                                          return const SizedBox(
                                                                            child: Center(
                                                                                child: CircularProgressIndicator(
                                                                                  color: Color(0xFFFF4D00),
                                                                                )
                                                                            ),
                                                                          );
                                                                        }
                                                                        return image;
                                                                      },
                                                                      loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                                                        if (loadingProgress == null) return image;
                                                                        return SizedBox(
                                                                          child: Center(
                                                                            child: CircularProgressIndicator(
                                                                              value: loadingProgress.expectedTotalBytes != null
                                                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                  : null,
                                                                              color: Color(0xFFFF4D00),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      errorBuilder: (_, __, ___) =>
                                                                          SvgPicture.asset(
                                                                            'assets/images/ic_gane.svg',
                                                                            fit: BoxFit.contain,

                                                                          ),
                                                                    ),
                                                                  );

                                                                }

                                                            ),
                                                          );
                                                        }else
                                                          return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");
                                                      }

                                                    }else{/// Item

                                                      if(index==0){
                                                        return PlanMonis(context);
                                                      } else{
                                                        return ValueListenableBuilder<bool>(
                                                            valueListenable: notifierShowDetails,
                                                            builder: (context,valueDetail,_){

                                                              if(value1.data!.plans!.isEmpty){
                                                                if(singleton.notifierUserProfile.value.data!.user!.userAltan! == false){
                                                                  return InkWell(
                                                                    onTap: (){
                                                                      var time = 350;
                                                                      if(singleton.isIOS == false){
                                                                        time = utils.ValueDuration();
                                                                      }
                                                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                                                                          reverseDuration: Duration(milliseconds: time)
                                                                      )).then((value) {
                                                                      });
                                                                    },
                                                                    child: ValueListenableBuilder<BannerWallet>(
                                                                        valueListenable: singleton.notifierBannerAltan,
                                                                        builder: (context,valueBanner,_){


                                                                          return Card(
                                                                            margin: EdgeInsets.all(10),
                                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                            color: CustomColors.white,
                                                                            elevation: 0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(color: Colors.transparent, width: 1),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Image.network(
                                                                              valueBanner.data!.item!.photoUrl!,
                                                                              fit: BoxFit.cover,
                                                                              height: 100, width: MediaQuery.of(context).size.width,
                                                                              frameBuilder: (_, image, loadingBuilder, __) {
                                                                                if (loadingBuilder == null) {
                                                                                  return const SizedBox(
                                                                                    child: Center(
                                                                                        child: CircularProgressIndicator(
                                                                                          color: Color(0xFFFF4D00),
                                                                                        )
                                                                                    ),
                                                                                  );
                                                                                }
                                                                                return image;
                                                                              },
                                                                              loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                                                                if (loadingProgress == null) return image;
                                                                                return SizedBox(
                                                                                  child: Center(
                                                                                    child: CircularProgressIndicator(
                                                                                      value: loadingProgress.expectedTotalBytes != null
                                                                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                          : null,
                                                                                      color: Color(0xFFFF4D00),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              errorBuilder: (_, __, ___) =>
                                                                                  SvgPicture.asset(
                                                                                    'assets/images/ic_gane.svg',
                                                                                    fit: BoxFit.contain,

                                                                                  ),
                                                                            ),
                                                                          );

                                                                        }

                                                                    ),
                                                                  );
                                                                }else {
                                                                  return valueDetail == false ? SizedBox(height: 0,) : utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");
                                                                }

                                                              }else {
                                                                return valueDetail == false ? SizedBox(height: 0,) : Container(
                                                                  color: index%2 == 0 ? CustomColors.grayBackDetailPlan : CustomColors.white,
                                                                  margin: EdgeInsets.only(left: 10,right: 10),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,

                                                                    children: [

                                                                      ///Reload and date
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [

                                                                            /// Reload
                                                                            Expanded(
                                                                              child: AutoSizeText(Strings.reload+ (index).toString(),
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15,),
                                                                                textScaleFactor: 1.0,
                                                                                maxLines: 1,
                                                                                minFontSize: 6,
                                                                              ),
                                                                            ),

                                                                            /// Date
                                                                            Expanded(
                                                                              child: AutoSizeText(
                                                                                value1.data!.plans![index-1].createdDate!  == "" ? "-" :
                                                                                //DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index-1].createdDate!).toLocal()),
                                                                                value1.data!.plans![index-1].createdDate!,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                textScaleFactor: 1.0,
                                                                                maxLines: 1,
                                                                                minFontSize: 6,
                                                                              ),
                                                                            ),


                                                                          ],
                                                                        ),
                                                                      ),

                                                                      ///Expirate date
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [

                                                                            /// Reload
                                                                            Expanded(
                                                                              child: AutoSizeText(Strings.expireddate,
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                textScaleFactor: 1.0,
                                                                                maxLines: 1,
                                                                                minFontSize: 6,
                                                                              ),
                                                                            ),

                                                                            /// Date
                                                                            Expanded(
                                                                              child: AutoSizeText(
                                                                                value1.data!.plans![index-1].expireDate!  == "" ? "-" :
                                                                                //DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index-1].createdDate!).toLocal()),
                                                                                value1.data!.plans![index-1].expireDate!,
                                                                                textAlign: TextAlign.right,
                                                                                style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.black, fontSize: 10,),
                                                                                textScaleFactor: 1.0,
                                                                                maxLines: 1,
                                                                                minFontSize: 6,
                                                                              ),
                                                                            ),


                                                                          ],
                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 15 ),

                                                                      /// Name
                                                                      value1.data!.plans![index-1].name! == "" ? Container(height: 0,): Container(
                                                                        margin: EdgeInsets.all(10),
                                                                        color: CustomColors.grayBackDetailPlan,
                                                                        child:Html(
                                                                          data: value1.data!.plans![index-1].name!,
                                                                          style: {
                                                                            "b": Style(
                                                                                fontSize: FontSize(27.0),
                                                                                fontFamily: Strings.font_bold,
                                                                                color: HexColor(value1.data!.plans![index-1].color!),
                                                                                alignment: Alignment.center,textAlign: TextAlign.center
                                                                            ),
                                                                            "p": Style(
                                                                                fontSize: FontSize(17.0),
                                                                                fontFamily: Strings.font_medium,
                                                                                color: CustomColors.black,
                                                                                alignment: Alignment.center,textAlign: TextAlign.center
                                                                            ),
                                                                          },
                                                                        ),


                                                                      ),

                                                                      SizedBox(height: value1.data!.plans![index-1].name! == "" ? 15 : 5,),

                                                                      /// PLan Details SMS, Data
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Column(

                                                                          children: [

                                                                            ///SMS
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// SMS
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.sms,
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.sms!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.sms!.value!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 5),

                                                                            ///Minutes
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// Minutes
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.minutes1,
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.minute!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.minute!.value!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 5,),

                                                                            /// GB full
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// GB full
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.datosfull,
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.gbFull!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.gbFull!.value!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 5,),

                                                                            /// GB full reducida
                                                                            value1.data!.plans![index-1].detailPlan! == null ? Container(): value1.data!.plans![index-1].detailPlan!.velRed!.value! == "0" ? Container() : Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// GB full
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.velredufull,
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.velRed!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].detailPlan! == null ? "-" : value1.data!.plans![index-1].detailPlan!.velRed!.value!,

                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: value1.data!.velRed!.value! == null ? 0: value1.data!.velRed!.value! == "0" ? 0 : 10,),

                                                                          ],

                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 15,),

                                                                      /// Saldo recarga title
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                        child: AutoSizeText(Strings.balancereload+ (index).toString(),
                                                                          textAlign: TextAlign.left,
                                                                          style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15,),
                                                                          textScaleFactor: 1.0,
                                                                          maxLines: 1,
                                                                          minFontSize: 6,
                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 10,),

                                                                      /// PLan Details SMS, Data  Saldos
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                                        child: Column(

                                                                          children: [

                                                                            ///SMS
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// SMS
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.sms,
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.sms!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.sms!.value!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 5),

                                                                            ///Minutes
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// Minutes
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.minutes1,
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.minute!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.minute!.value!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 5,),

                                                                            /// GB full
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// GB full
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.datosfull,
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.gbFull!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.gbFull!.value!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 5,),

                                                                            /// GB full reducida
                                                                            value1.data!.plans![index-1].balanceRecharge! == null ? Container(): value1.data!.plans![index-1].balanceRecharge!.velRed!.value! == "0" ? Container() : Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [

                                                                                /// GB full
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: Container(
                                                                                    //color: Colors.red,
                                                                                    child: AutoSizeText(
                                                                                      //Strings.velredufull,
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.velRed!.name!,
                                                                                      textAlign: TextAlign.left,
                                                                                      textScaleFactor: 1.0,
                                                                                      //maxLines: 1,
                                                                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                                                                      //maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                ///Value
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    alignment: Alignment.centerRight,
                                                                                    child: AutoSizeText(
                                                                                      value1.data!.plans![index-1].balanceRecharge! == null ? "-" : value1.data!.plans![index-1].balanceRecharge!.velRed!.value!,

                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 20,),
                                                                                      textScaleFactor: 1.0,
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 10,),

                                                                          ],

                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 20,),

                                                                    ],

                                                                  ),
                                                                );
                                                              }
                                                            }

                                                        );

                                                      }


                                                    }


                                                  },

                                                ),
                                              );

                                            }

                                        ),
                                      ),
                                    );

                                  }else{  /// Monis History
                                    return Container(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 50),
                                        child: ValueListenableBuilder<Userpointlist1>(
                                            valueListenable: singleton.notifierListUserPoints1,
                                            builder: (context,value1,_){

                                              return  Container(
                                                //color: Colors.green,
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(15.0),
                                                    topRight: Radius.circular(15.0),
                                                  ),
                                                  color: CustomColors.graybackwallet,

                                                ),
                                                child: SmartRefresher(
                                                  enablePullDown: true,
                                                  enablePullUp: true,
                                                  footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                                                  header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, distance: 30, offset: 0,),
                                                  controller: _refreshController,
                                                  onRefresh: _onRefresh,
                                                  onLoading: _onLoading,
                                                  child: value1.code == 102 ?

                                                  Container(
                                                    //margin: EdgeInsets.only(top: 30),
                                                    child: utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg"),
                                                  ) :

                                                  ListView.builder(
                                                    controller: _scrollViewController,
                                                    padding: EdgeInsets.only(top: 0,left: 0,right: 0,),
                                                    scrollDirection: Axis.vertical,
                                                    itemCount: value1.code == 1 ? 6 : value1.code == 102 ? 1 : value1.code == 120 ? 0 : value1.data!.items!.length ,
                                                    itemBuilder: (BuildContext context, int index){

                                                      if(value1.code == 1){
                                                        return utils.PreloadingPlane1();

                                                      }else if(value1.code == 102){
                                                        return utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg");

                                                      }else{

                                                        return itemPoints(value1.data!.items![index],index, context);

                                                      }


                                                    },

                                                  ),

                                                ),
                                              );

                                            }

                                        ),
                                      ),
                                    ) ;
                                  }



                                }
                            )

                          ],
                        ),
                      ),
                    )


                  );

                }

            );

          }

      ),

    );
  }

  /// Header Tab
  Widget headerTab(BuildContext context){

    return Container(
      height: 45,
      decoration: BoxDecoration(
        //color: CustomColors.red,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),

      ),
      child: ValueListenableBuilder<int>(
          valueListenable: notifierHeaderTab,
          builder: (context,value2,_){

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ///Saldos
                Expanded(
                  child: InkWell(
                    onTap: (){
                      notifierHeaderTab.value = 0;
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: value2== 0 ? CustomColors.white : CustomColors.grayTabBar1,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          //topRight: Radius.circular(10.0),
                        ),

                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          Strings.saldo,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          //maxLines: 1,
                          style: TextStyle(fontFamily: Strings.font_boldFe, color: value2== 0 ? CustomColors.black : CustomColors.grayTabBar, fontSize: 16.0,),
                          //maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                ///Monis History
                Expanded(
                  child: InkWell(
                    onTap: (){
                      notifierHeaderTab.value = 1;
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: value2== 1 ? CustomColors.white : CustomColors.grayTabBar1,
                        borderRadius: const BorderRadius.only(
                          //topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),

                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          Strings.monihistory,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          //maxLines: 1,
                          style: TextStyle(fontFamily: Strings.font_boldFe, color: value2== 1 ? CustomColors.black : CustomColors.grayTabBar, fontSize: 16.0,),
                          //maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            );

          }

      ),

    );

  }

  /// Widget CanjeControl y Monis
  Widget PlanMonis(BuildContext context){

    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: 15,),

          ///CanjeControl monis
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Canje y control
              Expanded(
                child: Container(
                  child: AutoSizeText(
                    Strings.totalchange1,
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.0,
                    //maxLines: 1,
                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15.0,),
                    //maxLines: 1,
                  ),
                ),
              ),

              ///Monis
              Expanded(
                child: Container(
                  child: AutoSizeText(
                    Strings.share7,
                    textAlign: TextAlign.right,
                    textScaleFactor: 1.0,
                    //maxLines: 1,
                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.orangeborderpopup, fontSize: 15.0,),
                    //maxLines: 1,
                  ),
                ),
              ),

            ],
          ),

          SizedBox(height: 10,),

          Container(height: 1,color: CustomColors.grayTabBar1,),

          SizedBox(height: 10,),

          ///Tienes - value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Tienes
              Expanded(
                child: Container(
                  //color: Colors.red,
                  child: AutoSizeText(
                    Strings.dyh,
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.0,
                    //maxLines: 1,
                    style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 16.0,),
                    //maxLines: 1,
                  ),
                ),
              ),

              ///Value
              Expanded(
                  child: Container(
                    //color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        /// Value
                        Container(
                          //color: Colors.yellow,
                          child: ValueListenableBuilder<UserAltan>(
                              valueListenable: singleton.notifierUseraltan,
                              builder: (context,value4,_){

                                /*return ValueListenableBuilder<Userpoints>(
                                    valueListenable: singleton.notifierUserPoints,
                                    builder: (context,value,_){*/

                                      return AutoSizeText(
                                        //(value.code == 1 || value.code == 102) ? "0" : value.data!.result!,
                                        (value4.code == 1 || value4.code == 102) ? "0" : value4.data!.item!.pointsUser!.points!,
                                        textAlign: TextAlign.right ,
                                        maxLines: 1,
                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: value4.code == 1 ? CustomColors.greenbutton : value4.data!.item!.remainingPoints! != "0" ? CustomColors.orangeborderpopup : CustomColors.greenbutton  , fontSize: 20.0,),
                                        textScaleFactor: 1.0,
                                        //maxLines: 1,
                                      );

                                    //}

                               // );

                              }

                          ),

                        ),

                        SizedBox(width: 7,),

                        /// Icon
                        /*Container(
                        //color: Colors.green,
                        child: SvgPicture.asset(
                          'assets/images/monedamonedero.svg',
                          fit: BoxFit.contain,
                          width: 18,
                          height: 18,
                        ),
                      ),*/

                        /*Container(
                        child: Stack(
                          alignment: Alignment.center,

                          children: [

                            Image(
                              image: AssetImage("assets/images/circuloonline.png"),
                              fit: BoxFit.contain,
                              width: 20,
                              height: 20,
                              color: "#FF4D00".toColors(),
                            ),

                            Image(
                              image: AssetImage("assets/images/monedaonline.png"),
                              fit: BoxFit.contain,
                              width: 20,
                              height: 20,
                              //color: "#00A86B".toColors(),
                            )

                          ],

                        ),
                      )*/
                        ValueListenableBuilder<SegmentationCustom>(
                            valueListenable: singleton.notifierValidateSegmentation,
                            builder: (context,valuese,_){

                              return Stack(
                                alignment: Alignment.center,

                                children: [

                                  /*Image(
                                  image: AssetImage("assets/images/circuloonline.png"),
                                  fit: BoxFit.contain,
                                  width: 20,
                                  height: 20,
                                  color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                                ),*/

                                  ClipOval(
                                    child: Container(
                                      color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                                      height: 22,
                                      width: 22,
                                    ),
                                  ),


                                  SvgPicture.asset(
                                    'assets/images/pruebaonline.svg',
                                    fit: BoxFit.contain,
                                    width: 20,
                                    height: 20,
                                    //color: Colors.white,
                                    //color: CustomColors.orangeborderpopup,
                                  )

                                ],

                              );
                            }

                        )

                      ],

                    ),
                  )
              ),

            ],
          ),

          SizedBox(height: 10,),

          ///Faltan
          ValueListenableBuilder<UserAltan>(
              valueListenable: singleton.notifierUseraltan,
              builder: (context,value4,_){

                //return ( double.parse( value4. data!.item!.exchangeDay! ) == 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing" ? Container() :  Row(
                return value4.data!.item!.remainingPoints! == "0" ? Container() :  Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    /// faltan
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        child: AutoSizeText(
                          Strings.dym,
                          textAlign: TextAlign.left,
                          textScaleFactor: 1.0,
                          //maxLines: 1,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 16.0,),
                          //maxLines: 1,
                        ),
                      ),
                    ),

                    ///Value
                    Expanded(
                        child: Container(
                          //color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              /// Value
                              Container(
                                //color: Colors.yellow,
                                child: ValueListenableBuilder<UserAltan>(
                                    valueListenable: singleton.notifierUseraltan,
                                    builder: (context,value4,_){

                                      return AutoSizeText(
                                        //(value4.code == 1 || value4.code == 102) ? "0" : value4.data!.item!.remainingPoints! == "0" ? value4.data!.item!.points! : utils.returnDividendoString( double.parse(value4.data!.item!.remainingPoints!) ),
                                        (value4.code == 1 || value4.code == 102) ? "0" : value4.data!.item!.remainingPoints! == "0" ? value4.data!.item!.points! : value4.data!.item!.remainingPointsConvert!,
                                        textAlign: TextAlign.right ,
                                        maxLines: 1,
                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.lightGreyProgrerss, fontSize: 20.0,),
                                        textScaleFactor: 1.0,
                                        //maxLines: 1,
                                      );

                                    }

                                ),

                              ),

                              SizedBox(width: 7,),

                              /// Icon
                              /*Container(
                            //color: Colors.green,
                            child: SvgPicture.asset(
                              'assets/images/monedamonedero.svg',
                              fit: BoxFit.contain,
                              width: 18,
                              height: 18,
                            ),
                          ),*/
                              Container(
                                child: ValueListenableBuilder<SegmentationCustom>(
                                    valueListenable: singleton.notifierValidateSegmentation,
                                    builder: (context,valuese,_){

                                      return Stack(
                                        alignment: Alignment.center,

                                        children: [

                                          Image(
                                            image: AssetImage("assets/images/circuloonline.png"),
                                            fit: BoxFit.contain,
                                            width: 22,
                                            height: 22,
                                            color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                                          ),

                                          SvgPicture.asset(
                                            'assets/images/pruebaonline.svg',
                                            fit: BoxFit.contain,
                                            width: 20,
                                            height: 20,
                                            //color: Colors.white,
                                          )

                                        ],

                                      );
                                    }

                                ),
                              )

                            ],

                          ),
                        )
                    ),

                  ],
                );

              }

          ),

          SizedBox(height: 10,),

          /// Change Button
          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container()
          /*InkWell(
            onTap: (){
              var time = 350;
              if(singleton.isIOS == false){
                time = utils.ValueDuration();
              }
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                  reverseDuration: Duration(milliseconds: time)
              )).then((value) {
              });
            },
            child: Container(
                  height: singleton.isIOS == false ? 130 : 140,
                  child: Image(
                    image: AssetImage(
                        "assets/images/hombre_chipgane.png"
                    ),
                    //height: 130,
                    fit: BoxFit.fitHeight,
                  ),
            ),
          )*/ : ValueListenableBuilder<UserAltan>(
              valueListenable: singleton.notifierUseraltan,
              builder: (context,value4,_){

                return Container(
                  //color: Colors.yellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        //color: Colors.green,
                        child: SpringButton(
                          SpringButtonType.OnlyScale,
                          Container(
                            //color: Colors.black,
                            //padding: EdgeInsets.only(right: 5,left: 5,),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: value4.code == 1 || value4.code == 102 ? CustomColors.grayCanje :
                              ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > value4.data!.item!.daysTotal! ) && value4.data!.item!.exchange! != "missing" ? CustomColors.greenbutton : CustomColors.grayCanje,
                              // color: value4.code == 1 || value4.code == 102 ? CustomColors.grayCanje : ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ? CustomColors.bluelogin : CustomColors.grayCanje,
                              elevation: 1.2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Container(
                                margin:  EdgeInsets.only(right: 10,left: 10,),
                                height: 40,
                                //width: 130,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [

                                    SizedBox(width: 5,),

                                    SvgPicture.asset(
                                      'assets/images/update.svg',
                                      fit: BoxFit.contain,
                                      width: 14,
                                      height: 14,
                                      color: value4.code == 1 || value4.code == 102 ? CustomColors.lightGreyProgrerss : ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing" ? CustomColors.white : CustomColors.lightGreyProgrerss,
                                      //color: value4.code == 1 || value4.code == 102 ? CustomColors.lightGreyProgrerss : ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ? CustomColors.white : CustomColors.lightGreyProgrerss,
                                    ),

                                    SizedBox(width: 5,),

                                    /// Text and points
                                    Container(
                                      //color: Colors.red,
                                      child: Text(
                                        ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing" ?
                                        Strings.canjearmoni : Strings.changecasi,
                                        style: TextStyle(
                                            fontFamily: Strings.font_mediumFe,
                                            fontSize:14,
                                            color: value4.code == 1 || value4.code == 102 ? CustomColors.lightGreyProgrerss : ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing" ? CustomColors.white : CustomColors.lightGreyProgrerss
                                        ),
                                        textAlign: TextAlign.start,
                                        textScaleFactor: 1.0,
                                      ),
                                    ),

                                  ],

                                ),

                              ),

                            ),

                          ),
                          useCache: false,
                          onTap: (){

                            if(value4.code == 1 || value4.code == 102 ){
                              /// No tap
                            }else if( ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > value4.data!.item!.daysTotal! ) && value4.data!.item!.exchange! != "missing"){
                              // }else if( ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ){
                              //dialogRedeem(context, exchangeCoinstoMb);

                              if(singleton.notifierUserProfile.value.data!.user!.verificationCodeSim == true){
                                dialogRedeem(context, exchangeCoinstoMb);
                              }else{
                                utils.showDialogValidateTelf(context, (){});
                              }

                            }else {
                              utils.openSnackBarInfo(context, Strings.noyetcanje, "assets/images/ic_sad.svg",CustomColors.blueBack,"error");
                            }

                          },

                          //onTapDown: (_) => decrementCounter(),

                        ),
                      ),


                    ],

                  ),
                );

              }

          ),

          SizedBox(height: 25,),

          /// Telf
          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : Container(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              Strings.telfs,
              textAlign: TextAlign.left,
              textScaleFactor: 1.0,
              //maxLines: 1,
              style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15.0,),
              //maxLines: 1,
            ),
          ),

          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : SizedBox(height: 10,),

          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : Container(height: 1,color: CustomColors.grayTabBar1,),

          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : SizedBox(height: 10,),

          /// Values Telefonia
          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : Container(
            /*child: ValueListenableBuilder<AltanPLane>(
                valueListenable: singleton.notifierUseraltanPlan,*/
            child: ValueListenableBuilder<AltanPLane1>(
                valueListenable: singleton.notifierUseraltanPlan1,
                builder: (context,valueAP,_){

                  return Column(

                    children: [

                      ///SMS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          /// SMS
                          Expanded(
                            child: Container(
                              //color: Colors.red,
                              child: AutoSizeText(
                                //Strings.sms,
                                valueAP.data!.sms!.name! == null ? "-" : valueAP.data!.sms!.name!,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                //maxLines: 1,
                                style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                //maxLines: 1,
                              ),
                            ),
                          ),

                          ///Value
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                //valueAP.data!.plan == null ? "0" : valueAP.data!.plan!.smsConvert!,
                                valueAP.data!.sms!.value! == null ? "0" : valueAP.data!.sms!.value!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blueback2, fontSize: 20,),
                                textScaleFactor: 1.0,
                                maxLines: 1,
                              ),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(height: 5,),

                      ///Minutes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          /// Minutes
                          Expanded(
                            child: Container(
                              //color: Colors.red,
                              child: AutoSizeText(
                                //Strings.minutes1,
                                valueAP.data!.minute!.name! == null ? "-" : valueAP.data!.minute!.name!,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                //maxLines: 1,
                                style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.black, fontSize: 16.0,),
                                //maxLines: 1,
                              ),
                            ),
                          ),

                          ///Value
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(valueAP.code == 1 || valueAP.code == 102 ? "-" :
                              //valueAP.data!.plan == null ? "0" : valueAP.data!.plan!.minuteConvert!,
                                valueAP.data!.minute!.value! == null ? "0" : valueAP.data!.minute!.value!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blueback2, fontSize: 20,),
                                textScaleFactor: 1.0,
                                maxLines: 1,
                              ),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(height: 10,),

                      /// GB full
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          /// GB full
                          Expanded(
                            flex: 3,
                            child: Container(
                              //color: Colors.red,
                              child: AutoSizeText(
                                //Strings.datosfull,
                                valueAP.data!.gbFull!.name! == null ? "-" : valueAP.data!.gbFull!.name!,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                //maxLines: 1,
                                style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                //maxLines: 1,
                              ),
                            ),
                          ),

                          ///Value
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                //valueAP.data!.plan == null ? "0" :  valueAP.data!.plan!.gbConvert!,
                                valueAP.data!.gbFull!.value! == null ? "0" : valueAP.data!.gbFull!.value!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blueback2, fontSize: 20,),
                                textScaleFactor: 1.0,
                                maxLines: 1,
                              ),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(height: 5,),

                      /// GB full reducida
                      valueAP.data!.velRed!.value! == null ? Container(): valueAP.data!.velRed!.value! == "0" ? Container() : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          /// GB full
                          Expanded(
                            flex: 3,
                            child: Container(
                              //color: Colors.red,
                              child: AutoSizeText(
                                //Strings.velredufull,
                                valueAP.data!.velRed!.name! == null ? "-" : valueAP.data!.velRed!.name!,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                //maxLines: 1,
                                style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 16.0,),
                                //maxLines: 1,
                              ),
                            ),
                          ),

                          ///Value
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(
                                valueAP.code == 1 || valueAP.code == 102 ? "-" :
                                //valueAP.data!.plan == null ? "0" :  valueAP.data!.plan!.gbRedConvert!,
                                valueAP.data!.velRed!.value! == null ? "0" : valueAP.data!.velRed!.value!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blueback2, fontSize: 20,),
                                textScaleFactor: 1.0,
                                maxLines: 1,
                              ),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(height: valueAP.data!.velRed!.value! == null ? 0: valueAP.data!.velRed!.value! == "0" ? 0 : 5,),

                    ],

                  );

                }

            ),
          ),

          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : SizedBox(height: 25,),

          /// Reloads
          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : InkWell(
            onTap: (){
              notifierShowDetails.value = !notifierShowDetails.value;
            },
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [

                  Expanded(
                    child: AutoSizeText(
                      Strings.reloadacc,
                      textAlign: TextAlign.left,
                      textScaleFactor: 1.0,
                      //maxLines: 1,
                      style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 15.0,),
                      //maxLines: 1,
                    ),
                  ),

                  ValueListenableBuilder<bool>(
                      valueListenable: notifierShowDetails,
                      builder: (context,valueDetail,_){

                        return SvgPicture.asset(
                            valueDetail == true ? 'assets/images/Flecha gane.svg' : 'assets/images/flecha.svg',
                            fit: BoxFit.contain
                        );

                      }

                  ),

                ],

              )
            ),
          ),

          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : SizedBox(height: 10,),

          singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : ValueListenableBuilder<bool>(
              valueListenable: notifierShowDetails,
              builder: (context,valueDetail,_){
                return Container(height: 1,color: valueDetail == false ? CustomColors.white : CustomColors.black,);

              }
          ),



        ],
      ),
    );

  }

  ///Item Wallet
  Widget itemPoints(ItemsLUP1 item, int index, BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(width: 1.0, color: CustomColors.greysearch),
        ),
      ),
      child: Container(
        //color: Colors.red,
        padding: EdgeInsets.only(top: 13,bottom: 13,left: 15,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[



            /// Texts
            Expanded(
              child: Container(
                //color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    /// Title
                    Container(
                      child: Text(item.title! == null ? "" : item.title!,
                        style: TextStyle(
                            fontFamily: Strings.font_bold,
                            fontSize:17,
                            //color: CustomColors.grayalert1),
                            color: CustomColors.black),
                        textAlign: TextAlign.start,
                        textScaleFactor: 1.0,
                      ),
                    ),

                    /// Date
                    Container(
                      child: Text(DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(item.options!.createdAt!).toLocal()),
                        style: TextStyle(
                            fontFamily: Strings.font_medium,
                            fontSize:13,
                            color: CustomColors.lightGreyProgrerss),
                        textAlign: TextAlign.start,
                        textScaleFactor: 1.0,
                      ),
                    ),



                  ],

                ),
              ),
            ),

            SizedBox(width: 10,),

            /// Points
            Container(
              //color: Colors.red,
              child: Row(

                children: [

                  /// Points
                  Container(
                    margin: EdgeInsets.only(right: 2),
                    child: Text( item.points!.toDouble() < 0.0 ? singleton.formatter.format(item.points!.toDouble()) :  "+" +singleton.formatter.format(item.points!.toDouble()),
                      style: TextStyle(
                          fontFamily: Strings.font_bold,
                          fontSize:16,
                          color:  item.points!.toDouble() < 0.0 ? CustomColors.redcanje : CustomColors.greenbutton),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                    ),
                  ),

                  ///Flag
                  /*SvgPicture.asset(
                    'assets/images/monedaroja.svg',
                    height: 15,
                    fit: BoxFit.cover,
                  ),*/

                  ValueListenableBuilder<SegmentationCustom>(
                      valueListenable: singleton.notifierValidateSegmentation,
                      builder: (context,valuese,_){

                        return Stack(
                          alignment: Alignment.center,

                          children: [

                            Image(
                              image: AssetImage("assets/images/circuloonline.png"),
                              fit: BoxFit.contain,
                              width: 20,
                              height: 20,
                              color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                            ),

                            SvgPicture.asset(
                              'assets/images/pruebaonline.svg',
                              fit: BoxFit.contain,
                              width: 20,
                              height: 20,
                              color: Colors.white,
                            )

                          ],

                        );
                      }

                  )

                  /*Container(
                    child: Stack(
                      alignment: Alignment.center,

                      children: [

                        Image(
                          image: AssetImage("assets/images/circuloonline.png"),
                          fit: BoxFit.cover,
                          width: 15,
                          height: 15,
                          //color: "#00A86B".toColors(),
                        ),

                        Image(
                          image: AssetImage("assets/images/monedaonline.png"),
                          fit: BoxFit.cover,
                          width: 15,
                          height: 15,
                          color: "#00A86B".toColors(),
                        )

                      ],

                    ),
                  )*/

                ],

              ),
            ),

            /// Points
            /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SvgPicture.asset(
                  'assets/images/ic_coin.svg',
                  height: 30,
                  fit: BoxFit.cover,
                ),

                SizedBox(height: 5,),

                Container(
                  child: Text("+" +singleton.formatter.format(double.parse(item.points!)),
                      style: TextStyle(
                          fontFamily: Strings.font_bold,
                          fontSize:12,
                          color: CustomColors.orangeback1),
                      textAlign: TextAlign.center
                  ),
                ),

              ],
            ),*/

          ],

        ),
      ),

    );
  }

  /// Exchange coins to Mb
  void exchangeCoinstoMb()async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        //utils.dialogLoading(singleton.navigatorKey.currentContext!);
        utils.openProgress(singleton.navigatorKey.currentContext!);
        singleton.notifierListUserPoints.value = Userpointlist(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchExchangeCoinsToMb(singleton.notifierUseraltan.value.data!.item!.id!,singleton.navigatorKey.currentContext!).then((value) {
          launchFetch();
        });

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }


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
        color: CustomColors.graybackwallet,
        elevation: 5,
        shape: RoundedRectangleBorder(
          //side: BorderSide(color: categoryItem.categoryStatus == "completed" ? CustomColors.graybordercomplete : HexColor(categoryItem.color!) ),
          borderRadius: BorderRadius.circular(15),
        ),
        //color: backgroundColor,
        child: Center(
          child: Container(
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

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      //color: categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 : HexColor(categoryItem.color!),
                      color: categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 : CustomColors.blueBack,

                    ),

                    ///Name category
                    Container(
                      //color: Colors.blue,
                      child: AutoSizeText(
                        categoryItem.name!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(fontFamily: Strings.font_medium, color: categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 : CustomColors.blueBack, fontSize: 12.0,),
                        textScaleFactor: 1.0,
                        //maxLines: 1,
                      ),
                    ),

                  ],
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
                                child: ValueListenableBuilder<Getprofile>(
                                    valueListenable: singleton.notifierUserProfile,
                                    builder: (context,value1,_){

                                      return Text(Strings.money,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.white, fontSize: 30,),
                                        textScaleFactor: 1.0,
                                      );

                                    }

                                ),
                              ),

                              SizedBox(height: 5,),

                              /// Reload account
                              singleton.notifierUserProfile.value.data!.user!.userAltan! == false ? Container() : Container(
                                margin: EdgeInsets.only(left: 30,right: 30),
                                child: SpringButton(
                                  SpringButtonType.OnlyScale,
                                  Container(
                                    width: 180,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: CustomColors.blueback2,
                                      borderRadius: BorderRadius.all(const Radius.circular(20)),
                                      border: Border.all(
                                        width: 1,
                                        color: CustomColors.blueback2,
                                      ),
                                    ),
                                    child: Container(
                                      //margin: EdgeInsets.only(top: 15,bottom: 15),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: <Widget>[

                                            /// languaje
                                            Expanded(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Strings.rechargeAccount,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor: 1.0,
                                                  //maxLines: 1,
                                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 14.0,),
                                                  //maxLines: 1,
                                                ),
                                              ),
                                            ),


                                          ],

                                        ),
                                      ),
                                    ),
                                  ),
                                  useCache: false,
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

                                  //onTapDown: (_) => decrementCounter(),

                                ),
                              ),


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

          children: [

            /// Height pre header choose category
            ValueListenableBuilder<Getprofile>(
                valueListenable: singleton.notifierUserProfile,
                builder: (context,value3,_){

                  return ValueListenableBuilder<double>(
                      valueListenable: singleton.notifierHeightHeaderWallet1,
                      builder: (context,valueHeight,_){

                        return SizedBox(height: value3.data!.user!.userAltan! == true ?  valueHeight == 90 ? 0 : 80 : 5,);

                      }

                  );

                }

            ),

            SizedBox(height: 15,),

            /// Choose category
            Container(
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
