import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/UI/Campaigns/Winpoints.dart';
import 'package:gane/src/UI/Campaigns/WinpointsWeb.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_gameout.dart';
import 'package:gane/src/Widgets/dialog_winorlostgame.dart';
//import 'package:interactive_webview_null_safety/interactive_webview.dart';
import 'package:location/location.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebGames extends StatefulWidget{
  final title;
  final url;
  final VoidCallback relaunch;

  WebGames({this.title, this.url, required this.relaunch});

  _WebGames createState()=> _WebGames();
}

class _WebGames extends State<WebGames> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  late WebViewController controller;
  //final _webView = new InteractiveWebView();
  var onlyone = 0;

  @override
  void initState(){


    WidgetsBinding.instance!.addPostFrameCallback((_){

      Future.delayed( Duration(seconds: 10), () {
        //showAlertWonPoints();
      });


    });


    super.initState();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      //singleton.isOffline = !hasConnection;
    });
  }

  @override
  void dispose() {
    //singleton.indexBeforeSelectedMarker=0;
    ////pr.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    singleton.contextGlobal = context;
    return singleton.isOffline?  Nointernet() : OKToast(
        child: Scaffold(
          /*key: _scaffoldKey,
              drawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: DrawerMenu()),*/
            body: Builder(

              builder: (BuildContext context1){
                singleton.contextGlobal = context1;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: CustomColors.white,
                  child: Stack(

                    children: <Widget>[

                      /*Container(
                          margin: EdgeInsets.only(top: 80.0),
                          child: Container(),
                        ),

                        _appBar(),*/

                      AppBar(),

                      _fields(context1),


                    ],
                  ),


                );

              },


            )

        ),
    );


  }

  /// Header
  Widget _appBar(){
    return new Container(
      //color: CustomColors.white,
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: CustomColors.white,
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
                  'assets/images/back.svg',
                  fit: BoxFit.contain,
                  color: CustomColors.black,
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30,right: 40),
              child: Container(
                child: AutoSizeText(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(fontSize: 19.0,fontFamily: Strings.font_bold, color: CustomColors.black,),
                  //maxLines: 1,
                ),
              ),

            ),
          ),

        ],
      ),
    );
  }

  /// Fields List
  Widget _fields(BuildContext context){

    return Container(
      //color: Colors.red,
      margin: EdgeInsets.only(top: 90),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(

        children: [


          /*WebView(
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController contro) async{
              controller = contro;
            },
            debuggingEnabled: true,
            initialUrl: Uri.encodeFull(widget.url),
            onPageStarted: (v){
              print("loading page");
              //utils.openProgress(context);
            },
            onPageFinished: (v) async{
              print("page finish");
              //Navigator.pop(context);
              controller.evaluateJavascript('sendBack()');
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'messageHandler',
                  onMessageReceived: (JavascriptMessage message) {
                    print(message.message);
                    Future.delayed(const Duration(milliseconds: 450), () {
                      if(onlyone==0){
                        onlyone = 1;
                        showAlertWonPoints();
                      }
                    });
                  })
            ]),
            navigationDelegate: (NavigationRequest request) async {
              print(request.url);

              //if(singleton.isIOS == true){

              if (request.url.startsWith('https://easygane.inkubo.co/success')) {
                //showAlertWonPoints1();
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
          ),*/



        ],

      )

    );
  }

  /// Resume game
  void resumeGame(){

  }

  /*/// Lister js Function
  JavascriptChannel _scriptGameOver(BuildContext context){

    return JavascriptChannel(
        name: "lost",
        onMessageReceived: (JavascriptMessage message){
          print(message.message);
          Future.delayed(const Duration(milliseconds: 450), () {
            if(onlyone==0){
              onlyone = 1;
              dialogWinOrLostGames(singleton.navigatorKey.currentContext!, Strings.lostgame, Strings.activate3, widget.relaunch);

            }
          });
        }
    );

  }

  /// Lister js Function
  JavascriptChannel _scriptWin(BuildContext context){

    return JavascriptChannel(
        name: "win",
        onMessageReceived: (JavascriptMessage message){
          print(message.message);
          Future.delayed(const Duration(milliseconds: 450), () {
            if(onlyone==0){
              onlyone = 1;
              /*dialogWinOrLostGames(singleton.navigatorKey.currentContext!, Strings.wingame, Strings.activate3, widget.relaunch);

              utils.callOrWebView(singleton.item.ads![0]!.url!);*/
              /*if(singleton.item.ads![0]!.url != ""){
                var url = singleton.item.ads![0]!.url;
                if(url!.contains("http")){
                  if(singleton.isIOS == false){
                    Navigator.push(context, Transition(child: TyC(url: url, title: "",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                  }else{
                    utils.launchWebView(url);
                  }
                }else{
                  if(singleton.isIOS == true){
                    Navigator.push(context, Transition(child: TyC(url: "", title: "",lauchPhone: url,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                  }else{
                    utils.launchCaller(url);
                  }
                }
              }*/
              showAlertWonPoints();
            }


          });
        }
    );

  }*/


  /// Show Alert won points
  void showAlertWonPoints(){

    Future.delayed(const Duration(milliseconds: 100), () {

      utils.VibrateAndMusic();
      showCupertinoModalPopup(context: context, builder:
          (context) => WinsPointsweb(points: "240", image: "", onNextAd: (){},back: true, callWeb: "", aditionalPoints: "",)
      );

    });


  }


}

class AppBar extends StatelessWidget{
  final singleton = Singleton();
  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
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
                    /*SpringButton(
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


                    ),*/


                  ],
                )

              ],

            ),


          );

        }

    );

  }

}

