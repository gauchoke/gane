import 'dart:io';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/altanplan.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/planchip.dart';
import 'package:gane/src/Models/profilecategories.dart';
import 'package:gane/src/Models/referrals.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Home/pidechipform.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
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

class PideSimCard extends StatefulWidget{

  final from;
  final VoidCallback? PointProfileCategorie;

  PideSimCard({this.from, this.PointProfileCategorie});

  _statePideSimCard createState()=> _statePideSimCard();
}

class _statePideSimCard extends State<PideSimCard> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ScrollController _scrollViewController = new ScrollController();


  late HomeProvider providerHome;
  final _controllerimei = TextEditingController();


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
        servicemanager.fetchPlanChip(context);

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
            child: Image(
              image: AssetImage("assets/images/headernew.png"),
              fit: BoxFit.fill,
            )
        ),

        /// Header
        Container(

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              ///Icon menu
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(top: 40,left: 10),
                  child: Container(
                    child: SvgPicture.asset(
                      'assets/images/back.svg',
                      fit: BoxFit.contain,
                      color: CustomColors.white,
                    ),
                  ),

                ),
              ),

              ///Logo
              Container(
                alignment: Alignment.topLeft,
                //color: Colors.blue,
                padding: EdgeInsets.only(top: 35,left: 10),
                child:InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );
                  },
                  child: SvgPicture.asset(
                    'assets/images/logohome.svg',
                    fit: BoxFit.contain,
                    width: 80,
                    height: 42,
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  height: 10,
                  //color: Colors.red,
                ),
              ),

              ///Coins
              SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  margin: EdgeInsets.only(right: 10, top: 40,),
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
                            child: SvgPicture.asset(
                              'assets/images/coins.svg',
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
                  Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 4,)) );
                  //Navigator.pop(context);
                },

                //onTapDown: (_) => decrementCounter(),

              ),

              ///Notifications
              SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  padding: EdgeInsets.only(right: 20, top: 40,),
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
                            /*child: Image(
                                      width: 40,
                                      height: 40,
                                      image: AssetImage("assets/images/notifications.png"),
                                      fit: BoxFit.contain,
                                    ),*/
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
                    time = 1200;
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


                          /// Data
                          Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              SizedBox(height: 20,),

                              /// TyC
                              Container(
                                //color: Colors.red,
                                margin: EdgeInsets.only(left: 20,right: 20),
                                child: Text(Strings.pidechip,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blueback, fontSize: 35,),
                                  textScaleFactor: 1.0,
                                ),
                              ),

                              /// TyC
                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                child: Text(Strings.consult,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 12,),
                                  textScaleFactor: 1.0,
                                ),
                              ),

                              SizedBox(height: 40,),

                              /// firs text image
                              Container(
                                padding: EdgeInsets.only(left: 20,right: 20),
                                child: SvgPicture.asset(
                                  'assets/images/Verifica.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),

                              SizedBox(height: 15,),

                              /// TextFIeld Imei
                              Padding(
                                padding: const EdgeInsets.only(left: 20,right: 20),
                                child: _fieldPhone(),
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              ///Emei Validate
                              Container(
                                padding: EdgeInsets.only(left: 30,right: 30),
                                alignment: Alignment.center,
                                child: ArgonButton(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  borderRadius: 40.0,
                                  color: CustomColors.blueimei,
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: CustomColors.blueimei,
                                      borderRadius: BorderRadius.all(const Radius.circular(10)),
                                      border: Border.all(
                                        width: 1,
                                        color: CustomColors.blueimei,
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
                                                Strings.validateimei,
                                                textAlign: TextAlign.center,
                                                //maxLines: 1,
                                                style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 16.0,),
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
                                        backgroundColor: CustomColors.white,
                                        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.white),
                                      ),
                                    ),
                                  ),
                                  onTap: (startLoading, stopLoading, btnState) {
                                    if(btnState == ButtonState.Idle){
                                      startLoading();
                                      launchFetchValidateImei(stopLoading);
                                    }
                                  },
                                ),
                              ),

                              SizedBox(height: 40,),

                              /// second text image
                              Container(
                                //padding: EdgeInsets.only(left: 20,right: 20),
                                child: SvgPicture.asset(
                                  'assets/images/pide.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),

                              SizedBox(height: 30,),


                              /// Plan Chip
                              Container(
                                //color: Colors.green,
                                  child: ValueListenableBuilder<ChipPlans>(
                                      valueListenable: singleton.notifierPlanChip,
                                      builder: (context,value,_){

                                        return value.code == 1 ? utils.PreloadBanner():
                                        InkWell(
                                          onTap: (){


                                            singleton.idPlan = value.data!.plan!.id!;
                                            singleton.plan = value.data!.plan!.name!;
                                            singleton.planvalue = value.data!.plan!.price!.toString();
                                            //singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );

                                            var time = 350;
                                            if(singleton.isIOS == false){
                                              time = utils.ValueDuration();
                                            }
                                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimForm(),
                                                reverseDuration: Duration(milliseconds: time)
                                            )).then((value) {
                                            });

                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.symmetric(vertical: 5,),
                                            //child:  SvgPicture.asset(value.data!.items![index]!.photoUrl!,),
                                            child: Stack(
                                              children: [

                                                /// Bakcground
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Image(
                                                    //width: 63,
                                                    //height: 40,
                                                    image: AssetImage("assets/images/vectores.png"),
                                                    fit: BoxFit.cover,
                                                  ),

                                                ),

                                                /// Plan, whatsapp
                                                Container(
                                                  child: Column(
                                                    children: [

                                                      /// Plan image
                                                      Image.network(
                                                          value.data!.plan!.photoUrl!,
                                                          fit: BoxFit.contain,
                                                          frameBuilder: (_, image, loadingBuilder, __) {
                                                            if (loadingBuilder == null) {
                                                              return const SizedBox(
                                                                child: Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: Color(0xFFFF4D00),
                                                                      //color: CustomColors.orangeback,
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
                                                                  //color: CustomColors.orangeback,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          errorBuilder: (_, __, ___) {

                                                            //setState(() {});
                                                            return Container(
                                                              child: Icon(Icons.error,color: CustomColors.orangeback,size: 40,),
                                                            );

                                                          }

                                                      ),

                                                      SizedBox(height: 30,),

                                                      /// Order by whatsapp
                                                      Container(
                                                        child: SpringButton(
                                                          SpringButtonType.OnlyScale,
                                                          Card(
                                                            margin: EdgeInsets.only( left: 30,right: 30),
                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            color: CustomColors.white,
                                                            elevation: 5,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: Container(
                                                              margin: EdgeInsets.all(10),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                  children: <Widget>[

                                                                    Container(
                                                                      padding: EdgeInsets.only(left: 10,right: 10),
                                                                      child: SvgPicture.asset(
                                                                        'assets/images/ic_whatsapp_responsive.svg',
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),

                                                                    /// languaje
                                                                    Expanded(
                                                                      child: Container(
                                                                        child: AutoSizeText(
                                                                          Strings.buywhats,
                                                                          textScaleFactor: 1.0,
                                                                          textAlign: TextAlign.left,
                                                                          //maxLines: 1,
                                                                          style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17.0,),
                                                                          //maxLines: 1,
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    SizedBox(height: 10,),

                                                                  ],

                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          useCache: false,
                                                          onTap: (){
                                                            //launchCallOrWhat("https://wa.me/"+singleton.notifierBannerAltan.value.data!.item!.callingCode!+singleton.notifierBannerAltan.value.data!.item!.whatsapp!);
                                                            utils.callOrWebView("https://api.whatsapp.com/send?phone=5215585263805&text=Solicitar%20Chip%20GANE");//"https://wa.me/5215585263805&text=Solicitar%20Chip%20GANE");
                                                          },

                                                        ),
                                                      ),

                                                      SizedBox(height: 50,),


                                                    ],
                                                  ),
                                                ),



                                              ],
                                            ),

                                          ),
                                        );
                                      }
                                  )
                              ),




                              /// Reference info
                              /*Container(
                                color: CustomColors.lightGrayNumbers,
                                child: Column(
                                  children: [

                                    SizedBox(height: 20,),

                                    Container(
                                      padding: EdgeInsets.only(left: 30,right: 30),
                                      child: RichText(
                                        textScaleFactor: 1.0,
                                        text: new TextSpan(
                                          // Note: Styles for TextSpans must be explicitly defined.
                                          // Child text spans will inherit styles from parent
                                          style: new TextStyle(
                                            fontSize: 12.0,
                                            //color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            new TextSpan(text: Strings.imeitext,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 12.0,
                                            )),
                                            new TextSpan(text: Strings.imeitext3,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.orangeback, fontSize: 12.0,
                                            ),recognizer: new TapGestureRecognizer()..onTap = () {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              Navigator.push(context, Transition(child: TyC(url: "https://www.gane.com", title: Strings.imeitext3,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                                            }),
                                            new TextSpan(text: Strings.imeitext1,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 12.0,
                                            )),
                                            new TextSpan(text: Strings.imeitext4,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.orangeback, fontSize: 12.0,
                                            ),recognizer: new TapGestureRecognizer()..onTap = () {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              Navigator.push(context, Transition(child: TyC(url: "https://www.gane.com", title: Strings.imeitext3,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                                            }),
                                            new TextSpan(text: Strings.imeitext2,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 12.0,
                                            )),
                                            new TextSpan(text: Strings.imeitext4,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.orangeback, fontSize: 12.0,
                                            ),recognizer: new TapGestureRecognizer()..onTap = () {
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              Navigator.push(context, Transition(child: TyC(url: "https://www.gane.com", title: Strings.imeitext3,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                                            }
                                            ),

                                          ],
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              ),

                              SizedBox(height: 30,),


                              /// Trade mark
                              Container(
                                padding: EdgeInsets.only(left: 30,right: 30),
                                child: RichText(
                                  textScaleFactor: 1.0,
                                  text: new TextSpan(
                                    // Note: Styles for TextSpans must be explicitly defined.
                                    // Child text spans will inherit styles from parent
                                    style: new TextStyle(
                                      fontSize: 12.0,
                                      //color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      new TextSpan(text: Strings.imeitext5,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 12.0,
                                      )),
                                      new TextSpan(text: Strings.imeitext6,style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.orangeback, fontSize: 12.0,
                                      ),recognizer: new TapGestureRecognizer()..onTap = () {
                                        FocusScope.of(context).requestFocus(new FocusNode());
                                        Navigator.push(context, Transition(child: TyC(url: "https://www.gane.com", title: Strings.imeitext3,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                                      }),


                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 20,),

                              Container(
                                child: SvgPicture.asset(
                                  'assets/images/coins.svg',
                                  fit: BoxFit.contain,
                                  width: 40,
                                  height: 40,
                                ),
                              ),

                              SizedBox(height: 30,),*/

                            ],


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

  ///Create telf field
  Widget _fieldPhone() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              controller: _controllerimei,
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: Strings.font_semiboldFe,
                                  fontSize: 19,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.addemei,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regularFe,
                                      fontSize: 13,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

                              },

                              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            )
                        ),


                      ],
                    )
                )
            ),


          ],
        ),
      ),

    );
  }

  /// Validate Imei
  void launchFetchValidateImei(Function stopLoading)async{
    FocusScope.of(context).requestFocus(new FocusNode());
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        if (_controllerimei.text.trim().isEmpty) {
          Future.delayed(const Duration(milliseconds: 500), () {
            stopLoading();
          });
          utils.openSnackBarInfo(context, Strings.errorimei, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        }else{
          servicemanager.fetchCheckImei(context,_controllerimei.text.trim(),stopLoading);
        }



      }

    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

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
                            child: SvgPicture.asset(
                              'assets/images/logohome.svg',
                              fit: BoxFit.contain,
                              width: 80,
                              height: 42,
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
                            //Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
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