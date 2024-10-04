import 'dart:io';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/altanplan.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/profilecategories.dart';
import 'package:gane/src/Models/referrals.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Home/profileDetail.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
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
import 'package:transition/transition.dart';
import 'package:badges/badges.dart' as badges;

class ShareData extends StatefulWidget{

  final from;
  final VoidCallback? PointProfileCategorie;

  ShareData({this.from, this.PointProfileCategorie});

  _stateShareData createState()=> _stateShareData();
}

class _stateShareData extends State<ShareData> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ScrollController _scrollViewController = new ScrollController();


  late HomeProvider providerHome;



  @override
  void initState(){

    WidgetsBinding.instance!.addPostFrameCallback((_){
      launchFetch();
    });

    super.initState();
  }

  void launchFetch()async{
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        utils.openProgress(context);
        servicemanager.fetchUserProfile(context);
        servicemanager.fetchReffereal(context);
        servicemanager.fetchValidateSegmentation(context);

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


  @override
  void dispose() {
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

                        // AppBar(),

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

    return Stack(

      children: [

        ///Background header
        Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            /*child: Image(
              image: AssetImage("assets/images/header.png"),
              fit: BoxFit.fill,
              color: Colors.red,
            )*/

            child: ValueListenableBuilder<SegmentationCustom>(
                valueListenable: singleton.notifierValidateSegmentation,
                builder: (context,value2,_){

                  return value2.code == 1 ? Image(
                    image: AssetImage("assets/images/header.png"),
                    fit: BoxFit.fill,
                  ):
                  value2.code==100 ? Container(
                    color: value2.data!.styles!.colorHeader!.toColors(),
                  ) :
                  Image(
                    image: AssetImage("assets/images/header.png"),
                    fit: BoxFit.fill,
                  );

                }

            )
        ),

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

              Expanded(
                child: Container(
                  height: 10,
                  //color: Colors.red,
                ),
              ),

              /// User image
              /*InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
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
              ),*/
              /*SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  margin: EdgeInsets.only(right: 10, top: 40,),
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
          margin: EdgeInsets.only(top: 88),
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
            header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback,),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(

                  children: [

                    /// Data
                    Container(

                      //height: 103,

                      child: Stack(

                        children: [

                          /// Orange header
                          Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            /*child: SvgPicture.asset(
                              'assets/images/Background_orange_referrals.svg',
                              fit: BoxFit.fill,
                            ),*/
                              child: ValueListenableBuilder<SegmentationCustom>(
                                  valueListenable: singleton.notifierValidateSegmentation,
                                  builder: (context,value2,_){

                                    return value2.code == 1 ? SvgPicture.asset(
                                      'assets/images/Background_orange_referrals.svg',
                                      fit: BoxFit.fill,
                                    ):
                                    value2.code==100 ? Container(
                                      color: value2.data!.styles!.colorHeader!.toColors(),
                                    ) :
                                    SvgPicture.asset(
                                      'assets/images/Background_orange_referrals.svg',
                                      fit: BoxFit.fill,
                                    );

                                  }

                              )

                          ),

                          /// Data
                          Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              SizedBox(height: 10,),

                              /// Gana xxx
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [

                                  Expanded(child: Container(),),

                                  ValueListenableBuilder<ReferralData>(
                                      valueListenable: singleton.notifierReferralData,
                                      builder: (context,value1,_){

                                        return value1.code == 1 ? Container() : Container(
                                          child: Text(Strings.share3 + " " + singleton.formatter.format(value1.data!.information!.pointsUser!) ,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 41,),
                                            textScaleFactor: 1.0,
                                          ),
                                        );

                                      }

                                  ),

                                  SizedBox(width: 5,),

                                  Container(
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
                                                    )  : valuese.code==100 ?  Image(
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
                                                    ) ;*/

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

                                  Container(
                                    child: Text(" !",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 41,),
                                      textScaleFactor: 1.0,
                                    ),
                                  ),

                                  Expanded(child: Container(),),

                                ],

                              ),

                              SizedBox(height: 10,),

                              /// firs text
                              Container(
                                padding: EdgeInsets.only(left: 20,right: 20),
                                child: SvgPicture.asset(
                                  'assets/images/Text_referrals_blue.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),

                              SizedBox(height: 10,),

                              /// Cuates Gana xxx
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [

                                  Expanded(child: Container(),),


                                  ValueListenableBuilder<ReferralData>(
                                      valueListenable: singleton.notifierReferralData,
                                      builder: (context,value1,_){

                                        return value1.code == 1 ? Container() : Container(
                                          //color: Colors.green,
                                          child: Text(Strings.share4 + " " + singleton.formatter.format(value1.data!.information!.pointsFriend!)  ,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 20,),
                                            textScaleFactor: 1.0,
                                          ),
                                        );

                                      }

                                  ),


                                  SizedBox(width: 5,),

                                  Container(
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
                                                  ) ;*/

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

                                  Container(
                                    child: Text(" !",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 20,),
                                      textScaleFactor: 1.0,
                                    ),
                                  ),

                                  Expanded(child: Container(),),

                                ],

                              ),

                              SizedBox(height: 160,),

                              Container(
                                margin: EdgeInsets.only(left: 60),
                                alignment: Alignment.centerLeft,
                                child: Text(Strings.share5,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 18,),
                                  textScaleFactor: 1.0,
                                ),
                              ),

                              SizedBox(height: 15,),

                              /// firs text
                              Container(
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.green,
                                child: SvgPicture.asset(
                                  'assets/images/Text_steps.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),

                              SizedBox(height: 15,),

                              /// MIs Monis y los de mis cuates
                              ValueListenableBuilder<ReferralData>(
                                  valueListenable: singleton.notifierReferralData,
                                  builder: (context,value1,_){

                                    return value1.code == 1 ? Container() :
                                    ValueListenableBuilder<SegmentationCustom>(
                                        valueListenable: singleton.notifierValidateSegmentation,
                                        builder: (context,valuese,_){

                                          return Container(
                                            child: Text(Strings.share6 + singleton.formatter.format(value1.data!.information!.pointsUser!) + Strings.share7 + "\n" +  Strings.share8 +
                                                singleton.formatter.format(value1.data!.information!.pointsFriend!) + Strings.share7,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontFamily: Strings.font_boldFe, color: valuese.code==1 ? CustomColors.orangeback : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors(): CustomColors.orangeback, fontSize: 20,),
                                              textScaleFactor: 1.0,
                                            ),
                                          );

                                        }

                                    );

                                  }

                              ),

                              SizedBox(height: 30,),

                              /// Share data
                              Card(
                                margin: EdgeInsets.only(left: 30,right: 30),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: CustomColors.graycountry, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                child: Container(
                                    margin: EdgeInsets.all(13),

                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,

                                      children: [


                                        /// Compartidos efectivos
                                        Row(

                                          children: [

                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(Strings.share,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 17,),
                                                  textScaleFactor: 1.0,
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              flex: 1,
                                              child: ValueListenableBuilder<ReferralData>(
                                                  valueListenable: singleton.notifierReferralData,
                                                  builder: (context,value1,_){


                                                    return value1.code == 1 ? utils.PreloadRefarreal() :
                                                    ValueListenableBuilder<SegmentationCustom>(
                                                        valueListenable: singleton.notifierValidateSegmentation,
                                                        builder: (context,valuese,_){

                                                          return Container(
                                                            child: Text(singleton.formatter.format(double.parse(value1.data!.information!.effectiveShares!)),
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(fontFamily: Strings.font_boldFe, color: valuese.code==1 ? CustomColors.orangeback : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors(): CustomColors.orangeback, fontSize: 17,),
                                                              textScaleFactor: 1.0,
                                                            ),
                                                          );

                                                        }

                                                    );

                                                  }

                                              ),
                                            )

                                          ],

                                        ),

                                        SizedBox(height: 15,),

                                        /// Monis ganados
                                        Row(

                                          children: [

                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                child: Text(Strings.share1,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 17,),
                                                  textScaleFactor: 1.0,
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              flex: 1,
                                              child: ValueListenableBuilder<ReferralData>(
                                                  valueListenable: singleton.notifierReferralData,
                                                  builder: (context,value1,_){

                                                    return value1.code == 1 ? utils.PreloadRefarreal() : Container(
                                                      child: Text(singleton.formatter.format(double.parse(value1.data!.information!.pointsWin!)),
                                                        textAlign: TextAlign.right,
                                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 17,),
                                                        textScaleFactor: 1.0,
                                                      ),
                                                    );

                                                  }

                                              ),
                                            )

                                          ],

                                        ),

                                      ],

                                    )

                                ),

                              ),

                              SizedBox(height: 30,),



                            ],


                          ),

                          /// Share number
                          InkWell(
                            onTap: (){
                              shareFile();
                            },
                            child: Card(
                              margin: EdgeInsets.only(left: 30,right: 30,top: 200),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: CustomColors.blueback,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: CustomColors.blueback, width: 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.all(20),
                                child: Column(

                                  mainAxisSize: MainAxisSize.min,

                                  children: [

                                    /// share númber
                                    Container(
                                      child: Text(Strings.share2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 18,),
                                        textScaleFactor: 1.0,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        ValueListenableBuilder<ReferralData>(
                                            valueListenable: singleton.notifierReferralData,
                                            builder: (context,value1,_){

                                              return value1.code == 1 ? Container(width: 100, child: utils.PreloadRefarreal()) : Container(
                                                child: Text(value1.data!.information!.codeReferrals!,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 26,),
                                                  textScaleFactor: 1.0,
                                                ),
                                              );

                                            }
                                        ),

                                        SizedBox(
                                          width: 5,
                                        ),

                                        SvgPicture.asset(
                                          'assets/images/ic_share_white.svg',
                                          fit: BoxFit.fill,
                                        ),



                                      ],

                                    ),


                                  ],

                                ),
                              ),

                            ),
                          ),

                        ],

                      ),

                    ),

                  ],

                )
            ),
          ),
        ),

      ],

    );

  }


  /// Share
  Future<void> shareFile() async {
    await FlutterShare.share(
      //title: '¡Únete a Gane Moni donde los Datos y la Telefonía son gratis!',
      title: singleton.notifierReferralData.value.data!.information!.title!,
      text: singleton.notifierReferralData.value.data!.information!.description!,

      //filePath: docs[0] as String,
    );
  }


}


///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  @override

  Widget build(BuildContext context) {

    return AnimatedContainer(
      height: 340,
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
              height: 340,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(
                'assets/images/headerprofile.svg',
                fit: BoxFit.fill,
              ),

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

                        /// User image
                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
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
                    //height: 103,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        SizedBox(height: 20,),

                        /// firs text
                        Container(
                          child: SvgPicture.asset(
                            'assets/images/Text_referrals_blue.svg',
                            fit: BoxFit.cover,
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

}