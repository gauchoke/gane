
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
//import 'package:custom_ping/custom_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/countries.dart';
import 'package:gane/src/Models/gamelist.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Onboarding/loginphone.dart';
import 'package:gane/src/UI/Onboarding/onboarding_provider.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
import 'package:gane/src/UI/Onboarding/tyc1.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/lang/applanguage.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:crypto/crypto.dart';
//import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'dart:convert';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:gane/src/Widgets/dialog_blur.dart';
import 'package:gane/src/Widgets/dialog_validatetelf.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/Utils/toast_widget.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as hand;
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loading.dart';


import 'package:another_flushbar/flushbar.dart';

import 'package:permission_handler/permission_handler.dart' as permi;
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as cript;
//import 'package:simnumber/sim_number.dart';
//import 'package:simnumber/siminfo.dart';


Singleton singleton = Singleton();
final prefs = SharePreference();
servicesManager servicemanager = servicesManager();



AudioPlayer instance = new AudioPlayer();
//AudioCache musicCache = new AudioCache(fixedPlayer: instance);
AudioCache musicCache = new AudioCache();

class _Utils {

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  callToastGeneric(String message) {
    showToastWidget(
        ToastWidget(
          description: message,
        ),
        duration: Duration(seconds: 3));
  }

  messageSnackBar(BuildContext context, String message){

    /*Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message,
          textScaleFactor: 1.0,
          style: TextStyle(
            //fontFamily: utils.ReadLanguage("font_regular"),
            //fontFamily: utils.ReadLanguage("key"),
              fontSize: 14,
              color: CustomColors.white)),
      duration: Duration(seconds: 1),
    ));*/
  }

  String encryptSha1(String value){
    var bytes = utf8.encode(value);
    var digest = sha1.convert(bytes);
    return digest.toString();
  }

  /*Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }


  dynamic checkInternet(Function func, BuildContext context) {
    check().then((internet) {
      if (internet != null && internet) {
        func(true, context);
      }
      else{
        func(false, context);
      }
    });
  }*/

  /// Check internet
  void check() async{

    try {
      /*final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        singleton.notifierIsOffline.value = false;
      }else{
        singleton.notifierIsOffline.value = true;
      }*/


      /*PingService().getSubscription(callBack: (e) {
          print('Ping has connection ${e.hasConnection}, with ${e.getNetworkTye}');

          if(e.hasConnection){
            singleton.notifierIsOffline.value = false; /// OK internet
          }else{
            singleton.notifierIsOffline.value = true; /// No internet
          }

      });*/

      pingServer("https://www.google.com/").then((value) {
        if(value==true){
          singleton.notifierIsOffline.value = false; /// OK internet
        }else{
          singleton.notifierIsOffline.value = true; /// No internet
        }
      });




    } on SocketException catch (_) {
      print('not connected');
      singleton.notifierIsOffline.value = true;
    }

  }//23e2c74ea60e48618003c2aee02a501dd0d7e5745a39b4b5b88dd2286285949d

  Future<bool> pingServer(String urlTarget) async {
    try {
      Uri url = Uri.parse(urlTarget);

      Response response = await http.get(url).timeout(Duration(seconds: 8)).catchError((value){
      });

      return response.statusCode == 200;
    } on Exception catch (_) {
      return false;
    }
  }



  String getCardType(String input) {
    if (input.startsWith(new RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      return 'Master';
    } else if (input.startsWith(new RegExp(r'[4]'))) {
      return 'Visa';
    } else if (input
        .startsWith(new RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
      return 'Verve';
    } else if (input.startsWith(new RegExp(r'((34)|(37))'))) {
      return 'AmericanExpress';
    } else if (input.startsWith(new RegExp(r'((6[45])|(6011))'))) {
      return 'Discover';
    } else if (input
        .startsWith(new RegExp(r'((30[0-5])|(3[89])|(36)|(3095))'))) {
      return 'DinersClub';
    } else if (input.startsWith(new RegExp(r'(352[89]|35[3-8][0-9])'))) {
      return 'Jcb';
    } else if (input.length <= 8) {
      return 'Others';
    } else {
      return 'Others';
    }
  }

  AssetImage getCardIcon(String input) {
    if(input.toLowerCase().contains("master")){
      return AssetImage("assets/images/ic_master.png");
    } if(input.toLowerCase().contains("visa")){
      return AssetImage("assets/images/ic_visa.png");
    } if(input.toLowerCase().contains("american")){
      return AssetImage("assets/images/ic_express.png");
    } else {
      return AssetImage("assets/images/ic_card2.png");
    }
  }


  openProgress(BuildContext context){
    Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => LoadingProgress()));
  }



  String textWithEmoji(String commentIn){

    var comment = "";
    var input = commentIn.replaceAll("[", "");
    input = input.replaceAll("]", "");
    input = input.replaceAll(", ", ",");
    final _delimiter = ',';
    final _values = input.split(_delimiter);
    //var ite = _values.map(int.parse).toList();
    var ite = _values.map(int.parse).toList();

    comment = "";
    for (int i = 0; i < ite.length; i++) {
      var character=new String.fromCharCode(ite[i]);
      print(character);

      comment = comment + character;
    }
    return comment;

  }

  String changeAccents(String commentIN){

    var text = commentIN;
    text = text.replaceAll("á", "a");
    text = text.replaceAll("é", "e");
    text = text.replaceAll("í", "i");
    text = text.replaceAll("ó", "o");
    text = text.replaceAll("ú", "u");
    text = text.replaceAll("Á", "A");
    text = text.replaceAll("É", "E");
    text = text.replaceAll("Í", "I");
    text = text.replaceAll("Ó", "O");
    text = text.replaceAll("Ú", "U");

    return text;

  }

