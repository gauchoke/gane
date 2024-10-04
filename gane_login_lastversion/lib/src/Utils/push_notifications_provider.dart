
//Imports
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/UI/Notifications/notificationsdetail.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:page_transition/page_transition.dart';

class PushNotificationsProvider{

  late FirebaseMessaging _firebaseMessaging;
  late StreamSubscription iosSubscription;
  final singleton = Singleton();

  final _messageStreamController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get message => _messageStreamController.stream;
  final prefs = SharePreference();

  initNotifications(){

      _firebaseMessaging = FirebaseMessaging.instance;

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) { /// Close app
        if (message != null) {

          prefs.dataMessage = "Push";

          if(singleton.idPush != int.parse(message.data["id"])){ /// Only once time
            singleton.idPush = int.parse(message.data["id"]);

            Future.delayed(const Duration(milliseconds: 3200), () {

              singleton.isOnNotificationView = false;

              if(message.data["type"]=="GN"){ /// General Notifications
                //Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: "GN",idSequence: int.parse(message.data["id"]),) ));
                Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: message.data["type"],idSequence: int.parse(message.data["id"]),) ));

              }else if(message.data["type"]=="ADSWEB"){ /// General Notifications Enlace
                Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: message.data["type"],idSequence: int.parse(message.data["id"]),) ));

              }else{ /// Sequence notifications
                singleton.GaneOrMira = "push";
                utils.openProgress(singleton.navigatorKey.currentContext!);
                servicemanager.fetchClickSequenceNotification(int.parse(message.data["id"]), "SEQUENCE", singleton.navigatorKey.currentContext!);
              }

            });


          }

        }
      });

    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token){
      print("====FCM Token===");
      print("token usuario " + token!);
      prefs.token = token;
    });




    FirebaseMessaging.onMessage.listen((RemoteMessage message) { /// Foreground
      /*   RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;*/
      print('A new onMessage event was published!');
      print(message.data["id"]);
      print(message.data["type"]);
      print(message..notification!.title);
      print(message..notification!.body);
      //print(message..notification!.android!.imageUrl!);

      if(singleton.idPush != int.parse(message.data["id"])){/// Only once time

        singleton.isOnNotificationView = false;
        showLocalPush(message);
      }

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { /// Tap notification
      print('A new onMessageOpenedApp event was published!');
      print('A new onMessage event was published!');
      print(message.data["id"]);
      print(message.data["type"]);
      print(message..notification!.title);
      print(message..notification!.body);
      //print(message..notification!.android!.imageUrl!);
      //prefs.dataMessage = message.notification!.body!;

      if(singleton.idPush != int.parse(message.data["id"])){ /// Only once time
        singleton.idPush = int.parse(message.data["id"]);

        singleton.isOnNotificationView = false;

        if(message.data["type"]=="GN"){ /// General Notifications
          Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: message.data["type"],idSequence: int.parse(message.data["id"]),) ));
        }else if(message.data["type"]=="ADSWEB"){ /// General Notifications Enlace
          Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: message.data["type"],idSequence: int.parse(message.data["id"]),) ));
        }else{ /// Sequence notifications
          singleton.GaneOrMira = "push";
          utils.openProgress(singleton.navigatorKey.currentContext!);
          servicemanager.fetchClickSequenceNotification(int.parse(message.data["id"]), "SEQUENCE", singleton.navigatorKey.currentContext!);
        }

      }


    });

    FirebaseMessaging.onBackgroundMessage(_messageHandler);



  }

  /// show local Push
  void showLocalPush(RemoteMessage message){

     /*BotToast.showCustomNotification(

        animationDuration: Duration(milliseconds: 200),
        animationReverseDuration: Duration(milliseconds: 200),
        duration: Duration(seconds: 3),
        backButtonBehavior: BackButtonBehavior.none,

        toastBuilder: (cancel) {

          return Material(
            color: Colors.transparent,

            child: InkWell(

              onTap: (){

                if(singleton.idPush != int.parse(message.data["id"])){ /// Only once time
                  singleton.idPush = int.parse(message.data["id"]);

                  if(message.data["type"]=="GN"){ /// General Notifications
                    Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: message.data["type"],idSequence: int.parse(message.data["id"]),) ));
                    //Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: "GN",idSequence: int.parse(message.data["id"]),) ));
                  }else if(message.data["type"]=="ADSWEB"){ /// General Notifications Enlace
                    Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: NotificationssDetail(type: message.data["type"],idSequence: int.parse(message.data["id"]),) ));
                  }else{ /// Sequence notifications
                    singleton.GaneOrMira = "push";
                    utils.openProgress(singleton.navigatorKey.currentContext!);
                    servicemanager.fetchClickSequenceNotification(int.parse(message.data["id"]), "SEQUENCE", singleton.navigatorKey.currentContext!);
                  }

                }

              },


              child: Card(
                margin: EdgeInsets.only(left: 20,right: 20),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: CustomColors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: CustomColors.graysearch, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  //margin: EdgeInsets.only(left: 20,right: 20),
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        ///Icon
                        Container(
                          //color: Colors.blue,
                          margin: EdgeInsets.only(left: 20),
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: singleton.isIOS == true ? message.notification!.apple!.imageUrl! : message.notification!.android!.imageUrl!,
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Image(
                                image: AssetImage('assets/images/ic_gane.png'),
                                color: CustomColors.graylines.withOpacity(0.6),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),

                        ///Text
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[

                                //Title
                                Container(
                                  //color: Colors.blue,
                                  child: AutoSizeText(
                                    message.notification!.title!,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: Strings.font_bold,
                                        fontSize: 14,
                                        color: CustomColors.graytext),
                                    maxLines: 2,
                                  ),
                                ),

                                //Body
                                Container(
                                  //color: Colors.green,
                                  child: AutoSizeText(
                                    message.notification!.body!,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontFamily: Strings.font_regular,
                                        fontSize: 14,
                                        color: CustomColors.graytext),
                                    maxLines: 2,
                                  ),
                                ),


                              ],

                            ),

                          ),
                        ),

                      ],

                    )

                ),
              ),


            ),

          );

        },
        enableSlideOff: true,
        onlyOne: true,
        crossPage: true
    );*/

  }

  Future<void> _messageHandler(RemoteMessage message) async {
    print('background message ${message.notification!.body}');
    //prefs.dataMessage = message.notification!.body!;
  }

  dispose(){
    _messageStreamController.close();
  }

}
