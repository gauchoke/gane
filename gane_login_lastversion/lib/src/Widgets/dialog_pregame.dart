import 'dart:ui';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';


final singleton = Singleton();
double heighty = 0.0;
servicesManager servicemanager = servicesManager();



dialogWinPointsGame(BuildContext contextContainer, String buttonLeft, Function playvideo, String title, String logo, String points, int format) async {

  print(MediaQuery.of(contextContainer).size.height); ///724
  print(MediaQuery.of(contextContainer).devicePixelRatio); /// 3.0

  if(MediaQuery.of(contextContainer).devicePixelRatio == 3.0){
    heighty = 20.0;
  }else if(MediaQuery.of(contextContainer).devicePixelRatio < 3.0){
    heighty = 80.0;
  }


  /*return showAnimatedDialog(
    barrierDismissible: false,
    context: contextContainer,
    animationType: DialogTransitionType.slideFromBottomFade,
    curve: Curves.easeOutQuad,
    duration: Duration(milliseconds: 600),
    builder: (BuildContext context) {
      return /*BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3,sigmaY: 3),
        child: */
        WillPopScope(
          onWillPop: () async => false,
          child: Material(
              //type: MaterialType.transparency,
              color: CustomColors.backgroundalert,
            child:  Container(
              color: CustomColors.backgroundalert,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Container(
                    height: 450,
                    //color: Colors.red,
                    child: Stack(

                      children: [

                        /// Center card
                        Align(
                          alignment: Alignment.center,
                          child:  Container(
                            //alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 30, left: 30,top: 30),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: CustomColors.white,
                                borderRadius: BorderRadius.all(const Radius.circular(13))
                            ),
                            child: Column(

                              //crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,

                                children: <Widget>[

                                  TextButton(
                                    onPressed: () {

                                      singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
                                      if(singleton.GaneOrMira == "mira"){
                                        singleton.GaneRoomPages = 0;
                                        servicemanager.fetchMiraRoom(context, "borrar");

                                      }else if(singleton.GaneOrMira == "gane"){
                                        singleton.Gane1RoomPages = 0;
                                        servicemanager.fetchGaneRoom(context, "borrar");

                                      }else{ /// Answers
                                        singleton.AnswersRoomPages = 0;
                                        servicemanager.fetchAnswersRoom(context, "borrar");
                                      }
                                      int count = 2;
                                      Navigator.of(context).popUntil((_) => count-- <= 0);
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(top: 10,),
                                      child: Image(
                                        image: AssetImage("assets/images/ic_close1.png"),
                                        width: 40.0,
                                        height:40.0,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 5,),

                                  /// Reward
                                  Container(
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
                                            child: Text(title,
                                                style: TextStyle(
                                                    fontFamily: Strings.font_bold,
                                                    fontSize: 14,
                                                    color: CustomColors.orangelight))
                                        ),

                                        /// Value
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            Text(
                                              '+',
                                              style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangeback, fontSize: 34.0,),
                                              maxLines: 1,
                                            ),

                                            /// Value
                                            Container(
                                              child: BorderedText(
                                                strokeWidth: 5.0,
                                                strokeColor: CustomColors.orangeback,
                                                child: Text(
                                                  singleton.formatter.format(double.parse(points)),
                                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowtext, fontSize: 34.0,),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),

                                            ///Coins
                                            Container(
                                              child: Container(
                                                child: Image(
                                                  width: 40,
                                                  height: 40,
                                                  image: AssetImage("assets/images/coins.png"),
                                                  fit: BoxFit.contain,
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

                                  SizedBox(
                                    height: 20,
                                  ),

                                  /// Button
                                  Container(
                                      margin: EdgeInsets.only(left: 60,right: 60),
                                      height: 45,
                                      decoration: BoxDecoration(
                                          color: CustomColors.orangeback2,
                                          borderRadius: BorderRadius.all(
                                              const Radius.circular(23))),
                                      child: Builder(builder: (BuildContext context) {
                                        return Container(
                                          width: double.infinity,
                                          child: ValueListenableBuilder<bool>(
                                              valueListenable: singleton.notifierVideoLoaded,
                                              builder: (context,value1,_){

                                                return value1== true ? TextButton(
                                                    key: Key('btnButtonLeft'),
                                                    onPressed: () {

                                                      if(format == 1){
                                                        playvideo();
                                                      }
                                                      Navigator.pop(context);

                                                    },
                                                    child: Text(buttonLeft,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: Strings.font_semibold,
                                                            fontSize: 16,
                                                            color: CustomColors.white))
                                                ) :
                                                TextButton(
                                                    key: Key('btnButtonLeft'),
                                                    onPressed: () {

                                                    },
                                                    child: Container(
                                                      child: const CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                );

                                              }

                                          ),
                                        );
                                      })
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                ]),
                          ),
                        ),

                        /// Logo
                        Align(
                          alignment: Alignment.topCenter,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: CustomColors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: 90,
                              height: 90,
                              child: CachedNetworkImage(
                                imageUrl: logo,
                                placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),

                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.contain,
                                useOldImageOnUrlChange: false,

                              ),
                            ),
                          ),
                        ),

                      ],

                    )
                  ),

                  /*Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child:  Container(
                          //alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 30, left: 30),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.all(const Radius.circular(13))
                          ),
                          child: Column(

                            //crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,

                              children: <Widget>[

                                TextButton(
                                  onPressed: () {

                                    singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
                                    if(singleton.GaneOrMira == "mira"){
                                      singleton.GaneRoomPages = 0;
                                      servicemanager.fetchMiraRoom(context, "borrar");

                                    }else{
                                      singleton.Gane1RoomPages = 0;
                                      servicemanager.fetchGaneRoom(context, "borrar");

                                    }
                                    int count = 2;
                                    Navigator.of(context).popUntil((_) => count-- <= 0);
                                  },
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(top: 10,),
                                    child: Image(
                                      image: AssetImage("assets/images/ic_close1.png"),
                                      width: 40.0,
                                      height:40.0,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 5,),

                                ///Image
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: CustomColors.graysearch,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.transparent, width: 1),
                                      borderRadius: BorderRadius.circular(13),
                                    ),

                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      /*child: Image.network(image),*/
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        height: 150,
                                        imageUrl: image,
                                        placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),

                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.contain,
                                        useOldImageOnUrlChange: false,

                                      ),
                                    ),
                                  ),
                                ),

                                /// Reward
                                Container(
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
                                          child: Text(title,
                                              style: TextStyle(
                                                  fontFamily: Strings.font_bold,
                                                  fontSize: 14,
                                                  color: CustomColors.orangelight))
                                      ),

                                      /// Value
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          Text(
                                            '+',
                                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangeback, fontSize: 34.0,),
                                            maxLines: 1,
                                          ),

                                          /// Value
                                          Container(
                                            child: BorderedText(
                                              strokeWidth: 5.0,
                                              strokeColor: CustomColors.orangeback,
                                              child: Text(
                                                singleton.formatter.format(double.parse(points)),
                                                style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowtext, fontSize: 34.0,),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),

                                          ///Coins
                                          Container(
                                            child: Container(
                                              child: Image(
                                                width: 40,
                                                height: 40,
                                                image: AssetImage("assets/images/coins.png"),
                                                fit: BoxFit.contain,
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

                                SizedBox(
                                  height: 20,
                                ),

                                /// Button
                                Container(
                                    margin: EdgeInsets.only(left: 60,right: 60),
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: CustomColors.orangeback2,
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(23))),
                                    child: Builder(builder: (BuildContext context) {
                                      return Container(
                                        width: double.infinity,
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: singleton.notifierVideoLoaded,
                                            builder: (context,value1,_){

                                              return value1== true ? TextButton(
                                                  key: Key('btnButtonLeft'),
                                                  onPressed: () {

                                                    if(format == 1){
                                                      playvideo();
                                                    }
                                                    Navigator.pop(context);

                                                  },
                                                  child: Text(buttonLeft,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: Strings.font_semibold,
                                                          fontSize: 16,
                                                          color: CustomColors.white))
                                              ) :
                                              TextButton(
                                                  key: Key('btnButtonLeft'),
                                                  onPressed: () {

                                                  },
                                                  child: Container(
                                                    child: const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                              );

                                            }

                                        ),
                                      );
                                    })
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                              ]),
                        ),
                    ),
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height / 5 - heighty,
                    //left: 0,
                    //right: 0,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: CustomColors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 90,
                        child: CachedNetworkImage(
                          imageUrl: logo,
                          placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),

                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.contain,
                          useOldImageOnUrlChange: false,

                        ),
                      ),
                    ),
                  )*/

                ],

              ),
            )
          ),
        );//,
      //);
    },
  );*/
   showDialog(
      context: contextContainer,
      barrierDismissible: true,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Material(
          //type: MaterialType.transparency,
            color: CustomColors.backgroundalert,
            child:  Container(
              color: CustomColors.backgroundalert,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Container(
                      height: 450,
                      //color: Colors.red,
                      child: Stack(

                        children: [

                          /// Center card
                          Align(
                            alignment: Alignment.center,
                            child:  Container(
                              //alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 30, left: 30,top: 30),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: CustomColors.white,
                                  borderRadius: BorderRadius.all(const Radius.circular(13))
                              ),
                              child: Column(

                                //crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,

                                  children: <Widget>[

                                    TextButton(
                                      onPressed: () {

                                        singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
                                        if(singleton.GaneOrMira == "mira"){
                                          singleton.GaneRoomPages = 0;
                                          servicemanager.fetchMiraRoom(context, "borrar");

                                        }else if(singleton.GaneOrMira == "gane"){
                                          singleton.Gane1RoomPages = 0;
                                          servicemanager.fetchGaneRoom(context, "borrar");

                                        }else{ /// Answers
                                          singleton.AnswersRoomPages = 0;
                                          servicemanager.fetchAnswersRoom(context, "borrar");
                                        }
                                        int count = 2;
                                        Navigator.of(context).popUntil((_) => count-- <= 0);
                                      },
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(top: 10,),
                                        child: Image(
                                          image: AssetImage("assets/images/ic_close1.png"),
                                          width: 40.0,
                                          height:40.0,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 5,),

                                    /// Reward
                                    Container(
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
                                              child: Text(title,
                                                  style: TextStyle(
                                                      fontFamily: Strings.font_bold,
                                                      fontSize: 14,
                                                      color: CustomColors.orangelight))
                                          ),

                                          /// Value
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              Text(
                                                '+',
                                                style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangeback, fontSize: 34.0,),
                                                maxLines: 1,
                                              ),

                                              /// Value
                                              Container(
                                                child: BorderedText(
                                                  strokeWidth: 5.0,
                                                  strokeColor: CustomColors.orangeback,
                                                  child: Text(
                                                    singleton.formatter.format(double.parse(points)),
                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowtext, fontSize: 34.0,),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),

                                              ///Coins
                                              Container(
                                                child: Container(
                                                  child: Image(
                                                    width: 40,
                                                    height: 40,
                                                    image: AssetImage("assets/images/coins.png"),
                                                    fit: BoxFit.contain,
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

                                    SizedBox(
                                      height: 20,
                                    ),

                                    /// Button
                                    Container(
                                        margin: EdgeInsets.only(left: 60,right: 60),
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: CustomColors.orangeback2,
                                            borderRadius: BorderRadius.all(
                                                const Radius.circular(23))),
                                        child: Builder(builder: (BuildContext context) {
                                          return Container(
                                            width: double.infinity,
                                            child: ValueListenableBuilder<bool>(
                                                valueListenable: singleton.notifierVideoLoaded,
                                                builder: (context,value1,_){

                                                  return value1== true ? TextButton(
                                                      key: Key('btnButtonLeft'),
                                                      onPressed: () {

                                                        if(format == 1){
                                                          playvideo();
                                                        }
                                                        Navigator.pop(context);

                                                      },
                                                      child: Text(buttonLeft,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily: Strings.font_semibold,
                                                              fontSize: 16,
                                                              color: CustomColors.white))
                                                  ) :
                                                  TextButton(
                                                      key: Key('btnButtonLeft'),
                                                      onPressed: () {

                                                      },
                                                      child: Container(
                                                        child: const CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                  );

                                                }

                                            ),
                                          );
                                        })
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                  ]),
                            ),
                          ),

                          /// Logo
                          Align(
                            alignment: Alignment.topCenter,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: CustomColors.white,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                width: 90,
                                height: 90,
                                child: CachedNetworkImage(
                                  imageUrl: logo,
                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),

                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  useOldImageOnUrlChange: false,

                                ),
                              ),
                            ),
                          ),

                        ],

                      )
                  ),

                  /*Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child:  Container(
                          //alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 30, left: 30),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.all(const Radius.circular(13))
                          ),
                          child: Column(

                            //crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,

                              children: <Widget>[

                                TextButton(
                                  onPressed: () {

                                    singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
                                    if(singleton.GaneOrMira == "mira"){
                                      singleton.GaneRoomPages = 0;
                                      servicemanager.fetchMiraRoom(context, "borrar");

                                    }else{
                                      singleton.Gane1RoomPages = 0;
                                      servicemanager.fetchGaneRoom(context, "borrar");

                                    }
                                    int count = 2;
                                    Navigator.of(context).popUntil((_) => count-- <= 0);
                                  },
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(top: 10,),
                                    child: Image(
                                      image: AssetImage("assets/images/ic_close1.png"),
                                      width: 40.0,
                                      height:40.0,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 5,),

                                ///Image
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: CustomColors.graysearch,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.transparent, width: 1),
                                      borderRadius: BorderRadius.circular(13),
                                    ),

                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      /*child: Image.network(image),*/
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        height: 150,
                                        imageUrl: image,
                                        placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),

                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.contain,
                                        useOldImageOnUrlChange: false,

                                      ),
                                    ),
                                  ),
                                ),

                                /// Reward
                                Container(
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
                                          child: Text(title,
                                              style: TextStyle(
                                                  fontFamily: Strings.font_bold,
                                                  fontSize: 14,
                                                  color: CustomColors.orangelight))
                                      ),

                                      /// Value
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          Text(
                                            '+',
                                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangeback, fontSize: 34.0,),
                                            maxLines: 1,
                                          ),

                                          /// Value
                                          Container(
                                            child: BorderedText(
                                              strokeWidth: 5.0,
                                              strokeColor: CustomColors.orangeback,
                                              child: Text(
                                                singleton.formatter.format(double.parse(points)),
                                                style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowtext, fontSize: 34.0,),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),

                                          ///Coins
                                          Container(
                                            child: Container(
                                              child: Image(
                                                width: 40,
                                                height: 40,
                                                image: AssetImage("assets/images/coins.png"),
                                                fit: BoxFit.contain,
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

                                SizedBox(
                                  height: 20,
                                ),

                                /// Button
                                Container(
                                    margin: EdgeInsets.only(left: 60,right: 60),
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: CustomColors.orangeback2,
                                        borderRadius: BorderRadius.all(
                                            const Radius.circular(23))),
                                    child: Builder(builder: (BuildContext context) {
                                      return Container(
                                        width: double.infinity,
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable: singleton.notifierVideoLoaded,
                                            builder: (context,value1,_){

                                              return value1== true ? TextButton(
                                                  key: Key('btnButtonLeft'),
                                                  onPressed: () {

                                                    if(format == 1){
                                                      playvideo();
                                                    }
                                                    Navigator.pop(context);

                                                  },
                                                  child: Text(buttonLeft,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: Strings.font_semibold,
                                                          fontSize: 16,
                                                          color: CustomColors.white))
                                              ) :
                                              TextButton(
                                                  key: Key('btnButtonLeft'),
                                                  onPressed: () {

                                                  },
                                                  child: Container(
                                                    child: const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                              );

                                            }

                                        ),
                                      );
                                    })
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                              ]),
                        ),
                    ),
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height / 5 - heighty,
                    //left: 0,
                    //right: 0,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: CustomColors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 90,
                        child: CachedNetworkImage(
                          imageUrl: logo,
                          placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),

                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.contain,
                          useOldImageOnUrlChange: false,

                        ),
                      ),
                    ),
                  )*/

                ],

              ),
            )
        ),
      )
  );
}
/// Logo
