import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/bannerWall.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/useraltam.dart';
import 'package:gane/src/Models/userpointlist.dart';
import 'package:gane/src/Models/userpointlist1.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/Models/verifyphone.dart';
import 'package:gane/src/UI/Home/pidechip.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/Onboarding/loginphone.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
import 'package:gane/src/UI/Onboarding/tyc1.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/image_picker_handler.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_banner.dart';
import 'package:gane/src/Widgets/dialog_redeem.dart';
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
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:transition/transition.dart';
import 'package:mime_type/mime_type.dart';
import 'package:badges/badges.dart' as badges;

class MyWallet extends StatefulWidget{

  final from;

  MyWallet({this.from});

  _stateMyWallet createState()=> _stateMyWallet();
}

class _stateMyWallet extends State<MyWallet> with  TickerProviderStateMixin, WidgetsBindingObserver{ //ImagePickerListener

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  //var _controllerPhone = TextEditingController();
  final formatter = new NumberFormat("#,###.##", "es_CO");
  bool visibleTotalShopingCart = false;

  var imgCountry = "";
  var name = "";

  bool visibleUpdateApp = false;
  bool visibleOptionalUpdateApp = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  late HomeProvider provider;


   ScrollController _scrollViewController = new ScrollController();
  final notifierRecomOrConsum = ValueNotifier(0);


