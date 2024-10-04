import 'dart:convert';
import 'dart:io';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/planaltandetail.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Home/completeprof.dart';

import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/Onboarding/loginphone.dart';

import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/image_picker_handler.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_disableaccount.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:ui' as ui;

class PlansDetalsAltan extends StatefulWidget{

  final from;

  PlansDetalsAltan({this.from});

  _statePlansDetalsAltan createState()=> _statePlansDetalsAltan();
}

class _statePlansDetalsAltan extends State<PlansDetalsAltan> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;

  bool visibleTotalShopingCart = false;

  var imgCountry = "";
  var name = "";

  bool visibleUpdateApp = false;
  bool visibleOptionalUpdateApp = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  late HomeProvider provider;


  @override
  void initState(){

    singleton.notifierPlansDetailsAltan.value = PlansAltanDetails(code: 1,message: "No hay nada", status: false, );

    WidgetsBinding.instance!.addPostFrameCallback((_){

      servicemanager.fetchAltanPlansDetails(context);

      print(MediaQuery.of(context).devicePixelRatio);
      print(MediaQuery.of(context).size.height);


    });

    super.initState();
  }

  @override
  void dispose() {
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
                  backgroundColor: CustomColors.graydetail,
                  key: _scaffoldKey,
                  body: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child:


                    Stack(
                      children: [

                        _fields(context),
                        AppBar(),
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
      color: CustomColors.graydetail,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15,right: 15),
      margin: EdgeInsets.only(top: 90),
      child: ValueListenableBuilder<Getprofile>(
          valueListenable: singleton.notifierUserProfile,
          builder: (context,value2,_){

            return SingleChildScrollView(

              child: Container(

                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    SizedBox(height: 10,),

                    /// Name
                    Container(
                      //color: Colors.blue,
                      margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child: Text(Strings.plandetails1,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 18,),
                        textScaleFactor: 1.0,
                      ),
                    ),

                    SizedBox(height: 10,),

                    /// Data
                    Container(
                      child: ValueListenableBuilder<PlansAltanDetails>(
                          valueListenable: singleton.notifierPlansDetailsAltan,
                          builder: (context,value1,_){

                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                              scrollDirection: Axis.vertical,
                              itemCount: value1.code == 1 ? 5 : value1.code == 102 ? 1 : value1.data!.plans!.length,
                              itemBuilder: (BuildContext context, int index){

                                if(value1.code==1){ ///preloading
                                  return utils.PreloadingSubCategories();

                                }else if(value1.code==102){ ///No data
                                  return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");

                                }else{/// Item
                                  return Container(
                                    //margin: EdgeInsets.only(left: 10,right: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        //SizedBox(height: 20,),

                                        /// Name
                                        value1.data!.plans![index].name! == "" ? Container(height: 0,): Container(
                                          //color: Colors.blue,
                                          //margin: EdgeInsets.only(left: 20,right: 20),
                                          /*child: Text(value1.data!.plans![index].name!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.orangesnack, fontSize: 18,),
                                            textScaleFactor: 1.0,
                                          ),*/
                                          child:Html(
                                              //data:"<p>El origen de la controversia es la entrevista que <b>Luis Fernando Velasco</b>, ministro del Interior, concedió al periodista Yamid Amat, del noticiero CM&amp;, en la noche del martes. En el tramo final de la conversación, el jefe de esa cartera fue interrogado por su posición frente al tema del sometimiento a la justicia y respondió en alrededor de cinco minutos sobre lo que vendría para los grupos que están al margen de la ley.</p> y por el culo se le fue",
                                            data: value1.data!.plans![index].name!,
                                            style: {
                                              "b": Style(
                                                fontSize: FontSize(27.0),
                                                fontFamily: Strings.font_bold,
                                                color: HexColor(value1.data!.plans![index].color!),
                                              ),
                                              "p": Style(
                                                fontSize: FontSize(17.0),
                                                fontFamily: Strings.font_medium,
                                                color: CustomColors.black,
                                              ),
                                            },
                                          ),
                                        ),

                                        SizedBox(height: value1.data!.plans![index].name! == "" ? 15 : 0,),

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
                                                          child: AutoSizeText(value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index].smsConvert!,
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
                                                          child: AutoSizeText(value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index].minuteConvert!,
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
                                                            value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index].gbConvert!,
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
                                                            value1.code == 1 || value1.code == 102 ? "-" : value1.data!.plans![index].gbRedConvert!,
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
                                                new TextSpan(text: Strings.vigencia,style: TextStyle(fontFamily: Strings.font_semiboldFe, color: HexColor(value1.data!.plans![index].color!), fontSize: 10.0,
                                                )),
                                                new TextSpan(text: value1.data!.plans![index].expireDate! == "" ? "" : DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.plans![index].expireDate!).toLocal()).toUpperCase() ,style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blacktyc, fontSize: 10.0,
                                                )),

                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20,),

                                        Container(
                                          height: 1, color: CustomColors.graylineplans,
                                        )


                                      ],

                                    ),
                                  );
                                }


                              },

                            );

                          }

                      ),
                    )


                  ],

                ),

              ),

            );

          }

      ),

    );

  }

}

///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  @override

  Widget build(BuildContext context) {

    /* return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderGrid,
        builder: (context,value2,_){

          return AnimatedContainer(
            height: 90,
            duration: Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,

            child: Stack(

              children: [

                ///Background
                Container(
                  //margin: EdgeInsets.only(left: 30),
                  //color: CustomColors.orange,
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    /*child: SvgPicture.asset(
                    'assets/images/headernew.svg',
                    fit: BoxFit.fill,

                  ),*/
                    child: Image(
                      image: AssetImage("assets/images/headernew.png"),
                      fit: BoxFit.fill,
                    )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    /// Back
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
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
                    Expanded(
                      child: Container(
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
                    ),

                    ///Coins
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        padding: EdgeInsets.only(right: 10,left: 10,top: 20 ),
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

                              return Badge(
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
                )

              ],

            ),


          );

        }

    );*/

    return new Container(
      //color: CustomColors.white,
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: CustomColors.orangeOne,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/ic_backwhite.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30,right: 40),
              child: Container(
                child: AutoSizeText(
                  Strings.SEEDETAIL,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,

                  maxLines: 3,
                  style: TextStyle(fontSize: 19.0,fontFamily: Strings.font_bold, color: Colors.white,),
                  //maxLines: 1,
                ),
              ),

            ),
          ),

        ],
      ),
    );

  }


}
