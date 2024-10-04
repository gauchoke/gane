import 'dart:ui';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';

class WinsPoints extends StatefulWidget{

  final from;
  final image;
  final points;
  final aditionalPoints;
  final back;
  final callWeb;
  final VoidCallback onNextAd;

  WinsPoints({this.from, this.image, this.points, required this.onNextAd, this.back, this.callWeb, this.aditionalPoints});

  _stateWinsPoints createState()=> _stateWinsPoints();
}

class _stateWinsPoints extends State<WinsPoints> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  final notifierHeightAditionalPoints = ValueNotifier([0.0,0.0]);
  var aditional = "single";
  var launchAditional = "NO";

  @override
  void initState(){
    notifierHeightAditionalPoints.value = [0.0,0.0];

    if(singleton.itemSequence.pointsAdditional != "0" && widget.back == true) {
      aditional = "Aditional";
    }


    WidgetsBinding.instance!.addPostFrameCallback((_){


      if(widget.callWeb != ""){ /// Call to action

        utils.callOrWebView1(widget.callWeb,validateTimes);
      }


      if(widget.callWeb == ""){ ///  Not Call to action
        this.validateTimes();
      }


    });

    super.initState();
  }

  /// Validate times to show view win
  void validateTimes(){

    if(aditional=="single"){
      Future.delayed( Duration(milliseconds: 2000), () {
        next();
      });

    }else{

      Future.delayed( Duration(milliseconds: 3000), () {
        notifierHeightAditionalPoints.value = [MediaQuery.of(context).size.width,240];
        Future.delayed( Duration(milliseconds: 2000), () {
          next();
        });

      });
    }

  }


  /// next
  void next(){
    widget.onNextAd();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                onWillPop: backHandle.callToast,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  key: _scaffoldKey,
                  body: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle.dark,
                      child: _fields(context),

                    ),
                  ),
                ),

              )
          );

        }

    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Fields List
  Widget _fields(BuildContext context){

    return Stack(
      alignment: Alignment.center,

      children: [


        /// Coins animation up

        /*Image.asset(
          "assets/images/winback.gif",
          fit:BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),*/

        /// Black back Container
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: CustomColors.backBlackWin.withOpacity(0.58),
        ),

        /// animation
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.transparent,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          /*child: Image(
            image: AssetImage("assets/images/genial-ganaste-.gif"),
            fit:BoxFit.contain,
            width: 270,
            height: 270,
          ),*/
          child: Image.asset("assets/images/genial-ganaste-.gif",
              gaplessPlayback: true, fit: BoxFit.contain,
            width: 270,
            height: 270,),
        ),

        /// Points
        Container(
          //alignment: Alignment.center,
          margin: EdgeInsets.only(top: 140),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              BorderedText(
                strokeWidth: 10.0,
                strokeColor: CustomColors.orangeswitch,///orangeWinpoints
                child: Text(
                  singleton.formatter.format(double.parse(widget.points)),
                  textScaleFactor: 1.0,
                  style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 35.0,),
                  maxLines: 1,
                ),
              ),

              SizedBox(
                width: 5,
              ),

              ///Coin image
              Container(
                child: SvgPicture.asset(
                  'assets/images/ic_coinGane_border.svg',
                  fit: BoxFit.contain,
                  width: 35,
                  height: 35,
                ),
              ),


            ],

          ),
        ),

        /// Aditional points
        singleton.itemSequence.pointsAdditional != "0" && widget.back == true ?
        ValueListenableBuilder<List>(
            valueListenable: notifierHeightAditionalPoints,
            builder: (context,value1,_){

              return value1[0] == 0.0 ? Container() :Stack(
                alignment: Alignment.center,
                children: [

                  /*Image.asset(
                    "assets/images/winback.gif",
                    fit:BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),*/

                  /// Animations
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: CustomColors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image(
                      image: AssetImage("assets/images/pe.gif"),
                      fit:BoxFit.contain,
                      width: 270,
                      height: 270,
                    ),
                  ),

                  /// Aditional points
                  /*Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /// Animation aditional points
                      Container(
                        /*child: Lottie.asset (
                            'assets/images/puntosextra.json',
                            repeat: false,
                            fit:BoxFit.contain,
                          ),*/
                        /*child: Image(
                            image: AssetImage("assets/images/pe.gif"),
                            fit:BoxFit.contain,
                          ),*/
                        child: Image.asset(
                          "assets/images/pe.gif",
                          fit:BoxFit.contain,
                        ),


                      ),

                      /// points
                      Container(
                        child: BorderedText(
                          strokeWidth: 7.0,
                          strokeColor: CustomColors.redBorderTextHeader,
                          child: Text(
                            "+" + singleton.formatter.format(double.parse(singleton.itemSequence.pointsAdditional!)),
                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 51.0,),
                            maxLines: 1,
                          ),
                        ),
                      )


                    ],
                  ),*/

                  /// Points
                  Container(
                    //alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 140),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        BorderedText(
                          strokeWidth: 10.0,
                          strokeColor: CustomColors.orangeswitch,
                          child: Text(
                            singleton.formatter.format(double.parse(widget.aditionalPoints)),
                            textScaleFactor: 1.0,
                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 35.0,),
                            maxLines: 1,
                          ),
                        ),

                        SizedBox(
                          width: 5,
                        ),

                        ///Coin image
                        Container(
                          child: SvgPicture.asset(
                            'assets/images/ic_coinGane_border.svg',
                            fit: BoxFit.contain,
                            width: 35,
                            height: 35,
                          ),
                        ),


                      ],

                    ),
                  ),

                ],
              );

            }

        ) : Container(),


      ],

    );

  }


}
