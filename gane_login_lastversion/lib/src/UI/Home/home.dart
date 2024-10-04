import 'dart:io';
import 'dart:math';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/bannerWall.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/useraltam.dart';
import 'package:gane/src/Models/userpointlist.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Campaigns/ganecampaignsdetail.dart';
import 'package:gane/src/UI/Home/completeprof.dart';
import 'package:gane/src/UI/Home/pidechip.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_banner.dart';
import 'package:gane/src/Widgets/dialog_redeem.dart';
import 'package:gane/src/Widgets/dialog_updateversion.dart';
import 'package:gane/src/Widgets/dialog_validatetelf.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:showcaseview/showcaseview.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:badges/badges.dart' as badges;
//import 'package:page_route_transition/page_route_transition.dart' as trans;

//import 'package:simnumber/sim_number.dart';
//import 'package:simnumber/siminfo.dart';


class Home extends StatefulWidget{

  final from;


  Home({this.from});

  _stateHome createState()=> _stateHome();
}

class _stateHome extends State<Home> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  //var _controllerPhone = TextEditingController();
  //final formatter = new NumberFormat("#,###.##", "es_CO");
  bool visibleTotalShopingCart = false;

  var imgCountry = "";
  var name = "";

  bool visibleUpdateApp = false;
  bool visibleOptionalUpdateApp = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);



  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;

  late CircularSliderAppearance appearance01;
  late CircularSliderAppearance appearance02;

  //PermissionStatus _permissionStatus = PermissionStatus.denied;
  //Permission _permission = Permission.phone;
  //late HomeProvider provider;

  //SimInfo simInfo = SimInfo([]);

  GlobalKey _one = GlobalKey();
  //final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();


  GlobalKey _two = GlobalKey();

  /*startShowCase() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      ShowCaseWidget.of(singleton.navigatorKey.currentContext!).startShowCase([_two]);
    });
  }*/


  @override
  void initState(){

    appearance01 = CircularSliderAppearance(
        customWidths: CustomSliderWidths(trackWidth: 9, progressBarWidth: 9),
        customColors: CustomSliderColors(
            dotColor: Colors.white.withOpacity(0.8),
            trackColor: CustomColors.white.withOpacity(0.8),
            progressBarColors: [
              CustomColors.orangeswitch,
              CustomColors.orangeswitch,
              CustomColors.orangeswitch
              /*"#00A86B".toColors(),
              "#00A86B".toColors(),
              "#00A86B".toColors()*/
            ],
            shadowColor: Colors.white,
            shadowMaxOpacity: 0.08
        ),
        infoProperties: InfoProperties(
          //mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
          mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: Colors.transparent,),
          //bottomLabelText: "Moni",
          bottomLabelText: "",
          bottomLabelStyle: TextStyle(fontSize: 11.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),

          modifier: (double value) {
            double  kcal = value;
            kcal = utils.returnDividendo(kcal);
            var val = kcal.toString();
            print(val.length);

            if(val.contains('.0') || val.contains('.99')){
              return kcal.toStringAsFixed(0) + utils.suffixValues(value);
            }
            return  kcal.toStringAsFixed(1) + utils.suffixValues(value);
          },

        ),
        startAngle: 135,
        angleRange: 270,
        //size: singleton.isIOS == false ? 55.0 : 70.0,
        size: singleton.isIOS == false ? 45.0 : 50.0,
        //animationEnabled: true,
        animDurationMultiplier: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner().toDouble() : 3.0,
        spinnerDuration: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner() : 3
    );
    appearance02 = CircularSliderAppearance(
        customWidths: CustomSliderWidths(trackWidth: 9, progressBarWidth: 9,),
        customColors: CustomSliderColors(
            dotColor: Colors.white.withOpacity(0.8),
            trackColor: CustomColors.white.withOpacity(0.8),
            progressBarColors: [
              CustomColors.orangeswitch,
              CustomColors.orangeswitch,
              CustomColors.orangeswitch
              /* "#00A86B".toColors(),
              "#00A86B".toColors(),
              "#00A86B".toColors()*/
            ],
            shadowColor: Colors.white,
            shadowMaxOpacity: 0.08

        ),
        infoProperties: InfoProperties(
          //mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
            mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: Colors.transparent,),
            //bottomLabelText: "Días",
            bottomLabelText: "",
            bottomLabelStyle: TextStyle(fontSize: 11.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),

            modifier: (double value) {

              final kcal = 7 - value.toInt();
              return singleton.formatter.format(kcal);
            }
        ),
        startAngle: 135,//180
        angleRange: 270,//180
        //size: singleton.isIOS == false ? 55.0 : 70.0,
        size: singleton.isIOS == false ? 45.0 : 50.0,
        animDurationMultiplier: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner().toDouble() : 3.0,
        spinnerDuration: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner() : 3
    );



    singleton.GaneOrMira = "gane";
    //provider = Provider.of<HomeProvider>(this.context);
    print(singleton.secuenceOne);
    print(singleton.secuenceTwo);
    print(singleton.secuenceThree);


    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        /*if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }*/
        singleton.notifierHeightHeaderGrid.value = 0.0;
      }

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        /*if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }*/
        singleton.notifierHeightHeaderGrid.value = 90.0;
      }
    });



    WidgetsBinding.instance!.addPostFrameCallback((_){
      //notifierValueYButtons.value = MediaQuery.of(context).size.height ;
      utils.initUserLocation(context).then((value) {
        launchFetchGaneRoom();
      });
      Future.delayed(const Duration(milliseconds: 150), () {

        launchFetch();
        //launchFetchGaneRoom();
      });

      print(MediaQuery.of(context).devicePixelRatio);
      print(MediaQuery.of(context).size.height);
      print(MediaQuery.of(context).size.width);

      utils.values();
      //utils.getDeviceModel();
      launchFetchValidateSIM();


      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors()
          statusBarColor: Colors.transparent
      ));


      singleton.homeOrAnswer = "home";
    });

    super.initState();

    //startShowCase();
  }

  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    /*String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
    } on PlatformException {
      platformVersion = 'Failed to get sim country code.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

      print(platformVersion);
      print(prefs.countrySIMCOde);

      if(prefs.countrySIMCOde == "0"){
        prefs.countrySIMCOde = platformVersion!;
      }else{

        if(prefs.countrySIMCOde != platformVersion){ /// Different sim country code
          utils.goLogin();
        }


      }*/


  }


  /// Reset Load
  void _onRefresh() async{
    _refreshController.refreshCompleted();
    launchFetch();
    launchFetchGaneRoom();


    Future.delayed(const Duration(milliseconds: 1000), () {
      utils.addUserPointAnimation();
    });



  }

  ///Load More
  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();

    if(singleton.notifierLookRoom.value.code == 100){

      if(singleton.notifierLookRoom.value.data!.page! >= (singleton.Gane1RoomPages + 1)){
        singleton.Gane1RoomPages = singleton.Gane1RoomPages + 1;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            servicemanager.fetchGaneRoom(context,"agregar");
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

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        servicemanager.fetchPointProfileCategories(context);
        if(singleton.lat != 0.0){
          //utils.openProgress(context);
          servicemanager.fetchUpdateProfile(context);
        }

        servicemanager.fetchValidateSegmentation(context).then((value) {

          if(singleton.notifierValidateSegmentation.value.code==100){

           /* appearance01 = CircularSliderAppearance(
                customWidths: CustomSliderWidths(trackWidth: 9, progressBarWidth: 9),
                customColors: CustomSliderColors(
                    dotColor: Colors.white.withOpacity(0.8),
                    trackColor: CustomColors.white.withOpacity(0.8),
                    progressBarColors: [
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors(),
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors(),
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors()
                    ],
                    shadowColor: Colors.white,
                    shadowMaxOpacity: 0.08
                ),
                infoProperties: InfoProperties(
                  //mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
                  mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: Colors.transparent,),
                  //bottomLabelText: "Moni",
                  bottomLabelText: "",
                  bottomLabelStyle: TextStyle(fontSize: 11.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
                  modifier: (double value) {
                    double  kcal = value;
                    kcal = utils.returnDividendo(kcal);
                    var val = kcal.toString();
                    print(val.length);

                    /*if(val.length >= 5 && val.contains('.')){
                return kcal.toStringAsFixed(0) + utils.suffixValues(value);

              }else*/ if(val.contains('.0') || val.contains('.99')){
                      return kcal.toStringAsFixed(0) + utils.suffixValues(value);
                    }
                    return  kcal.toStringAsFixed(1) + utils.suffixValues(value);
                  },

                ),
                startAngle: 135,
                angleRange: 270,
                //size: singleton.isIOS == false ? 55.0 : 70.0,
                size: singleton.isIOS == false ? 45.0 : 50.0,
                //animationEnabled: true,
                animDurationMultiplier: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner().toDouble() : 3.0,
                spinnerDuration: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner() : 3
            );
            appearance02 = CircularSliderAppearance(
                customWidths: CustomSliderWidths(trackWidth: 9, progressBarWidth: 9,),
                customColors: CustomSliderColors(
                    dotColor: Colors.white.withOpacity(0.8),
                    trackColor: CustomColors.white.withOpacity(0.8),
                    progressBarColors: [
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors(),
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors(),
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors()
                    ],
                    shadowColor: Colors.white,
                    shadowMaxOpacity: 0.08

                ),
                infoProperties: InfoProperties(
                  //mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
                    mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: Colors.transparent,),
                    //bottomLabelText: "Días",
                    bottomLabelText: "",
                    bottomLabelStyle: TextStyle(fontSize: 11.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
                    modifier: (double value) {
                      final kcal = 7 - value.toInt();
                      return singleton.formatter.format(kcal);
                    }
                ),
                startAngle: 135,//180
                angleRange: 270,//180
                //size: singleton.isIOS == false ? 55.0 : 70.0,
                size: singleton.isIOS == false ? 45.0 : 50.0,
                animDurationMultiplier: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner().toDouble() : 3.0,
                spinnerDuration: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner() : 3
            );*/




          }

        });


        singleton.notifierUserPoints.value = Userpoints(code: 1,message: "No hay nada", status: false, data: DataPU(result: "0") );
        singleton.notifierNotificationCount.value = "0";
        servicemanager.fetchNotificationCount(context);
        servicemanager.fetchUserProfile(context);
        servicemanager.fetchPointUserPoints(context);
        servicemanager.fetchCountriesList(context);
        servicemanager.fetchUserAltam(context).then((values){

          if(values.code == 100){
            /*appearance02 = CircularSliderAppearance(
                customWidths: CustomSliderWidths(trackWidth: 9, progressBarWidth: 9,),
                customColors: CustomSliderColors(
                    dotColor: Colors.white.withOpacity(0.8),
                    trackColor: CustomColors.white.withOpacity(0.8),
                    progressBarColors: [
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors(),
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors(),
                      singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!.toColors()
                    ],
                    shadowColor: Colors.white,
                    shadowMaxOpacity: 0.08

                ),
                infoProperties: InfoProperties(
                  //mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
                    mainLabelStyle: TextStyle(fontSize: 12.0,fontFamily: Strings.font_bold, color: Colors.transparent,),
                    //bottomLabelText: "Días",
                    bottomLabelText: "",
                    bottomLabelStyle: TextStyle(fontSize: 11.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),

                    modifier: (double value) {
                      //final kcal = values.data!.user!.days! - value.toInt();
                      final kcal = values.data!.item!.daysTotal! == 0.0 ? 0.0 : values.data!.item!.daysTotal!- value.toInt();
                      return singleton.formatter.format(kcal);
                    }
                ),
                startAngle: 135,//180
                angleRange: 270,//180
                //size: singleton.isIOS == false ? 55.0 : 70.0,
                size: singleton.isIOS == false ? 45.0 : 50.0,
                animDurationMultiplier: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner().toDouble() : 3.0,
                spinnerDuration: singleton.isIOS== false ? utils.ValueDurationAnimatedSpinner() : 3
            );*/

          }

        } );

        servicemanager.fetchObtainPointsGame(context);
        // utils.dialogLoading(context);
        //utils.openProgress(context);
        //servicemanager.fetchCountriesList(context);

        //if(singleton.notifierUserProfile.value.data!.user!.userAltan! == true){
          servicemanager.fetchUserProfile1(context);
          servicemanager.fetchListPointsUser1(context, "borrar");
        //}




      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  void launchFetchGaneRoom()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        singleton.Gane1RoomPages = 0;
        singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchGaneRoom(context, "borrar");
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  void launchFetchValidateSIM()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        servicemanager.fetchValidateSIM(context,utils.getDeviceModel);
        servicemanager.fetchValidateVersion(context,showUpdateAlert);
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }
  }

  /// Alert update app
  void showUpdateAlert(BuildContext context){
    dialogUpdateVersion(context, update);
  }

  /// Launch update version
  void update() async{
    var url = 'https://play.google.com/store/apps/details?id=com.kubo.gane';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }


  @override
  void dispose() {
    _scrollViewController.removeListener(() {});
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //provider = Provider.of<HomeProvider>(context);

    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                onWillPop: backHandle.callToast,
                child: Scaffold(
                  backgroundColor: CustomColors.graybackwallet,
                  key: _scaffoldKey,
                  body: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child:

                    Stack(
                      children: [

                        _fields(context),
                        AppBar(),

                        /*Showcase(
                            key: _two,
                            description: 'Tap to see notification',
                            child: IconButton(
                                onPressed: () {
                                  // Navigate to notification screen  //
                                },
                                icon: const Icon(Icons.notifications_active)
                            )
                        )*/

                      ],
                    ),

                  ),

                ),
              )
          );

        }

    );

  }

  /// Fields List
  Widget _fields(BuildContext context){

    return Container(
      //padding: EdgeInsets.only(top: 100),
      child: Container(
        //color: Colors.red,
        padding: EdgeInsets.only(left: 10,right: 10),

        child: ValueListenableBuilder<Getprofile>(
            valueListenable: singleton.notifierUserProfile,
            builder: (context,value1,_){

              return ValueListenableBuilder<Roomlook>(
                  valueListenable: singleton.notifierLookRoom,
                  builder: (context,value2,_){

                    return SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                      header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, distance: 30, offset: 90,),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: StaggeredGridView.countBuilder(
                        //controller: _scrollViewController,
                        crossAxisCount: 3,
                        itemCount: value2.code == 1 ? 20 : value2.code == 102 ? 2 : value1.code == 120 ? 0 : value2.data!.result!.length + 1,
                        itemBuilder: (BuildContext context, int index) {

                          if(index==0){
                            return CompleteProfile(context);

                          }else if(value2.code == 1){
                            return utils.PreloadBanner();

                          }else if(value2.code == 102){
                            return utils.emptyHomeNew(Strings.emptyhome1, "", "assets/images/emptyhome.svg");

                          }else{

                            if(value2.data!.result!.length == 0){
                              return utils.emptyHome(value2.message!, "", "assets/images/emptyhome.svg");

                            }else {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 230),
                                columnCount: 3,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child: _itemGane(value2.data!.result![index-1],index-1,_onRefresh),
                                  ),
                                ),
                                //child: itemHome(context, value2.data!.result![index-1],index-1),
                              );
                            }

                          }


                        } ,
                        staggeredTileBuilder: (int index) {
                          //return _staggeredTiles[index];
                          if (index==0 && value1.code == 1) { /// first item Preloading
                            return StaggeredTile.count(4, 1);

                          }else if ((index==0 && (value1.code == 102 || value1.code == 120))) { /// first item and no results or token error
                            return StaggeredTile.count(4, 0.1);

                          } else {
                            /// Load data
                            if(index==0){ /// First item and points no complete

                              /*if( MediaQuery.of(context).devicePixelRatio >= 2.0 && MediaQuery.of(context).devicePixelRatio <= 3.0){
                                //return StaggeredTile.count(4, singleton.isIOS == true ? 1.75 :2.05);

                                if(singleton.isIOS == true){

                                  //if(MediaQuery.of(context).size.height > 568.0 && MediaQuery.of(context).size.height < 812.0){
                                  if(MediaQuery.of(context).size.height > 667.0 && MediaQuery.of(context).size.height < 812.0){
                                    return StaggeredTile.count(4, 1.85);//1.95
                                  }if(MediaQuery.of(context).size.height == 812.0){
                                    return StaggeredTile.count(4, 1.95);//1.95
                                  }else  if(MediaQuery.of(context).size.height <= 568.0){
                                    return StaggeredTile.count(4, 2.35);//1.95
                                  }else  if(MediaQuery.of(context).size.height == 844.0){
                                    return StaggeredTile.count(4, 1.90);//1.95
                                  }else  if(MediaQuery.of(context).size.height == 667.0){
                                    return StaggeredTile.count(4, 2.05);//1.95
                                  }else{
                                    return StaggeredTile.count(4, 1.7);//1.75
                                  }

                                }else{

                                  if( MediaQuery.of(context).devicePixelRatio > 2.0 && MediaQuery.of(context).devicePixelRatio <= 2.8){

                                    if(MediaQuery.of(context).size.height == 856.7272727272727 && MediaQuery.of(context).devicePixelRatio == 2.75){
                                      return StaggeredTile.count(4, 1.92);
                                    }else return StaggeredTile.count(4, 1.85);//1.95

                                  }else if( MediaQuery.of(context).devicePixelRatio == 2.0){

                                    if(MediaQuery.of(context).size.height == 672.0){
                                      return StaggeredTile.count(4, 2.05);
                                    }else return StaggeredTile.count(4, 1.9);//2.0
                                  }else
                                    return StaggeredTile.count(4, 2.05);// 2.15
                                }



                              }else if(MediaQuery.of(context).devicePixelRatio < 2.0){

                                if(MediaQuery.of(context).size.height > 1000.0){
                                  return StaggeredTile.count(4, 1.5); //  1.6
                                }else if(MediaQuery.of(context).size.height > 700.0){
                                  return StaggeredTile.count(4, 1.78);//1.88
                                }else {
                                  return StaggeredTile.count(4, 2.38);//2.48
                                }

                              }else{

                                if( MediaQuery.of(context).devicePixelRatio == 3.5 && MediaQuery.of(context).size.height > 683){
                                  return StaggeredTile.count(4, 1.75);// 1.75

                                }else if( MediaQuery.of(context).devicePixelRatio == 3.375 && ( MediaQuery.of(context).size.height > 647 && MediaQuery.of(context).size.height < 649) ){
                                  return StaggeredTile.count(4, 2.10);

                                }else
                                  return StaggeredTile.count(4, 1.65);// 1.75
                              }
                              */

                              return  StaggeredTile.fit(3);

                            }else{ /// Loading

                              if(value2.code == 1){

                                if(index %7 == 0 ){ /// 2 Cube
                                  return StaggeredTile.count(2, 2);

                                }else if(index %10 == 0){ /// banner
                                  return StaggeredTile.count(4, 1.2);

                                }else{  /// 1 Cube
                                  return StaggeredTile.count(1, 1); // Cambiar para el doble alto
                                }

                              }else if(value2.code == 102){ /// No results

                                return StaggeredTile.count(4, 3);

                              }else { /// Load data

                                if(value2.data!.result![index-1]!.sizeAds! == "standard"){ /// 1 Normal
                                  return StaggeredTile.count(1, 1);//

                                }else if(value2.data!.result![index-1]!.sizeAds! == "block"){ /// 2 Cubes
                                  return StaggeredTile.count(2, 2);

                                }else{  /// Banner
                                  return StaggeredTile.count(4, 1.2);

                                }

                              }

                            }

                            //}
                          }

                        },
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        padding: const EdgeInsets.all(4),


                      ),
                    );

                  }

              );

            }

        ),

      ),

    );

  }

  /// Item CompleteProfile
  Widget CompleteProfile(BuildContext context){

    return Center(

      child: ValueListenableBuilder<Getprofile>(
          valueListenable: singleton.notifierUserProfile,
          builder: (context,value1,_){

            return (value1.code == 1 || value1.code == 102 || value1.code == 120) ? Container() :

            ValueListenableBuilder<UserAltan>( /// user gane
                valueListenable: singleton.notifierUseraltan,
                builder: (context,value4,_){

                  return InkWell(
                    onTap: (){


                      if(value1.data!.user!.userAltan! == false){
                        //dialogBanner(context,launchCallOrWhat);

                        var time = 350;
                        if(singleton.isIOS == false){
                          time = utils.ValueDuration();
                        }
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                            reverseDuration: Duration(milliseconds: time)
                        )).then((value) {
                        });

                      }else  if(( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > value4.data!.item!.daysTotal! ) && value4.data!.item!.exchange! != "missing" ){ /// Canjear
                        //}else  if((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing"){ /// Canjear
                        //exchangeCoinstoMb();

                        if(singleton.notifierUserProfile.value.data!.user!.verificationCodeSim == true){
                          dialogRedeem(context, exchangeCoinstoMb);
                        }else{
                          utils.showDialogValidateTelf(context, (){ });
                          //utils.showDialogValidateTelf(context, launchFetchValidateTelf);
                        }


                      }else {
                        utils.openSnackBarInfo(context, Strings.noyetcanje, "assets/images/ic_sad.svg",CustomColors.blueBack,"error");
                      }


                    },
                    child: Container(/// Data with gane
                      //color: Colors.red,

                      child: Stack(

                        alignment: AlignmentDirectional.center,

                        children: [

                          /// Blue View
                          Column(

                            children: [

                              SizedBox(
                                height: 100,
                              ),

                              /// Blue Back
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: CustomColors.blueText,
                                  borderRadius: BorderRadius.all(const Radius.circular(5)),
                                ),
                                child: Container(
                                  height: 120,
                                  //padding: EdgeInsets.only(top: 4),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: SvgPicture.asset(
                                      'assets/images/backcanjessss.svg',
                                      height: 120,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),


                            ],

                          ),

                          /// Days moni
                          Container(
                            height: 130,
                            //color: Colors.green,
                            margin: EdgeInsets.only(top:
                            /// Android
                            singleton.isIOS == false && MediaQuery.of(context).size.height < 840 ? 93 :
                            singleton.isIOS == false && (MediaQuery.of(context).size.height > 840 && MediaQuery.of(context).size.height < 925) ? 84 :
                            singleton.isIOS == false && MediaQuery.of(context).size.height > 925 ? 77 :
                            //singleton.isIOS == false && MediaQuery.of(context).size.height == 856.7272727272727  && MediaQuery.of(context).devicePixelRatio == 2.75 ? 120 :
                            /// IOS
                            MediaQuery.of(context).size.height < 750 ? 83 :  90,left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [

                                /// Days moni
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 120,
                                    //color: Colors.black,
                                    child: Column(

                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: <Widget>[

                                        ((MediaQuery.of(context).devicePixelRatio >= 2.0 && MediaQuery.of(context).devicePixelRatio <= 3.0) && (MediaQuery.of(context).size.height > 568.0 && MediaQuery.of(context).size.height < 812.0) ) ?
                                        Container() :
                                        singleton.isIOS == false && MediaQuery.of(context).size.height > 925 ? Container() :
                                        Container(height: 10,),

                                        ///Text and Logo
                                        Container(
                                          //margin: EdgeInsets.only(left: 10),
                                          //color:Colors.yellow,
                                          alignment: Alignment.center,
                                          child:  AutoSizeText(
                                            Strings.totalchange,
                                            textAlign: TextAlign.left,
                                            maxLines: 1,
                                            style: TextStyle(fontFamily: Strings.font_bold, color: Colors.transparent,fontSize: 30.0),
                                            textScaleFactor: 1.0,
                                            minFontSize: 9,
                                            maxFontSize: 30,
                                            //maxLines: 1,
                                          ),
                                        ),

                                        SizedBox(height: singleton.isIOS == false ? 15 : 5,), // 5 antes

                                        /// View Moni and days
                                        Container(
                                          //color: Colors.red,
                                          //margin: EdgeInsets.only(left: 20),

                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.max,

                                              children: [

                                                ///View Moni

                                                Column(
                                                  children: [

                                                    /// Progress
                                                    SleekCircularSlider(
                                                      appearance: appearance01,
                                                      min: 0,
                                                      //initialValue: value4.code == 1 || value4.code == 102 ? 0.0 : double.parse( value4.data!.item!.points! ) - double.parse( value4.data!.item!.remainingPoints! ),
                                                      //max: value4.code == 1 || value4.code == 102 ? 0.0 : double.parse( value4.data!.item!.points! ),
                                                      initialValue: value4.code == 1 || value4.code == 102 ? 0.0 : double.parse( value4.data!.item!.pointsUser!.result!),
                                                      max: value4.code == 1 || value4.code == 102 ? 0.0 : value4.data!.item!.remainingPoints! == "0" && value4.data!.item!.exchange! == "convert" ? double.parse( value4.data!.item!.pointsUser!.result! )  :  double.parse( value4.data!.item!.points! ),
                                                    ),

                                                    SizedBox(
                                                      height: 3,
                                                    ),

                                                    /// value
                                                    Container(
                                                      height: 15,
                                                      padding: EdgeInsets.only(left: 5,right: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                        color: CustomColors.white,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child:  AutoSizeText(
                                                        value4.code == 1 || value4.code == 102 ? "0" : utils.returnDataMoni(double.parse( value4.data!.item!.pointsUser!.result!)) + " Moni", /// singleton.formatter.format(double.parse( value4.data!.item!.pointsUser!.result!)) + " Moni",
                                                        //value4.code == 1 || value4.code == 102 ? "0" : utils.returnDataMoni(double.parse( "12345")) + " Moni",
                                                        textAlign: TextAlign.left,
                                                        maxLines: 1,
                                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.orangeswitch ,fontSize: 13.0),//"#00A86B".toColors()
                                                        textScaleFactor: 1.0,
                                                        minFontSize: 9,
                                                        maxFontSize: 14,
                                                        //maxLines: 1,
                                                      ),
                                                    )

                                                  ],
                                                ),

                                                //SizedBox(width: 10,),

                                                /// View Days
                                                Column(
                                                  //crossAxisAlignment: CrossAxisAlignment.center,

                                                  children: [

                                                    /// Progress
                                                    SleekCircularSlider(
                                                      appearance: appearance02,
                                                      //initialValue: value4.code == 1 || value4.code == 102 ? 0.0 : double.parse( value4.data!.item!.exchangeDay! ) > 7 ? 7 : double.parse( value4.data!.item!.exchangeDay! ) < 7 ? double.parse( value4.data!.item!.exchangeDay! ) :  7 - double.parse( value4.data!.item!.exchangeDay! ),
                                                      initialValue: value4.code == 1 || value4.code == 102 ? 0.0 : ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > value4.data!.item!.daysTotal! ) ?  value4.data!.item!.daysTotal! : value4.data!.item!.daysTotal! - double.parse( value4.data!.item!.exchangeDay! ),
                                                      min: 0,
                                                      max: value4.code == 1 || value4.code == 102 ? 7 : value4.data!.item!.daysTotal! ,//7 value1.data!.user!.days!
                                                    ),

                                                    SizedBox(
                                                      height: 3,
                                                    ),

                                                    /// value
                                                    Container(
                                                      height: 15,
                                                      padding: EdgeInsets.only(left: 5,right: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(
                                                          Radius.circular(10.0),
                                                        ),
                                                        color: CustomColors.white,
                                                      ),
                                                      alignment: Alignment.center,
                                                      child:  AutoSizeText(
                                                        //value4.code == 1 || value4.code == 102 ? "0" : singleton.formatter.format( 7-( 7 - double.parse( value4.data!.item!.exchangeDay! ) ) ) + " Días",
                                                        //value4.code == 1 || value4.code == 102 ? "0" : double.parse( value4.data!.item!.exchangeDay! ) >= 7 ? "0 Días" : double.parse( value4.data!.item!.exchangeDay! ) <= 7 ? singleton.formatter.format( double.parse( value4.data!.item!.exchangeDay! )  ) + " Días" : singleton.formatter.format( 7-( 7 - double.parse( value4.data!.item!.exchangeDay! ) ) ) + " Días",
                                                        value4.code == 1 || value4.code == 102 ? "0" : ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > value4.data!.item!.daysTotal! ) ? "0 Días"  : singleton.formatter.format( double.parse( value4.data!.item!.exchangeDay! )  ) + " Días",
                                                        textAlign: TextAlign.left,
                                                        maxLines: 1,
                                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.orangeswitch,fontSize: 13.0),// "#00A86B".toColors()
                                                        textScaleFactor: 1.0,
                                                        minFontSize: 9,
                                                        maxFontSize: 14,
                                                        //maxLines: 1,
                                                      ),
                                                    )

                                                  ],

                                                )

                                              ],

                                            )
                                        ),

                                        //SizedBox(height: 10,),

                                      ],

                                    ),
                                  ),
                                ),

                                SizedBox(width: 5,),

                                /// Person image
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height: singleton.isIOS == false ? 130 : 140,
                                    //color: Colors.yellow,
                                    //padding: EdgeInsets.only(bottom: singleton.isIOS == false ? 0 : 10),
                                    child: Image(
                                      image: AssetImage(
                                        //prefs.flagWinCanje == "Canjeo" ? "assets/images/hombre_ganaste.png" :
                                        value1.data!.user!.userAltan! == false ? "assets/images/hombre_chipgane.png" :
                                        //value4.data!.item!.exchangeDay! == "0" && value4.data!.item!.exchange! != "missing" ? "assets/images/hobre_canjear.png" :
                                        ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > value4.data!.item!.daysTotal! ) && value4.data!.item!.exchange! != "missing" ? "assets/images/hobre_canjear.png" :
                                        // ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ? "assets/images/hobre_canjear.png" :
                                        "assets/images/hombre_casicasi.png",

                                      ),
                                      //height: 130,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),

                              ],

                            ),
                          ),

                          /// CANJE CONTROL TEXT
                          Container(
                            /*margin: EdgeInsets.only(top:
                            /// Android
                            singleton.isIOS == false && MediaQuery.of(context).size.height < 840 ? 113 :
                            //singleton.isIOS == false && MediaQuery.of(context).size.height > 840 ? 104 :
                            singleton.isIOS == false && (MediaQuery.of(context).size.height > 840 && MediaQuery.of(context).size.height < 925) ? 104 :
                            singleton.isIOS == false && MediaQuery.of(context).size.height > 925 ? 114 :
                            /// IOS
                            MediaQuery.of(context).size.height < 750 ? 108 :  110,left: 8),*/
                            margin: EdgeInsets.only(top: 15,left: 8),
                            alignment: Alignment.topLeft,
                            child: AutoSizeText(
                              Strings.totalchange,
                              //MediaQuery.of(context).devicePixelRatio.toString() + ", " + MediaQuery.of(context).size.height.toString() + ", " + MediaQuery.of(context).size.width.toString() + ", ",
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: TextStyle(fontFamily: Strings.font_boldFe, color:CustomColors.white,fontSize: 20.0),
                              textScaleFactor: 1.0,
                              minFontSize: 9,
                              maxFontSize: 30,
                              //maxLines: 1,
                            ),
                          )

                        ],

                      ),

                    ),
                  );

                }

            );

          }
      ),

    );

  }

  /// Validate Telf
  void launchFetchValidateTelf()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        dialogRedeem(singleton.navigatorKey.currentContext!, exchangeCoinstoMb);
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Exchange coins to Mb
  void exchangeCoinstoMb()async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        utils.openProgress(singleton.navigatorKey.currentContext!);
        singleton.notifierListUserPoints.value = Userpointlist(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchExchangeCoinsToMb(singleton.notifierUseraltan.value.data!.item!.id!,singleton.navigatorKey.currentContext!);

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }


  }

  /// Item CompleteProfile
  Widget CompleteProfile1(BuildContext context){

    return Center(
      child: ValueListenableBuilder<TotalpointProfileCategories>(
          valueListenable: singleton.notifierPointsProfileCategories,
          builder: (context,value1,_){

            return (value1.code == 1 || value1.code == 102 || value1.code == 120) ? Container() : value1.data!.point! == value1.data!.totalUser! ?
            Container() :
            Container(
              //padding: EdgeInsets.only(top: 100),
              //color: Colors.yellow,
              child: Column(

                children: [

                  SizedBox(
                    height: 100,
                  ),

                  InkWell(
                    onTap: (){

                      Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 2,)) );
                      //Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: CProfile(PointProfileCategorie: launchFetch,) ));
                    },
                    child: Container(
                      width: double.infinity,
                      //height: 120,
                      decoration: BoxDecoration(
                        color: CustomColors.blueText,
                        borderRadius: BorderRadius.all(const Radius.circular(5)),
                      ),
                      child: Container(
                        //color: Colors.red,
                        padding: EdgeInsets.only(top: 4,left: 10),

                        child: Center(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: <Widget>[

                              SizedBox(height: 10,),

                              ///Text and Logo
                              Container(
                                //margin: EdgeInsets.only(bottom: 30),
                                //color: Colors.green,
                                child: Row(

                                  children: [

                                    ///Text
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        //color:Colors.yellow,
                                        alignment: Alignment.center,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: AutoSizeText(
                                            Strings.completeprofile,
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 20.0,fontFamily: Strings.font_bold, color: CustomColors.white,),
                                            textScaleFactor: 1.0,
                                            //maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///Coin image
                                    Container(
                                      //color: Colors.red,
                                      padding: EdgeInsets.only(left: 30,right: 15),
                                      /*child: Image(
                                      width: 40,
                                      height: 63,
                                      image: AssetImage("assets/images/coinspile.png"),
                                      fit: BoxFit.cover,
                                    ),*/
                                      child: SvgPicture.asset(
                                        'assets/images/coinspile.svg',
                                        fit: BoxFit.cover,
                                      ),

                                    ),

                                  ],

                                ),
                              ),

                              SizedBox(height:10,),

                              ///Liquid Linear progress, Value coins
                              Align(
                                alignment: Alignment.bottomRight,
                                /*bottom: 0,
                                left: 0,
                                right: 0,*/
                                child: Container(
                                  margin: EdgeInsets.only(top: 1.5,left: 10),
                                  //color: Colors.red,
                                  child: Row(
                                    children: [

                                      ///Liquid Linear progress
                                      Expanded(
                                        //flex: 3,
                                        child: Container(
                                          //zmargin: EdgeInsets.only(top: 4),
                                          height: 15,
                                          child: ValueListenableBuilder<TotalpointProfileCategories>(
                                              valueListenable: singleton.notifierPointsProfileCategories,
                                              builder: (context,value,_){

                                                return LiquidLinearProgressIndicator(
                                                  value: (value.code == 1 || value.code == 102 || value.code == 120) ? 0.0 :  ((value.data!.totalUser! * 100)/value.data!.point!)/100, // Defaults to 0.5.
                                                  valueColor: AlwaysStoppedAnimation(CustomColors.orangeback), // Defaults to the current Theme's accentColor.
                                                  backgroundColor: CustomColors.white, // Defaults to the current Theme's backgroundColor.
                                                  borderColor: CustomColors.white,
                                                  borderWidth: 3.0,
                                                  borderRadius: 8.0,
                                                  direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                                  center: Text(""),

                                                );

                                              }

                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 20,
                                      ),

                                      ///Value coins
                                      Container(
                                        //margin: EdgeInsets.only(left: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(7.0),
                                            bottomRight: Radius.circular(5.0),
                                            topRight: Radius.circular(7.0),
                                            bottomLeft: Radius.circular(5.0),
                                          ),
                                          color: CustomColors.orangeback,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.only(top: 4,right: 4,bottom: 4,left: 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,

                                            children: [

                                              ///Value
                                              Container(

                                                //color: Colors.blue,
                                                child: ValueListenableBuilder<TotalpointProfileCategories>(
                                                    valueListenable: singleton.notifierPointsProfileCategories,
                                                    builder: (context,value,_){

                                                      return Text((value.code == 1 || value.code == 102 || value.code == 120) ? "0" : singleton.formatter.format(value.data!.point!.toDouble()),
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 16,),
                                                        textScaleFactor: 1.0,
                                                      );

                                                    }

                                                ),
                                              ),

                                              SizedBox(width: 3,),

                                              ///Icon
                                              /*Container(
                                              child: Image(
                                                width: 15,
                                                height: 15,
                                                image: AssetImage("assets/images/coins.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),*/
                                              Container(
                                                //color: Colors.green,
                                                //padding: EdgeInsets.only(left: 5,right: 5),
                                                padding: EdgeInsets.only(bottom: 1),
                                                child: SvgPicture.asset(
                                                  'assets/images/coins.svg',
                                                  fit: BoxFit.contain,
                                                  width: 13,
                                                  height: 13,
                                                ),
                                              ),

                                            ],

                                          ),
                                        ),
                                      ),

                                    ],

                                  ),
                                ),
                              )


                            ],

                          ),
                        ),
                      ),
                    ),
                  )

                ],

              ),
            );

          }

      ),
    );

  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>  CProfile(PointProfileCategorie: launchFetch,),
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

  /// Data Plan Gane
  Widget dataPlanGane(BuildContext context){

    return Container(
      margin: EdgeInsets.only(top: 100,left: 3,right: 3),
      //color: Colors.green,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            // margin: EdgeInsets.only(top: 125,left: 20,right: 20),
            width: MediaQuery.of(context).size.width,
            height: 110,
            decoration: BoxDecoration(
              borderRadius:  BorderRadius.all(const Radius.circular(5)),
              color: CustomColors.blueBack.withOpacity(0.9),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: ///Image
              InkWell(
                onTap: (){
                  ///dialogBanner(context,launchCallOrWhat);
                },
                child: ValueListenableBuilder<BannerWallet>(
                    valueListenable: singleton.notifierBannerAltan,
                    builder: (context,valueBanner,_){

                      /*return CachedNetworkImage(
                                fit: BoxFit.cover,
                                //imageUrl: "https://viva.com.do/wp-content/uploads/2021/01/Plan-Estudiantil-web-.png",
                                imageUrl: valueBanner.data!.item!.photoUrl!,
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
                              );*/

                      return Image.network(
                        valueBanner.data!.item!.photoUrl!,
                        //"http://url.com/image.png",
                        fit: BoxFit.cover,
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
                      );

                    }

                ),
              ),
            )

        ),
      ),
    );

  }


  void relaunch(){

  }

  /// Call or Whats
  void launchCallOrWhat(String url){
    //url = url.replaceAll("+", "");
    utils.callOrWebView(url);

  }


}

