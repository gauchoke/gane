import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/roomgane.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/UI/Campaigns/campaignsdetail.dart';
import 'package:gane/src/UI/Campaigns/ganecampaignsdetail.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/Wallet/mywallet.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/my_flutter_app_icons.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_winpoints.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:badges/badges.dart' as badges;

class AnswersL extends StatefulWidget{

  final from;

  AnswersL({this.from});

  _stateAnswersL createState()=> _stateAnswersL();
}

class _stateAnswersL extends State<AnswersL> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  bool visibleTotalShopingCart = false;

  var imgCountry = "";
  var name = "";

  bool visibleUpdateApp = false;
  bool visibleOptionalUpdateApp = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final notifierOpacity = ValueNotifier(0.0);
  var itemSelected = -1;

  @override
  void initState(){
    singleton.GaneOrMira = "Answer";

    launchFetch();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      //
      Future.delayed(const Duration(milliseconds: 450), () {
        if(singleton.isOffline == false){
        }
        //launchFetch();

      });

      //showAlertWonPoints();

    });

    super.initState();
  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        // utils.dialogLoading(context);
        //utils.openProgress(context);
        singleton.AnswersRoomPages = 0;
        singleton.notifierAnswerRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchAnswersRoom(context, "borrar");
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Reset Load
  void _onRefresh() async{
    _refreshController.refreshCompleted();
    launchFetch();
  }

  ///Load More
  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();

    if(singleton.notifierAnswerRoom.value.code == 100){

      if(singleton.notifierAnswerRoom.value.data!.page! >= (singleton.AnswersRoomPages + 1)){
        singleton.AnswersRoomPages = singleton.AnswersRoomPages + 1;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            servicemanager.fetchAnswersRoom(context,"agregar");

          }
        } on SocketException catch (_) {
          print('not connected');
          singleton.isOffline = true;
          //Navigator.pop(context);
          ConnectionStatusSingleton.getInstance().checkConnection();
        }
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    return singleton.isOffline?  Nointernet() : OKToast(
        child: WillPopScope(
          onWillPop: backHandle.callToast,
          child: Scaffold(
            backgroundColor: CustomColors.graybackhome,
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: /*Container(
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                color: CustomColors.white,
                child: Stack(

                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(top: 80.0),
                      child: Container(),
                    ),

                    //_appBar(),

                    KeyboardActions(
                      tapOutsideToDismiss: false,
                      config: KeyboardActionsConfig(
                        keyboardSeparatorColor: CustomColors.white,
                        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,

                        actions: [

                          KeyboardActionsItem(
                            displayArrows: false,
                            focusNode: _focusNodeQuantity,
                            toolbarButtons: [
                              //button 2
                                  (node) {
                                return GestureDetector(
                                  onTap: () => node.unfocus(),
                                  child: Container(
                                    //color: Colors.black,
                                    padding: EdgeInsets.only(right: 16),
                                    child: Text(
                                      Strings.accept,
                                      style: TextStyle(color: CustomColors.graytext2),
                                    ),
                                  ),
                                );
                              }
                            ],
                          ),
                        ],
                      ),
                      child: _fields(context),
                    ),

                  ],
                ),




              ),*/

              Stack(
                //fit:  StackFit.expand ,
                children: [

                  _fields(context),

                  AppBar(),

                  WinBond(context),


                ],
              ),

            ),
          ),
        )
    );


  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Fields List
  Widget _fields(BuildContext context){

    return Container(
      //padding: EdgeInsets.only(top: 90),
      //width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      //color: Colors.green,
      child: Container(
        //color: Colors.red,
        padding: EdgeInsets.only(left: 15,right: 15),
        child: ValueListenableBuilder<Roomlook>(
            valueListenable: singleton.notifierAnswerRoom,
            builder: (context,value1,_){

              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, distance: 30, offset: 90,),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: value1.code == 1 ? 6 : value1.code == 102 ? 2 : value1.code == 120 ? 0 : value1.data!.result!.length + 1,
                  itemBuilder: (BuildContext context, int index) {

                    if(index==0){
                      return Container(height: 80,);

                    }else if(value1.code == 1){
                      return utils.PreloadBanner();

                    }else if(value1.code == 102){
                      return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");

                    }else{

                      if(value1.data!.result!.length == 0){
                        return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");

                      }else
                      //return _Example01Tile(context, value1.data!.result![index-1],index-1);
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 230),
                          columnCount: 3,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _Example01Tile(context, value1.data!.result![index-1],index-1),
                            ),
                          ),
                        );

                    }
                    //return _tiles[index];
                    //return index==0 ?  CompleteProfile() :  _tiles[index];
                    //return index==0 ?  CompleteProfile() :  utils.emptyHome(Strings.emptyhome, Strings.categories, "assets/images/emptyhome.png");

                  } ,
                  staggeredTileBuilder: (int index) {
                    if (index== 0) {
                      //return StaggeredTile.count(4, 1);

                      if( MediaQuery.of(context).devicePixelRatio >= 2.0 && MediaQuery.of(context).devicePixelRatio <= 3.0){
                        return StaggeredTile.count(4, 1);
                      }else if(MediaQuery.of(context).devicePixelRatio < 2.0){
                        if(MediaQuery.of(context).size.height > 1000.0){
                          return StaggeredTile.count(4, 0.83);
                        }else return StaggeredTile.count(4, 1.1);
                      }else{
                        return StaggeredTile.count(4, 0.9);
                      }


                    } else {
                      if (value1.code == 102) {
                        return StaggeredTile.count(4, 4);
                      } else {
                        return StaggeredTile.count(4, 1.2);
                      }
                    }
                    //return index==0 ?  StaggeredTile.count(4, 1.487) : _staggeredTiles[index];
                    //return index==0 ?  StaggeredTile.count(4, 1.487) : StaggeredTile.count(4, 5);
                  },
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  padding: const EdgeInsets.all(4),
                ),
              );

            }

        ),

      ),


    );

  }

  /// Item
  Widget _Example01Tile(BuildContext context, ResultSL item, int index){

    return GestureDetector(
      onTap: () {

        singleton.itemSequence = item;

        singleton.format=3;
        /*itemSelected = index;
        singleton.idSecuence = item.id!;
        singleton.idAds = item.ads![0]!.id!;
        singleton.format = item.ads![0]!.formatValue!;
        singleton.notifierPointsGaneRoom.value = item.ads![0]!.pointsAds!;
        //Navigator.push(context, Transition(child: CampaignDetail(onWonCoin: launchFetchObtainPointsAds,item: item,),curve: Curves.bounceOut , transitionEffect: TransitionEffect.RIGHT_TO_LEFT), );
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: CampaignDetail(onWonCoin: launchFetchObtainPointsAds,item: item,) ));

        */
        itemSelected = index;
        singleton.GaneOrMira = "Answer";
        singleton.notifierHeightViewQuestions.value = MediaQuery.of(context).size.height-150;
        singleton.itemSelected = index;
        singleton.idSecuence = item.id!;
        singleton.idAds = item.ads![0]!.id!;
        singleton.format = item.ads![0]!.formatValue!;

        /*int value = 0;
        for(int i=0; i<item.ads!.length;i++){
          value = value + int.parse(item.ads![0]!.pointsAds!);
        }

        singleton.notifierPointsGaneRoom.value = value.toString();*/
        singleton.notifierPointsGaneRoom.value = utils.valuePointsAds(item).toString();

        if(item.ads![0]!.formatValue == 3){ /// Poll
          singleton.notifierQuestionAds.value = item.ads![0]!.questionAds!;
        }else{
          singleton.notifierQuestionAds.value = <QuestionAds>[];
        }

        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: GaneCampaignDetail(item: item,relaunch: showAlertWonPoints,) ));

        },
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: CustomColors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
                child: Stack(

                  children: [

                    /// Image and title
                    Container(
                      alignment: Alignment.center,
                      //color: Colors.red,

                      child: Row(

                        children: [

                          ///Image
                          Container(
                            margin: EdgeInsets.only(left: 20,right: 10),
                            width: 80,
                            height: 80,
                            /*createRectTween: (begin, end) {
                        //return CustomRectTween(a: begin, b: end);
                        return CustomRectTween(a: begin!, b: end!);
                      },*/
                            //tag: item.id!,
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              //imageUrl: item.ads![0]!.formatValue == 1 ? item.ads![0]!.lgImages! : item.ads![0]!.adImages!,
                              imageUrl: item.ads![0]!.adImages!,
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

                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: AutoSizeText(
                                Strings.completeprofile,
                                textAlign: TextAlign.left,
                                //maxLines: 2,
                                style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_bold, color: CustomColors.grayalert1,),
                                //maxLines: 1,
                              ),
                            ),
                          ),

                        ],

                      ),
                    ),



                    /// Value coins
                    /*Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                          ),
                          color: CustomColors.orangeback1,
                        ),
                        child: Container(
                          //padding: EdgeInsets.only(top: 7,bottom: 7),
                          padding: EdgeInsets.only(top: 1,bottom: 1),
                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              ///Value
                              Expanded(
                                child: Container(

                                  //color: Colors.blue,
                                  child: Text(singleton.formatter.format(double.parse(item.ads![0]!.pointsAds!)),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontFamily: Strings.font_black, color: CustomColors.white, fontSize: 14,),
                                  ),
                                ),
                              ),

                              ///Icon
                              Container(
                                //padding: EdgeInsets.only(left: 5,right: 5),
                                padding: EdgeInsets.only(left: 2,right: 5),
                                child: Image(
                                  width: 20,
                                  height: 20,
                                  image: AssetImage("assets/images/coins.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),

                            ],

                          ),
                        ),
                      ),
                    ),*/
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.only(top: 1,bottom: 1,left: 8,right: 5),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                          ),
                          color: CustomColors.orangeback1,
                        ),
                        child: Row(

                          //mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            ///Value
                            Container(
                              //color: Colors.blue,
                              child: AutoSizeText(
                                //singleton.formatter.format(double.parse(item.ads![0]!.pointsAds!)),
                                singleton.formatter.format(utils.valuePointsAds(item)),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                style: TextStyle(fontFamily: Strings.font_black, color: CustomColors.white, fontSize: 14,),
                                //maxLines: 1,
                              ),
                            ),

                            ///Icon
                            Container(
                              //padding: EdgeInsets.only(left: 5,right: 5),
                              child: Image(
                                width: 15,
                                height: 15,
                                image: AssetImage("assets/images/coins.png"),
                                fit: BoxFit.contain,
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
    );

  }

  /// Obtain offset
  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());
    notifierOpacity.value = 0.0;

    /*singleton.notifierOffsetTapGane.value = [x-20,y];
    if(x>=250){
      singleton.notifierOffsetInitialTapGane.value = [x-70,y];
    }else singleton.notifierOffsetInitialTapGane.value = [x-20,y];*/

    singleton.valuenotifierOffsetTapCategory = [];
    singleton.valuenotifierOffsetInitialTapCategory = [];

    singleton.valuenotifierOffsetTapCategory.add(x-20);
    singleton.valuenotifierOffsetTapCategory.add(y);

    if(x>=250){
      singleton.valuenotifierOffsetInitialTapCategory.add(x-70);
    }else{
      singleton.valuenotifierOffsetInitialTapCategory.add(x-20);
    }
    singleton.valuenotifierOffsetInitialTapCategory.add(y);

  }

  /// Run coin animation
  void onAnimationCoin(){


    Future.delayed(const Duration(milliseconds: 400), () {
      singleton.notifierOffsetTapGane.value = [MediaQuery.of(context).size.width-130,40];

    });

    Future.delayed(const Duration(milliseconds: 550), () {
      notifierOpacity.value = 1.0;
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      notifierOpacity.value = 0.0;
      Roomlook notifierGaneRoom = singleton.notifierAnswerRoom.value;
      notifierGaneRoom.data!.result!.removeAt(itemSelected);
      singleton.notifierAnswerRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
      if(notifierGaneRoom.data!.result!.length >0){
        singleton.notifierAnswerRoom.value = notifierGaneRoom;
      }else{
        launchFetch();
      }

    });

  }

  /// Win Bond
  Widget WinBond(BuildContext context){

    return ValueListenableBuilder<List>(
        valueListenable: singleton.notifierOffsetTapGane,
        builder: (context,value1,_){

          return Container(
            //color: Colors.deepPurpleAccent,
            child: ValueListenableBuilder<double>(
                valueListenable: notifierOpacity,
                builder: (context,value4,_){

                  return Container(
                    //color: Colors.amberAccent,
                    width: value4==0 ? 0 : MediaQuery.of(context).size.width,
                    height: value4==0 ? 0 : MediaQuery.of(context).size.height,
                    child: Opacity(
                        opacity: value4,
                        child: Stack(

                          children: [

                            ValueListenableBuilder<String>(
                                valueListenable: singleton.notifierPointsGaneRoom,
                                builder: (context,value,_){

                                  return ValueListenableBuilder<List>(
                                      valueListenable: singleton.notifierOffsetInitialTapGane,
                                      builder: (context,value2,_){

                                        return Container(
                                          //color: Colors.deepPurpleAccent,
                                          margin: EdgeInsets.only(top: value2[1],left: value2[0]),
                                          child: BorderedText(
                                            strokeWidth: 5.0,
                                            strokeColor: CustomColors.orangeback,
                                            child: Text(
                                              '+' + singleton.formatter.format(double.parse(value)),
                                              style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowtext, fontSize: 40.0,),
                                              maxLines: 1,
                                            ),
                                          ),
                                        );

                                      }

                                  );

                                }

                            ),

                            AnimatedContainer(
                              //color: Colors.lime,
                              duration: Duration(milliseconds: 1550),
                              curve: Curves.fastOutSlowIn,
                              margin: EdgeInsets.only(top: value1[1],left: value1[0]),
                              child: Image(
                                width: 70,
                                height: 70,
                                image: AssetImage("assets/images/coins.png"),
                                fit: BoxFit.contain,
                              ),
                            ),

                          ],

                        )
                    ),
                  );

                }


            ),
          );

        }

    );

  }

  /// Show Alert won points
  void showAlertWonPoints(){

    singleton.notifierOffsetTapGane.value = [singleton.valuenotifierOffsetTapCategory[0],singleton.valuenotifierOffsetTapCategory[1]];
    singleton.notifierOffsetInitialTapGane.value = [singleton.valuenotifierOffsetInitialTapCategory[0],singleton.valuenotifierOffsetInitialTapCategory[1]];


    //onAnimationCoin();
    Future.delayed(const Duration(milliseconds: 400), () {
      onAnimationCoin();
      //dialogWinPoints(context, Strings.greatwin, Strings.activate4, Strings.activate3,onAnimationCoin,singleton.notifierPointsGaneRoom.value);

    });
  }

  /// Obtain Points Ads
  void launchFetchObtainPointsAds()async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        Future.delayed(const Duration(milliseconds: 400), () {
          //utils.openProgress(context);
         // servicemanager.fetchObtainPointsLookRoom(context,showAlertWonPoints);
        });

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

}

