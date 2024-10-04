import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gane/src/Models/accesstok.dart';
import 'package:gane/src/UI/Onboarding/onboarding_provider.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/inter.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/push_notifications_provider.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';
import 'package:gane/src/UI/Splash/splash.dart';
import 'dart:io' show Platform;
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  final prefs = SharePreference();
  await prefs.initPrefs();

  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    //InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CustomColors.orangeborderpopup,
      //systemNavigationBarColor: CustomColors.orangeborderpopup,
  ));*/



  initializeDateFormatting().then((_) => runApp(MyApp()));

}

void initPrefs() async{
  final prefs = SharePreference();
  await prefs.initPrefs();

}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  late StreamSubscription _connectionChangeStream;
  Singleton singleton = Singleton();
  servicesManager servicemanager = servicesManager();
  final prefs = SharePreference();


  final pushProvider = PushNotificationsProvider();
  var typeDetailNotification = "-";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {

    //conectionInter();
    singleton.historyObserver = NavigationHistoryObserver();

    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_push');
    var initializationSettingsIOS = new DarwinInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    //flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
    initNotifications();


    super.initState();

    //ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    //_connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);


    WidgetsBinding.instance!.addPostFrameCallback((_){
      //initPrefs();
      _portraitModeOnly();

      singleton.isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      print(singleton.isIOS);

      String os = Platform.operatingSystem;
      singleton.isIOS = false;
      if(os=="ios"){
        singleton.isIOS = true;
      }
      print(os);


      singleton.historyObserver.historyChangeStream.listen(
              (change) => setState(() {
            //historyCount = historyObserver.history.length;
            //poppedCount = historyObserver.poppedRoutes.length;
                print("Cantidad pages: "+singleton.historyObserver.history.length.toString());
                print("Cantidad pages: "+singleton.historyObserver.poppedRoutes.length.toString());

                /*if(singleton.historyObserver.history.length.toString() == "1"){
                  singleton.controller.pause();
                }*/

          }
          )
      );



    });

    WidgetsBinding.instance!.addObserver(this);


  }


  @override
  void dispose() {
    //_connectionChangeStream.cancel();
    _connectivity.disposeStream();
    super.dispose();
  }

  /*void connectionChanged(dynamic hasConnection) {
    setState(() {
      singleton.isOffline = !hasConnection;
    });
  }*/

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        singleton.typeInternetConnection = 'Mobile: Online';
        singleton.notifierIsOffline.value = false;
        print(singleton.typeInternetConnection);
        //utils.check();

        break;
      case ConnectivityResult.wifi:
        singleton.typeInternetConnection = 'WiFi: Online';
        print(singleton.typeInternetConnection);
        singleton.notifierIsOffline.value = false;

        break;
      case ConnectivityResult.none:
      default:
      singleton.typeInternetConnection = 'Offline';
      print(singleton.typeInternetConnection);
      //singleton.notifierIsOffline.value = true;

    }
    print(singleton.typeInternetConnection);

    //initPrefs();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (tapDown)
      {
        //launchTimer();
      },
      child: MultiProvider(
        providers: [

          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => OnboardingProvider()),

        ],
        child: MaterialApp(
          navigatorKey: singleton.navigatorKey,
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver(), NavigationHistoryObserver()], //
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              //backwardsCompatibility: false, // 1
              systemOverlayStyle: SystemUiOverlayStyle.light, // 2

            ),
          ),
          home: Scaffold(
            backgroundColor: CustomColors.orangeback,
              /*body: ShowCaseWidget(
                builder: Builder(
                  builder: (context) => validateUser(),
                ),
                autoPlayDelay: const Duration(seconds: 3),
                blurValue: 1,
              ),*/
            body: validateUser(),
          ),

        ),
      )
    );



  }


  @override
  void didChangePlatformBrightness() {
    print(WidgetsBinding.instance!.window.platformBrightness); // should print Brightness.light / Brightness.dark when you switch
    super.didChangePlatformBrightness(); // make sure you call this
  }

  ///Change rootView
  Widget validateUser(){
    servicemanager.fetchAccessToken(context).then((AccessToken result){
      print("AccessToken es: " + result.data.accessToken);
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      //initPrefs();
    });
    return SplashPage();

  }

  /// Init Notifications
  void initNotifications(){
    pushProvider.initNotifications();
    pushProvider.message.listen((data){

    });
  }

  /// Select Notifications
  Future onSelectNotification(String? params) async {
    //_launchNotification(params);
    print("Entro");
  }


}