///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();

  final GlobalKey _two = GlobalKey();
  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderGrid,
        builder: (context,value2,_){

          return AnimatedContainer(
            height: value2,
            duration: Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,

            child: Stack(

              children: [

                ///Background
                Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,

                    child: ValueListenableBuilder<SegmentationCustom>(
                        valueListenable: singleton.notifierValidateSegmentation,
                        builder: (context,value2,_){

                          return value2.code == 1 ? Image(
                            image: AssetImage("assets/images/headernew.png"),
                            fit: BoxFit.fill,
                          ) :
                          value2.code==100 ? Container(
                            color: value2.data!.styles!.colorHeader!.toColors(),
                          ) :
                          Image(
                            image: AssetImage("assets/images/headernew.png"),
                            fit: BoxFit.fill,
                          );

                        }

                    )
                  /*child: Image(
                    image: AssetImage("assets/images/headernew.png"),
                    fit: BoxFit.fill,
                  ),*/


                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    ///Logo
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        //color: Colors.blue,
                        padding: EdgeInsets.only(top: 35,left: 20),

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
                        /*child: SvgPicture.asset(
                          'assets/images/logohome.svg',
                          fit: BoxFit.contain,
                          width: 80,
                          height: 42,
                        ),*/


                      ),
                    ),

                    /// Ciudad
                    /*ValueListenableBuilder<String>(
                        valueListenable: singleton.notifierCity,
                        builder: (context,value22,_){

                          return Expanded(
                            child: InkWell(
                              onTap: (){

                                singleton.Gane1RoomPages = 0;
                                singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );

                                singleton.notifierChangeCity.value = singleton.notifierChangeCity.value + 1;
                                if(singleton.notifierChangeCity.value > 4){
                                  singleton.notifierChangeCity.value = 0;
                                }

                                Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );

                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                color: Colors.red,
                                height: 40,
                                child: Text(
                                  value22,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                ),
                              ),
                            ),
                          );

                        }

                    ),*/

                    ///Coins
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        padding: EdgeInsets.only(right: 10,left: 10,top: 20 ),
                        //color: Colors.red,
                        child: ValueListenableBuilder<Userpoints>(

                            valueListenable: singleton.notifierUserPoints,
                            builder: (context,value,_){

                              /*return Badge(
                                position: BadgePosition.topEnd(end: value.code == 1 || value.code == 102 ? -4 : int.parse(value.data!.result!) < 10 ? 0 : -10,),
                                toAnimate: true,
                                animationType: BadgeAnimationType.scale,
                                showBadge: value.code == 1 && value.code == 102 ? false :  true,
                                badgeColor: CustomColors.blueBack,

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
                                  /*child: SvgPicture.asset(
                                    'assets/images/coins.svg',
                                    fit: BoxFit.contain,
                                    width: 30,
                                    height: 30,
                                  ),*/

                                    child: Container(
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

                                          ValueListenableBuilder<SegmentationCustom>(
                                              valueListenable: singleton.notifierValidateSegmentation,
                                              builder: (context,valuese,_){

                                                /*return valuese.code == 1 ? SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                          ) : valuese.code==100 ?  Image(
                                            image: AssetImage("assets/images/monedaonline.png"),
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                            color: valuese.data!.styles!.colorHeader!.toColors(),
                                          ) :
                                          SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
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
                                                      width: 30,
                                                      height: 30,
                                                      color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                                                    )

                                                  ],

                                                );


                                              }

                                          )

                                        ],

                                      ),
                                    )


                                ),
                              );*/

                              return badges.Badge(
                                  badgeContent: AnimatedFlipCounter(
                                    duration: Duration(milliseconds: 2000),
                                    value: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? int.parse(value.data!.result!) : ( double.parse(value.data!.result!) / 1000),
                                    fractionDigits: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? 0 : int.parse(value.data!.result!) > 9999 ? 0 : 1, // decimal precision
                                    suffix: value.code == 1 || value.code == 102 ? "" : int.parse(value.data!.result!) < 1000 ? "" : "K",

                                    textStyle: TextStyle(fontSize: value.code == 1 || value.code == 102 ? 9.0 : int.parse(value.data!.result!) < 1000 ? 9.0 : 8.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                  ),
                                  showBadge: value.code == 1 && value.code == 102 ? false :  true,
                                  badgeStyle: badges.BadgeStyle(
                                    badgeColor: CustomColors.blueBack,
                                  ),
                                  position: BadgePosition.topEnd(end: value.code == 1 || value.code == 102 ? -4 : int.parse(value.data!.result!) < 10 ? 0 : -10,),
                                child: Container(
                                  /*child: SvgPicture.asset(
                                    'assets/images/coins.svg',
                                    fit: BoxFit.contain,
                                    width: 30,
                                    height: 30,
                                  ),*/

                                    child: Container(
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

                                          ValueListenableBuilder<SegmentationCustom>(
                                              valueListenable: singleton.notifierValidateSegmentation,
                                              builder: (context,valuese,_){

                                                /*return valuese.code == 1 ? SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                          ) : valuese.code==100 ?  Image(
                                            image: AssetImage("assets/images/monedaonline.png"),
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                            color: valuese.data!.styles!.colorHeader!.toColors(),
                                          ) :
                                          SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
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
                                                      width: 30,
                                                      height: 30,
                                                      color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                                                    )

                                                  ],

                                                );


                                              }

                                          )

                                        ],

                                      ),
                                    )


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

                    ),

                    ///Notifications
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        padding: EdgeInsets.only(right: 15,top: 20),
                        //color: Colors.blue,
                        child: ValueListenableBuilder<String>(
                            valueListenable: singleton.notifierNotificationCount,
                            builder: (context,value,_){

                              /*return Badge(
                                position: BadgePosition.topEnd(end: -2,),
                                //position: BadgePosition.topEnd(end: -10,),
                                toAnimate: true,
                                animationType: BadgeAnimationType.scale,
                                showBadge: value == "0" ? false : true,
                                //showBadge: true,
                                badgeColor: CustomColors.blueBack,
                                badgeContent: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                ),
                                child: Container(

                                    child: Image(
                                      image: AssetImage("assets/images/campanaonline.png"),
                                      fit: BoxFit.contain,
                                      width: 30,
                                      height: 30,
                                      //color: "#00A86B".toColors(),
                                    )


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

                                    child: Image(
                                      image: AssetImage("assets/images/campanaonline.png"),
                                      fit: BoxFit.contain,
                                      width: 30,
                                      height: 30,
                                      //color: "#00A86B".toColors(),
                                    )


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
                          time = 1200;
                        }

                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: Notificationss(),
                            reverseDuration: Duration(milliseconds: time)
                        ));

                      },


                    ),

                  ],
                )

              ],

            ),


          );

        }

    );

  }

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

          /*Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: GaneCampaignDetail(item: item,relaunch: relaunch,),
          reverseDuration: Duration(milliseconds: time)
          ));*/


          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: GaneCampaignDetail(item: item,relaunch: relaunch,),
              reverseDuration: Duration(milliseconds: time)
          )).then((value) {
            if(value=="relaunch"){

              /*Future.delayed(const Duration(seconds: 2), () {

                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: GaneCampaignDetail(item: item,relaunch: relaunch,),
                        reverseDuration: Duration(milliseconds: time)
                    ));

                  });*/
              //utils.openSnackBarInfo(context, "Video no disponible en el momento, intente nuevamente.", "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

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
