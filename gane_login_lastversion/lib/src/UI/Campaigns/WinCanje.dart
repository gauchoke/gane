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

class WinsCanje extends StatefulWidget{

  WinsCanje();

  _stateWinsCanje createState()=> _stateWinsCanje();
}

class _stateWinsCanje extends State<WinsCanje> with  TickerProviderStateMixin, WidgetsBindingObserver{

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

    this.validateTimes();

    super.initState();
  }

  /// Validate times to show view win
  void validateTimes(){

      Future.delayed( Duration(milliseconds: 2000), () {
        next();
      });

  }


  /// next
  void next(){
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
          ), child: Image.asset("assets/images/genial_canjeaste.gif",
              gaplessPlayback: true, fit: BoxFit.contain,
            width: 270,
            height: 270,),
        ),


      ],

    );

  }


}