  @override
  void initState(){

    singleton.notifierHeightNoPlanGane.value = 75;
    singleton.notifierHeightHeaderWallet.value = 180.0;


    //provider = Provider.of<HomeProvider>(context, listen: false);
    print(singleton.secuenceOne);
    print(singleton.secuenceTwo);
    print(singleton.secuenceThree);

    WidgetsBinding.instance!.addPostFrameCallback((_){

      launchFetch();
      print(MediaQuery.of(context).devicePixelRatio);
      print(MediaQuery.of(context).size.height);


      //_scrollViewController = new ScrollController();
      _scrollViewController.addListener(() {
        if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
          singleton.notifierHeightHeaderWallet.value = 90.0;
          singleton.notifierHeightNoPlanGane.value = 0.0;
        }

        if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
          /*if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }*/
          singleton.notifierHeightHeaderWallet.value = 180.0;
          singleton.notifierHeightNoPlanGane.value = 75;
        }
      });


    });

    super.initState();
  }

  @override

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

    if(singleton.notifierListUserPoints1.value.code == 100){

      //if(singleton.notifierListUserPoints.value.data!.page! >= (singleton.UserPointsPages + 1)){
        if(singleton.notifierListUserPoints1.value.data!.totalPages! >= (singleton.UserPointsPages + 1)){
        singleton.UserPointsPages = singleton.UserPointsPages + 1;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            //servicemanager.fetchListPointsUser(context,"agregar");
            servicemanager.fetchListPointsUser1(context,"agregar");
          }
        } on SocketException catch (_) {
          print('not connected');
          singleton.isOffline = true;
          //Navigator.pop(context);
          ConnectionStatusSingleton.getInstance().checkConnection();
        }
      }

    }

    /*if(provider.notifierLookRoomss.code == 100){

      if(provider.notifierLookRoomss.data!.page! >= (singleton.Gane1RoomPages + 1)){
        singleton.Gane1RoomPages = singleton.Gane1RoomPages + 1;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            Future callUser = servicemanager.fetchGaneRoom(context,"agregar");
            await callUser.then((data) {
              if (data.code == 100) {

                Roomlook notifierGaneRoom = provider.notifierLookRoomss;
                notifierGaneRoom.data!.result!.addAll(data.data!.result!);
                provider.notifierLookRoomss = Roomlook(code: 1,message: "No hay nada", status: false, );
                provider.notifierLookRoomss = notifierGaneRoom;

                //provider.notifierLookRoomss.data!.result!.addAll(data.data!.result!);
                print(provider.notifierLookRoomss);
              }

            }, onError: (error) {
            });

          }
        } on SocketException catch (_) {
          print('not connected');
          singleton.isOffline = true;
          //Navigator.pop(context);
          ConnectionStatusSingleton.getInstance().checkConnection();
        }
      }

    }*/


  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        singleton.notifierUserPoints.value = Userpoints(code: 1,message: "No hay nada", status: false, data: DataPU(result: "0") );
        singleton.UserPointsPages = 0;
        singleton.notifierListUserPoints.value = Userpointlist(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchPointUserPoints(context);
        singleton.UserPointsPages = 0;
        singleton.notifierListUserPoints1.value = Userpointlist1(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchListPointsUser1(context, "borrar");
        servicemanager.fetchSettings(context);
        servicemanager.fetchUserProfile(context);
        servicemanager.fetchUserAltam(context);
        //singleton.notifierBannerAltan.value = BannerWallet(code: 1,message: "No hay nada", status: false, data: DataW(item: ItemW( callingCode: "", photoUrl: "", sms: "", whatsapp: "")) );
        //servicemanager.fetchBannerAltan(context);

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //provider = Provider.of<HomeProvider>(context);
    return  ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                onWillPop: backHandle.callToast,
                child: Scaffold(
                  backgroundColor: CustomColors.white,
                  key: _scaffoldKey,
                  body: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                    child:

                    Stack(
                      children: [

                        _fields(context),
                        AppBar(),

                        /// No user Gane
                        ValueListenableBuilder<Getprofile>(
                            valueListenable: singleton.notifierUserProfile,
                            builder: (context,value2,_){

                              return value2.data!.user!.userAltan! == true ? Container(width: 0,height: 0,) : dataPlanGane(context);

                            }

                        ),
                      ],
                    ),

                  ),
                ),
              )
          );

        }

    );

  }

  /// Fields List
  Widget _fields(BuildContext context){

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderWallet,
        builder: (context,value2,_){

          return ValueListenableBuilder<Userpointlist1>(
              valueListenable: singleton.notifierListUserPoints1,
              builder: (context,value3,_){

                var parts = value3.message!.split('-');

                return Container(
                  color: CustomColors.graybackwallet,
                  //margin: EdgeInsets.only(top: value2),

                  child: value3.code == 102 ?
                  Container(
                      margin: EdgeInsets.only(left: 15,right: 15,top: value2+45),
                      child: utils.emptyWallete(parts.length>0 ? parts[0] : "", parts.length>1 ? parts[1] : "", "assets/images/emptywallet.svg")
                  ) :
                  Stack(

                    children: [

                      /// White Container
                      Container(
                        margin: EdgeInsets.only(left: 15,right: 15,top: value2+45),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          color: CustomColors.graybackwallet,
                          border: Border.all(
                            width: 1,
                            color: CustomColors.graybackwallet,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 1,
                              blurRadius: 9,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        //color: CustomColors.white,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - value2 -30,
                      ),

                      /// Table
                      ValueListenableBuilder<Userpointlist1>(
                          valueListenable: singleton.notifierListUserPoints1,
                          builder: (context,value1,_){

                            return  Container(
                              //color: Colors.green,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                                color: CustomColors.graybackwallet,

                              ),
                              margin: EdgeInsets.only(top: value2+45,left: 20,right: 20,bottom: 5),// 80 en top
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                                header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, distance: 30, offset: 0,),
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                child: value1.code == 102 ?

                                Container(
                                  //margin: EdgeInsets.only(top: 30),
                                  child: utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg"),
                                ) :

                                ListView.builder(
                                  //physics: AlwaysScrollableScrollPhysics(),
                                  //shrinkWrap: true,
                                  controller: _scrollViewController,
                                  padding: EdgeInsets.only(top: 0,left: 0,right: 0,),
                                  scrollDirection: Axis.vertical,
                                  itemCount: value1.code == 1 ? 9 : value1.code == 102 ? 1 : value1.code == 120 ? 0 : value1.data!.items!.length ,
                                  itemBuilder: (BuildContext context, int index){

                                    if(value1.code == 1){
                                      return utils.PreloadingPlane1();

                                    }else if(value1.code == 102){
                                      return utils.emptyHome(value1.message!, "", "assets/images/emptywallet.svg");

                                    }else{

                                      return itemPoints(value1.data!.items![index],index, context);

                                    }


                                  },

                                ),

                              ),
                            );

                          }

                      ),


                      /// Tabs Recom-Consu
                      /*Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      color: CustomColors.graytabs,
                      border: Border.all(
                        width: 1,
                        color: CustomColors.graytabs,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 15,right: 15,top: value2+30),
                    height: 50,
                    //color: CustomColors.greysearch,
                    child: ValueListenableBuilder<int>(
                              valueListenable: notifierRecomOrConsum,
                              builder: (context,value1,_){

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [

                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          notifierRecomOrConsum.value = 0;
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                              ),
                                              color: value1==0 ? CustomColors.white : Colors.transparent,
                                              border: Border.all(
                                                width: 1,
                                                color: value1==0 ? CustomColors.white : Colors.transparent,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            height: 50,
                                            //color: Colors.red,
                                            child: Text(Strings.recom,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: Strings.font_bold,
                                                    fontSize: 15,
                                                    color: value1==0 ? CustomColors.orangeswitch : CustomColors.orangesnack,
                                                ))
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          notifierRecomOrConsum.value = 1;
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                              ),
                                              color: value1==1 ? CustomColors.white : Colors.transparent,
                                              border: Border.all(
                                                width: 1,
                                                color: value1==1 ? CustomColors.white : Colors.transparent,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            height: 50,
                                            //color: Colors.yellow,
                                            child: Text(Strings.consumo,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: Strings.font_bold,
                                                    fontSize: 15,
                                                  color: value1==1 ? CustomColors.orangeswitch : CustomColors.orangesnack,
                                                ))
                                        ),
                                      ),
                                    )

                                  ],

                                );

                              }

                    ),
                    /*child: TabContainer(
                      color: CustomColors.greysearch,
                      //colors: [CustomColors.white,CustomColors.greysearch],
                      children: [
                        Container(
                          child: Text('Child 1'),
                        ),
                        Container(
                          child: Text('Child 2'),
                        ),
                      ],
                      tabs: [
                        'Tab 1',
                        'Tab 2',
                      ],
                    ),*/
                  ),*/

                    ],

                  ),

                );

              }

          );

        }

    );

  }

  /// Data Plan Gane
  Widget dataPlanGane(BuildContext context){

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightNoPlanGane,
        builder: (context,value2,_){

          return Container(
              margin: EdgeInsets.only(top: 140,left: 20,right: 20),
              //color: Colors.blue,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                   // margin: EdgeInsets.only(top: 125,left: 20,right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: value2,
                    decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(const Radius.circular(15)),
                      color: CustomColors.blueBack.withOpacity(0.9),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: ///Image
                      InkWell(
                        onTap: (){
                          //dialogBanner(context,launchCallOrWhat);

                          var time = 350;
                          if(singleton.isIOS == false){
                            time = utils.ValueDuration();
                          }
                          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimCard(),
                              reverseDuration: Duration(milliseconds: time)
                          )).then((value) {
                          });

                        },
                        child: ValueListenableBuilder<BannerWallet>(
                            valueListenable: singleton.notifierBannerAltan,
                            builder: (context,valueBanner,_){

                              /*return CachedNetworkImage(
                                fit: BoxFit.cover,
                                //imageUrl: "https://viva.com.do/wp-content/uploads/2021/01/Plan-Estudiantil-web-.png",
                                imageUrl: valueBanner.data!.item!.photoUrl!,
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
                              );*/

                              return Image.network(
                                valueBanner.data!.item!.photoUrl!,
                                //"http://url.com/image.png",
                                fit: BoxFit.cover,
                                frameBuilder: (_, image, loadingBuilder, __) {
                                  if (loadingBuilder == null) {
                                    return const SizedBox(
                                      child: Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFFF4D00),
                                          )
                                      ),
                                    );
                                  }
                                  return image;
                                },
                                loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return image;
                                  return SizedBox(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                            : null,
                                        color: Color(0xFFFF4D00),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) =>
                                    SvgPicture.asset(
                                      'assets/images/ic_gane.svg',
                                      fit: BoxFit.contain,

                                    ),
                              );

                            }

                        ),
                      ),
                    )

                ),
              ),
            );


        }

    );

  }

  ///Item Wallet
  /*Widget itemPoints(ResultLUP item, int index, BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(width: 1.0, color: CustomColors.graycountry),
        ),
      ),
      child: Container(
        //color: Colors.red,
        padding: EdgeInsets.only(top: 13,bottom: 13,left: 15,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[



            /// Texts
            Expanded(
              child: Container(
                //color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    /// Title
                    Container(
                      child: Text(item.title! == null ? "" : item.title!,
                          style: TextStyle(
                              fontFamily: Strings.font_bold,
                              fontSize:14,
                              color: CustomColors.grayalert1),
                          textAlign: TextAlign.start
                      ),
                    ),

                    /// Date
                    Container(
                      child: Text(DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(item.options!.createdAt!)),
                          style: TextStyle(
                              fontFamily: Strings.font_medium,
                              fontSize:12,
                              color: CustomColors.grayButton),
                          textAlign: TextAlign.start
                      ),
                    ),



                  ],

                ),
              ),
            ),

            SizedBox(width: 10,),

            /// Points
            Container(
              //color: Colors.red,
              child: Row(

                children: [

                  /// Points
                  Container(
                    margin: EdgeInsets.only(right: 2),
                    child: Text("+" +singleton.formatter.format(double.parse(item.points!)),
                        style: TextStyle(
                            fontFamily: Strings.font_bold,
                            fontSize:14,
                            color: CustomColors.greenbutton),
                        textAlign: TextAlign.center
                    ),
                  ),

                  ///Flag
                  SvgPicture.asset(
                    'assets/images/monedaroja.svg',
                    height: 12,
                    fit: BoxFit.cover,
                  ),

                ],

              ),
            ),

            /// Points
            /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SvgPicture.asset(
                  'assets/images/ic_coin.svg',
                  height: 30,
                  fit: BoxFit.cover,
                ),

                SizedBox(height: 5,),

                Container(
                  child: Text("+" +singleton.formatter.format(double.parse(item.points!)),
                      style: TextStyle(
                          fontFamily: Strings.font_bold,
                          fontSize:12,
                          color: CustomColors.orangeback1),
                      textAlign: TextAlign.center
                  ),
                ),

              ],
            ),*/

          ],

        ),
      ),

    );
  }*/
  Widget itemPoints(ItemsLUP1 item, int index, BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(width: 1.0, color: CustomColors.greysearch),
        ),
      ),
      child: Container(
        //color: Colors.red,
        padding: EdgeInsets.only(top: 13,bottom: 13,left: 15,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[



            /// Texts
            Expanded(
              child: Container(
                //color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    /// Title
                    Container(
                      child: Text(item.title! == null ? "" : item.title!,
                          style: TextStyle(
                              fontFamily: Strings.font_bold,
                              fontSize:17,
                              //color: CustomColors.grayalert1),
                              color: CustomColors.black),
                          textAlign: TextAlign.start,
                        textScaleFactor: 1.0,
                      ),
                    ),

                    /// Date
                    Container(
                      child: Text(DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.parse(item.options!.createdAt!).toLocal()),
                          style: TextStyle(
                              fontFamily: Strings.font_medium,
                              fontSize:13,
                              color: CustomColors.lightGreyProgrerss),
                          textAlign: TextAlign.start,
                        textScaleFactor: 1.0,
                      ),
                    ),



                  ],

                ),
              ),
            ),

            SizedBox(width: 10,),

            /// Points
            Container(
              //color: Colors.red,
              child: Row(

                children: [

                  /// Points
                  Container(
                    margin: EdgeInsets.only(right: 2),
                    child: Text( item.points!.toDouble() < 0.0 ? singleton.formatter.format(item.points!.toDouble()) :  "+" +singleton.formatter.format(item.points!.toDouble()),
                        style: TextStyle(
                            fontFamily: Strings.font_bold,
                            fontSize:16,
                            color:  item.points!.toDouble() < 0.0 ? CustomColors.redcanje : CustomColors.greenbutton),
                        textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                    ),
                  ),

                  ///Flag
                  SvgPicture.asset(
                    'assets/images/monedaroja.svg',
                    height: 15,
                    fit: BoxFit.cover,
                  ),

                  /*Container(
                    child: Stack(
                      alignment: Alignment.center,

                      children: [

                        Image(
                          image: AssetImage("assets/images/circuloonline.png"),
                          fit: BoxFit.cover,
                          width: 15,
                          height: 15,
                          //color: "#00A86B".toColors(),
                        ),

                        Image(
                          image: AssetImage("assets/images/monedaonline.png"),
                          fit: BoxFit.cover,
                          width: 15,
                          height: 15,
                          color: "#00A86B".toColors(),
                        )

                      ],

                    ),
                  )*/

                ],

              ),
            ),

            /// Points
            /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SvgPicture.asset(
                  'assets/images/ic_coin.svg',
                  height: 30,
                  fit: BoxFit.cover,
                ),

                SizedBox(height: 5,),

                Container(
                  child: Text("+" +singleton.formatter.format(double.parse(item.points!)),
                      style: TextStyle(
                          fontFamily: Strings.font_bold,
                          fontSize:12,
                          color: CustomColors.orangeback1),
                      textAlign: TextAlign.center
                  ),
                ),

              ],
            ),*/

          ],

        ),
      ),

    );
  }


  /// Call or Whats
  void launchCallOrWhat(String url){
    //url = url.replaceAll("+", "");
    utils.callOrWebView(url);

  }

  /// Change valUE SIM OR NOT
  void changeSIMOrNo(){

    Getprofile notifierGaneRoom = singleton.notifierUserProfile.value;
    //notifierGaneRoom.data!.user!.userAltan! = "true";
    singleton.notifierUserProfile.value = Getprofile(code: 1,message: "No hay nada", status: false, );
    singleton.notifierUserProfile.value = notifierGaneRoom;

  }

}

