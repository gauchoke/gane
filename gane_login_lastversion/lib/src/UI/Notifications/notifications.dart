import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/notificationslist.dart';
import 'package:gane/src/UI/Notifications/notificationsdetail.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_deletenotification.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spring_button/spring_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:ui' as ui;


class Notificationss extends StatefulWidget{
  final textEmail;
  final backbutton;

  Notificationss({this.textEmail, this.backbutton});

  @override
  _Notificationss createState() => new _Notificationss();

}

class _Notificationss extends State<Notificationss>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  final notifierTab = ValueNotifier(0);


  int itemdelete = -1;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  var type = "GN";

  @override
  void initState(){
    //ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    //_connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    notifierTab.value = 1;
    type = "SEQUENCE";
    launchFetch();

    launchFetch();

    WidgetsBinding.instance!.addPostFrameCallback((_){

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

        singleton.notifierListNotfications.value = Notificationslist(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchListNotifications(context, "borrar", type);
        servicemanager.fetchNotificationZero(context);

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
    return  ValueListenableBuilder<bool>(
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
                      color: CustomColors.white,
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
      //margin: EdgeInsets.only(top: 100,),
      //color: Colors.red,
      child: Column(

        children: <Widget>[

          ///Header
          AppBar(context),

          Expanded(
            child: Container(
              child: ValueListenableBuilder<Notificationslist>(
                    valueListenable: singleton.notifierListNotfications,
                    builder: (context,value1,_){

                      return  value1.code == 102 ?
                              utils.emptyHomeNotifications(value1.message!, "", "assets/images/emptyhome.svg")
                      : ListView.builder(
                        //physics: AlwaysScrollableScrollPhysics(),
                        //shrinkWrap: true,
                        padding: EdgeInsets.only(top: 2,left: 0,right: 0),
                        scrollDirection: Axis.vertical,
                        itemCount: value1.code == 1 ? 6 : value1.code == 102 ? 0 : value1.code == 120 ? 0 : value1.data!.result!.length ,
                        itemBuilder: (BuildContext context, int index){

                          if(value1.code == 1){
                            return utils.PreloadingPlane();

                          }else
                          return itemNotification(index, context, value1.data!.result![index]);

                        },

                      );

                    }

              ),

            ),
          )


        ],

      ),

    );

  }

  ///Item Notification
  Slidable itemNotification(int index, BuildContext context, ResultNL item) {
      /*return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.20,
        child: InkWell(
          onTap: (){

            if(singleton.notifierListNotfications.value.data!.result![index].notificationValue == 0){

              Notificationslist notifierGaneRoom = singleton.notifierListNotfications.value;
              notifierGaneRoom.data!.result![index].notificationValue = 1;
              singleton.notifierListNotfications.value = Notificationslist(code: 1,message: "No hay nada", status: false, );
              singleton.notifierListNotfications.value = notifierGaneRoom;

              itemdelete = index;

              if(type=="GN"){
                  if(item.notificationValue!=1){ /// Not Seen

                  }

                  var time = 350;
                  if(singleton.isIOS == false){
                    time = utils.ValueDuration();
                  }

                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: NotificationssDetail(type: item.notification!.type!,idSequence: item.notification!.id!,itemdelte: index,),
                      reverseDuration: Duration(milliseconds: time)
                  ));

                  //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: item.notification!.type!,idSequence: item.notification!.id!,itemdelte: index,) ));

              }else{
                  //item.notificationValue
                  singleton.GaneOrMira = "push";
                  singleton.isOnNotificationView = true;
                  utils.openProgress(context);
                  servicemanager.fetchClickSequenceNotification(item.notification!.id!, "SEQUENCE", context);
              }

            }


          },
          child: Align(
            //alignment: Alignment.topCenter,
            //heightFactor: 1.0,
            child: Container(
              //padding: EdgeInsets.all(16),
              decoration: new BoxDecoration(
                color: item.notificationValue==1 ? CustomColors.graycountry : CustomColors.orangenoti,
                boxShadow: <BoxShadow>[
                  new BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 6, offset: Offset(2, 1)),
                ],
                //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              child: Container(
                padding: EdgeInsets.only(top: 15,bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    ///Flag
                    Container(
                      height: 70,
                      width: 70,
                      margin: EdgeInsets.only(left: 20,),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CachedNetworkImage(

                          imageUrl: item.notification!.ntImage!,
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

                    /// Text
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10,right: 20,),
                        //color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              child: Text(item.notification!.title!,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontFamily: item.notificationValue==1 ? Strings.font_medium : Strings.font_bold,
                                      fontSize:14,
                                      //color: item.notificationValue==1 ? CustomColors.grayalert1 : CustomColors.white),
                                      color: CustomColors.grayalert1),
                                  textAlign: TextAlign.start
                              ),
                            ),

                            Container( ///
                              //child: Text(DateFormat.yMMMMd("es_ES").format(DateTime.parse("2021-10-23")),
                              child: Text(DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(item.options!.createdAt!,).toLocal()),
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontFamily: Strings.font_medium,
                                      fontSize:12,
                                      //color: item.notificationValue==1 ? CustomColors.grayButton : CustomColors.white.withOpacity(0.5)),
                                      color: CustomColors.grayalert1),
                                  textAlign: TextAlign.start
                              ),
                            ),

                            item.notificationValue==1 ? Container(height: 1,) : RichText(
                              textScaleFactor: 1.0,
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  //color: Colors.black,
                                ),
                                children: <TextSpan>[

                                  new TextSpan(text: Strings.seemore,
                                      style: TextStyle(
                                        fontFamily: Strings.font_bold, color: item.notificationValue==1 ? Colors.transparent : CustomColors.orangeswitch, fontSize: 12.0,
                                        decoration: TextDecoration.underline,
                                        decorationColor: item.notificationValue==1 ? Colors.transparent : CustomColors.orangeswitch,
                                      ),

                                  ),


                                ],
                              ),
                            ),

                          ],

                        ),
                      ),
                    ),

                  ],

                ),
              ),

            ),
          ),
        ),
        secondaryActions: <Widget>[

          Container(
              decoration: new BoxDecoration(
                color: CustomColors.reddelete,
              ),
              child: IconSlideAction(
                  key: Key('delete'),
                  color: Colors.transparent,
                  iconWidget: Container(
                    child: SvgPicture.asset(
                      'assets/images/iconobasurero.svg',
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    itemdelete = index;
                    dialogDeleteNoification(context,deleteNotification,singleton.notifierListNotfications.value.data!.result![itemdelete]!.id!,singleton.notifierListNotfications.value.data!.result![itemdelete]!.notification!.id!);
                  }
              )
          ),

        ],

      );*/

    return Slidable(
      key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          itemdelete = index;
          dialogDeleteNoification(context,deleteNotification,singleton.notifierListNotfications.value.data!.result![itemdelete]!.id!,singleton.notifierListNotfications.value.data!.result![itemdelete]!.notification!.id!);
        }),
        children:  [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: predelete,
            backgroundColor: CustomColors.orangeborderpopup,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '',
          ),

        ],
      ),
      child: InkWell(
        onTap: (){
          if(singleton.notifierListNotfications.value.data!.result![index].notificationValue == 0){

            Notificationslist notifierGaneRoom = singleton.notifierListNotfications.value;
            notifierGaneRoom.data!.result![index].notificationValue = 1;
            singleton.notifierListNotfications.value = Notificationslist(code: 1,message: "No hay nada", status: false, );
            singleton.notifierListNotfications.value = notifierGaneRoom;

            itemdelete = index;

            if(type=="GN"){
              if(item.notificationValue!=1){ /// Not Seen

              }

              var time = 350;
              if(singleton.isIOS == false){
                time = utils.ValueDuration();
              }

              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: NotificationssDetail(type: item.notification!.type!,idSequence: item.notification!.id!,itemdelte: index,),
                  reverseDuration: Duration(milliseconds: time)
              ));

              //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: item.notification!.type!,idSequence: item.notification!.id!,itemdelte: index,) ));

            }else{
              //item.notificationValue
              singleton.GaneOrMira = "push";
              singleton.isOnNotificationView = true;
              utils.openProgress(context);
              servicemanager.fetchClickSequenceNotification(item.notification!.id!, "SEQUENCE", context);
            }

          }
        },
        child: Align(
          //alignment: Alignment.topCenter,
          //heightFactor: 1.0,
          child: Container(
            //padding: EdgeInsets.all(16),
            decoration:  BoxDecoration(
              color: item.notificationValue==1 ? CustomColors.graycountry : CustomColors.orangenoti,
              boxShadow: <BoxShadow>[
                new BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 6, offset: Offset(2, 1)),
              ],
              //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 15,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  ///Flag
                  Container(
                    height: 70,
                    width: 70,
                    margin: EdgeInsets.only(left: 20,),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: CachedNetworkImage(

                        imageUrl: item.notification!.ntImage!,
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

                  /// Text
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 20,),
                      //color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Container(
                            child: Text(item.notification!.title!,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontFamily: item.notificationValue==1 ? Strings.font_medium : Strings.font_bold,
                                    fontSize:14,
                                    //color: item.notificationValue==1 ? CustomColors.grayalert1 : CustomColors.white),
                                    color: CustomColors.grayalert1),
                                textAlign: TextAlign.start
                            ),
                          ),

                          Container( ///
                            //child: Text(DateFormat.yMMMMd("es_ES").format(DateTime.parse("2021-10-23")),
                            child: Text(DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(item.options!.createdAt!,).toLocal()),
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontFamily: Strings.font_medium,
                                    fontSize:12,
                                    //color: item.notificationValue==1 ? CustomColors.grayButton : CustomColors.white.withOpacity(0.5)),
                                    color: CustomColors.grayalert1),
                                textAlign: TextAlign.start
                            ),
                          ),

                          item.notificationValue==1 ? Container(height: 1,) : RichText(
                            textScaleFactor: 1.0,
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: 12.0,
                                //color: Colors.black,
                              ),
                              children: <TextSpan>[

                                new TextSpan(text: Strings.seemore,
                                  style: TextStyle(
                                    fontFamily: Strings.font_bold, color: item.notificationValue==1 ? Colors.transparent : CustomColors.orangeswitch, fontSize: 12.0,
                                    decoration: TextDecoration.underline,
                                    decorationColor: item.notificationValue==1 ? Colors.transparent : CustomColors.orangeswitch,
                                  ),

                                ),


                              ],
                            ),
                          ),

                        ],

                      ),
                    ),
                  ),

                ],

              ),
            ),

          ),
        ),
      ),
    );
  }

  void predelete(BuildContext context) {

  }


  /// delete notification
  void deleteNotification(){
    singleton.notifierListNotfications.value.data!.result!.removeAt(itemdelete);
    Notificationslist notifierNotificationsPrevius = singleton.notifierListNotfications.value;
    singleton.notifierListNotfications.value = Notificationslist(code: 1,message: "No hay nada",status: false,);
    singleton.notifierListNotfications.value = notifierNotificationsPrevius;
  }

  /// AppBar
  Widget AppBar(BuildContext context){

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
                          Strings.notificationsroom,
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

            ValueListenableBuilder(
                valueListenable: notifierTab,
                builder: (context,value1,_){

                  return Container(
                    height: 60,
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        SizedBox(width: 30,),

                        Expanded(
                          child: SpringButton(
                            SpringButtonType.OnlyScale,
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: value1== 0 ? CustomColors.orangeback : CustomColors.graybackhome,
                                borderRadius: BorderRadius.all(const Radius.circular(10)),
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
                                        child: AutoSizeText(
                                          Strings.general,
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.0,
                                          //maxLines: 1,
                                          style: TextStyle(fontFamily: Strings.font_semibold, color: value1== 0 ? CustomColors.white : CustomColors.grayTextemptyhome, fontSize: 14.0,),
                                          //maxLines: 1,
                                        ),
                                      ),
                                    ),

                                  ],

                                ),
                              ),
                            ),
                            useCache: false,
                            onTap: (){
                              notifierTab.value = 0;
                              type = "GN";
                              launchFetch();
                            },

                            //onTapDown: (_) => decrementCounter(),

                          ),
                        ),

                        SizedBox(width: 30,),

                        Expanded(
                          child: SpringButton(
                            SpringButtonType.OnlyScale,
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: value1== 1 ? CustomColors.orangeback : CustomColors.graybackhome,
                                borderRadius: BorderRadius.all(const Radius.circular(10)),
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
                                        child: AutoSizeText(
                                          Strings.myads,
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 1.0,
                                          //maxLines: 1,
                                          style: TextStyle(fontFamily: Strings.font_semibold, color: value1== 1 ? CustomColors.white : CustomColors.grayTextemptyhome, fontSize: 14.0,),
                                          //maxLines: 1,
                                        ),
                                      ),
                                    ),

                                  ],

                                ),
                              ),
                            ),
                            useCache: false,
                            onTap: (){
                              notifierTab.value = 1;
                              type = "SEQUENCE";
                              launchFetch();
                            },

                            //onTapDown: (_) => decrementCounter(),

                          ),
                        ),

                        SizedBox(width: 30,),

                      ],

                    ),
                  );

                }
            )

          ],

        )
    );

  }


}





