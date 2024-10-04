import 'dart:ui';
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/UI/principalcontainer.dart';
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
import 'package:transition/transition.dart';

class WinsPointsweb extends StatefulWidget{

  final from;
  final image;
  final points;
  final aditionalPoints;
  final back;
  final callWeb;
  final VoidCallback onNextAd;

  WinsPointsweb({this.from, this.image, this.points, required this.onNextAd, this.back, this.callWeb, this.aditionalPoints});

  _stateWinsPointsweb createState()=> _stateWinsPointsweb();
}

class _stateWinsPointsweb extends State<WinsPointsweb> with  TickerProviderStateMixin, WidgetsBindingObserver{

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


    WidgetsBinding.instance!.addPostFrameCallback((_){

      if(widget.callWeb == ""){ ///  Not Call to action
        this.validateTimes();
      }

    });

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
    widget.onNextAd();
    //Navigator.pop(context);
    Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 2,)) );
    //int count = 0;
    //Navigator.of(context).popUntil((_) => count++ >= 3);
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

              ValueListenableBuilder<String>(
                  valueListenable: singleton.notifierPointsByGame,
                  builder: (context,value1,_){

                    return BorderedText(
                      strokeWidth: 10.0,
                      strokeColor: CustomColors.orangeswitch,///orangeWinpoints
                      child: Text(
                        singleton.formatter.format(double.parse(value1)),
                        textScaleFactor: 1.0,
                        style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 35.0,),
                        maxLines: 1,
                      ),
                    );

                  }

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


}
