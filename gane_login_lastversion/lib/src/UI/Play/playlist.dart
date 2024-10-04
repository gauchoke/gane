import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:badges/badges.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gane/src/Models/gamelist.dart';
import 'package:gane/src/Models/gamelistn.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Campaigns/WinpointsWeb.dart';
import 'package:gane/src/UI/Home/profileDetail.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/dialog_gameout.dart';
import 'package:gane/src/Widgets/dialog_winorlostgame.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:badges/badges.dart' as badges;

class PlayLists extends StatefulWidget{

  final from;

  PlayLists({this.from});

  _statePlayLists createState()=> _statePlayLists();
}

class _statePlayLists extends State<PlayLists> with  TickerProviderStateMixin, WidgetsBindingObserver{

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

  //late WebViewController controller;
  late InAppWebViewController controller;
  var onlyone = 0;


  final String _url = 'https://easygane.inkubo.co/p/948463?lt=\$5\$dGF7emr9XUTj6FtE\$pJb3O3o70t4botdfhKnYiv4ZmCY96G32nX9ZYbBfOA'; // https://easygane.inkubo.co/p/948383



  @override
  void initState(){
    singleton.GaneOrMira = "Answer";

    //loadurls();
    launchFetch();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      launchFetch();
      Future.delayed(const Duration(milliseconds: 450), () {
        if(singleton.isOffline == false){
        }
      });


      print("Número random: " + utils.randomNumber().toString());

    });

    super.initState();
  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        singleton.GamesRoomPages = 0;
        singleton.notifierGamesRoomN.value = GamelistN(code: 1,message: "No hay nada", status: false, );
        utils.openProgress(context);
        //servicemanager.fetchGamesRoom(context);

        servicemanager.fetchGamesRoom(context).then((value){

          if(value.code == 100){
            singleton.idAds = int.parse(singleton.notifierGamesRoomN.value.data!.items!.items![0].id!);
            singleton.itemN = singleton.notifierGamesRoomN.value.data!.items!.items![0];
            itemSelected = 0;
            singleton.notifierHeightViewQuestions.value = MediaQuery.of(context).size.height-150;
            singleton.itemSelected = 0;
            var type = "online";
            launchFetchObtainUrl();
          }else{
            Navigator.pop(singleton.navigatorKey.currentContext!);
            utils.openSnackBarInfo(context, value.message!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          }

        });

        servicemanager.fetchUserProfile1(context);
        servicemanager.fetchValidateSegmentation(context);

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

    if(singleton.notifierGamesRoom.value.code == 100){

      if(singleton.notifierGamesRoom.value.data!.page! >= (singleton.GamesRoomPages + 1)){
        singleton.GamesRoomPages = singleton.GamesRoomPages + 1;
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            servicemanager.fetchGamesRoom(context,);

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
        padding: EdgeInsets.only(top: 90),

        /*child: ValueListenableBuilder<GamelistN>(
            valueListenable: singleton.notifierGamesRoomN,
            builder: (context,value1,_){

              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                footer: ClassicFooter(noDataText: "", loadingText: Strings.loadmoreinfo, idleText: "", idleIcon: null, height: 30),
                header: WaterDropMaterialHeader(backgroundColor: CustomColors.orangeback, distance: 30, offset: 90,),
                controller: _refreshController,
                onRefresh: _onRefresh,
                //onLoading: _onLoading,
                //itemCount: value1.code == 1 ? 6 : value1.code == 102 ? 2 : value1.data!.result!.length + 1,

                child: ListView.builder(
                  //physics: AlwaysScrollableScrollPhysics(),
                  //shrinkWrap: true,
                  padding: EdgeInsets.only(top: 2,left: 0,right: 0),
                  scrollDirection: Axis.vertical,
                  itemCount: value1.code == 1 ? 6 : value1.code == 102 ? 2 : value1.code == 120 ? 0 : value1.data!.items!.items!.length + 1,
                  itemBuilder: (BuildContext context, int index){

                    if(index==0){
                      return Container(height: 95,);

                    }else if(value1.code == 1){
                      return utils.PreloadBanner();

                    }else if(value1.code == 102){
                      return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");

                    }else{
                      if(value1.data!.items!.items!.length == 0){
                        return utils.emptyHome(value1.message!, "", "assets/images/emptyhome.svg");

                      }else return itemPlayList(context, value1.data!.items!.items![index-1],index-1);
                    }


                  },

                ),
              );

            }

        ),*/

        child: Stack(

          children: [

            ValueListenableBuilder<String>(
                valueListenable: singleton.notifierUrlsByGame,
                builder: (context,value1,_){

                  return value1== "" ?
                  Container() :
                  /*WebView(
                    //gestureNavigationEnabled: true,
                    onWebViewCreated: (WebViewController contro) async{
                      controller = contro;
                    },

                    debuggingEnabled: true,
                    initialUrl: Uri.encodeFull(value1),
                    onPageStarted: (v){
                      print("loading page");
                      utils.openProgress(context);
                    },
                    onPageFinished: (v) async{
                      print("page finish");
                      Navigator.pop(context);
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
                                showAlertWonPoints1();
                              }
                            });
                          })

                    ]),
                    /*javascriptChannels: <JavascriptChannel>[
                      _scriptWin(context),
                    ].toSet(),*/
                    navigationDelegate: (NavigationRequest request) async {
                      print(request.url);

                      //if(singleton.isIOS == true){

                      if (request.url.startsWith('https://easygane.inkubo.co/success')) {
                        //showAlertWonPoints1();
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                  );*/

                  InAppWebView(
                    //initialUrlRequest: URLRequest(url: Uri.parse(value1)),
                    initialUrlRequest: URLRequest(url: WebUri(value1)),
                    initialOptions: InAppWebViewGroupOptions(
                      //crossPlatform: InAppWebViewOptions(javaScriptCanOpenWindowsAutomatically:true,useShouldOverrideUrlLoading: true, javaScriptEnabled: true),
                        crossPlatform: InAppWebViewOptions(
                            userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
                            javaScriptEnabled: true, useShouldOverrideUrlLoading: true, javaScriptCanOpenWindowsAutomatically:true,clearCache: true
                        ),
                      ios: IOSInAppWebViewOptions(),
                      //android: AndroidInAppWebViewOptions(),
                      android: AndroidInAppWebViewOptions(
                        useHybridComposition: true,
                      )
                    ),
                    onWebViewCreated: (controllerrr) {
                      controller = controllerrr;
                      controller.addJavaScriptHandler(handlerName: 'messageHandler', callback: (args) {
                        print(args);
                        Future.delayed(const Duration(milliseconds: 450), () {
                          if(onlyone==0){
                            onlyone = 1;
                            showAlertWonPoints1();
                          }
                        });

                      });

                    },
                    onProgressChanged: (controller, progress) {
                      print(progress.toString());
                    },
                    onLoadError: (controller, url, i, s) async {
                    },
                    onLoadHttpError: (controller, url, i, s) async {

                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                      // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
                    },



                    /*shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
                      var url = shouldOverrideUrlLoadingRequest.request.url;
                      if (widget.stopOnURL != null &&
                          url.toString().contains(widget.stopOnURL)) {
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.ALLOW;
                    },*/
                  );

                }
            ),

            /*WebView(
              initialUrl: 'about:blank',
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: 'messageHandler',
                    onMessageReceived: (JavascriptMessage message) {
                      print(message.message);
                      Future.delayed(const Duration(milliseconds: 450), () {
                        if(onlyone==0){
                          onlyone = 1;
                          showAlertWonPoints1();
                        }
                      });
                    })
              ]),
              onWebViewCreated: (WebViewController webViewController) async {
                controller = webViewController;
                String fileContent = await rootBundle.loadString('assets/index.html');
                controller?.loadUrl(Uri.dataFromString(fileContent, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
              },
              onPageFinished: (v) async{
                print("page finish");
                controller.evaluateJavascript('fromFlutter("From Flutter")');
              },
            )*/

          ],

        ),

      ),

    );

  }

  /// Lister js Function
 /* JavascriptChannel _scriptWin(BuildContext context){

    return JavascriptChannel(
        name: "messageHandler",
        onMessageReceived: (JavascriptMessage message){
          print(message.message);
          Future.delayed(const Duration(milliseconds: 450), () {
            /*if(onlyone==0){
              onlyone = 1;*/
              showAlertWonPoints1();
            //}
          });
        }
    );

  }*/

  /// Item Game
  Widget itemPlayList(BuildContext context,ItemsN item, int index){

    final maxWidth = (MediaQuery.of(context).size.width / 3) - 35;

    return GestureDetector(
      onTap: (){

        //singleton.idAds = item.ads![0]!.id!;
/*        singleton.item = singleton.notifierGamesRoom.value.data!.result![index];

        itemSelected = index;
        //singleton.GaneOrMira = "Answer";
        singleton.notifierHeightViewQuestions.value = MediaQuery.of(context).size.height-150;
        singleton.itemSelected = index;
        singleton.idSecuence = item.id!;
        singleton.idAds = item.ads![0]!.id!;
        singleton.format = item.ads![0]!.formatValue!;
        //singleton.notifierPointsGaneRoom.value = item.ads![0]!.pointsAds!;


        print(singleton.notifierGamesRoom.value.data!.result![index].ads![0].gamerAds![0].gamer );
        var type = "pop";

        singleton.imageGame = item.ads![0]!.lgImages!;



        if(singleton.notifierGamesRoom.value.data!.result![index].ads![0].gamerAds![0].gamer == 13){ /// Pop Balloon
          print(item.ads![0].gamerAds![0].figure![0]);
          utils.vectorGame(item.ads![0].gamerAds![0].figure![0],item.ads![0].gamerAds![0].figure!);
          type = "pop";

        }else  if(singleton.notifierGamesRoom.value.data!.result![index].ads![0].gamerAds![0].gamer == 4){ /// Run game
          print(item.ads![0].gamerAds![0].figure![0]);
          utils.vectorGame(item.ads![0].gamerAds![0].figure![0],item.ads![0].gamerAds![0].figure!);
          type = "run";

        }else{
          type = "online";
          singleton.codeUrl = item.ads![0].gamerAds![0].codeUrl!;
        }

*/

        singleton.idAds = int.parse(item.id!);
        singleton.itemN = item;
        itemSelected = index;
        singleton.notifierHeightViewQuestions.value = MediaQuery.of(context).size.height-150;
        singleton.itemSelected = index;
        //singleton.codeUrl = item.;

        var type = "online";
        launchFetchObtainUrl();

      },
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      child: Container(
        margin: EdgeInsets.all(15),
          //padding: EdgeInsets.only(top: 20),
          /*child: Column(

            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  /// Text
                  Expanded(
                    child: Container(
                      //color: Colors.red,
                      margin: EdgeInsets.only(left: 15,right: 5,),
                      //color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Container(
                              //height: 30,
                              //width: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:item.description!,
                                  //imageUrl: item.ads![0]!.adImages!,
                                  placeholder: (context, url) => Container(
                                      height: 30,
                                      width: 30,
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

                            SizedBox(height: 5,),

                          Container(
                            child: Text(item.title!,
                                style: TextStyle(
                                    fontFamily: Strings.font_bold,
                                    fontSize:18,
                                    color: CustomColors.grayalert1),
                                textAlign: TextAlign.start
                            ),
                          ),

                          Container(
                            //child: Text(DateFormat.yMMMMd("es_ES").format(DateTime.parse("2021-10-23")),
                            child: HtmlWidget(item.description!),
                          ),

                        ],

                      ),
                    ),
                  ),

                  /// Coins
                  /*Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.only(top: 3,bottom: 3,left: 5,right: 2),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                          color: CustomColors.orangeback1,
                        ),
                        child: Row(

                          //mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            /// Points
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: maxWidth),
                                //color: Colors.blue,
                                child: AutoSizeText(
                                  singleton.formatter.format(double.parse(item.ads![0]!.pointsAds!)),
                                  //singleton.formatter.format(utils.valuePointsGames(item)),
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(fontFamily: Strings.font_black, color: CustomColors.white, fontSize: 14,),
                                  //maxLines: 1,
                                ),
                              ),
                            ),

                            ///Icon
                            Container(
                              //color: Colors.green,
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
                    ),*/

                  SizedBox(width: 10,),

                ],

              ),

              /*SizedBox(height: 10,),

                Container(
                  color: CustomColors.red,
                  margin: EdgeInsets.only(left: 15,right: 15),
                  height: 1,

                ),

                SizedBox(height: 10,),*/

            ],

          )*/
        child: Stack(
          
          children: [

            Container(
              //height: 30,
              //width: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl:item.description!,
                  //imageUrl: item.ads![0]!.adImages!,
                  placeholder: (context, url) => Container(
                      height: 30,
                      width: 30,
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

            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width-30,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  color: CustomColors.greyborderbutton.withOpacity(0.8),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(item.title!,
                      style: TextStyle(
                          fontFamily: Strings.font_bold,
                          fontSize:18,
                          color: CustomColors.grayalert1),
                      textAlign: TextAlign.start
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );

  }

  /// Obtain url game
  void launchFetchObtainUrl()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
       // utils.openProgress(context);
        servicemanager.fetchObtainUrlGame(context);
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

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
      Gamelist notifierGaneRoom = singleton.notifierGamesRoom.value;
      notifierGaneRoom.data!.result!.removeAt(itemSelected);
      singleton.notifierGamesRoom.value = Gamelist(code: 1,message: "No hay nada", status: false, );
      if(notifierGaneRoom.data!.result!.length >0){
        singleton.notifierGamesRoom.value = notifierGaneRoom;
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

          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            //color: Colors.deepPurpleAccent,
            child: ValueListenableBuilder<double>(
                valueListenable: notifierOpacity,
                builder: (context,value4,_){

                  return Container(
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

    Future.delayed(const Duration(milliseconds: 400), () {
      onAnimationCoin();
    });
  }

  /// Obtain Points Ads
  void launchFetchObtainPointsAds()async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        Future.delayed(const Duration(milliseconds: 400), () {
          utils.openProgress(context);
          //servicemanager.fetchObtainPointsLookRoom(context,showAlertWonPoints);
          servicemanager.fetchObtainPointsLookRoom(context,(){});
        });

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }


  /// Show Alert won points
  void showAlertWonPoints1(){

    Future.delayed(const Duration(milliseconds: 100), () {

      servicemanager.fetchPointUserPoints(context);
      servicemanager.fetchUserAltam(context);

      utils.VibrateAndMusic();
      showCupertinoModalPopup(context: context, builder:
          (context) => WinsPointsweb(points: "240", image: "", onNextAd: (){},back: true, callWeb: "", aditionalPoints: "",)
      );

    });

  }



}

///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();

  final GlobalKey _two = GlobalKey();
  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderGrid,
        builder: (context,value2,_){

          return AnimatedContainer(
            height: value2,
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
                    /*child: SvgPicture.asset(//headernew
                    'assets/images/headernew.svg',
                    fit: BoxFit.fill,

                  ),*/
                    /*child: Image(
                      image: AssetImage("assets/images/headernew.png"),
                      fit: BoxFit.fill,
                    )*/

                    child: ValueListenableBuilder<SegmentationCustom>(
                        valueListenable: singleton.notifierValidateSegmentation,
                        builder: (context,value2,_){

                          return value2.code == 1 ? Image(
                            image: AssetImage("assets/images/headernew.png"),
                            fit: BoxFit.fill,
                          ) :
                          value2.code==100 ? Container(
                            color: value2.data!.styles!.colorHeader!.toColors(),
                          ) :
                          Image(
                            image: AssetImage("assets/images/headernew.png"),
                            fit: BoxFit.fill,
                          );

                        }

                    )

                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    ///Logo
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          //color: Colors.blue,
                          padding: EdgeInsets.only(top: 35,left: 20),

                          /*child: SvgPicture.asset(
                            'assets/images/logohome.svg',
                            fit: BoxFit.contain,
                            width: 80,
                            height: 42,
                          ),*/
                          child: ValueListenableBuilder<SegmentationCustom>(
                              valueListenable: singleton.notifierValidateSegmentation,
                              builder: (context,value2,_){
                                return value2.code == 1 ? SvgPicture.asset(
                                  'assets/images/logohome.svg',
                                  fit: BoxFit.contain,
                                  width: 80,
                                  height: 42,
                                ) :
                                value2.code==100 ? CachedNetworkImage(
                                  imageUrl: value2.data!.styles!.logoHeader!,
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
                                ) :
                                SvgPicture.asset(
                                  'assets/images/logohome.svg',
                                  fit: BoxFit.contain,
                                  width: 80,
                                  height: 42,
                                ) ;
                              }

                          ),

                        ),
                      ),
                    ),


                    /// Ciudad
                    /*ValueListenableBuilder<String>(
                        valueListenable: singleton.notifierCity,
                        builder: (context,value22,_){

                          return Expanded(
                            child: InkWell(
                              onTap: (){

                                singleton.Gane1RoomPages = 0;
                                singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );

                                singleton.notifierChangeCity.value = singleton.notifierChangeCity.value + 1;
                                if(singleton.notifierChangeCity.value > 4){
                                  singleton.notifierChangeCity.value = 0;
                                }

                                Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );

                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                color: Colors.red,
                                height: 40,
                                child: Text(
                                  value22,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                ),
                              ),
                            ),
                          );

                        }

                    ),*/

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
                                  /*child: Container(
                                    child: Stack(
                                      alignment: Alignment.center,

                                      children: [

                                        Image(
                                          image: AssetImage("assets/images/circuloonline.png"),
                                          fit: BoxFit.contain,
                                          width: 30,
                                          height: 30,
                                          //color: "#00A86B".toColors(),
                                        ),

                                        Image(
                                          image: AssetImage("assets/images/monedaonline.png"),
                                          fit: BoxFit.contain,
                                          width: 30,
                                          height: 30,
                                          color: "#00A86B".toColors(),
                                        )

                                      ],

                                    ),
                                  )*/
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

                        Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 4,)) );


                      },

                      //onTapDown: (_) => decrementCounter(),

                    ),*/


                    /// User image
                    InkWell(
                      onTap: (){
                        //Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
                        //dialogSetting(context);
                        var time = 350;
                        if(singleton.isIOS == false){
                          time = utils.ValueDuration();
                        }
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: ProfileDetail(),
                            reverseDuration: Duration(milliseconds: time)
                        ));

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
                        padding: EdgeInsets.only(right: 15,top: 20),
                        //color: Colors.blue,
                        child: ValueListenableBuilder<String>(
                            valueListenable: singleton.notifierNotificationCount,
                            builder: (context,value,_){

                              /*return Badge(
                                position: BadgePosition.topEnd(end: -2,),
                                //position: BadgePosition.topEnd(end: -10,),
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
                          time = 1200;
                        }

                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: Notificationss(),
                            reverseDuration: Duration(milliseconds: time)
                        ));

                      },


                    ),

                  ],
                )

              ],

            ),


          );

        }

    );

  }

}