  Widget empty(String title, String message,String image,){

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 30),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ///Image
            Container(
              child: Image(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),

            ///title
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Text(title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_bold,
                      fontSize: 25,
                      color: CustomColors.grayalert),
                  textAlign: TextAlign.center),
            ),

            ///message
            Container(
              margin: EdgeInsets.only(top: 10,left: 30,right: 30),
              child: Text(message,
                  style: TextStyle(
                      fontFamily: Strings.font_medium,
                      fontSize: 15,
                      color: CustomColors.grayalert),
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center),
            ),


          ],

        ),
      ),
    );

  }

  Widget empty1(String title, String message,String image,){

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 30),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ///Image
            Container(
              child: Image(
                width: 250,height: 250,
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),

            ///title
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Text(title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_bold,
                      fontSize: 25,
                      color: CustomColors.grayalert),
                  textAlign: TextAlign.center),
            ),

            ///message
            Container(
              margin: EdgeInsets.only(top: 10,left: 30,right: 30),
              child: Text(message,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_medium,
                      fontSize: 15,
                      color: CustomColors.grayalert),
                  textAlign: TextAlign.center),
            ),


          ],

        ),
      ),
    );

  }

  /// Empy message Home
  Widget emptyHome(String title, String message,String image,){

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 30,top: 30),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ///Image
            Container(
                /*child: Image(
                  width: 200,height: 200,
                  image: AssetImage(image),
                  fit: BoxFit.contain,
                )*/
              child: SvgPicture.asset(
                image,
                fit: BoxFit.contain,
                width: 122,height: 115,
              ),
            ),

            ///title
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,top: 20),
              child: Text(title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_semibold,
                      fontSize: 18,
                      color: CustomColors.black),
                  textAlign: TextAlign.center),
            ),


            /*SizedBox(height: 40,),

            Center(
              child: InkWell(
                onTap: (){
                  utils.check();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 3),
                  height: 30,
                  //color: Colors.blue,
                  child: Text(Strings.tryagain, textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomColors.orangeswitch,
                      fontSize: 17.0,fontFamily: Strings.font_semibold,

                    ),
                  ),
                ),
              ),
            ),*/


          ],

        ),
      ),
    );

  }

  /// Empy message Home Notifications
  Widget emptyHomeNotifications(String title, String message,String image,){

    return Container(
      //color: Colors.yellow,
        child: Stack(

          children: [

            ///Image
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: MediaQuery.of(singleton.navigatorKey.currentContext!).size.width,height: MediaQuery.of(singleton.navigatorKey.currentContext!).size.height,
                  child: Container(
                    width: MediaQuery.of(singleton.navigatorKey.currentContext!).size.width,height: MediaQuery.of(singleton.navigatorKey.currentContext!).size.height,
                    child: SvgPicture.asset(
                      "assets/images/gris.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),

            ///Image
            Positioned(
              bottom: 0,
              child: Container(
                    width: MediaQuery.of(singleton.navigatorKey.currentContext!).size.width,
                child: Image(
                width: MediaQuery.of(singleton.navigatorKey.currentContext!).size.width,
                  image: AssetImage("assets/images/azul.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Positioned.fill(
              child: Align(
                  alignment: Alignment.topCenter,
                  child:  Container(
                    margin: EdgeInsets.only(left: 20,right: 20,top: MediaQuery.of(singleton.navigatorKey.currentContext!).size.height/4),
                    child: Text(title,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            fontFamily: Strings.font_boldFe,
                            fontSize: 28,
                            color: CustomColors.blueback),
                        textAlign: TextAlign.center),
                  ),
              ),
            ),

          ],

        ),
      );

  }

  Widget emptyHomeNew(String title, String message,String image,){

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 30,top: 30),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            ///title
            Container(
              margin: EdgeInsets.only(left: 30,right: 30,top: 20),
              child: Text(title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_boldFe,
                      fontSize: 30,
                      color: CustomColors.blueBack),
                  textAlign: TextAlign.center),
            ),

            SizedBox(height: 40,),

            /// Games
            InkWell(
              onTap: (){
                Navigator.pushReplacement(singleton.navigatorKey.currentContext!, Transition(child: PrincipalContainer(selectedIndex: 2,)) );
              },
              child: RichText(
                textScaleFactor: 1.0,
                text: new TextSpan(
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: Strings.emptyhome2,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.blueBack, fontSize: 20.0,
                    )),
                    new TextSpan(text: Strings.emptyhome4,style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.orangeback, fontSize: 20.0,
                      decoration: TextDecoration.underline,
                      decorationColor: CustomColors.orangeback,

                    )),

                  ],
                ),
              ),
            ),

            SizedBox(height: 5,),

            InkWell(
              onTap: (){
                Navigator.pushReplacement(singleton.navigatorKey.currentContext!, Transition(child: PrincipalContainer(selectedIndex: 1,)) );//3
              },
              child: RichText(
                textScaleFactor: 1.0,
                text: new TextSpan(
                  style: new TextStyle(
                    fontSize: 20.0,
                  ),
                  children: <TextSpan>[

                    new TextSpan(text: Strings.emptyhome3,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.blueBack, fontSize: 20.0,
                    )),
                    new TextSpan(text: Strings.emptyhome5,style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.orangeback, fontSize: 20.0,
                      decoration: TextDecoration.underline,
                      decorationColor: CustomColors.orangeback,
                    )),

                  ],
                ),
              ),
            ),


          ],

        ),
      ),
    );

  }

  /// Empy message Home
  Widget emptyWallete(String title, String message,String image,){

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 30,top: 30),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ///Image
            Container(
              /*child: Image(
                  width: 200,height: 200,
                  image: AssetImage(image),
                  fit: BoxFit.contain,
                )*/
              child: SvgPicture.asset(
                image,
                fit: BoxFit.contain,
                width: 122,height: 115,
              ),
            ),

            ///title
            Container(
              margin: EdgeInsets.only(left: 30,right: 30,top: 20),
              child: Text(title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_semibold,
                      fontSize: 19,
                      color: CustomColors.black),
                  textAlign: TextAlign.center),
            ),

            ///description
            Container(
              margin: EdgeInsets.only(left: 30,right: 30,top: 10),
              child: Text(message,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_regular,
                      fontSize: 15,
                      color: CustomColors.greyplaceholder),
                  textAlign: TextAlign.center),
            ),


          ],

        ),
      ),
    );

  }

  /// empty Categories
  Widget emptyCategories(String image,){

    return Container(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        image,
        fit: BoxFit.contain,
        //color: CustomColors.greyplaceholder
      ),
    );

  }

  /// Complete category
  Widget completeCategories(){

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 20,top: 20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            //SizedBox(height: 40,),

            ///Image
            Container(
              child: SvgPicture.asset(
                //'assets/images/ic_check_validated.svg',
                'assets/images/cele.svg',
                fit: BoxFit.contain,
                //width: 90,
                //height: 90,
              ),
            ),

            /*SizedBox(height: 10,),

            ///title
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Text(Strings.complete,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_bold,
                      fontSize: 22,
                      color: CustomColors.blueText),
                  textAlign: TextAlign.center),
            ),*/

          ],

        ),
      ),
    );

  }

  /// Complete category
  Widget commingSoon(){

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 20,top: 20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ///Image
            Container(
              child: SvgPicture.asset(
                'assets/images/emptyhome.svg',
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 10,),

            ///title
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Text(Strings.commingsoon,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_bold,
                      fontSize: 30,
                      color: CustomColors.blacktextmax),
                  textAlign: TextAlign.center),
            ),

            ///subtitle
            Container(
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Text(Strings.commingsoon1,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      fontFamily: Strings.font_medium,
                      fontSize: 14,
                      color: CustomColors.graycomming),
                  textAlign: TextAlign.center),
            ),

          ],

        ),
      ),
    );

  }


  ///View Error
  Widget error(){

    return ValueListenableBuilder<List>(
        valueListenable: singleton.notifierError,
        builder: (context,value,_,){

          return Visibility(
            visible: value[0],
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(value[1],
                textScaleFactor: 1.0,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: Strings.font_bold, color: value[2]=="RED" ? CustomColors.reddelete : CustomColors.orangeback, fontSize: 13,),
              ),
            ),
          );

        }

    );

  }
  void seeerror(String message, String color){
    singleton.notifierError.value = [true,message,color];

    Future.delayed(const Duration(seconds: 2), () {
      singleton.notifierError.value = [false, "","RED"];
    });

  }


  String formatDuration(Duration d) {

    String f(int n) {
      return n.toString().padLeft(2, '0');
    }
    // We want to round up the remaining time to the nearest second
    d += Duration(microseconds: 999999);
    return "${f(d.inMinutes)}:${f(d.inSeconds%60)}";

  }

  ///Loading View
  dialogLoading(BuildContext context) async {
    return /*showAnimatedDialog(
      barrierDismissible: false,
      context: context,
      animationType: DialogTransitionType.slideFromTop,
      curve: Curves.easeOutQuad,
      duration: Duration(milliseconds: 600),
      builder: (BuildContext context) {
        return Builder(
            builder: (context) => WillPopScope(
                onWillPop: backHandle.backNoInternet,
                child:Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      margin: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 0, left: 0),
                              padding: EdgeInsets.all(0),
                              width: double.infinity,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 120,
                                      child:  Container(
                                        width: 120,
                                        height: 120,
                                        //alignment: Alignment.center,
                                        child: Lottie.asset('assets/images/loading.json'),

                                      ),
                                    ),

                                    /*Container(
                                      margin: EdgeInsets.only(top: 15,left: 30,right: 30),
                                      child: AutoSizeText(
                                        singleton.messageLoading,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 14.0,fontFamily: utils.ReadLanguage("font_regular"), color: CustomColors.textcolor,),
                                        //maxLines: 1,
                                      ),
                                    ),*/

                                  ])),
                        ],
                      ),
                    ))
            )
        );
      },
    );*/

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Builder(
            builder: (context) => WillPopScope(
                onWillPop: backHandle.backNoInternet,
                child:Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      margin: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 0, left: 0),
                              padding: EdgeInsets.all(0),
                              width: double.infinity,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 120,
                                      child:  Container(
                                        width: 120,
                                        height: 120,
                                        //alignment: Alignment.center,
                                        child: Lottie.asset('assets/images/loading.json'),

                                      ),
                                    ),

                                    /*Container(
                                      margin: EdgeInsets.only(top: 15,left: 30,right: 30),
                                      child: AutoSizeText(
                                        singleton.messageLoading,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 14.0,fontFamily: utils.ReadLanguage("font_regular"), color: CustomColors.textcolor,),
                                        //maxLines: 1,
                                      ),
                                    ),*/

                                  ])),
                        ],
                      ),
                    ))
            )
        )
    );
  }


  /// Widget preloading categories
  Widget PreloadindCategories(){

    return Container(
      child: Shimmer(
        duration: Duration(milliseconds: 1400), //Default value
        interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
        color: CustomColors.white, //Default value
        enabled: true, //Default value
        direction: ShimmerDirection.fromLTRB(),  //Default Value
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: CustomColors.graysearch,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 100, height: 100,
          ),
        ),
      ),
    );

  }

  /// Widget preloading subcategories
  Widget PreloadingSubCategories(){

    return Container(
      //margin: EdgeInsets.only(left: index == 0 ? 20 : 0),
      child: Shimmer(
        duration: Duration(milliseconds: 1400), //Default value
        interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
        color: CustomColors.white, //Default value
        enabled: true, //Default value
        direction: ShimmerDirection.fromLTRB(),  //Default Value
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: CustomColors.graysearch,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Container(
            width: 100, height: 40,
          ),
        ),
      ),
    );

  }

  /// Widget preloading questions
  Widget PreloadingQuestions(){

    return Container(
        margin: EdgeInsets.only(left: 20,right: 20,bottom: 5),
        child: Row(
          children: [

            Shimmer(
              duration: Duration(milliseconds: 1400), //Default value
              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
              color: CustomColors.white, //Default value
              enabled: true, //Default value
              direction: ShimmerDirection.fromLTRB(),  //Default Value
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: CustomColors.graysearch,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Container(
                  width: 40, height: 40,
                ),
              ),
            ),

            SizedBox(width: 5,),

            Expanded(
              child: Shimmer(
                duration: Duration(seconds: 2), //Default value
                interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                color: CustomColors.white, //Default value
                enabled: true, //Default value
                direction: ShimmerDirection.fromLTRB(),  //Default Value
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: CustomColors.graysearch,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent, width: 1),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Container(
                    width: double.infinity, height: 40,
                  ),
                ),
              ),
            ),

          ],

        )
    );

  }

  ///widget preloading products with Card
  Widget PreloadingCard(){

    return Container(
      color: CustomColors.white,
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            ///Flag
            Container(
              height: 50,
              width: 50,
              margin: EdgeInsets.only(left: 25,),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Shimmer(
                  duration: Duration(seconds: 2), //Default value
                  interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                  color: CustomColors.white, //Default value
                  enabled: true, //Default value
                  direction: ShimmerDirection.fromLTRB(),  //Default Value
                  child: Container(
                    color: CustomColors.graysearch,
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
            ),

            ///Title
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 25,left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[

                      Container(
                        child: Shimmer(
                          duration: Duration(seconds: 2), //Default value
                          interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                          color: CustomColors.white, //Default value
                          enabled: true, //Default value
                          direction: ShimmerDirection.fromLTRB(),  //Default Value
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: CustomColors.graysearch,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.transparent, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Container(
                              height: 40,
                            ),
                          ),
                        ),
                      ),

                      Container(
                        child: Shimmer(
                          duration: Duration(seconds: 2), //Default value
                          interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                          color: CustomColors.white, //Default value
                          enabled: true, //Default value
                          direction: ShimmerDirection.fromLTRB(),  //Default Value
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: CustomColors.graysearch,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.transparent, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Container(
                              height: 20,
                            ),
                          ),
                        ),
                      ),

                    ],

                  )
              ),
            ),


          ],

        ),
      ),

    );

  }

  ///widget preloading products plane
  Widget PreloadingPlane() {
    return Container(
      //color:Colors.red,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          ///Beach
          Container(
            //color:Colors.yellow,
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                ///Flag
                Container(
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.only(left: 40,),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Shimmer(
                      duration: Duration(seconds: 2), //Default value
                      interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                      color: CustomColors.white, //Default value
                      enabled: true, //Default value
                      direction: ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        color: CustomColors.graysearch,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                ),

                ///Title
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(right: 20,left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  height: 40,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  height: 20,
                                ),
                              ),
                            ),
                          ),

                        ],

                      )
                  ),
                ),



              ],

            ),
          ),

          ///Line
          Container(
            margin: EdgeInsets.only(top: 20,left: 40,right: 30),
            height: 1,
            color: CustomColors.grayunselected,
          )

        ],

      ),

    );
  }

  ///widget preloading products plane
  Widget PreloadingPlane1() {
    return Container(
      //color:Colors.red,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          ///Beach
          Container(
            //color:Colors.yellow,
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                ///Title
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(right: 20,left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  height: 30,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  height: 20,
                                ),
                              ),
                            ),
                          ),

                        ],

                      )
                  ),
                ),



              ],

            ),
          ),

          ///Line
          Container(
            margin: EdgeInsets.only(top: 20,left: 40,right: 30),
            height: 1,
            color: CustomColors.grayunselected,
          )

        ],

      ),

    );
  }

  ///widget preloading chat
  Widget PreloadingChat(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      //color:Colors.red,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          ///Beach
          Container(
            //color:Colors.yellow,
            margin: EdgeInsets.only(top: 20),
            child: index%2==0 ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                ///Flag
                Container(
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(left: 40,),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Shimmer(
                      duration: Duration(seconds: 2), //Default value
                      interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                      color: CustomColors.white, //Default value
                      enabled: true, //Default value
                      direction: ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        color: CustomColors.graysearch,
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                ),

                ///Title
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(right: 10,left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  //width: 150,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 10,
                                ),
                              ),
                            ),
                          ),

                        ],

                      )
                  ),
                ),

              ],

            ): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                ///Title
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(right: 10,left: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: <Widget>[

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  //width: 150,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 10,
                                ),
                              ),
                            ),
                          ),

                        ],

                      )
                  ),
                ),

                ///Flag
                Container(
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(right: 20,),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Shimmer(
                      duration: Duration(seconds: 2), //Default value
                      interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                      color: CustomColors.white, //Default value
                      enabled: true, //Default value
                      direction: ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        color: CustomColors.graysearch,
                        height: 60,
                        width: 60,
                      ),
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

  /// Widget preloadin Banners
  Widget PreloadBanner(){

    return Container(
      //margin: EdgeInsets.only(bottom: 10),
      child:  Shimmer(
        duration: Duration(milliseconds: 1400), //Default value
        interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
        color: CustomColors.white, //Default value
        enabled: true, //Default value
        direction: ShimmerDirection.fromLTRB(),  //Default Value
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: CustomColors.graysearch,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            height: 130,
          ),
        ),
      ),
    );

  }

  ///widget preloading products plane
  Widget PreloadingNotification() {
    return Container(
      //color:Colors.red,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          ///Beach
          Container(
            //color:Colors.yellow,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[

                ///Title
                Expanded(
                  child: Container(
                    //margin: EdgeInsets.only(right: 20,left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  height: 40,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            child: Shimmer(
                              duration: Duration(seconds: 2), //Default value
                              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                              color: CustomColors.white, //Default value
                              enabled: true, //Default value
                              direction: ShimmerDirection.fromLTRB(),  //Default Value
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.graysearch,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  height: 15,
                                ),
                              ),
                            ),
                          ),

                        ],

                      )
                  ),
                ),

                SizedBox(width: 10,),

                ///Flag
                Container(
                  height: 70,
                  width: 70,
                  //margin: EdgeInsets.only(left: 40,),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Shimmer(
                      duration: Duration(seconds: 2), //Default value
                      interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
                      color: CustomColors.white, //Default value
                      enabled: true, //Default value
                      direction: ShimmerDirection.fromLTRB(),  //Default Value
                      child: Container(
                        color: CustomColors.graysearch,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ),




              ],

            ),
          ),

          SizedBox(height: 15,),

          Container(
            child: Shimmer(
              duration: Duration(seconds: 2), //Default value
              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
              color: CustomColors.white, //Default value
              enabled: true, //Default value
              direction: ShimmerDirection.fromLTRB(),  //Default Value
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: CustomColors.graysearch,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Container(
                  height: 15,
                ),
              ),
            ),
          ),

          Container(
            child: Shimmer(
              duration: Duration(seconds: 2), //Default value
              interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
              color: CustomColors.white, //Default value
              enabled: true, //Default value
              direction: ShimmerDirection.fromLTRB(),  //Default Value
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: CustomColors.graysearch,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Container(
                  height: 120,
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),

        ],

      ),

    );
  }

  /// Widget preloadin referral
  Widget PreloadRefarreal(){

    return Container(
      //margin: EdgeInsets.only(bottom: 10),
      child:  Shimmer(
        duration: Duration(milliseconds: 1400), //Default value
        interval: Duration(seconds: 0), //Default value: Duration(seconds: 0)
        color: CustomColors.white, //Default value
        enabled: true, //Default value
        direction: ShimmerDirection.fromLTRB(),  //Default Value
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: CustomColors.graysearch,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 30,
              ),

              ///Line
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 1,
                color: CustomColors.grayunselected,
              )

            ],

          )
        ),
      ),
    );

  }


  int randomNumber(){
    Random random = new Random();
    //int randomNum = random.nextInt(9999);
    int randomNum = Random().nextInt(99 - 10 + 1) + 10;
    return randomNum;
  }

  ///CallPhone
  launchCaller(String phoneNumber) async {
    //phoneNumber = phoneNumber.replaceAll("+", "");
    var url = "tel:"+phoneNumber;
    if (await canLaunch(url)) {
      await launch(url,forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
    //await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  ///WebViewCarrierInfo
  launchWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(url,forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }

    //await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }


  ///Initial User Position
  Future<void>initUserLocation(BuildContext context) async {

    singleton.serviceEnabled = await singleton.location.serviceEnabled();
    if (!singleton.serviceEnabled) {
      singleton.serviceEnabled = await singleton.location.requestService();
      if (!singleton.serviceEnabled) {
        print("valor de singleton.serviceEnabled :"+singleton.serviceEnabled.toString());
        //dialogNotifications(context, Strings.wait, Strings.activate4, Strings.activate2, Strings.activate1, "gps");
        //dialogBlur(context, Strings.wait, Strings.activate4, Strings.activate2, Strings.activate1, "gps");
        return;
      }
    }

    singleton.permissionGranted = await singleton.location.hasPermission();
    if (singleton.permissionGranted == PermissionStatus.denied) {
      singleton.permissionGranted = await singleton.location.requestPermission();
      if (singleton.permissionGranted != PermissionStatus.granted) {
        //dialogNotifications(context, Strings.wait, Strings.activate4, Strings.activate2, Strings.activate1, "gps");
        dialogBlur(context, Strings.wait, Strings.activate4, Strings.activate2, Strings.activate1, "gps");
        print("Mostrar alert");
        return;
      }

    }

    singleton.locationData = await singleton.location.getLocation();

    singleton.location.onLocationChanged.listen((LocationData currentLocation) {
      singleton.lat = currentLocation.latitude!;
      singleton.lon = currentLocation.longitude!;

      /*if(singleton.notifierChangeCity.value == 0){
        ///Bogotá
        singleton.lat =  4.643481841225928;
        singleton.lon = -74.10044462098264;
        singleton.notifierCity.value = "Bogotá";

      }else if(singleton.notifierChangeCity.value == 1){
        ///Medellín
        singleton.lat =  6.23284619560671;
        singleton.lon = -75.58090956800666;
        singleton.notifierCity.value = "Medellín";

      }else if(singleton.notifierChangeCity.value == 2){
        ///Cali
        singleton.lat =  3.3778394989650224;
        singleton.lon = -76.52760794847728;
        singleton.notifierCity.value = "Cali";

      }else if(singleton.notifierChangeCity.value == 3){
        ///Cartagena
        singleton.lat =  10.390189790882019;
        singleton.lon = -75.48666948425739;
        singleton.notifierCity.value = "Cartagena";

      }else if(singleton.notifierChangeCity.value == 4){
        ///Barranquilla
        singleton.lat =  10.981282186660899;
        singleton.lon =  -74.79393687882123;
        singleton.notifierCity.value = "Barranquilla";

      }*/

    });

    /*location.onLocationChanged.listen((LocationData event) {


    });*/


  }


  ///View Error Textfields
  Widget viewErrorTextField(String title, String description, BuildContext context){

    /*return MotionToast.error(
      title:  title,
      titleStyle:  TextStyle(
        color: CustomColors.black,
        fontSize: 14.0,fontFamily: Strings.font_semibold,
      ),
      description:  description,
      descriptionStyle:  TextStyle(
        color: CustomColors.greyplaceholder,
        fontSize: 14.0,fontFamily: Strings.font_semibold,
      ),
      width: 280,

    ).show(context);*/

    return Flushbar(
      title: title,
      titleColor: Colors.white,
      message: description,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: CustomColors.white,
      //padding: EdgeInsets.all(20),
      maxWidth:  MediaQuery.of(context).size.width - 50,
      borderColor: CustomColors.red,
      borderRadius: BorderRadius.all(const Radius.circular(15)),
      //boxShadows: [BoxShadow(color: CustomColors.red, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      //backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(
        Icons.error,
        color: CustomColors.red,
      ),
      /*mainButton: TextButton(
        onPressed: () {},
        child: Text(
          "CLAP",
          style: TextStyle(color: Colors.amber),
        ),
      ),*/
      //showProgressIndicator: true,
      //progressIndicatorBackgroundColor: Colors.blueGrey,
      titleText: Text(
        title,
        textScaleFactor: 1.0,
        style: TextStyle(
          color: CustomColors.red,
          fontSize: 14.0,fontFamily: Strings.font_semibold,
        ),
      ),
      /*messageText: Text(
        "You killed that giant monster in the city. Congratulations!",
        style: TextStyle(fontSize: 18.0, color: Colors.green, fontFamily: "ShadowsIntoLightTwo"),
      ),*/
    )..show(context);

  }

  /// SnackBar Error
  openSnackBarInfo(BuildContext context, String message, String images, Color frontColor, String type) {


    /*if(type=="error"){
      Future.delayed(const Duration(milliseconds: 500), () {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:message,
            //backgroundColor: CustomColors.white,
            textStyle: TextStyle(fontFamily: Strings.font_semibold, color: frontColor, fontSize: 13,),
            icon: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(left: 20,right: 10),
              child: Image(
                image: AssetImage("assets/images/nook.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      });
    }else{
      Future.delayed(const Duration(milliseconds: 500), () {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message:message,
            //backgroundColor: CustomColors.white,
            textStyle: TextStyle(fontFamily: Strings.font_semibold, color: frontColor, fontSize: 13,),
            icon: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(left: 20,right: 10),
              child: Image(
                image: AssetImage("assets/images/ok.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      });
    }*/

    //Local Notification (Custom)
    BotToast.showCustomNotification(
        animationDuration:
        Duration(milliseconds: 200),
        animationReverseDuration:
        Duration(milliseconds: 200),
        duration: Duration(milliseconds: 4700),
        backButtonBehavior: BackButtonBehavior.close,

        toastBuilder: (cancel) {

          return Material(
            color: Colors.transparent,

            child: Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1.5,
                    color: frontColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  ///Icon
                  /*Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 40,
                    height: 40,
                    //child: Image.asset("assets/images/ic_local_push.png"),
                    child: SvgPicture.asset(
                      images,
                      fit: BoxFit.cover,
                    ),
                  ),*/

                  /*Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 40,
                    height: 40,
                  ),*/

                  ///Text
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Container(
                        child: AutoSizeText(
                          message,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontFamily: Strings.font_bold,
                              fontSize: 14,
                              color: frontColor),
                          maxLines: 3,
                        ),
                      ),

                    ),
                  )

                ],

              ),

            ),

          );

        },
        enableSlideOff: true,
        onlyOne: true,
        crossPage: true
    );
    ///////////////////////////

  }


  /// Create 1,4,7,10 secuence
  void createSecuenceOne(int total){

    for (int i = 1; i < total+1; i++) {

      var value = (3*i)-2; ///(3*n-2)
      singleton.secuenceOne.add(value);

      var value1 = (3*i)-1; ///(3*n-1)
      singleton.secuenceTwo.add(value1);

      var value2 = 3*i; ///(3*n)
      singleton.secuenceThree.add(value2);

    }



  }

  /// Detect if number is into 1,4,7,10,13,etc secuence
  bool detectSecuenceOne(int index){

    bool detect = false;
    detect = singleton.secuenceOne.contains(index);
    return detect;

  }

  /// Detect if number is into 2,5,6,11,etc secuence
  bool detectSecuenceTwo(int index){

    bool detect = false;
    detect = singleton.secuenceTwo.contains(index);
    return detect;

  }

  /// Detect if number is into 3,6,9,12,15,etc secuence
  bool detectSecuenceThree(int index){

    bool detect = false;
    detect = singleton.secuenceThree.contains(index);
    return detect;

  }

  /// Order Gane Room Vector
  void orderVectorAdvertising(){

    var itemFirst = "C1";
    var vecWS = [1,4,3,4,1,3,1,1,1,4,1,4,3,1,1,4,3];
    var vecPR = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
    var vecT  = [];
    var vecF  = [];

    for(int i = 0 ; i<vecWS.length ; i++){

      if(itemFirst == "C1"){

        if(vecWS[i] == 1){
          vecT.add(vecWS[i]);
          itemFirst = "C2";

        }else if(vecWS[i] == 4){
          vecT.add(vecWS[i]);
          itemFirst = "C3";

        }else if(vecWS[i] == 3){
          vecT.add(vecWS[i]);
          itemFirst = "C1";

        }

      }else if(itemFirst == "C2"){

        if(vecWS[i] == 1){
          vecT.add(vecWS[i]);
          itemFirst = "C3";

        }else if(vecWS[i] == 4){
          vecT.add(vecWS[i]);
          itemFirst = "C1+";

        }

      }else if(itemFirst == "C3"){

        if(vecWS[i] == 1 && vecWS[i-1] == 4){
          vecT.add(vecWS[i]);
          itemFirst = "C3";

        }else if(vecWS[i] == 1 && vecWS[i-1] == 1){
          vecT.add(vecWS[i]);
          itemFirst = "C1";

        }else{
          vecT.add(1);
          vecF.add(vecWS[i]);
          itemFirst = "C1";
        }


      }else if(itemFirst == "C1+"){

        vecT.add(1);
        vecF.add(vecWS[i]);
        itemFirst = "C1";


      }

    }



  }

  /// Launch timer SMS
  void timerReSentSMS(){

    var tiempo = 10;
    singleton.timer = Timer.periodic(Duration(seconds: 1), (timers) {

      tiempo = tiempo - 1;
      Duration f = Duration(seconds: tiempo);
      singleton.notifierTimerText.value = utils.formatDuration(f);
      print(singleton.notifierTimerText.value);
      if(tiempo==0){
        singleton.timer.cancel();
        singleton.notifierTimerText.value = "";
        tiempo = 10;
      }
      /*var now = DateTime.now();
      var remaining = singleton.alert.difference(now);
      print(remaining);
      singleton.notifierTimerText.value = utils.formatDuration(remaining);*/

    });

  }

  /// Return Points value
  double valuePointsAds(ResultSL item){
    //double value = 0.0;
    double value = double.parse(item.pointsAdditional!);

    for(int i=0; i<item.ads!.length ; i++){
      value = value + double.parse(item.ads![i]!.pointsAds!);
    }

    return value;
  }

  /// Return Points value Games
  double valuePointsGames(ResultGL item){
    //double value = 0.0;
    double value = double.parse(item.pointsAdditional!);

    for(int i=0; i<item.ads!.length ; i++){
      value = value + double.parse(item.ads![i]!.pointsAds!);
    }

    return value;
  }

  /// Local Hour
  String dateTimeZone(String dateValue){
    var date = "";
    var dateTime = DateTime.parse(dateValue).toLocal();
    var month = dateTime.month.toString();
    if(dateTime.month <= 9){
      month = "0${dateTime.month}";
    }
    var day = dateTime.day.toString();
    if(dateTime.day <= 9){
      day = "0${dateTime.day}";
    }
    var hour = dateTime.hour.toString();
    if(dateTime.hour <= 9){
      hour = "0${dateTime.hour}";
    }
    var minute = dateTime.minute.toString();
    if(dateTime.minute <= 9){
      minute = "0${dateTime.minute}";
    }
    var second = dateTime.second.toString();
    if(dateTime.second <= 9){
      second = "0${dateTime.second}";
    }
    //date = "${dateTime.year}-$month-$day $hour:$minute:$second";
    date = "$hour:$minute";

    return date;
  }

  /// Load Vector game
  void vectorGame(String image, List vector){



    singleton.notifierValueXY.value = [];
    double alto = singleton.al;
    //alto = 30;

    int item = -1;
    for(int i = 0 ; i < 11 ; i++){

      //alto = alto + (237*i);
      alto = alto + (i== 0 ? 0 :237);
      if(item < vector.length-1){
        item = item + 1;
      }else{
        item = 0;
        //item = Random().nextInt(vector.length-1);
      }


      Map<String, dynamic> myObject = {
        "x": singleton.an - 50,
        "y": alto,
        "color": Colors.primaries[i % Colors.primaries.length],
        "ancho": 112.0,
        "alto": 227.0,
        //"image":image,
        "image":vector[item],
        "pop": "0",
      };
      //singleton.notifierValueXY.value[i] = myObject;

      singleton.notifierValueXY.value.add(myObject);
    }

  }

  /// Call o goto WebView
  void callOrWebView(String url){

    if(url != ""){

      if(url!.contains("http")){
        if(singleton.isIOS == false){
          Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: TyC(url: url, title: "",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        }else{
          //utils.launchWebView(url);
          Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: TyC(url: url, title: "",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        }

      }else{
        if(singleton.isIOS == true){
          Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: TyC(url: "", title: "",lauchPhone: url,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        }else{
          //utils.launchCaller(url);
          Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: TyC(url: "", title: "",lauchPhone: url,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        }

      }
    }

  }

  /// Call o goto WebView
  void callOrWebView1(String url, VoidCallback onNext) {

    if(url != ""){

      if(url!.contains("http")){
        Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: TyC1(url: url, title: Strings.backtoreward,onNext:onNext ,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

      }else{
        if(singleton.isIOS == true){
          Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: TyC1(url: "", title: Strings.backtoreward,lauchPhone: url,onNext:onNext), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
        }else{
          Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: TyC1(url: "", title: Strings.backtoreward,lauchPhone: url,onNext:onNext), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
          //utils.launchCaller(url);
        }
      }

    }

  }


  /// Detect if Call-Whatsapp-Url
  String linkCallOrWhatsApp(String url){
      String type = "telf";
      if(url!.contains("wa.me")){
        type = "whatsapp";
      }else if(url!.contains("http")){
        type = "url";
      }
      return type;
  }


  /// Local Audios from url
  Future<String> loadAudioFile(String kUrl1, String BackOrBoom) async {
    var path = "";
    final bytes = await readBytes(Uri.parse(kUrl1));
    final dir = await getApplicationDocumentsDirectory();
    var name = "back.mp3";
    if(BackOrBoom == "boom"){
      name = "boom.mp3";
    }
    final file = File('${dir.path}/'+name);
    await file.writeAsBytes(bytes);
    if (file.existsSync()) {
      //setState(() => localFilePath = file.path);
      path = file.path;
      return path;
    }else return path;
  }



  Future<void> requestPermission(hand.Permission permission) async {
    final status = await singleton.permission.request();
    print(status);
    singleton.permissionStatus = status;
    print(singleton.permissionStatus);
    if(status.isGranted){
      Navigator.pop(singleton.navigatorKey.currentContext!);
    }

  }

  /// Detect SIM DATA USER
  void values() async{

    try {



      /*String platformVersion = await DeviceInformation.platformVersion;
      singleton.modelName = await DeviceInformation.deviceModel;
      singleton.manufacturer = await DeviceInformation.deviceManufacturer;
      String deviceName = await DeviceInformation.deviceName;
      String productName = await DeviceInformation.productName;
      String cpuType = await DeviceInformation.cpuName;
      String hardware = await DeviceInformation.hardware;
      print(singleton.modelName);
      print(deviceName);
      print(productName);*/




    } on PlatformException catch(e){
      //platformVersion = 'Failed to get platform version.';
      print(e);
    }


  }

  /// Detect animation duration change view
  int ValueDuration(){

    print(singleton.modelName);
    print(singleton.manufacturer);
    if(singleton.modelName == "moto g(7)" ){ //|| singleton.manufacturer == "samsung" || singleton.manufacturer == "Samsung"){
      return 6000;
    }

    return 450;

  }

  /// Detect spinner animation duration
  int ValueDurationAnimatedSpinner(){

    if(singleton.modelName == "moto g(7)" ){ //|| singleton.manufacturer == "samsung" || singleton.manufacturer == "Samsung"){
      return 15;
    }

    return 3;

  }

  void VibrateAndMusic()async{

    /*Clipboard.setData(ClipboardData());
    HapticFeedback.vibrate();

    Vibration.vibrate(pattern: [500]);*/

    //musicCache.play('beep.wav');
    musicCache.load('beep.wav');
    //Vibration.vibrate(duration: 100);
    HapticFeedback.mediumImpact();

  }


  /// Add points to view
  void addUserPoint(int? points){

    singleton.AddPointUser = singleton.AddPointUser + points!;

  }

  /// animation all points win
  void addUserPointAnimation(){

    //for (int i = 1; i<=singleton.AddPointUser ; i++){

      //Future.delayed(const Duration(milliseconds: 350), () {

        Userpoints point =  singleton.notifierUserPoints.value;
        var result = int.parse(point.data!.result!);
        //result = result + i.toInt();
        result = result + singleton.AddPointUser;
        point.data!.result = result.toString();
        singleton.notifierUserPoints.value = point;

     // });

    //}
    singleton.AddPointUser = 0;

  }

  /// Height View Win Points
  void heightViewWinPoint(){
    singleton.notifierHeightViewWinPoints.value = 0.0;

  }


  void reduceNumberPoints(){


  }


  /// Return value Moni
  double returnDividendo( double value){
    double dividendo = value;

    /*if(value > 999 && value <= 1000000){
      dividendo = dividendo /1000;

    }else if(value > 1000000 && value <= 10000000){
      dividendo = dividendo /10000;

    }else if(value > 10000000){
      dividendo = dividendo /100000;
    }*/

    if(value > 999 && value < 1000000){ /// Kilo
      dividendo = dividendo /1000;

    }else if(value >= 1000000 && value < 1000000000){ /// Mega
      dividendo = dividendo /1000000;

    }else if(value >= 1000000000){ /// Giga
      dividendo = dividendo / 1000000000;
    }


    return dividendo;

  }

  String returnDividendoString( double value){
    double dividendo = value;
    var suffix = "";

    if(value > 999 && value < 1000000){ /// Kilo
      dividendo = dividendo /1000;
      suffix = "K";

    }else if(value >= 1000000 && value < 1000000000){ /// Mega
      dividendo = dividendo /1000000;
      suffix = "M";

    }else if(value >= 1000000000){ /// Giga
      dividendo = dividendo / 1000000000;
      suffix = "G";
    }

    if(dividendo.toString().contains('.0') || dividendo.toString().contains('.99')){
      return dividendo.toStringAsFixed(0) + suffix;
    }
    return  dividendo.toStringAsFixed(1) + suffix;


  }

  /// Suffix value (K,M)
  String suffixValues(double value){

    String suffix = "";

    /*if(value > 999 && value < 1000000){
        suffix = 'K';
    }else if(value >= 1000000){
        suffix = 'M';
    }*/

    if(value > 999 && value < 1000000){ /// Kilo
      suffix = 'K';

    }else if(value >= 1000000 && value < 1000000000){ /// Mega
      suffix = 'M';

    }else if(value >= 1000000000){ /// Giga
      suffix = 'G';
    }

    return suffix;

  }

  /// Return value data moni
  String returnDataMoni(double value){

    double  kcal = value;
    kcal = returnDividendo(kcal);
    var val = kcal.toString();
    print(val.length);

    if(val.contains('.0') || val.contains('.99')){
      return kcal.toStringAsFixed(0) + utils.suffixValues(value);
    }
    return  kcal.toStringAsFixed(1) + utils.suffixValues(value);

  }






  ///Check status video
  void checkVideo(){

  }

  /// Go Login when no Altan user
  void goLogin(){

    //singleton.timer1.cancel();
    prefs.authToken ="0";
    prefs.imei = "0";
    singleton.notifierVisibleButtoms.value = 1;
    prefs.countrySIMCOde = "0";
    prefs.phoneUserNumber = "0";
    prefs.flagWinCanje = "0";

    /*if(singleton.controller != null){
      singleton.controller!.pause();
      singleton.controller!.removeListener(checkVideo);
      singleton.urls = [];
      //singleton.controller = null;
      singleton.notifierVideoLoaded.value = false;
      singleton.initializeVideoPlayerFuture = singleton.controller!.initialize();
      print("Paro el controller de video");
    }*/

    singleton.timer1 = null;

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(singleton.navigatorKey.currentContext!, Transition(child: LoginPhone()) );
    });

  }

  /// Detect change SIMCard
  void getDeviceModel() async {

    String _model;
    try {

      //stopTimer();

      singleton.timer1 = Timer.periodic(Duration(milliseconds: 1500), (timers) async {

        if(singleton.isIOS == false){
          //printSimCardsData();
          requestPermissionPhone(singleton.permission);
        }else{
          detectSIMDataiOS();
        }

        if(singleton.historyObserver.history.length.toString() == "1"){

          /*if(singleton.controller.value.isInitialized){
            singleton.controller.pause();
            print("Está activo el singleton.controller");
          }
          print("Paro el controller de video");*/

        }

      });


    } catch (e) {
      _model = "Can't fetch the method: '$e'.";
      print(_model);
    }

  }

  /// SIM Data Detect change SIMCard iOS
  void detectSIMDataiOS()async{

    String _model;
    try {

      final String result = await Singleton.platformChannel.invokeMethod('getSimPlugOut',);
      _model = result;
      singleton.resultSIMCardNetworkID.value = "0";
      singleton.resultSIMCardNetworkID.value = result;

      print("Valor retornado desde Nativo iOS: " + result);
      print("Numero actual de SIM guardado: " + prefs.countrySIMCOde);

      final statusAirPlaneMode = await AirplaneModeChecker.checkAirplaneMode();
      ///print("AirPlaneMode: " + statusAirPlaneMode.toString());

      if(statusAirPlaneMode == AirplaneModeStatus.off && result.toString() != "NoSIM"){ /// If AirPlaneMode is ON

        if(prefs.countrySIMCOde == "0"){
          prefs.countrySIMCOde = result.toString();
        }else if(result.toString() == "NoSIM"){
          print("ID de red retorna vacío, se le asigna 0 ");
          prefs.countrySIMCOde = "0";
          stopTimer();
          goLogin();
        }else{
          print("Numero actual de SIM: " + result.toString());
          print("Numero actual de SIM guardado: " + prefs.countrySIMCOde);
          if(prefs.countrySIMCOde != result.toString()){
            print("cambio de operador"); //descomentarear
            //stopTimer();
            //goLogin();
          }
        }

      } else if(statusAirPlaneMode == AirplaneModeStatus.off && result.toString() == "NoSIM"){
        Future.delayed(const Duration(milliseconds: 2700), () {
          print(singleton.resultSIMCardNetworkID.value);
          if(singleton.resultSIMCardNetworkID.value == "NoSIM"){
            stopTimer();
            goLogin();
          }

        });
      }


    } catch (e) {
      _model = "Can't fetch the method: '$e'.";
      print(_model);
    }

  }

  /// SIM Data Detect change SIMCard Android
  void printSimCardsData1() async {
    try {
      /*SimInfo simInfo = await SimNumber.getSimData();
      for (var s in simInfo.cards) {
        print('Serial number: ${s.slotIndex} ${s.phoneNumber}');

        if(prefs.phoneUserNumber == "0"){
          prefs.phoneUserNumber = s.phoneNumber.toString();
        }else{

          print("Numero actual de SIM: " + s.phoneNumber.toString());
          print("Numero actual de SIM guardado: " + prefs.phoneUserNumber);
          if(prefs.phoneUserNumber != s.phoneNumber.toString()){
            goLogin();
          }

        }

        break;
      }*/


      /*try {
        SimData simData = await SimDataPlugin.getSimData();
        if(simData.cards.length > 0){

          for (var s in simData.cards) {
            //print('Serial number: ${s.serialNumber}');

            if(prefs.countrySIMCOde == "0"){
              prefs.countrySIMCOde = s.serialNumber.toString();
            }else if(s.serialNumber.toString() == "NoSIM"){
              prefs.countrySIMCOde = "0";
              stopTimer();
              goLogin();
              break;
            }else{

              // print("Numero actual de SIM: " + s.serialNumber.toString());
              // print("Numero actual de SIM guardado: " + prefs.countrySIMCOde);
              if(prefs.countrySIMCOde != s.serialNumber.toString()){
                stopTimer();
                goLogin();
                break;
              }
            }
          }

        }else{
          stopTimer();
          goLogin();
        }

      } on PlatformException catch (e) {
        debugPrint("error! code: ${e.code} - message: ${e.message}");
      }*/



    } on Exception catch (e) {
      debugPrint("error! code: ${e}");
    }
  }

  /// SIM Data Permissions
  Future<void> requestPermissionPhone(hand.Permission permission) async {
    final status = await singleton.permission.request();
    //print(status);
    singleton.permissionStatus = status;
    //print(singleton.permissionStatus);

    final status1 = await singleton.permission.status;
    //print(status1);

    if(status.isGranted){
      //printSimCardsData();
      detectSIMDataiOS();
    }else{
      print("No tiene permisos");
      if(status.isPermanentlyDenied){
        stopTimer();
        dialogBlur(singleton.navigatorKey.currentContext!, Strings.wait, Strings.activate12, Strings.activate2, Strings.activate1, "telf");
        //goLogin();
      }
    }
  }

  /// Stop timer SIMCard check
  void stopTimer(){
    singleton.timer1!.cancel();
  }

  /// Token credit card
  void returnCreditCard(BuildContext context, String name, String tcnumber, String year, String month,String cvv,)async{

    String _model;
    try {

      final String result = await Singleton.platformChannel.invokeMethod('getCreditCard',{"name":name, "tcnumber":tcnumber,"year":year,"month":month,"cvv":cvv,});
      _model = result;
      print("Token de Tarjeta: "+_model);
      if(_model=="NoToken"){
        utils.openSnackBarInfo(context, _model, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
      }else{
        utils.openProgress(context);
        servicemanager.fetchCreatePaymentCreditCard(context,singleton.idPlan, _model);
      }

    } catch (e) {
      _model = "Can't fetch the method: '$e'.";
      print(_model);
    }

  }


  Map encryptPwdIv(String value) {
    var key = cript.Key.fromUtf8(Strings.key1);
    var iv = cript.IV.fromSecureRandom(16);
    var encrypter = cript.Encrypter(cript.AES(key, mode: cript.AESMode.ctr, padding: null));
    var iv16 = iv.base16;
    var encrypted = encrypter.encrypt(value, iv: iv);
    var encrypted16 = encrypted.base16;
    Map jsonEncrypted = {
      'iv': iv16,
      'encrypted': encrypted16,
    };
    print(iv16);
    print(encrypted16);
    return jsonEncrypted;
  }


  /// show dialog Validate Telf
  showDialogValidateTelf(BuildContext context, Function validate) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => dialogValidateTelf(validate: validate)
    );
  }


  /// Load Countries list
  loadCountries(){

    singleton.notifierCountriesList.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );
    singleton.notifierCountriesListSearch.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );

    singleton.notifierCountriesList.value = Countries(
        code: 100,
        message: "Información listada correctamente",
        status: true,
        data: <CountriesData>[
          CountriesData(id: "MX",country: "Mexico", callingCode: "+52",currency: "MXN"),
          CountriesData(id: "US",country: "Estados Unidos", callingCode: "+1",currency: "USD"),
          CountriesData(id: "CO",country: "Colombia", callingCode: "+57",currency: "COP"),
        ]
    );

    singleton.notifierCountriesListSearch.value = Countries(
        code: 100,
        message: "Información listada correctamente",
        status: true,
        data: <CountriesData>[
          CountriesData(id: "MX",country: "Mexico", callingCode: "+52",currency: "MXN"),
          CountriesData(id: "US",country: "Estados Unidos", callingCode: "+1",currency: "USD"),
          CountriesData(id: "CO",country: "Colombia", callingCode: "+57",currency: "COP"),
        ]
    );

    singleton.notifierCallingCode.value = (singleton.notifierCountriesList.value.data!.length > 0 ? singleton.notifierCountriesList.value.data![0]!.callingCode : "")!;
    print(singleton.notifierCallingCode.value);
    prefs.indiCountry = singleton.notifierCallingCode.value;
    prefs.countryCode = (singleton.notifierCountriesList.value.data!.length > 0 ? singleton.notifierCountriesList.value.data![0]!.id : "")!;
    print(prefs.countryCode);


  }

  void stopLoading(){
    Navigator.pop(singleton.navigatorKey.currentContext!);
  }



  ///Read string from language
  String appLanguage(String message){
    OnboardingProvider onboardingProvider = Provider.of<OnboardingProvider>(singleton.navigatorKey.currentContext!, listen: false);
    print(onboardingProvider.appLanguage);
    var text = message;
    text = AppLanguage.localizedValues[onboardingProvider.appLanguage]![message]!;
    return text; // onboardingProvider.appLanguage
  }




  /// Pick image gallery or camera
  Future<void> onImageButtonPressed(ImageSource source, Function reloadImage, {BuildContext? context, bool isMultiImage = false}) async {

    try {
      final XFile? pickedFile = await singleton.picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );
      reloadImage(pickedFile);

    } catch (e) {
      print(e);
    }

  }

  /// Pick image gallery or camera
  Future<void> onImageButtonPressed1(ImageSource source, Function reloadImage, {BuildContext? context, bool isMultiImage = true}) async {

    try {
      final XFile? pickedFile = await singleton.picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 70,
      );
      reloadImage(pickedFile);

    } catch (e) {
      print(e);
    }

  }


}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension ColorExtension on String {
  toColors() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

final utils = _Utils();


