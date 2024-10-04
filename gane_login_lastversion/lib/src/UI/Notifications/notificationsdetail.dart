import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gane/src/Models/generalnotification.dart';
import 'package:gane/src/Models/notificationslist.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_deletenotification.dart';
import 'package:gane/src/Widgets/dialog_winpoints.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spring_button/spring_button.dart';
import 'dart:ui' as ui;


class NotificationssDetail extends StatefulWidget{
  final idSequence;
  final type;
  final itemdelte;

  NotificationssDetail({this.idSequence, this.type, this.itemdelte});

  @override
  _NotificationssDetail createState() => new _NotificationssDetail();

}

class _NotificationssDetail extends State<NotificationssDetail>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  final notifierTab = ValueNotifier(0);


  int itemdelete = -1;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState(){
    //ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    //_connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);



    WidgetsBinding.instance!.addPostFrameCallback((_){
      launchFetch();
      //singleton.pr.hide();
      //pr.show();

      Future.delayed(const Duration(seconds: 3), () {
        //pr.update(message: "Consultando Distribuidores");
      });

    });

    super.initState();
  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        singleton.notifierGeneralnotification.value = Generalnotification(code: 1,message: "No hay nada", status: false, );

        if(widget.type == "GN"){
          servicemanager.fetchClickGeneralNotification(widget.idSequence, widget.type, context,onNextAd);
        }else{
          utils.openProgress(singleton.navigatorKey.currentContext!);
          servicemanager.fetchClickGeneralNotification(widget.idSequence, widget.type, context,launchFetchAddPoints);
        }

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /*void connectionChanged(dynamic hasConnection) {
    setState(() {
      singleton.isOffline = !hasConnection;
    });
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    singleton.contextGlobal = context;
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
            child: Scaffold(
                body: Builder(

                  builder: (BuildContext context1){
                    singleton.contextGlobal = context1;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: CustomColors.grayBackNoti,
                      child: Stack(

                        children: <Widget>[

                          Container(
                            margin: EdgeInsets.only(top: 80.0),
                            child: Container(),
                          ),

                          fields(context1),


                        ],
                      ),


                    );

                  },


                )

            ),
          );

        }

    );

  }

  /// Fields List
  Widget fields(BuildContext context){

    return Container(
      //padding: EdgeInsets.all(20),
      //color: Colors.red,
      child: Stack(

        children: <Widget>[

          ///Header
          AppBar(notifierTab),

          Padding(
            padding: EdgeInsets.only(top: 90,left: 15,right: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                //color: Colors.green,
                child: Column(

                  children: [


                    /// Delete
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(
                          'assets/images/deletenot.svg',
                          fit: BoxFit.contain,
                          width: 40,
                          height: 40,
                          //color: CustomColors.greyplaceholder
                        ),
                      ),
                      useCache: false,
                      onTap: (){
                        dialogDeleteNoification(context,deleteNotification,singleton.notifierListNotfications.value.data!.result![widget.itemdelte]!.id!,singleton.notifierListNotfications.value.data!.result![widget.itemdelte]!.notification!.id!);
                      },

                      //onTapDown: (_) => decrementCounter(),

                    ),

                    SizedBox(height: 10,),

                    /// Data
                    Card(
                      //padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: CustomColors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                        child: ValueListenableBuilder<Generalnotification>(
                            valueListenable: singleton.notifierGeneralnotification,
                            builder: (context,value1,_){

                              return value1.code == 1 ? utils.PreloadingNotification() :
                              Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,

                                children: [

                                  /// Titles
                                  Row(

                                    children: [

                                      /// Titles
                                      Expanded(
                                        child: Container(
                                          //color: Colors.red,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              Container(
                                                child: Text(value1.data!.title!,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontFamily: Strings.font_medium ,
                                                        fontSize:18,
                                                        color: CustomColors.black),
                                                    textAlign: TextAlign.start
                                                ),
                                              ),

                                              Container(
                                                child: Text(DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(value1.data!.options!.createdAt!).toLocal()),
                                                    style: TextStyle(
                                                        fontFamily: Strings.font_medium ,
                                                        fontSize:16,
                                                        color: CustomColors.grayalert1),
                                                    textAlign: TextAlign.start,
                                                  textScaleFactor: 1.0,
                                                ),
                                              ),

                                              Container(
                                                child: Text(utils.dateTimeZone(value1.data!.options!.createdAt!),
                                                    style: TextStyle(
                                                        fontFamily: Strings.font_bold ,
                                                        fontSize:14,
                                                        color: CustomColors.grayTextemptyhome),
                                                    textAlign: TextAlign.start,
                                                  textScaleFactor: 1.0,
                                                ),
                                              ),

                                            ],

                                          ),
                                        ),
                                      ),

                                      /// Image
                                      Container(
                                        height: 70,
                                        width: 70,
                                        margin: EdgeInsets.only(left: 20,),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(

                                            imageUrl: value1.data!.ntImage!,
                                            placeholder: (context, url) => Container(
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                                                  ),
                                                )
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            fit: BoxFit.cover,
                                            useOldImageOnUrlChange: true,
                                          ),
                                        ),
                                      ),

                                    ],

                                  ),

                                  /// Subtitle
                                  Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Text(value1.data!.message!,
                                        style: TextStyle(
                                            fontFamily: Strings.font_bold ,
                                            fontSize:14,
                                            color: CustomColors.black),
                                        textAlign: TextAlign.start,
                                      textScaleFactor: 1.0,
                                    ),
                                  ),

                                  /// Description
                                  widget.type == "GN" || widget.type == "SEQUENCE" ? Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text( value1.data!.description!,
                                        style: TextStyle(
                                            fontFamily: Strings.font_regular ,
                                            fontSize:14,
                                            color: CustomColors.black),
                                        textAlign: TextAlign.start,
                                      textScaleFactor: 1.0,
                                    ),
                                  ) : Container(padding: EdgeInsets.only(top: 10),
                                      child: HtmlWidget(singleton.notifierGeneralnotification.value.data!.description!)
                                  ),

                                  SizedBox(height: 20,),

                                  /// Reward
                                  widget.type == "GN" || widget.type == "SEQUENCE" ? Container() : Container(
                                    margin: EdgeInsets.only(top: 10, left: 30,right: 30),
                                    //padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: CustomColors.graybackhome,
                                        borderRadius: BorderRadius.all(const Radius.circular(13))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [

                                        SizedBox(
                                          height: 10,
                                        ),

                                        /// Reward
                                        Container(
                                            alignment: Alignment.center,
                                            child: Text(Strings.reward,
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontFamily: Strings.font_bold,
                                                    fontSize: 14,
                                                    color: CustomColors.orangeswitch)),
                                        ),

                                        /// Value
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [


                                            /// Value
                                            Container(
                                              /*child: BorderedText(
                                                strokeWidth: 5.0,
                                                strokeColor: CustomColors.redBorderTextHeader,
                                                child: Text(
                                                  "+" + singleton.formatter.format(double.parse(singleton.notifierGeneralnotification.value.data!.points!)),
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 34.0,),
                                                  maxLines: 1,
                                                ),
                                              ),*/
                                              child: BorderedText(
                                                strokeWidth: 5.0,
                                                strokeColor: CustomColors.orangeswitch,
                                                child: Text(
                                                  "+" + singleton.formatter.format(double.parse(singleton.notifierGeneralnotification.value.data!.points!)),
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 34.0,),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 3,),

                                            ///Coins
                                            Container(
                                              child: Container(
                                                child: SvgPicture.asset(
                                                  'assets/images/coins.svg',
                                                  fit: BoxFit.contain,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ),

                                            ),

                                          ],

                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                      ],

                                    ),

                                  ),

                                  SizedBox(height: 20,),

                                ],

                              );

                            }

                        ),
                      ),

                    ),

                    SizedBox(height: 20,),

                    /// Go to web
                    widget.type == "GN" || widget.type == "SEQUENCE" ? Container() : SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          color: CustomColors.orangeback ,
                          borderRadius: BorderRadius.all(const Radius.circular(20)),
                          border: Border.all(
                            width: 1,
                            color: CustomColors.orangeback,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[

                              /// languaje
                              Expanded(
                                child: Container(
                                  child: ValueListenableBuilder<String>(
                                      valueListenable: singleton.notifierCallOrLink,
                                      builder: (context,value11,_){

                                        return AutoSizeText(
                                          value11,
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.0,
                                          //maxLines: 1,
                                          style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 14.0,),
                                          //maxLines: 1,
                                        );

                                      }

                                  ),
                                ),
                              ),

                            ],

                          ),
                        ),
                      ),
                      useCache: false,
                      onTap: (){

                        launchFetchAddPoints();
                        //Navigator.push(context, Transition(child: TyC(url: singleton.notifierGeneralnotification.value.data!.url, title: "WebSite",), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                      },

                      //onTapDown: (_) => decrementCounter(),

                    ),

                    SizedBox(height: 20,),


                  ],

                ),
              ),
            ),
          ),


        ],

      ),

    );

  }

  /// delete notification
  void deleteNotification(){
    singleton.notifierListNotfications.value.data!.result!.removeAt(widget.itemdelte);
    Notificationslist notifierNotificationsPrevius = singleton.notifierListNotfications.value;
    singleton.notifierListNotfications.value = Notificationslist(code: 1,message: "No hay nada",status: false,);
    singleton.notifierListNotfications.value = notifierNotificationsPrevius;
    Navigator.pop(context);
  }

  /// Obtain points notifications link
  void launchFetchAddPoints()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        singleton.format = 4;
        utils.openProgress(singleton.navigatorKey.currentContext!);
        servicemanager.fetchObtainPointsNotificationslink(singleton.navigatorKey.currentContext!, showAlertWonPoints);

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Show Alert won points
  void showAlertWonPoints(){

    Future.delayed(const Duration(milliseconds: 400), () {

      dialogWinPoints(singleton.navigatorKey.currentContext!, Strings.greatwin, Strings.activate4, Strings.activate3,onNextAd,singleton.notifierGeneralnotification.value.data!.points);
      linkOrCall();
    });

  }

  /// Next Ad
  void onNextAd(){

  }

  /// Call or go to WebSite
  void linkOrCall(){

    utils.callOrWebView(singleton.notifierGeneralnotification.value.data!.url!);

    /*if(singleton.notifierGeneralnotification.value.data!.url! != ""){
      var url = singleton.notifierGeneralnotification.value.data!.url!;
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

  }

}


///Create search field
class AppBar extends StatelessWidget{

  AppBar(this.notifierTab);

  late final ValueNotifier notifierTab;
  @override

  Widget build(BuildContext context) {

    return Container(
      //height: 120,
      //color: CustomColors.red,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        decoration: BoxDecoration(
          color: CustomColors.white,
          //borderRadius: BorderRadius.all(const Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: CustomColors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: Offset(1, 1)),
          ],
        ),

        child: Column(

          children: [

            /// Back and title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[


                ///Icon menu
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 5,top: 35,left: 10),
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/images/back.svg',
                        fit: BoxFit.contain,
                        color: CustomColors.blacktyc,
                      ),
                    ),

                  ),
                ),

                ///Beach and time
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Container(
                        child: AutoSizeText(
                          Strings.notificationsroomdetail,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 18.0,fontFamily: Strings.font_bold, color: CustomColors.blacktyc,),
                          //maxLines: 1,
                        ),
                      ),

                    ),
                  ),
                ),


              ],
            ),

          ],

        )
    );

  }

}