///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  @override

  Widget build(BuildContext context) {

    return Container(
      height: 110,
      //color: CustomColors.red,
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),

      child: Stack(

        children: [

          ///Background
          Container(
            /*child: Image(
              height: 90,
              image: AssetImage("assets/images/baner.png"),
              fit: BoxFit.cover,
            ),*/
            height: 110,
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              'assets/images/headernew.svg',
              fit: BoxFit.cover,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              ///Logo
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  //color: Colors.blue,
                  padding: EdgeInsets.only(top: 40,left: 20),
                  child: Image(
                    width: 80,
                    height: 42,
                    image: AssetImage("assets/images/logohome.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              ///Coins
              SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  padding: EdgeInsets.only(right: 10,left: 10,),
                  //color: Colors.red,
                  child: Container(
                    child: Image(
                      width: 40,
                      height: 40,
                      image: AssetImage("assets/images/coins.png"),
                      fit: BoxFit.contain,
                    ),
                  ),

                ),
                useCache: false,
                onTap: (){
                  Navigator.push(
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
                  );
                },

                //onTapDown: (_) => decrementCounter(),

              ),

              ///Notifications
              SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  padding: EdgeInsets.only(right: 15,),
                  //color: Colors.blue,
                  child: ValueListenableBuilder<String>(
                      valueListenable: singleton.notifierNotificationCount,
                      builder: (context,value,_){

                        /*return Badge(
                          position: BadgePosition.topEnd(top: 2,end: 0),
                          toAnimate: true,
                          animationType: BadgeAnimationType.scale,
                          showBadge: value == "0" ? false : true,
                          badgeColor: CustomColors.blueBack,
                          badgeContent: Text(value,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11.0,fontFamily: Strings.font_bold, color: CustomColors.white,),
                          ),
                          child: Container(
                            child: Image(
                              width: 40,
                              height: 40,
                              image: AssetImage("assets/images/notifications.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );*/

                        return badges.Badge(
                          badgeContent: Text(value,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11.0,fontFamily: Strings.font_bold, color: CustomColors.white,),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: CustomColors.blueBack,
                          ),
                          position: badges.BadgePosition.topEnd(top: 0, end: 5),
                          child: Container(
                            child: Image(
                              width: 40,
                              height: 40,
                              image: AssetImage("assets/images/notifications.png"),
                              fit: BoxFit.contain,
                            ),
                          )
                        );

                      }

                  ),

                ),
                useCache: false,
                onTap: (){

                  Navigator.push(
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
                  );

                  /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GamePage(3, 9)));*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SinglePlayerGame(
                        difficulty: GameDifficulty.Easy,
                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RunGame(
                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScoreBoard(
                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BirdGame(
                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchPage(
                          mode: Mode.PVC,
                          cpu: HarderCpu(
                          //Random().nextBool() ? Color.RED : Color.YELLOW),
                          Color.YELLOW),

                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoardWidget(
                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlipCardGane(
                          Level.Medium),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BubbleScreen(
                          ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PacHomePage(
                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingScreen(
                      ),
                    ),
                  );*/

                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HangHomeScreen(
                      ),
                    ),
                  );*/

                },


              ),


            ],
          )

        ],

      ),


    );

  }

}

class CustomRectTween extends RectTween {
  CustomRectTween({required this.a, required this.b}) : super(begin: a, end: b);
  final Rect a;
  final Rect b;

  @override
  Rect lerp(double t) {
    Curves.elasticOut.transform(t);
    //any curve can be applied here e.g. Curve.elasticOut.transform(t);
    final verticalDist = Cubic(0.72, 0.15, 0.5, 1.23).transform(t);

    final top = lerpDouble(a.top, b.top, t) * (1 - verticalDist);
    return Rect.fromLTRB(
      lerpDouble(a.left, b.left, t),
      top,
      lerpDouble(a.right, b.right, t),
      lerpDouble(a.bottom, b.bottom, t),
    );
  }

  double lerpDouble(num a, num b, double t) {
    if (a == null && b == null) return 0.0;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}