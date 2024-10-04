

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/UI/Onboarding/loginphone.dart';
import 'package:gane/src/UI/Onboarding/onboarding_provider.dart';
import 'package:gane/src/UI/Splash/splashonline.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:gane/src/Utils/singleton.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  Splash createState() => Splash();
}

class Splash extends State<SplashPage> with TickerProviderStateMixin, WidgetsBindingObserver {

  final prefs = SharePreference();
  final singleton = Singleton();
  servicesManager servicemanager = servicesManager();
  late OnboardingProvider onboardingProvider;

  initState() {
    super.initState();


    WidgetsBinding.instance!.addPostFrameCallback((_){
      versionapp();

      singleton.an = MediaQuery.of(singleton.navigatorKey.currentContext!).size.width/2;
      singleton.al = MediaQuery.of(singleton.navigatorKey.currentContext!).size.height;

      /*double alto = singleton.al;
       //alto = 30;

      for(int i = 0 ; i < 11 ; i++){

        //alto = alto + (237*i);
        //alto = alto + (i== 0 ? 0 :237);

        Map<String, dynamic> myObject = {
          "x": singleton.an - 50,
          "y": alto,
          "color": Colors.primaries[i % Colors.primaries.length],
          "ancho": 112.0,
          "alto": 227.0,
          "image":"assets/images/Balloon.svg",
          "pop": "0",
        };
        //singleton.notifierValueXY.value[i] = myObject;

        singleton.notifierValueXY.value.add(myObject);
      }*/

      List<dynamic> t = singleton.notifierValueXY.value;
      singleton.notifierValueXY.value = [];
      singleton.notifierValueXY.value = t;

      print(ui.window.locale.toLanguageTag().toString());
      var lang = ui.window.locale.toLanguageTag().toString().split("-");
      onboardingProvider.appLanguage = lang[0];

      if(prefs.authToken=="0"){
        Future.delayed(const Duration(milliseconds: 2000), () {
          validateUser();
        });
      }else{
        launchFetch();
      }




    });


  }

  void versionapp() async{

    singleton.packageInfo = await PackageInfo.fromPlatform();

  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        servicemanager.fetchValidateSegmentation(context).then((value) {

          Future.delayed(const Duration(milliseconds: 2000), () {
            validateUser();
          });
        });

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }

  validateUser() {

    print(prefs.authToken);
    if(prefs.authToken=="0"){

      return Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (context) => LoginPhone()));

    }else{

      if(prefs.authToken=="0"){
        return  Navigator.pushReplacement(
            context, MaterialPageRoute(
            builder: (context) => PrincipalContainer()));
      }else{

        if( singleton.notifierValidateSegmentation.value.code == 100){
          return  Navigator.pushReplacement(
              context, MaterialPageRoute(
              builder: (context) => SplashPageOnline()));
        }else{
          return  Navigator.pushReplacement(
              context, MaterialPageRoute(
              builder: (context) => PrincipalContainer()));
        }

      }



    }



  }

  Widget build(BuildContext context) {
    onboardingProvider = Provider.of<OnboardingProvider>(context);
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Container(
            height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image:
                      AssetImage(
                          'assets/images/splash.png'
                      )
                ),
                gradient: LinearGradient(
                    colors: CustomColors.gradientSplash,
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomCenter
                ),


              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[

                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      child:  Container(
                        /*child: Image(
                          image: AssetImage("assets/images/splash.gif"),
                          fit:BoxFit.contain,
                        ),*/
                        child: Lottie.asset(
                          'assets/images/splash.json',
                          repeat: true,
                          fit:BoxFit.cover,
                        ),

                      ),
                    ),

                  ),

                  Container(
                    margin: EdgeInsets.only(top: 12),
                    /*child: Image(
                      image: AssetImage("assets/images/sombra.png"),
                      fit:BoxFit.contain,
                    ),*/
                    child: SvgPicture.asset(
                      'assets/images/sombra.svg',
                      fit: BoxFit.contain,
                    ),

                  ),


                ],

              )
          ),
        ),

    );
  }



}