///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  servicesManager servicemanager = servicesManager();

  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderWallet,
        builder: (context,value2,_){

          return AnimatedContainer(
            height: value2,
            duration: Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,

            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Stack(

                children: [

                  ///Background
                  Container(
                    //margin: EdgeInsets.only(left: 30),
                    //color: CustomColors.orange,
                    height: value2,
                    width: MediaQuery.of(context).size.width,
                    child: value2 > 90.0 ? SvgPicture.asset(
                      'assets/images/headerprofile.svg',
                      fit: BoxFit.fill,
                    ) : Image(
                            image: AssetImage("assets/images/headernew.png"),
                            fit: BoxFit.fill,
                    ),
                      /*child: Container(
                        color: "#00A86B".toColors(),
                      )*/


                  ),

                  /// Data
                  Container(
                    //color: Colors.green,
                    child: Column(

                      children: [

                        /// Header
                        Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              ///Logo
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  //color: Colors.blue,
                                  padding: EdgeInsets.only(top: 35,left: 20),
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

                                  /*child: CachedNetworkImage(
                                    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/2560px-Amazon_logo.svg.png",
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Image(
                                      image: AssetImage('assets/images/ic_gane.png'),
                                      color: CustomColors.graylines.withOpacity(0.6),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    useOldImageOnUrlChange: true,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.contain,
                                    width: 80,
                                    height: 42,
                                  ),*/


                                ),
                              ),

                              /// User image
                              InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
                                },
                                child: Container(
                                  //color: Colors.green,
                                  margin: EdgeInsets.only(right: 10, top: 40,),
                                  alignment: Alignment.topCenter,
                                  child: Stack(

                                    children: [

                                      ClipOval(
                                        child: Container(
                                          color: Colors.white,
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left: 1.2,top: 1.2),
                                        //alignment: Alignment.center,
                                        child: ClipOval(
                                          child: ValueListenableBuilder<Getprofile>(
                                              valueListenable: singleton.notifierUserProfile,
                                              builder: (context,value1,_){

                                                return CachedNetworkImage(
                                                  width: 29,
                                                  height: 29,
                                                  imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                  //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                    width: 29,
                                                    height: 29,
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  useOldImageOnUrlChange: false,

                                                );

                                              }

                                          ),

                                        ),
                                      ),

                                    ],

                                  ),
                                ),
                              ),

                              ///Notifications
                              SpringButton(
                                SpringButtonType.OnlyScale,
                                Container(
                                  padding: EdgeInsets.only(right: 15,top: 40,),
                                  //color: Colors.blue,
                                  child: ValueListenableBuilder<String>(
                                      valueListenable: singleton.notifierNotificationCount,
                                      builder: (context,value,_){

                                        /*return Badge(
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
                                          ),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/notifications.svg',
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        );*/

                                        return badges.Badge(
                                            badgeContent: Text(
                                              value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                            ),
                                          showBadge: value == "0" ? false : true,
                                            badgeStyle: badges.BadgeStyle(
                                              badgeColor: CustomColors.blueBack,
                                            ),
                                          position: BadgePosition.topEnd(end: -2,),
                                            child: Container(
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


                              ),


                            ],
                          ),
                        ),

                        /// Data user Gane or No gane
                        ValueListenableBuilder<Getprofile>(
                            valueListenable: singleton.notifierUserProfile,
                            builder: (context,value1,_){

                              return value1.data!.user!.userAltan! == false ?
                              Container(/// Data No gane
                                margin: EdgeInsets.only(top: 10,),
                                padding: EdgeInsets.only(left: 15,right: 15),
                                height: 60,
                                //color: Colors.green,
                                child: Column(

                                  mainAxisAlignment: MainAxisAlignment.start,


                                  children: [


                                    /// Missing
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(Strings.dyh1,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 14,),
                                        textScaleFactor: 1.0,
                                      ),
                                    ),

                                    /// Value
                                    Container(
                                      //color: Colors.blue,

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [



                                          /// Value
                                          Container(
                                            //color: Colors.yellow,
                                            child: ValueListenableBuilder<Userpoints>(
                                                valueListenable: singleton.notifierUserPoints,
                                                builder: (context,value,_){

                                                  return AutoSizeText(
                                                    singleton.formatter.format(double.parse(value.code == 1 || value.code == 102 ? "0" : value.data!.result!),),
                                                    textAlign: TextAlign.left ,
                                                    maxLines: 1,
                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 27.0,),
                                                    textScaleFactor: 1.0,
                                                    //maxLines: 1,
                                                  );

                                                }

                                            ),

                                          ),

                                          SizedBox(width: 3,),

                                          /// Icon
                                          Container(
                                            //color: Colors.green,
                                            child: SvgPicture.asset(
                                              'assets/images/monedabilletera.svg',
                                              fit: BoxFit.contain,
                                              width: 20,
                                              height: 20,
                                            ),
                                          )

                                        ],

                                      ),
                                    ),


                                  ],

                                ),
                              ) :
                              ValueListenableBuilder<UserAltan>( /// user gane
                                  valueListenable: singleton.notifierUseraltan,
                                  builder: (context,value4,_){

                                    return Container(/// Data with gane
                                      margin: EdgeInsets.only(top: 10,),
                                      padding: EdgeInsets.only(left: 15,right: 15),
                                      height: 90,
                                      //color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [

                                          /// Do you have
                                          Expanded(
                                            child: Container(
                                              //color: Colors.green,
                                              child: Column(

                                                mainAxisAlignment: MainAxisAlignment.center,


                                                children: [

                                                  /// Missing
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Text(Strings.dyh,
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 12,),
                                                      textScaleFactor: 1.0,
                                                    ),
                                                  ),

                                                  SizedBox(height: 3,),

                                                  /// Value
                                                  /*Container(
                                                    alignment: FractionalOffset.center,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,

                                                      children: [

                                                        /// Value
                                                        Flexible(
                                                          flex: 1, // default value
                                                          fit:  FlexFit.loose,
                                                          child: Container(
                                                              //color: Colors.yellow,
                                                              child: ValueListenableBuilder<Userpoints>(
                                                                  valueListenable: singleton.notifierUserPoints,
                                                                  builder: (context,value,_){

                                                                    return AutoSizeText(
                                                                      singleton.formatter.format(double.parse(value.code == 1 || value.code == 102 ? "0" : value.data!.result!),),
                                                                      //singleton.formatter.format(9999999),
                                                                      textAlign: TextAlign.center ,
                                                                      maxLines: 1,
                                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 25.0,),
                                                                      textScaleFactor: 1.0,
                                                                      //maxLines: 1,
                                                                    );

                                                                  }

                                                              ),

                                                            ),
                                                        ),


                                                        SizedBox(width: 3,),

                                                        /// Icon
                                                        Flexible(
                                                          flex: 1, // default value
                                                          fit:  FlexFit.loose,
                                                          child: Container(
                                                            //color: Colors.green,
                                                            child: SvgPicture.asset(
                                                              'assets/images/monedabilletera.svg',
                                                              fit: BoxFit.contain,
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                          ),
                                                        )

                                                      ],

                                                    ),
                                                  )*/
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      mainAxisSize: MainAxisSize.min,

                                                      children: [

                                                        /// Value
                                                        Container(
                                                          //color: Colors.yellow,
                                                          child: ValueListenableBuilder<Userpoints>(
                                                              valueListenable: singleton.notifierUserPoints,
                                                              builder: (context,value,_){

                                                                return AutoSizeText(
                                                                  //singleton.formatter.format(double.parse(value.code == 1 || value.code == 102 ? "0" : value.data!.result!),),
                                                                  //singleton.formatter.format(99999),
                                                                  (value.code == 1 || value.code == 102) ? "0" : utils.returnDividendoString( double.parse(value.data!.result!) ),
                                                                  //(value.code == 1 || value.code == 102) ? "0" : utils.returnDividendoString( double.parse("134503") ),
                                                                  textAlign: TextAlign.center ,
                                                                  maxLines: 1,
                                                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 25.0,),
                                                                  textScaleFactor: 1.0,
                                                                  //maxLines: 1,
                                                                );

                                                              }

                                                          ),

                                                        ),


                                                        SizedBox(width: 3,),

                                                        /// Icon
                                                        Container(
                                                          //color: Colors.green,
                                                          child: SvgPicture.asset(
                                                            'assets/images/monedabilletera.svg',
                                                            fit: BoxFit.contain,
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                            /*child: Container(
                                                              child: Stack(
                                                                alignment: Alignment.center,

                                                                children: [

                                                                  Image(
                                                                    image: AssetImage("assets/images/circuloonline.png"),
                                                                    fit: BoxFit.contain,
                                                                    width: 23,
                                                                    height: 23,
                                                                    //color: "#00A86B".toColors(),
                                                                  ),

                                                                  Image(
                                                                    image: AssetImage("assets/images/monedaonline.png"),
                                                                    fit: BoxFit.contain,
                                                                    width: 23,
                                                                    height: 23,
                                                                    color: "#00A86B".toColors(),
                                                                  )

                                                                ],

                                                              ),
                                                            )*/


                                                        )

                                                      ],

                                                    ),
                                                  )



                                                ],

                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 5,),

                                          /// Missing
                                          Expanded(
                                            child: Container(
                                              //color: Colors.blue,
                                              child: Column(

                                                mainAxisAlignment: MainAxisAlignment.center,

                                                children: [

                                                  /// Missing
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Text(value4.code == 1 || value4.code == 102 ? Strings.dym  : value4.data!.item!.remainingPoints! == "0" ? Strings.fch : Strings.dym,
                                                      textAlign: TextAlign.right,
                                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 12,),
                                                      textScaleFactor: 1.0,
                                                    ),
                                                  ),

                                                  SizedBox(height: 3,),

                                                  /// Value
                                                  /*Container(
                                                    //color: Colors.purple,
                                                    alignment: FractionalOffset.center,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,

                                                      children: [

                                                        /// Value
                                                        Flexible(
                                                          flex: 1, // default value
                                                          fit:  FlexFit.loose,
                                                          child: Container(
                                                            //color: Colors.yellow,
                                                            child: AutoSizeText(
                                                              singleton.formatter.format(double.parse(value4.code == 1 || value4.code == 102 ? "0" : value4.data!.item!.remainingPoints! == "0" ? value4.data!.item!.points! : value4.data!.item!.remainingPoints!  ),),
                                                              //singleton.formatter.format(9999999),
                                                              textAlign: TextAlign.center ,
                                                              maxLines: 1,
                                                              style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 25.0,),
                                                              textScaleFactor: 1.0,
                                                              //maxLines: 1,
                                                            ),

                                                          ),
                                                        ),

                                                        SizedBox(width: 3,),

                                                        /// Icon
                                                        Flexible(
                                                          flex: 1, // default value
                                                          fit:  FlexFit.loose,
                                                          child: Container(
                                                              //color: Colors.green,
                                                              child: SvgPicture.asset(
                                                                'assets/images/monedabilletera.svg',
                                                                fit: BoxFit.contain,
                                                                width: 20,
                                                                height: 20,
                                                              ),
                                                            ),
                                                        ),


                                                      ],

                                                    ),
                                                  )*/
                                                  Container(
                                                    //color: Colors.purple,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      mainAxisSize: MainAxisSize.min,

                                                      children: [

                                                        /// Value
                                                        Container(
                                                          //color: Colors.yellow,
                                                          child: AutoSizeText(
                                                            //singleton.formatter.format(double.parse(value4.code == 1 || value4.code == 102 ? "0" : value4.data!.item!.remainingPoints! == "0" ? value4.data!.item!.points! : value4.data!.item!.remainingPoints!  ),),
                                                            //singleton.formatter.format(9999999),
                                                            (value4.code == 1 || value4.code == 102) ? "0" : value4.data!.item!.remainingPoints! == "0" ? value4.data!.item!.points! : utils.returnDividendoString( double.parse(value4.data!.item!.remainingPoints!) ),
                                                            //(value4.code == 1 || value4.code == 102) ? "0" : utils.returnDividendoString( double.parse("134570") ),
                                                            textAlign: TextAlign.center ,
                                                            maxLines: 1,
                                                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 25.0,),
                                                            textScaleFactor: 1.0,
                                                            //maxLines: 1,
                                                          ),

                                                        ),

                                                        SizedBox(width: 3,),

                                                        /// Icon
                                                        Container(
                                                          //color: Colors.green,
                                                          child: SvgPicture.asset(
                                                            'assets/images/monedabilletera.svg',
                                                            fit: BoxFit.contain,
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),

                                                       /* Container(
                                                          child: Stack(
                                                            alignment: Alignment.center,

                                                            children: [

                                                              Image(
                                                                image: AssetImage("assets/images/circuloonline.png"),
                                                                fit: BoxFit.contain,
                                                                width: 23,
                                                                height: 23,
                                                                //color: "#00A86B".toColors(),
                                                              ),

                                                              Image(
                                                                image: AssetImage("assets/images/monedaonline.png"),
                                                                fit: BoxFit.contain,
                                                                width: 23,
                                                                height: 23,
                                                                color: "#00A86B".toColors(),
                                                              )

                                                            ],

                                                          ),
                                                        )*/


                                                      ],

                                                    ),
                                                  )


                                                ],

                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 5,),

                                          /// Change Button
                                          Expanded(
                                              child: Container(
                                                //color: Colors.yellow,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Container(
                                                      //color: Colors.green,
                                                      child: SpringButton(
                                                        SpringButtonType.OnlyScale,
                                                        Container(
                                                          //color: Colors.black,
                                                          //padding: EdgeInsets.only(right: 5,left: 5,),
                                                          child: Card(
                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            color: value4.code == 1 || value4.code == 102 ? CustomColors.grayCanje : ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing" ? CustomColors.bluelogin : CustomColors.grayCanje,
                                                            // color: value4.code == 1 || value4.code == 102 ? CustomColors.grayCanje : ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ? CustomColors.bluelogin : CustomColors.grayCanje,
                                                            elevation: 1.2,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            child: Container(
                                                              margin:  EdgeInsets.only(right: 5,left: 10,),
                                                              height: 40,
                                                              //width: 130,
                                                              child: Row(
                                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                children: [

                                                                  SizedBox(width: 5,),

                                                                  SvgPicture.asset(
                                                                    'assets/images/update.svg',
                                                                    fit: BoxFit.contain,
                                                                    width: 14,
                                                                    height: 14,
                                                                    color: value4.code == 1 || value4.code == 102 ? CustomColors.lightGreyProgrerss : ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing" ? CustomColors.white : CustomColors.lightGreyProgrerss,
                                                                    //color: value4.code == 1 || value4.code == 102 ? CustomColors.lightGreyProgrerss : ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ? CustomColors.white : CustomColors.lightGreyProgrerss,
                                                                  ),

                                                                  SizedBox(width: 5,),

                                                                  /// Text and points
                                                                  Expanded(
                                                                    child: Container(
                                                                      child: Text(Strings.converter,
                                                                          style: TextStyle(
                                                                              fontFamily: Strings.font_medium,
                                                                              fontSize:14,
                                                                              color: value4.code == 1 || value4.code == 102 ? CustomColors.lightGreyProgrerss : ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing" ? CustomColors.white : CustomColors.lightGreyProgrerss
                                                                            //color: value4.code == 1 || value4.code == 102 ? CustomColors.lightGreyProgrerss : ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ? CustomColors.white : CustomColors.lightGreyProgrerss
                                                                          ),
                                                                          textAlign: TextAlign.start,
                                                                        textScaleFactor: 1.0,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  //SizedBox(width: 5,),


                                                                ],

                                                              ),

                                                            ),

                                                          ),

                                                        ),
                                                        useCache: false,
                                                        onTap: (){

                                                          if(value4.code == 1 || value4.code == 102 ){
                                                            /// No tap
                                                          }else if( ( double.parse( value4.data!.item!.exchangeDay! )== 0 || double.parse( value4.data!.item!.exchangeDay! ) > 7 ) && value4.data!.item!.exchange! != "missing"){
                                                            // }else if( ((7 - double.parse(value4.data!.item!.exchangeDay!)) <= 0 && value4.data!.item!.exchange! != "missing") ){

                                                            //exchangeCoinstoMb();
                                                            dialogRedeem(context, exchangeCoinstoMb);
                                                          }else {
                                                            utils.openSnackBarInfo(context, Strings.noyetcanje, "assets/images/ic_sad.svg",CustomColors.blueBack,"error");
                                                          }

                                                        },

                                                        //onTapDown: (_) => decrementCounter(),

                                                      ),
                                                    ),


                                                  ],

                                                ),
                                              )
                                          ),


                                        ],

                                      ),
                                    );

                                  }

                              );

                            }
                        )

                      ],

                    ),
                  ),

                ],

              ),
            ),


          );

        }

    );

  }

  /// Exchange coins to Mb
  void exchangeCoinstoMb()async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        //utils.dialogLoading(singleton.navigatorKey.currentContext!);
        utils.openProgress(singleton.navigatorKey.currentContext!);
        singleton.notifierListUserPoints.value = Userpointlist(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchExchangeCoinsToMb(singleton.notifierUseraltan.value.data!.item!.id!,singleton.navigatorKey.currentContext!);

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }


  }

}

