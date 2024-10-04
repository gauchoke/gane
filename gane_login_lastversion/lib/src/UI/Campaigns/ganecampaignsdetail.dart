import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/sitemodel.dart';
import 'package:gane/src/UI/Campaigns/Winpoints.dart';
import 'package:gane/src/UI/Home/profileDetail.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_nopoints.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:badges/badges.dart' as badges;


class GaneCampaignDetail extends StatefulWidget{

  final format;
  final VoidCallback relaunch;
  final sequenceornot;
  final ResultSL item;


  GaneCampaignDetail({this.format, required this.item, this.sequenceornot, required this.relaunch});

  _stateGaneCampaignDetail createState()=> _stateGaneCampaignDetail();
}

class _stateGaneCampaignDetail extends State<GaneCampaignDetail> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  int formatValue = 0; /// debe ser notifier
  var once = 0;
  var onceVideo = 0;
  var relaun = 0;
  var itemAd = 0;
  var goWinView = 0;
  final notifierformatValue = ValueNotifier(0);
  bool outScreen = false;


  late AnimationController controllerButtons;
  late Animation<double> animationButtons;
  bool callonlyonce = false;

  final controlador = PageController(initialPage: 0);
  var _controllerComment = TextEditingController();
  late AnimationController controllerAnima;
  late Animation<double> animationIn;
  ScrollController _scrollController = new ScrollController();
  final notifierHeightQuestions = ValueNotifier(200.0);

  var urlVImeo = [];

  /// Timer Image
  late Timer _timer;
  final notifierImageCounter = ValueNotifier(15);
  int _startCounter = 15;
  final notifierActiveHeader = ValueNotifier(false);
  final notifierMinimumTimeComplete = ValueNotifier(false);
  int itemVIdeo = 0;
  bool playVideo = false;

  int intents = 0;



  /// Counter Image
  void runCounter() {
    _timer = Timer.periodic(Duration(seconds: 1), loadTimer);
  }

  loadTimer(Timer timer) {
      this.loadGameWhenReady(timer);
      notifierImageCounter.value--;
  }

  void loadGameWhenReady(Timer timer){

    if (notifierImageCounter.value > 1) {
      return;
    }

    timer.cancel();
    this.changeColorHeader();
  }

  /// Active header tap
  void changeColorHeader(){
    notifierActiveHeader.value = true;
  }

  void resetNumberCode(){
    singleton.notifierNumberReward.value = utils.randomNumber();
    singleton.notifierNumberRewardDigit.value= "";
  }

  /// detect intents code
  void detectIntents(){
    intents = intents + 1;
    if(intents >= 4){
      intents = 0;
      widget.relaunch();
      once = once + 1;
      Navigator.pop(singleton.navigatorKey.currentContext!);
    }
  }

  /// Block header tap
  void blockchangeColorHeader(){
    notifierActiveHeader.value = false;
    backMinimumTimeComplete();
  }

  /// Active minimum time complete
  void changeMinimumTimeComplete(){
    notifierMinimumTimeComplete.value = true;
  }

  /// Back minimum time complete
  void backMinimumTimeComplete(){
    notifierMinimumTimeComplete.value = false;
  }


// 23e2c74ea60e48618003c2aee02a501dd0d7e5745a39b4b5b88dd2286285949d


  @override
  void initState(){
    singleton.notifierHeightHeaderWallet1.value = 160.0;
    var url = widget.item.ads![itemAd]!.vimeoUrl!;
    urlVImeo = url.split("/");
    print(urlVImeo);
    print(urlVImeo[urlVImeo.length-1]);


    print(widget.item);

    formatValue = widget.item!.ads![itemAd]!.formatValue!;
    notifierformatValue.value =  widget.item!.ads![itemAd]!.formatValue!;
    LoadInitialSetting();
    launchFetchClickSecuence();

    servicemanager.fetchListNotifications(context, "borrar", "SEQUENCE");

    resetNumberCode();

    super.initState();
  }

  /// Fetch Click Secuence
  void launchFetchClickSecuence()async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        Future.delayed(const Duration(milliseconds: 400), () {
          servicemanager.fetchClickSequence(context);
        });

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }


  /// Load Initial setting
  void LoadInitialSetting(){
    intents = 0;
    blockchangeColorHeader();
    notifierImageCounter.value = 15;
    once = 0;
    onceVideo = 0;
    callonlyonce=false;
    singleton.notifierSeePlay.value = false;
    singleton.urls = [];
    singleton.notifierVideoLoaded.value = false;
    playVideo = false;

    if(formatValue == 1){ /// Video
      //initVideo("https://vod-progressive.akamaized.net/exp=1647993343~acl=%2Fvimeo-prod-skyfire-std-us%2F01%2F3935%2F15%2F394675185%2F1676012569.mp4~hmac=e847118604ac340181b2393ef18ecc398b28ba760b171c9190d88c4949f960ed/vimeo-prod-skyfire-std-us/01/3935/15/394675185/1676012569.mp4");
      if(singleton.isIOS == true){
       // initVideo("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4");
      }
      goWinView = 0;
      //ponerlo si algo no funciona
      videoPlay();
    }else if(formatValue == 2){/// Image
      singleton.notifierVideoLoaded.value = true;

      this.runCounter();

    }else{ /// Poll
      controllerButtons = AnimationController(duration: const Duration(milliseconds: 150), vsync: this,  );
      animationButtons = Tween(
          begin: 0.0,
          end: 1.0
      ).animate( controllerButtons);

      Future.delayed(const Duration(milliseconds: 600), () {
        controllerButtons.forward();

      });

      singleton.notifieriTemQuestion.value = 0;
      controllerAnima = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this,  );
      animationIn = Tween(
          begin: 0.0,
          end: 1.0
      ).animate( controllerAnima);
      controllerAnima.forward();
      singleton.notifierVideoLoaded.value = true;

    }

    WidgetsBinding.instance!.addPostFrameCallback((_){


      //Future.delayed( Duration(milliseconds: widget.item.ads![itemAd]!.formatValue == 1 ? 700 : 400), () {
      Future.delayed( Duration(milliseconds: 0), () {

        if( singleton.GaneOrMira != "Answer"){
          singleton.GaneOrMira = "gane";
        }

        //dialogWinPointsCampaings(context, Strings.seevideo, launchVideo, Strings.reward,  widget.item.ads![itemAd]!.lgImages!,widget.item.ads![itemAd]!.adImages!, widget.item.ads![itemAd]!.pointsAds!, widget.item.ads![itemAd]!.formatValue!);

      });

      /// Play video when you can't find the 720p
       if(formatValue == 1){/// Video /// quitar el if  si algo no funciona
         Future.delayed(const Duration(seconds: 4), () {
           //loadIfNotLoad();
         });
       }


      Future.delayed(const Duration(milliseconds: 180), () {
        singleton.notifierHeightViewQuestions.value = MediaQuery.of(context).size.height - 60;
      });


    });

  }

  /// Get Vimeo video url
  void videoPlay() async{

    var url = widget.item.ads![itemAd]!.vimeoUrl!;
    //print("Url del video: "+url);
    //var url = 'https://player.vimeo.com/video/463757727';https://player.vimeo.com/video/757593070
    //url = "https://vimeo.com/757338010";
    //url = "https://vimeo.com/757334566";
    //url = "https://vimeo.com/761539699";
    //url = "https://vimeo.com/757593070";

    url = url.replaceAll("video/", "");
    url = url.replaceAll("player.", "");

    var tokens = url.split("/");

    /*var check = await DirectLink.check(url);
      if (check == null || check.length == 0) {
      print("No data Vimeo");

            var che = await servicemanager.fetchVimeoNewVideos(context, tokens[tokens.length-1]);
            che!.forEach((element) {
              print("quality video: "+element.quality);
              print("link video: "+element.link);
              singleton.urls.add(element.link);
            });

            if(singleton.urls.length > 0){
              setState(() {
                initVideo(singleton.urls[0]);
              });
            }

      }else{

            check!.forEach((element) {
              print("quality video: "+element.quality);
              print("link video: "+element.link);
              singleton.urls.add(element.link);

              /*if(element.quality == '240p'){
                print("Find 240p");

                setState(() {
                  initVideo(element.link);
                });
              }*/

            });

            if(singleton.urls.length > 0){
              setState(() {
                initVideo(singleton.urls[0]);
              });

            }

    }*/


    var che = await servicemanager.fetchVimeoNewVideos(context, tokens[tokens.length-1]);
    che!.forEach((element) {
      print("quality video: "+element.quality!);
      print("link video: "+element.link!);
      singleton.urls.add(element.link);
    });

    if(singleton.urls.length > 0){
      setState(() {
        initVideo(singleton.urls[0]);
      });
    }


  }

  /// Video controller initialization
  void initVideo(String url){

    singleton.controller = VideoPlayerController.network(
      url
      //"https://player.vimeo.com/progressive_redirect/playback/739102979/rendition/360p/file.mp4?loc=external&signature=220b1d70402bbdc0cb215dfb07a0b49eaf10a69d94af9b8c8051080cf370e3dd"
    );

    // Initialize the controller and store the Future for later use.
    singleton.initializeVideoPlayerFuture = singleton.controller!.initialize();

    // Use the controller to loop the video.
    singleton.controller!.setLooping(false);

    singleton.controller!.addListener(() {
      if (singleton.controller!.value.hasError) {
        print("Video Error");
        print(singleton.controller!.value.errorDescription);
        if(itemVIdeo==0){
          itemVIdeo = 1;
          Navigator.pushReplacement(singleton.navigatorKey.currentContext!, Transition(child: PrincipalContainer(selectedIndex: 0,relaunch: "true",)) );
        }

      }
      if (singleton.controller!.value.isInitialized) {
          print("Video Play");
          //checkVideo();
          singleton.notifierVideoLoaded.value = true;
          if(playVideo == false){
            Future.delayed(const Duration(seconds: 1), () {
              launchVideo();
            });
            playVideo = true;
          }
          checkVideoNew();
      }
      if (singleton.controller!.value.isBuffering) {
        print("Video Buffering");

      }

    });



  }

  /// Play video when you can't find the 720p
  void loadIfNotLoad(){
    bool esta = false;

    if(singleton.notifierVideoLoaded.value == false){

      for (int i = 0; i < singleton.urls.length ; i++) {
        var country = singleton.urls![i];

        if (country.contains('720p')){
          esta = true;
        }

      }

      if(esta == false){

        if(singleton.urls.length>0){
          setState(() {
            //print('No encontro video y el tamño del vector de urls es de : '+ singleton.urls.length.toString());
            //print('Url de video cuando no da play : '+ singleton.urls![0]);
            //initVideo(singleton.urls![singleton.urls.length-1]);
            initVideo(singleton.urls![0]);

            //singleton.controller.addListener(checkVideo); ponerlo si algo no funciona
            Future.delayed(const Duration(seconds: 1), () {
              //singleton.notifierVideoLoaded.value = true;
            });
          });


        }


      }

    }

  }

  ///Check status video
  void checkVideo(){


    // Implement your calls inside these conditions' bodies :
    if(singleton.controller!.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    singleton.notifierSecondsVideo.value = singleton.controller!.value.position.inSeconds;
    print("Video Segundos: "+ singleton.controller!.value.duration.toString());
    print("Video actual Segundos: "+ singleton.controller!.value.position.inSeconds.toString());
    print("Video mínimo Segundos: "+ widget.item.ads![itemAd].timeVisible.toString());


    if(singleton.controller!.value.duration.toString() != "0:00:00.000000"){

      Future.delayed(const Duration(seconds: 1), () {

        if(singleton.notifierVideoLoaded.value == false){/// agregado

          print(singleton.historyObserver.history.length);
          print(singleton.isOnNotificationView);

          /*if(singleton.historyObserver.history.length.toString() != "1"){
            launchVideo();
          }else {
            singleton.controller!.pause();
            singleton.controller!.removeListener(checkVideo);
            singleton.urls = [];
            singleton.controller = null;
            singleton.notifierVideoLoaded.value = false;
            singleton.initializeVideoPlayerFuture = singleton.controller!.initialize();
            print("Paro el controller de video");
          }*/


          if(singleton.isOnNotificationView == false){ /// Not in notification view

            print("Count historial de items en vector vistas: "+singleton.historyObserver.history.length.toString());
              if(singleton.historyObserver.history.length.toString() != "1"){
                launchVideo();
              }else {
                stopvideocontroller();
              }

          }else{ /// is in the notification view

            if(singleton.historyObserver.history.length.toString() == "3"){
              launchVideo();
            }else {
              //stopvideocontroller();
            }

          }



        }///

        singleton.notifierVideoLoaded.value = true;

      });

    }


    var totalTimeVideo = singleton.controller!.value.duration.inSeconds.toDouble();
    print("Video totalTimeVideo: "+ totalTimeVideo.toString());
    var minimumTimeVideo = double.tryParse(widget.item.ads![itemAd].timeVisible ?? "0.0");
    print("Video minimumTimeVideo: "+ minimumTimeVideo.toString());
    var difer = totalTimeVideo - minimumTimeVideo!;
    print("Video difer: "+ difer.toString());

    if(difer < 0){
      //minimumTimeVideo = minimumTimeVideo + (difer*-1);
      //print("Video minimumTimeVideo sumado: "+ minimumTimeVideo.toString());
      if(totalTimeVideo > 0){
        minimumTimeVideo = totalTimeVideo;
      }

    }


    var actualSeconds = singleton.controller!.value.position.inSeconds.toDouble();
    print("Video actualSeconds: "+ actualSeconds.toString());




    //if( singleton.controller.value.position.inSeconds>=int.parse(widget.item.ads![itemAd]!.timeVisible!) ){
    if( actualSeconds >= minimumTimeVideo ){
      print('mostrar Gana vista');
      print("Video actualSeconds: "+ actualSeconds.toString());
      print("Video minimumTimeVideo: "+ minimumTimeVideo.toString());
      //this.changeColorHeader(); // se comentare porque ahora es cuando de al a x despues del tiempo mínimo
      this.changeMinimumTimeComplete();
    }

    //if(singleton.controller.value.position == singleton.controller.value.duration) {
    if(actualSeconds == totalTimeVideo) {
      print('video Ended');
      //singleton.controller.removeListener(() { });


      if(singleton.controller!.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {

        print('Entro a terminado video en 0,0,0');

        singleton.controller!.removeListener(checkVideo);

        if(singleton.urls.length>0){
          print('Entro vector urls mayor a 0');
          //Random random = new Random();
          //int randomNumber = random.nextInt(singleton.urls.length-1);
          //print(randomNumber);
          setState(() {

            print('Entro a terminado video en 0,0,0 para cambiar oncevideo' + singleton.controller!.value.duration.toString());
            if(singleton.controller!.value.duration.toString() == "0:00:00.000000"){
              print('Entro a terminado video en 0,0,0 para cambiar oncevideo');
              //onceVideo = 0;
            }

            if(onceVideo == 0){

              //if(singleton.historyObserver.history.length.toString() != "1"){
                print('relaunch video');
                /*dispoandWait();
                onceVideo = 1;
                initVideo(singleton.urls[0]);
                print('No encontro video y el tamño del vector de urls es de : '+ singleton.urls.length.toString());
                print('Url de video cuando no da play : '+ singleton.urls![0]);*/

              //}
            }

          });


        }else{
          print('Entro vector urls menor a 0');
        }

        //loadIfNotLoad();
      }else {

        if(once==0){
          /// agregado
          once = once + 1;
          if(goWinView==0){
            //launchFetchObtainPointsAds();
            this.changeColorHeader();
          }
        }

      }


    }


  }
  void checkVideoNew(){


    singleton.notifierSecondsVideo.value = singleton.controller!.value.position.inSeconds;
    //print("Video Segundos: "+ singleton.controller!.value.duration.toString());
    //print("Video actual Segundos: "+ singleton.controller!.value.position.inSeconds.toString());
    //print("Video mínimo Segundos: "+ widget.item.ads![itemAd].timeVisible.toString());


    var totalTimeVideo = singleton.controller!.value.duration.inSeconds.toDouble();
    //print("Video totalTimeVideo: "+ totalTimeVideo.toString());
    var minimumTimeVideo = double.tryParse(widget.item.ads![itemAd].timeVisible ?? "0.0");
    //print("Video minimumTimeVideo: "+ minimumTimeVideo.toString());
    var difer = totalTimeVideo - minimumTimeVideo!;
    //print("Video difer: "+ difer.toString());

    if(difer < 0){
      if(totalTimeVideo > 0){
        minimumTimeVideo = totalTimeVideo;
      }
    }
    var actualSeconds = singleton.controller!.value.position.inSeconds.toDouble();
    //print("Video actualSeconds: "+ actualSeconds.toString());

    if( actualSeconds >= minimumTimeVideo ){
      print('mostrar Gana vista');
      print("Video actualSeconds: "+ actualSeconds.toString());
      print("Video minimumTimeVideo: "+ minimumTimeVideo.toString());
      //this.changeColorHeader(); // se comentare porque ahora es cuando de al a x despues del tiempo mínimo
      this.changeMinimumTimeComplete();
    }

    if(actualSeconds == totalTimeVideo) {

      singleton.controller!.removeListener(checkVideoNew);

      //if(actualSeconds > 0  && actualSeconds == totalTimeVideo) {
      print('video Ended');

        if(once==0){
          /// agregado
          once = once + 1;
          if(goWinView==0){
            //launchFetchObtainPointsAds();
            this.changeColorHeader();
          }
        }

    }


  }

  /// stop video controller
  void stopvideocontroller(){
    singleton.controller!.pause();
    singleton.controller!.removeListener(checkVideo);
    singleton.urls = [];
    singleton.controller = null;
    singleton.notifierVideoLoaded.value = false;
    singleton.initializeVideoPlayerFuture = singleton.controller!.initialize();
    print("Paro el controller de video");
  }

  /// New
  void dispoandWait() async{ /// Verificar si funciona

    /*singleton.controller.pause();
    singleton.controller.removeListener(checkVideo);
    singleton.controller.dispose();
    singleton.urls = [];
    singleton.controller = VideoPlayerController.network(
        ""
    );
    singleton.initializeVideoPlayerFuture = singleton.controller.initialize();
    //await Future<void>.delayed(Duration(milliseconds: 200));*/

    //singleton.controller.dispose();



  }

  /// Play video from button popup
  void launchVideo(){

    //if(singleton.controller.value.position.inSeconds == 0){ /// Por si el controlador no entrega el segundo en el que va el video
    /*if(singleton.controller.value.duration.toString() == "0:00:00.000000"){
      setState(() {
        onceVideo = 0;
        singleton.controller.removeListener(checkVideo);
        if(singleton.urls.length>0){
            if(onceVideo == 0){
              onceVideo = 1;
              initVideo(singleton.urls[0]);
            }
        }
      });
    }*/

    singleton.controller!.play();

  }

  /// Back Phone Button
  Future<bool> callToast() async {

    //singleton.controller.pause();
    if(singleton.notifierSecondsVideo.value== 0 || singleton.notifierSecondsVideo.value<int.parse(widget.item.ads![itemAd]!.timeVisible!)){
      //dialogNoWinPoints(context, Strings.nopoints, Strings.nopoints1, Strings.out2, Strings.resume,launchVideo,singleton.notifierPointsGaneRoom.value);
      return true;
    }else{
      this.changeColorHeader();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //return singleton.isOffline?  Nointernet() : OKToast(
      return ValueListenableBuilder<bool>(
          valueListenable: singleton.notifierIsOffline,
          builder: (contexts,value2,_){

            return value2 == true ? Nointernet() : OKToast(
                child: WillPopScope(
                  onWillPop: callToast,
                  //onWillPop: () async => false,

                  child: SafeArea(
                    bottom: true,
                    top: false,
                    child: Scaffold(
                      backgroundColor: CustomColors.black,
                      key: _scaffoldKey,
                      body: AnnotatedRegion<SystemUiOverlayStyle>(
                          value: SystemUiOverlayStyle.dark,
                          child: ValueListenableBuilder<int>(

                              valueListenable: notifierformatValue,
                              builder: (context,value4,_){

                                if (value4 == 1) { /// Video
                                  return Stack( /// Video Player

                                    children: [

                                      /// Video Player
                                      Stack(
                                        //fit:  StackFit.expand ,
                                        children: [

                                          Hero(
                                            tag: widget.item.id!,

                                            child: ValueListenableBuilder<bool>(
                                                valueListenable: singleton.notifierVideoLoaded,
                                                builder: (context,value1,_){

                                                  return value1==true ? Container(

                                                    child:
                                                    /*FutureBuilder(
                                                      future: singleton.initializeVideoPlayerFuture,
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.done) {
                                                          // If the VideoPlayerController has finished initialization, use
                                                          // the data it provides to limit the aspect ratio of the video.
                                                          return SizedBox.expand(
                                                              child: FittedBox(
                                                                fit: BoxFit.contain,
                                                                child: SizedBox(
                                                                  width: singleton.controller!.value.size?.width ?? 0,
                                                                  height: singleton.controller!.value.size?.height ?? 0,
                                                                  child: AspectRatio(
                                                                      aspectRatio: singleton.controller!.value.aspectRatio,
                                                                      child: VideoPlayer(singleton.controller!)
                                                                  ),

                                                                  /*child: AspectRatio(
                                                      aspectRatio: singleton.controller.value.aspectRatio,
                                                      child: VimeoPlayer(
                                                        videoId: urlVImeo[urlVImeo.length-1],
                                                      ),
                                                    ),*/


                                                                ),
                                                              )
                                                          );

                                                        } else {
                                                          // If the VideoPlayerController is still initializing, show a
                                                          // loading spinner.
                                                          return Center(child: CircularProgressIndicator());
                                                        }

                                                      },
                                                    )*/
                                                    singleton.controller != null ?
                                                    SizedBox.expand(
                                                        child: FittedBox(
                                                          fit: BoxFit.contain,
                                                          child: SizedBox(
                                                            width: singleton.controller!.value.size?.width ?? 0,
                                                            height: singleton.controller!.value.size?.height ?? 0,
                                                            child: AspectRatio(
                                                                aspectRatio: singleton.controller!.value.aspectRatio,
                                                                child: VideoPlayer(singleton.controller!)
                                                            ),

                                                            /*child: AspectRatio(
                                                                  aspectRatio: singleton.controller!.value.aspectRatio,
                                                                  child: VimeoPlayer(
                                                                    videoId: urlVImeo[urlVImeo.length-1],
                                                                  ),
                                                                ),*/
                                                          ),
                                                        )
                                                    ): Center(child: CircularProgressIndicator())

                                                  ) : Container( /// Preloading video
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.height,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill, image:
                                                      AssetImage(
                                                          'assets/images/fondo.png'
                                                      )
                                                      ),
                                                    ),
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [

                                                        /// Animation
                                                        /*Lottie.asset(
                                                    'assets/images/wincoins.json',
                                                    repeat: true,
                                                    fit:BoxFit.cover,
                                                  ),*/

                                                        Image(
                                                          image: AssetImage("assets/images/prevideo.gif"),
                                                          fit:BoxFit.contain,
                                                        ),

                                                        Positioned(
                                                          right: 10,
                                                          top: 10,
                                                          child: InkWell(
                                                            onTap: (){

                                                              /// agregado
                                                              dispoandWait();
                                                              backOnceOne();
                                                              Navigator.pop(context);
                                                              //Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );

                                                            },
                                                            child: Container(
                                                              width: 40,height: 40,
                                                              //color: Colors.blue,
                                                              margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 29 : 10,right: 10),
                                                              alignment: Alignment.topRight,
                                                              child: SvgPicture.asset(
                                                                'assets/images/ic_close_orange.svg',
                                                                fit: BoxFit.contain,
                                                                color: CustomColors.white,
                                                                width: 30,height: 30,
                                                              ),
                                                            ),
                                                          ),
                                                        )

                                                      ],

                                                    ),

                                                  );/// agregado

                                                }

                                            ),


                                          ),

                                        ],

                                      ),

                                      /*///Header
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                  decoration: BoxDecoration(
                                    color: CustomColors.red,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[

                                      /// Home
                                      InkWell(
                                        onTap: (){

                                          singleton.controller.pause();
                                          /*if(singleton.notifierSecondsVideo.value== 0 || singleton.notifierSecondsVideo.value<int.parse(widget.item.ads![itemAd]!.timeVisible!)){
                                          dialogNoWinPoints(context, Strings.nopoints, Strings.nopoints1, Strings.out2, Strings.resume,launchVideo,singleton.notifierPointsGaneRoom.value);
                                        }else{
                                          outScreen = true;
                                          launchFetchObtainPointsAds();
                                        }*/

                                          /// agregado
                                          dialogNoWinPoints(context, Strings.nopoints, Strings.nopoints1, Strings.out2, Strings.resume,launchVideo,singleton.notifierPointsGaneRoom.value);

                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 10 : 0),
                                          alignment: Alignment.topRight,
                                          child: SvgPicture.asset(
                                            'assets/images/ic_home.svg',
                                            fit: BoxFit.contain,
                                            //color: CustomColors.greyplaceholder
                                          ),
                                        ),
                                      ),

                                      /// Points
                                      Expanded(
                                        child:
                                        Container(
                                          //color: Colors.red,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 25 : 10,right: 10),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: new TextSpan(
                                              style: new TextStyle(
                                                fontSize: 12.0,
                                              ),
                                              children: <TextSpan>[
                                                new TextSpan(text: Strings.greatwin19,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                                )),
                                                new TextSpan(text: singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangelight, fontSize: 12.0,
                                                )),
                                                new TextSpan(text: " puntos",style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangelight, fontSize: 12.0,
                                                )),
                                                new TextSpan(text: singleton.format==1 ? Strings.greatwin22 : singleton.format==4 ? Strings.greatwin44: singleton.format==3 ? Strings.greatwin55 : Strings.greatwin33,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                                )),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// Circular progress
                                      ValueListenableBuilder<bool>(

                                          valueListenable: singleton.notifierVideoLoaded,
                                          builder: (context,value1,_){

                                            return value1==false ? Container() : Positioned(
                                                top: 35,
                                                right: 10,
                                                child: ValueListenableBuilder<int>(
                                                    valueListenable: singleton.notifierSecondsVideo,
                                                    builder: (contexts,value2,_){

                                                      //return (value2== 0 || value2<singleton.controller.value.duration.inSeconds) ? CircularPercentIndicator(
                                                      return (value2== 0 || value2<int.parse(widget.item.ads![itemAd]!.timeVisible!)) ? CircularPercentIndicator(
                                                        radius: 45.0,
                                                        lineWidth: 4.0,
                                                        percent: ((value2*100)/int.parse(widget.item.ads![itemAd]!.timeVisible!))/100,
                                                        center: new Text(///grayalert1
                                                          (int.parse(widget.item.ads![itemAd]!.timeVisible!) - value2).toString(),style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 14,),
                                                        ),
                                                        progressColor: CustomColors.grayalert1,
                                                      ) : InkWell(
                                                        onTap: (){

                                                          if(once==0){

                                                            once = once + 1;
                                                            /// agregado
                                                            backOnceOne();
                                                            launchFetchObtainPointsAds();

                                                          }

                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 25 : 10),
                                                          alignment: Alignment.topRight,
                                                          child: SvgPicture.asset(
                                                            'assets/images/ic_close_mira.svg',
                                                            fit: BoxFit.contain,
                                                            //color: CustomColors.greyplaceholder
                                                          ),
                                                        ),
                                                      );

                                                    }

                                                )
                                            );

                                          }

                                      ),

                                    ],
                                  ),
                                ),*/

                                      ///Header
                                      ValueListenableBuilder<bool>(
                                          valueListenable: singleton.notifierVideoLoaded,
                                          builder: (context,value1,_){

                                            return value1 == true ?
                                            ValueListenableBuilder<bool>(
                                                valueListenable: notifierActiveHeader,
                                                builder: (context,value11,_){

                                                  return value11==true ?
                                                          Container( /// Pre View Win
                                                            child: Stack(
                                                              alignment: Alignment.center,

                                                              children: [

                                                                /// Black back Container
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: MediaQuery.of(context).size.height,
                                                                  color: CustomColors.backBlackWin.withOpacity(0.35),
                                                                ),

                                                                /// Back
                                                                /*Positioned(
                                                                top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10,right: 20,
                                                                  child: InkWell(
                                                                    onTap: (){

                                                                        /// agregado
                                                                        backOnceOne();
                                                                        Navigator.pop(context);


                                                                    },
                                                                    child: Container(
                                                                      //color: Colors.blue,
                                                                      width: 30,height: 30,
                                                                      //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10,right: 20),
                                                                      child: SvgPicture.asset(
                                                                        'assets/images/ic_close_orange.svg',
                                                                        fit: BoxFit.contain,
                                                                        color: CustomColors.white,

                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),*/

                                                                /// Center Data
                                                                Container(
                                                                  //width: MediaQuery.of(context).size.width,
                                                                  //color: Colors.yellow,
                                                                  //color: Colors.yellow,
                                                                  child: SingleChildScrollView(
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,


                                                                      children: [

                                                                        SizedBox(height: 20,),

                                                                        /// Win
                                                                        Container(

                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,

                                                                            children: [

                                                                              /// Win
                                                                              Container(
                                                                                child: Text("Gana "+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_semiboldFe,
                                                                                      fontSize:40,
                                                                                      color: CustomColors.white),
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                ),
                                                                              ),

                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),

                                                                              ///Coin image
                                                                              Container(
                                                                                child: SvgPicture.asset(
                                                                                  'assets/images/coins.svg',
                                                                                  fit: BoxFit.contain,
                                                                                  width: 25,
                                                                                  height: 25,
                                                                                ),
                                                                              ),

                                                                            ],

                                                                          ),

                                                                        ),

                                                                        /*/SizedBox(height: 10,),

                                                                      /// for do
                                                                      Container(
                                                                        child: Text(formatValue == 1 ? Strings.fordovideo : formatValue == 2 ? Strings.fordoimage : Strings.fordopoll,
                                                                          style: TextStyle(
                                                                              fontFamily: Strings.font_medium,
                                                                              fontSize:15,
                                                                              color: CustomColors.white),
                                                                          textAlign: TextAlign.center,
                                                                          textScaleFactor: 1.0,
                                                                        ),
                                                                      ),

                                                                      /// aditional for do
                                                                      widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                                      Container(
                                                                        margin: EdgeInsets.only(top: 5,left: 30, right: 30),
                                                                        child: Text(utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ? Strings.gotocall1 :
                                                                        utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ? Strings.gotowhats1 : Strings.gotoweb1,
                                                                            textScaleFactor: 1.0,
                                                                            style: TextStyle(
                                                                                fontFamily: Strings.font_medium,
                                                                                fontSize:15,
                                                                                color: CustomColors.white),
                                                                            textAlign: TextAlign.center
                                                                        ),
                                                                      ),*/

                                                                        /// for do
                                                                        /*Container(
                                                                        child: Text(Strings.winmore,
                                                                          style: TextStyle(
                                                                              fontFamily: Strings.font_semiboldFe,
                                                                              fontSize:20,
                                                                              color: CustomColors.white),
                                                                          textAlign: TextAlign.center,
                                                                          textScaleFactor: 1.0,
                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 30,),*/


                                                                        /// Keyboard and numbers
                                                                        Card(
                                                                          margin: EdgeInsets.only(top: 20,bottom: 20, left: 60,right: 60),
                                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                          color: CustomColors.white,
                                                                          elevation: 5,
                                                                          shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20),
                                                                          ),
                                                                          child: Container(

                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [

                                                                                SizedBox(height: 20,),

                                                                                /// Image
                                                                                Container(
                                                                                  //color: Colors.red,
                                                                                  width: 180,
                                                                                  //height: 80,
                                                                                  child: Image.network(
                                                                                    //"http://www.tusitio.com/image.png",
                                                                                      widget.item.ads![itemAd]!.adImages!,
                                                                                      fit: BoxFit.contain,
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
                                                                                      errorBuilder: (_, __, ___) {

                                                                                        return Container(
                                                                                          //color: Colors.red,
                                                                                          child: Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [

                                                                                              SvgPicture.asset(
                                                                                                'assets/images/ic_gane.svg',
                                                                                                fit: BoxFit.contain,
                                                                                                width: 180,
                                                                                              ),
                                                                                            ],

                                                                                          ),
                                                                                        );

                                                                                      }

                                                                                  ),
                                                                                ),

                                                                                SizedBox(height: 15,),

                                                                                /// add number
                                                                                Container(
                                                                                  child: Text(Strings.addnumber,
                                                                                    style: TextStyle(
                                                                                        fontFamily: Strings.font_semiboldFe,
                                                                                        fontSize:18,
                                                                                        color: CustomColors.black),
                                                                                    textAlign: TextAlign.center,
                                                                                    textScaleFactor: 1.0,
                                                                                  ),
                                                                                ),

                                                                                SizedBox(height: 10,),

                                                                                /// Number target
                                                                                ValueListenableBuilder<int>(
                                                                                    valueListenable: singleton.notifierNumberReward,
                                                                                    builder: (context,number,_){

                                                                                      return Container(
                                                                                        child: Text(number.toString(),
                                                                                          style: TextStyle(
                                                                                              fontFamily: Strings.font_boldFe,
                                                                                              fontSize:30,
                                                                                              color: CustomColors.black),
                                                                                          textAlign: TextAlign.center,
                                                                                          textScaleFactor: 1.0,
                                                                                        ),
                                                                                      );

                                                                                    }
                                                                                ),

                                                                                SizedBox(height: 10,),

                                                                                /// Number digit
                                                                                ValueListenableBuilder<String>(
                                                                                    valueListenable: singleton.notifierNumberRewardDigit,
                                                                                    builder: (context,number,_){

                                                                                      return Container(
                                                                                        width: 180,
                                                                                        decoration: BoxDecoration(
                                                                                          color: CustomColors.lightGrayNumbers,
                                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                                        ),
                                                                                        child: Container(
                                                                                          margin: EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30),
                                                                                          child: Text(number,
                                                                                            style: TextStyle(
                                                                                                fontFamily: Strings.font_boldFe,
                                                                                                fontSize:25,
                                                                                                color: CustomColors.black),
                                                                                            textAlign: TextAlign.center,
                                                                                            textScaleFactor: 1.0,
                                                                                          ),
                                                                                        ),
                                                                                      );

                                                                                    }
                                                                                ),

                                                                                SizedBox(height: 10,),

                                                                                /// Keyboard
                                                                                Container(
                                                                                  //margin: EdgeInsets.only(left: 20,right: 20),
                                                                                  width: 180,
                                                                                  child: StaggeredGridView.countBuilder(
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    shrinkWrap: true,
                                                                                    scrollDirection: Axis.vertical,
                                                                                    crossAxisCount: 3,
                                                                                    itemCount: 11,
                                                                                    itemBuilder: (BuildContext context, int index) {

                                                                                      return index==10 ?
                                                                                      InkWell(
                                                                                        onTap: (){
                                                                                          singleton.notifierNumberRewardDigit.value= "";
                                                                                          singleton.notifierNumberChange.value = false;
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 45,
                                                                                          decoration: BoxDecoration(
                                                                                            color: CustomColors.lightGrayNumbers,
                                                                                            borderRadius: BorderRadius.circular(5.0),
                                                                                          ),
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            //margin: EdgeInsets.all(20),
                                                                                            child: Text("Borrar",
                                                                                              style: TextStyle(
                                                                                                  fontFamily: Strings.font_semiboldFe,
                                                                                                  fontSize:25,
                                                                                                  color: CustomColors.black),
                                                                                              textAlign: TextAlign.center,
                                                                                              textScaleFactor: 1.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ):
                                                                                      InkWell(
                                                                                        onTap: (){
                                                                                          if(singleton.notifierNumberRewardDigit.value.length < 4){
                                                                                            // if(singleton.notifierNumberRewardDigit.value.length < 2){

                                                                                            if( index==9){
                                                                                              singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value +"0";
                                                                                            }else{
                                                                                              singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value + (index+1).toString();
                                                                                            }


                                                                                            print("Numero digitado: "+singleton.notifierNumberRewardDigit.value);
                                                                                            print("Numero genrado: "+singleton.notifierNumberReward.value.toString());
                                                                                            if(int.parse(singleton.notifierNumberRewardDigit.value) == singleton.notifierNumberReward.value){
                                                                                              singleton.notifierNumberChange.value = true;
                                                                                            }else{
                                                                                              singleton.notifierNumberChange.value = false;
                                                                                              //utils.openSnackBarInfo(context, Strings.erroraddnumber, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                            }

                                                                                          }
                                                                                        },
                                                                                        child: Container(
                                                                                          width: 45,height: 45,
                                                                                          decoration: BoxDecoration(
                                                                                            color: CustomColors.lightGrayNumbers,
                                                                                            borderRadius: BorderRadius.circular(5.0),
                                                                                          ),
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            //color: Colors.blue,
                                                                                            //margin: EdgeInsets.all(20),
                                                                                            child: Text( index== 9 ? "0" : (index+1).toString(),
                                                                                              style: TextStyle(
                                                                                                  fontFamily: Strings.font_semiboldFe,
                                                                                                  fontSize:25,
                                                                                                  color: CustomColors.black),
                                                                                              textAlign: TextAlign.center,
                                                                                              textScaleFactor: 1.0,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );

                                                                                    } ,
                                                                                    staggeredTileBuilder: (int index) {
                                                                                      return index == 10 ? StaggeredTile.fit(2) : StaggeredTile.fit(1);
                                                                                    },
                                                                                    mainAxisSpacing: 7.0,
                                                                                    crossAxisSpacing: 7.0,
                                                                                    padding: const EdgeInsets.all(4),

                                                                                  ),
                                                                                ),


                                                                                SizedBox(height: 20,),

                                                                                /// Go to for reward
                                                                                widget.item.ads![itemAd]!.url! == "" ? Container(

                                                                                  child: ValueListenableBuilder<bool>(
                                                                                      valueListenable: singleton.notifierNumberChange,
                                                                                      builder: (context,change,_){
                                                                                        return SpringButton(
                                                                                          SpringButtonType.OnlyScale,
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(left:60,right: 60 ),
                                                                                            height: 40,
                                                                                            decoration: BoxDecoration(
                                                                                                color:CustomColors.orangeswitch,
                                                                                                borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                            ),
                                                                                            child: Center(
                                                                                                child: Container(
                                                                                                  //margin: EdgeInsets.only(left: 20,right: 20),
                                                                                                  child: Text(Strings.backtoreward1,
                                                                                                      textScaleFactor: 1.0,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                          fontFamily: Strings.font_semibold,
                                                                                                          fontSize: 12,
                                                                                                          letterSpacing: 0.5,
                                                                                                          color: CustomColors.grayback
                                                                                                      )
                                                                                                  ),
                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                          useCache: false,
                                                                                          onTap: (){
                                                                                            if(value1==true){ /// if header is active

                                                                                              if(change==true){
                                                                                                /// agregado
                                                                                                backOnceOne();
                                                                                                launchFetchObtainPointsAds();
                                                                                              }else{
                                                                                                detectIntents();
                                                                                                utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                              }

                                                                                            }
                                                                                          },
                                                                                        );
                                                                                      }
                                                                                  ),

                                                                                ) : Container(),

                                                                                /// Got to Call, Whatsapp or Url
                                                                                widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                                                utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ?
                                                                                Container(
                                                                                  child: ValueListenableBuilder<bool>(
                                                                                      valueListenable: singleton.notifierNumberChange,
                                                                                      builder: (context,change,_){

                                                                                        return SpringButton(
                                                                                          SpringButtonType.OnlyScale,
                                                                                          Container(
                                                                                            //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                            height: 40,
                                                                                            width: 170,
                                                                                            decoration: BoxDecoration(
                                                                                                color:CustomColors.orangeswitch,
                                                                                                borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                            ),
                                                                                            child: Center(
                                                                                                child: Row(

                                                                                                  children: [

                                                                                                    ///Icon
                                                                                                    Container(
                                                                                                      //color: Colors.purple,
                                                                                                      margin: EdgeInsets.only(left: 20),
                                                                                                      child: SvgPicture.asset(
                                                                                                        'assets/images/ic_calling.svg',
                                                                                                        //fit: BoxFit.contain,
                                                                                                        width: 20,
                                                                                                        height: 20,
                                                                                                      ),
                                                                                                    ),

                                                                                                    SizedBox(width: 10,),

                                                                                                    /// Text
                                                                                                    Expanded(
                                                                                                      child: Container(
                                                                                                        //color: Colors.blue,
                                                                                                        margin: EdgeInsets.only(right: 30),
                                                                                                        child: Text(Strings.gotocall,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            textScaleFactor: 1.0,
                                                                                                            style: TextStyle(
                                                                                                                fontFamily: Strings.font_semibold,
                                                                                                                fontSize: 13,
                                                                                                                letterSpacing: 0.5,
                                                                                                                color: CustomColors.grayback)
                                                                                                        ),
                                                                                                      ),
                                                                                                    )

                                                                                                  ],

                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                          useCache: false,
                                                                                          onTap: (){

                                                                                            if(change==true){
                                                                                              backOnceOne();
                                                                                              launchFetchObtainPointsAds();
                                                                                            }else{
                                                                                              detectIntents();
                                                                                              utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                            }

                                                                                          },
                                                                                        );

                                                                                      }
                                                                                  ),
                                                                                ) :
                                                                                utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ?
                                                                                Container(
                                                                                  child: ValueListenableBuilder<bool>(
                                                                                      valueListenable: singleton.notifierNumberChange,
                                                                                      builder: (context,change,_){

                                                                                        return SpringButton(
                                                                                          SpringButtonType.OnlyScale,
                                                                                          Container(
                                                                                            //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                            height: 40,
                                                                                            width: 170,
                                                                                            decoration: BoxDecoration(
                                                                                                color:CustomColors.greenwhats,
                                                                                                borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                            ),
                                                                                            child: Center(
                                                                                                child: Row(

                                                                                                  children: [

                                                                                                    ///Icon
                                                                                                    Container(
                                                                                                      //color: Colors.purple,
                                                                                                      margin: EdgeInsets.only(left: 20),
                                                                                                      child: SvgPicture.asset(
                                                                                                        'assets/images/ic_waChat.svg',
                                                                                                        //fit: BoxFit.contain,
                                                                                                        width: 20,
                                                                                                        height: 20,
                                                                                                      ),
                                                                                                    ),

                                                                                                    SizedBox(width: 10,),

                                                                                                    /// Text
                                                                                                    Expanded(
                                                                                                      child: Container(
                                                                                                        //color: Colors.blue,
                                                                                                        margin: EdgeInsets.only(right: 30),
                                                                                                        child: Text(Strings.gotowhats,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            textScaleFactor: 1.0,
                                                                                                            style: TextStyle(
                                                                                                                fontFamily: Strings.font_semibold,
                                                                                                                fontSize: 13,
                                                                                                                letterSpacing: 0.5,
                                                                                                                color: CustomColors.grayback)
                                                                                                        ),
                                                                                                      ),
                                                                                                    )

                                                                                                  ],

                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                          useCache: false,
                                                                                          onTap: (){
                                                                                            if(change==true){
                                                                                              backOnceOne();
                                                                                              launchFetchObtainPointsAds();
                                                                                            }else{
                                                                                              detectIntents();
                                                                                              utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                            }
                                                                                          },
                                                                                        );
                                                                                      }

                                                                                  ),
                                                                                ) :
                                                                                Container(
                                                                                  child: ValueListenableBuilder<bool>(
                                                                                      valueListenable: singleton.notifierNumberChange,
                                                                                      builder: (context,change,_){
                                                                                        return SpringButton(
                                                                                          SpringButtonType.OnlyScale,
                                                                                          Container(
                                                                                            //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                            height: 40,
                                                                                            width: 194,
                                                                                            decoration: BoxDecoration(
                                                                                                color:CustomColors.orangeswitch,
                                                                                                borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                            ),
                                                                                            child: Center(
                                                                                                child: Row(

                                                                                                  children: [

                                                                                                    ///Icon
                                                                                                    Container(
                                                                                                      //color: Colors.purple,
                                                                                                      margin: EdgeInsets.only(left: 20),
                                                                                                      child: SvgPicture.asset(
                                                                                                        'assets/images/ic_webSite.svg',
                                                                                                        //fit: BoxFit.contain,
                                                                                                        width: 20,
                                                                                                        height: 20,
                                                                                                      ),
                                                                                                    ),

                                                                                                    SizedBox(width: 10,),

                                                                                                    /// Text
                                                                                                    Expanded(
                                                                                                      child: Container(
                                                                                                        //color: Colors.blue,
                                                                                                        margin: EdgeInsets.only(right: 10),
                                                                                                        child: Text(Strings.gotoweb,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            textScaleFactor: 1.0,
                                                                                                            style: TextStyle(
                                                                                                                fontFamily: Strings.font_semibold,
                                                                                                                fontSize: 13,
                                                                                                                letterSpacing: 0.5,
                                                                                                                color: CustomColors.grayback)
                                                                                                        ),
                                                                                                      ),
                                                                                                    )

                                                                                                  ],

                                                                                                )
                                                                                            ),
                                                                                          ),
                                                                                          useCache: false,
                                                                                          onTap: (){
                                                                                            if(change==true){
                                                                                              backOnceOne();
                                                                                              launchFetchObtainPointsAds();
                                                                                            }else{
                                                                                              detectIntents();
                                                                                              utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                            }
                                                                                          },
                                                                                        );

                                                                                      }

                                                                                  ),
                                                                                ),


                                                                                SizedBox(height: 20,),

                                                                              ],
                                                                            ),

                                                                          ),


                                                                        ),

                                                                        SizedBox(height: 20,),

                                                                      ],

                                                                    ),
                                                                  ),
                                                                ),


                                                              ],

                                                            ),
                                                          ) :
                                                          Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            height: 85,
                                                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                                            decoration: BoxDecoration(
                                                              //color: value11==false ? CustomColors.greyHeaderNowin : CustomColors.orangeHeaderWin,
                                                              color: CustomColors.white.withOpacity(0.7),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey.withOpacity(0.5),
                                                                  spreadRadius: 2,
                                                                  blurRadius: 5,
                                                                  offset: Offset(0, 1), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[

                                                                /// Circular progress
                                                                value11==true ?
                                                                /// Logo gane
                                                                /*Container(
                                                                  alignment: Alignment.topLeft,
                                                                  padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,),
                                                                  child: Image(
                                                                    width: 80,
                                                                    height: 42,
                                                                    image: AssetImage("assets/images/logohome.png"),
                                                                    fit: BoxFit.contain,
                                                                  ),
                                                                )*/ Container(width: 30, height: 30,):
                                                                /// Ciruclar progress
                                                                Container(
                                                                    padding:EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 25 : 8,left: 10),
                                                                    //color: Colors.green,
                                                                    child: ValueListenableBuilder<bool>(

                                                                        valueListenable: singleton.notifierVideoLoaded,
                                                                        builder: (context,value1,_){

                                                                          return value1==false ? Container() : Container(

                                                                              child: ValueListenableBuilder<int>(
                                                                                  valueListenable: singleton.notifierSecondsVideo,
                                                                                  builder: (contexts,value2,_){

                                                                                    /*print(value2);
                                                                          if( value2>int.parse(widget.item.ads![itemAd]!.timeVisible!) ){
                                                                              this.changeColorHeader();
                                                                          }*/

                                                                                    return (value2== 0 || value2<int.parse(widget.item.ads![itemAd]!.timeVisible!)) ?
                                                                                    Transform.scale(
                                                                                      scale: 0.9,
                                                                                      child: Center(
                                                                                        child: CircularPercentIndicator(
                                                                                          radius: 15.0,
                                                                                          lineWidth: 3.0,
                                                                                          percent: ((value2*100)/int.parse(widget.item.ads![itemAd]!.timeVisible!))/100,
                                                                                          center: new Text(///grayalert1
                                                                                            (int.parse(widget.item.ads![itemAd]!.timeVisible!) - value2).toString(),style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.orangeswitch, fontSize: 14,),
                                                                                            textScaleFactor: 1.0,
                                                                                          ),
                                                                                          progressColor: CustomColors.orangeswitch,
                                                                                          backgroundColor: CustomColors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ) :
                                                                                    Container();

                                                                                  }

                                                                              )
                                                                          );

                                                                        }

                                                                    )
                                                                ),

                                                                /// Points
                                                                /*Expanded(
                                                                    child:
                                                                    InkWell(
                                                                      onTap: (){

                                                                        if(value11==true){ /// if header is active
                                                                          if(once==0){

                                                                            once = once + 1;
                                                                            /// agregado
                                                                            backOnceOne();
                                                                            launchFetchObtainPointsAds();

                                                                          }
                                                                        }

                                                                      },
                                                                      child: Container(
                                                                        //color: Colors.blue,
                                                                        margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,right: 8,left: 8),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,

                                                                          children: [

                                                                            /// points
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              child: BorderedText(
                                                                                strokeWidth: 7.0,
                                                                                strokeColor: CustomColors.redBorderTextHeader,
                                                                                child: Text(
                                                                                  "+"+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                                  style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 30.0,),
                                                                                  maxLines: 1,
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),

                                                                            ///Coin image
                                                                            Container(
                                                                              child: SvgPicture.asset(
                                                                                'assets/images/coins.svg',
                                                                                fit: BoxFit.contain,
                                                                                width: 25,
                                                                                height: 25,
                                                                              ),
                                                                            ),

                                                                          ],

                                                                        ),
                                                                      ),
                                                                    )
                                                                ),*/
                                                                /*InkWell(
                                                                  onTap: (){
                                                                    if(value11==true){ /// if header is active
                                                                      if(once==0){

                                                                        once = once + 1;
                                                                        /// agregado
                                                                        backOnceOne();
                                                                        launchFetchObtainPointsAds();

                                                                      }
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    //color: Colors.yellow,
                                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.transparent,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(20)),
                                                                      border: Border.all(
                                                                        width: 3,
                                                                        color: value11==true ? CustomColors.white : Colors.transparent,
                                                                      ),
                                                                    ),
                                                                    margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,right: value11==true ? 50 : 8,left: 8),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,

                                                                      children: [

                                                                        SizedBox(
                                                                          width: 20,
                                                                        ),

                                                                        /// points
                                                                        Container(
                                                                          alignment: Alignment.center,
                                                                          child: BorderedText(
                                                                            strokeWidth: 7.0,
                                                                            strokeColor: CustomColors.redBorderTextHeader,
                                                                            child: Text(
                                                                              "+"+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                              style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 30.0,),
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        SizedBox(
                                                                          width: 5,
                                                                        ),

                                                                        ///Coin image
                                                                        Container(
                                                                          child: SvgPicture.asset(
                                                                            'assets/images/coins.svg',
                                                                            fit: BoxFit.contain,
                                                                            width: 25,
                                                                            height: 25,
                                                                          ),
                                                                        ),

                                                                        SizedBox(
                                                                          width: 20,
                                                                        ),

                                                                      ],

                                                                    ),
                                                                  ),
                                                                ),*/

                                                                /// Back
                                                                ValueListenableBuilder<bool>(
                                                                    valueListenable: notifierMinimumTimeComplete,
                                                                    builder: (context,value112,_){

                                                                      return InkWell(
                                                                        onTap: (){

                                                                          /// agregado
                                                                          //backOnceOne();
                                                                          //Navigator.pop(context);

                                                                          singleton.controller!.pause();
                                                                          if(value112==true){
                                                                            this.changeColorHeader();
                                                                          }else{
                                                                            backOnceOne();
                                                                            Navigator.pop(context);
                                                                            //Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );
                                                                          }

                                                                        },
                                                                        child: Container(
                                                                          width: 40,height: 40,
                                                                          //color: Colors.blue,
                                                                          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 29 : 10,right: 10),
                                                                          alignment: Alignment.topRight,
                                                                          child: SvgPicture.asset(
                                                                            'assets/images/ic_close_orange.svg',
                                                                            fit: BoxFit.contain,
                                                                            //color: CustomColors.orangeswitch,
                                                                            width: 30,height: 30,
                                                                          ),
                                                                        ),
                                                                      );

                                                                    }

                                                                ),

                                                              ],
                                                            ),
                                                          );
                                                }

                                            ) :
                                            Container();

                                          }

                                      ),

                                    ],

                                  );
                                } else {
                                  return value4 == 2 ? Stack ( /// Image

                                    children: [

                                      ///Image
                                      Hero(
                                        tag: widget.item.id!,
                                        child: Container(
                                          //color: Colors.green,
                                            //margin: EdgeInsets.only(top: 80),
                                            //height: MediaQuery.of(context).size.height-80,
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width,
                                            child: Image.network(
                                              //"http://www.tusitio.com/image.png",
                                              widget.item.ads![itemAd]!.adImages!,
                                                //"https://i.pinimg.com/originals/b7/5a/71/b75a7117c51def402c60bafcef9e02c5.jpg",
                                                //"https://static.zerochan.net/Shirogane.Noel.full.3170758.jpg",
                                                //"https://www.plody.work/media/pages/products/bacchus-vertical-divider/bf43a26b93-1609816307/outro-800x1600-q75.jpg",
                                                //"https://images.squarespace-cdn.com/content/v1/56cf0eb5a3360c3f9d46db69/1567786719535-UCV7HMYTIFU63Q6F4FYX/free-digital-mermaid-desktop-wallpapers.jpg",
                                                fit: BoxFit.contain,
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
                                              errorBuilder: (_, __, ___) {

                                                //setState(() {});
                                                return InkWell(
                                                  onTap: (){
                                                    //setState(() {});
                                                    LoadInitialSetting();
                                                  },
                                                  child: Container(
                                                    //color: Colors.red,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [

                                                        SvgPicture.asset(
                                                          'assets/images/ic_gane.svg',
                                                          fit: BoxFit.contain,
                                                          width: 280,
                                                        ),

                                                        SizedBox(height: 10,),

                                                        Icon(Icons.refresh,color: CustomColors.white,size: 40,)


                                                      ],

                                                    ),
                                                  ),
                                                );

                                              }

                                            ),
                                        ),
                                      ),

                                      ///Header
                                      ValueListenableBuilder<bool>(
                                          valueListenable: notifierActiveHeader,
                                          builder: (context,value1,_){

                                            return  value1==true ?
                                            Container( /// Pre View Win
                                              //width: MediaQuery.of(context).size.width,
                                              //height: MediaQuery.of(context).size.height,
                                              child: Stack(
                                                  alignment: Alignment.center,

                                                children: [

                                                  /// Black back Container
                                                  Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: MediaQuery.of(context).size.height,
                                                    color: CustomColors.backBlackWin.withOpacity(0.35),
                                                  ),


                                                  /// Center Data
                                                  Container(
                                                    //width: MediaQuery.of(context).size.width,
                                                    //color: Colors.yellow,
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [

                                                          SizedBox(height: 20,),

                                                          /// Win
                                                          Container(

                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,

                                                              children: [

                                                                /// Win
                                                                Container(
                                                                  child: Text("Gana "+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                      textScaleFactor: 1.0,
                                                                      style: TextStyle(
                                                                          fontFamily: Strings.font_semiboldFe,
                                                                          fontSize:40,
                                                                          color: CustomColors.white),
                                                                      textAlign: TextAlign.center
                                                                  ),
                                                                ),

                                                                SizedBox(
                                                                  width: 5,
                                                                ),

                                                                ///Coin image
                                                                Container(
                                                                  child: SvgPicture.asset(
                                                                    'assets/images/coins.svg',
                                                                    fit: BoxFit.contain,
                                                                    width: 25,
                                                                    height: 25,
                                                                  ),
                                                                ),

                                                              ],

                                                            ),

                                                          ),

                                                          /*SizedBox(height: 10,),

                                                        /// for do
                                                        Container(
                                                          child: Text(formatValue == 1 ? Strings.fordovideo : formatValue == 2 ? Strings.fordoimage : Strings.fordopoll,
                                                              textScaleFactor: 1.0,
                                                              style: TextStyle(
                                                                  fontFamily: Strings.font_medium,
                                                                  fontSize:15,
                                                                  color: CustomColors.white),
                                                              textAlign: TextAlign.center
                                                          ),
                                                        ),

                                                        /// aditional for do
                                                        widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                        Container(
                                                          margin: EdgeInsets.only(top: 5,left: 30, right: 30),
                                                          child: Text(utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ? Strings.gotocall1 :
                                                          utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ? Strings.gotowhats1 : Strings.gotoweb1,
                                                              textScaleFactor: 1.0,
                                                              style: TextStyle(
                                                                  fontFamily: Strings.font_medium,
                                                                  fontSize:15,
                                                                  color: CustomColors.white),
                                                              textAlign: TextAlign.center
                                                          ),
                                                        ),*/

                                                          /// Keyboard and numbers
                                                          Card(
                                                            margin: EdgeInsets.only(top: 20,bottom: 20, left: 60,right: 60),
                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                            color: CustomColors.white,
                                                            elevation: 5,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            child: Container(

                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [

                                                                  SizedBox(height: 20,),

                                                                  /// Image
                                                                  Container(
                                                                    //color: Colors.red,
                                                                    width: 180,
                                                                    //height: 80,
                                                                    child: Image.network(
                                                                      //"http://www.tusitio.com/image.png",
                                                                        widget.item.ads![itemAd]!.lgImages!,
                                                                        fit: BoxFit.contain,
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
                                                                        errorBuilder: (_, __, ___) {

                                                                          return Container(
                                                                            //color: Colors.red,
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [

                                                                                SvgPicture.asset(
                                                                                  'assets/images/ic_gane.svg',
                                                                                  fit: BoxFit.contain,
                                                                                  width: 180,
                                                                                ),
                                                                              ],

                                                                            ),
                                                                          );

                                                                        }

                                                                    ),
                                                                  ),

                                                                  SizedBox(height: 15,),

                                                                  SizedBox(height: 20,),

                                                                  /// add number
                                                                  Container(
                                                                    child: Text(Strings.addnumber,
                                                                      style: TextStyle(
                                                                          fontFamily: Strings.font_semiboldFe,
                                                                          fontSize:18,
                                                                          color: CustomColors.black),
                                                                      textAlign: TextAlign.center,
                                                                      textScaleFactor: 1.0,
                                                                    ),
                                                                  ),

                                                                  SizedBox(height: 10,),

                                                                  /// Number target
                                                                  ValueListenableBuilder<int>(
                                                                      valueListenable: singleton.notifierNumberReward,
                                                                      builder: (context,number,_){

                                                                        return Container(
                                                                          child: Text(number.toString(),
                                                                            style: TextStyle(
                                                                                fontFamily: Strings.font_boldFe,
                                                                                fontSize:30,
                                                                                color: CustomColors.black),
                                                                            textAlign: TextAlign.center,
                                                                            textScaleFactor: 1.0,
                                                                          ),
                                                                        );

                                                                      }
                                                                  ),

                                                                  SizedBox(height: 10,),

                                                                  /// Number digit
                                                                  ValueListenableBuilder<String>(
                                                                      valueListenable: singleton.notifierNumberRewardDigit,
                                                                      builder: (context,number,_){

                                                                        return Container(
                                                                          width: 180,
                                                                          decoration: BoxDecoration(
                                                                            color: CustomColors.lightGrayNumbers,
                                                                            borderRadius: BorderRadius.circular(5.0),
                                                                          ),
                                                                          child: Container(
                                                                            margin: EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30),
                                                                            child: Text(number,
                                                                              style: TextStyle(
                                                                                  fontFamily: Strings.font_boldFe,
                                                                                  fontSize:25,
                                                                                  color: CustomColors.black),
                                                                              textAlign: TextAlign.center,
                                                                              textScaleFactor: 1.0,
                                                                            ),
                                                                          ),
                                                                        );

                                                                      }
                                                                  ),

                                                                  SizedBox(height: 10,),

                                                                  /// Keyboard
                                                                  Container(
                                                                    width: 180,
                                                                    child: StaggeredGridView.countBuilder(
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      shrinkWrap: true,
                                                                      scrollDirection: Axis.vertical,
                                                                      crossAxisCount: 3,
                                                                      itemCount: 11,
                                                                      itemBuilder: (BuildContext context, int index) {

                                                                        return index==10 ?
                                                                        InkWell(
                                                                          onTap: (){
                                                                            singleton.notifierNumberRewardDigit.value= "";
                                                                            singleton.notifierNumberChange.value = false;
                                                                          },
                                                                          child: Container(
                                                                            height: 45,
                                                                            decoration: BoxDecoration(
                                                                              color: CustomColors.lightGrayNumbers,
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                            child: Container(
                                                                              alignment: Alignment.center,
                                                                              //margin: EdgeInsets.all(20),
                                                                              child: Text("Borrar",
                                                                                style: TextStyle(
                                                                                    fontFamily: Strings.font_semiboldFe,
                                                                                    fontSize:25,
                                                                                    color: CustomColors.black),
                                                                                textAlign: TextAlign.center,
                                                                                textScaleFactor: 1.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ):
                                                                        InkWell(
                                                                          onTap: (){
                                                                            if(singleton.notifierNumberRewardDigit.value.length < 4){

                                                                              if( index==9){
                                                                                singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value +"0";
                                                                              }else{
                                                                                singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value + (index+1).toString();
                                                                              }


                                                                              print("Numero digitado: "+singleton.notifierNumberRewardDigit.value);
                                                                              print("Numero genrado: "+singleton.notifierNumberReward.value.toString());
                                                                              if(int.parse(singleton.notifierNumberRewardDigit.value) == singleton.notifierNumberReward.value){
                                                                                singleton.notifierNumberChange.value = true;
                                                                              }else{
                                                                                singleton.notifierNumberChange.value = false;
                                                                                //utils.openSnackBarInfo(context, Strings.erroraddnumber, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                              }

                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            width: 45,height: 45,
                                                                            decoration: BoxDecoration(
                                                                              color: CustomColors.lightGrayNumbers,
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                            ),
                                                                            child: Container(
                                                                              alignment: Alignment.center,
                                                                              //color: Colors.blue,
                                                                              //margin: EdgeInsets.all(20),
                                                                              child: Text( index== 9 ? "0" : (index+1).toString(),
                                                                                style: TextStyle(
                                                                                    fontFamily: Strings.font_semiboldFe,
                                                                                    fontSize:25,
                                                                                    color: CustomColors.black),
                                                                                textAlign: TextAlign.center,
                                                                                textScaleFactor: 1.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );

                                                                      } ,
                                                                      staggeredTileBuilder: (int index) {
                                                                        return index == 10 ? StaggeredTile.fit(2) : StaggeredTile.fit(1);
                                                                      },
                                                                      mainAxisSpacing: 7.0,
                                                                      crossAxisSpacing: 7.0,
                                                                      padding: const EdgeInsets.all(4),

                                                                    ),
                                                                  ),


                                                                  SizedBox(height: 20,),

                                                                  /// Go to for reward
                                                                  widget.item.ads![itemAd]!.url! == "" ? Container(

                                                                    child: ValueListenableBuilder<bool>(
                                                                        valueListenable: singleton.notifierNumberChange,
                                                                        builder: (context,change,_){
                                                                          return SpringButton(
                                                                            SpringButtonType.OnlyScale,
                                                                            Container(
                                                                              margin: EdgeInsets.only(left:60,right: 60 ),
                                                                              height: 40,
                                                                              decoration: BoxDecoration(
                                                                                  color:CustomColors.orangeswitch,
                                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                              ),
                                                                              child: Center(
                                                                                  child: Container(
                                                                                    //margin: EdgeInsets.only(left: 20,right: 20),
                                                                                    child: Text(Strings.backtoreward1,
                                                                                        textScaleFactor: 1.0,
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                            fontFamily: Strings.font_semibold,
                                                                                            fontSize: 12,
                                                                                            letterSpacing: 0.5,
                                                                                            color: CustomColors.grayback
                                                                                        )
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                            ),
                                                                            useCache: false,
                                                                            onTap: (){
                                                                              if(value1==true){ /// if header is active

                                                                                if(change==true){
                                                                                  /// agregado
                                                                                  backOnceOne();
                                                                                  launchFetchObtainPointsAds();
                                                                                }else{
                                                                                  detectIntents();
                                                                                  utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                }

                                                                              }
                                                                            },
                                                                          );
                                                                        }
                                                                    ),

                                                                  ) : Container(),

                                                                  /// Got to Call, Whatsapp or Url
                                                                  widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                                  utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ?
                                                                  Container(
                                                                    child: ValueListenableBuilder<bool>(
                                                                        valueListenable: singleton.notifierNumberChange,
                                                                        builder: (context,change,_){

                                                                          return SpringButton(
                                                                            SpringButtonType.OnlyScale,
                                                                            Container(
                                                                              //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                              height: 40,
                                                                              width: 170,
                                                                              decoration: BoxDecoration(
                                                                                  color:CustomColors.orangeswitch,
                                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                              ),
                                                                              child: Center(
                                                                                  child: Row(

                                                                                    children: [

                                                                                      ///Icon
                                                                                      Container(
                                                                                        //color: Colors.purple,
                                                                                        margin: EdgeInsets.only(left: 20),
                                                                                        child: SvgPicture.asset(
                                                                                          'assets/images/ic_calling.svg',
                                                                                          //fit: BoxFit.contain,
                                                                                          width: 20,
                                                                                          height: 20,
                                                                                        ),
                                                                                      ),

                                                                                      SizedBox(width: 10,),

                                                                                      /// Text
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          //color: Colors.blue,
                                                                                          margin: EdgeInsets.only(right: 30),
                                                                                          child: Text(Strings.gotocall,
                                                                                              textAlign: TextAlign.center,
                                                                                              textScaleFactor: 1.0,
                                                                                              style: TextStyle(
                                                                                                  fontFamily: Strings.font_semibold,
                                                                                                  fontSize: 13,
                                                                                                  letterSpacing: 0.5,
                                                                                                  color: CustomColors.grayback)
                                                                                          ),
                                                                                        ),
                                                                                      )

                                                                                    ],

                                                                                  )
                                                                              ),
                                                                            ),
                                                                            useCache: false,
                                                                            onTap: (){

                                                                              if(change==true){
                                                                                backOnceOne();
                                                                                launchFetchObtainPointsAds();
                                                                              }else{
                                                                                detectIntents();
                                                                                utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                              }

                                                                            },
                                                                          );

                                                                        }
                                                                    ),
                                                                  ) :
                                                                  utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ?
                                                                  Container(
                                                                    child: ValueListenableBuilder<bool>(
                                                                        valueListenable: singleton.notifierNumberChange,
                                                                        builder: (context,change,_){

                                                                          return SpringButton(
                                                                            SpringButtonType.OnlyScale,
                                                                            Container(
                                                                              //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                              height: 40,
                                                                              width: 170,
                                                                              decoration: BoxDecoration(
                                                                                  color:CustomColors.greenwhats,
                                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                              ),
                                                                              child: Center(
                                                                                  child: Row(

                                                                                    children: [

                                                                                      ///Icon
                                                                                      Container(
                                                                                        //color: Colors.purple,
                                                                                        margin: EdgeInsets.only(left: 20),
                                                                                        child: SvgPicture.asset(
                                                                                          'assets/images/ic_waChat.svg',
                                                                                          //fit: BoxFit.contain,
                                                                                          width: 20,
                                                                                          height: 20,
                                                                                        ),
                                                                                      ),

                                                                                      SizedBox(width: 10,),

                                                                                      /// Text
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          //color: Colors.blue,
                                                                                          margin: EdgeInsets.only(right: 30),
                                                                                          child: Text(Strings.gotowhats,
                                                                                              textAlign: TextAlign.center,
                                                                                              textScaleFactor: 1.0,
                                                                                              style: TextStyle(
                                                                                                  fontFamily: Strings.font_semibold,
                                                                                                  fontSize: 13,
                                                                                                  letterSpacing: 0.5,
                                                                                                  color: CustomColors.grayback)
                                                                                          ),
                                                                                        ),
                                                                                      )

                                                                                    ],

                                                                                  )
                                                                              ),
                                                                            ),
                                                                            useCache: false,
                                                                            onTap: (){
                                                                              if(change==true){
                                                                                backOnceOne();
                                                                                launchFetchObtainPointsAds();
                                                                              }else{
                                                                                detectIntents();
                                                                                utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                              }
                                                                            },
                                                                          );
                                                                        }

                                                                    ),
                                                                  ) :
                                                                  Container(
                                                                    child: ValueListenableBuilder<bool>(
                                                                        valueListenable: singleton.notifierNumberChange,
                                                                        builder: (context,change,_){
                                                                          return SpringButton(
                                                                            SpringButtonType.OnlyScale,
                                                                            Container(
                                                                              //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                              height: 40,
                                                                              width: 194,
                                                                              decoration: BoxDecoration(
                                                                                  color:CustomColors.orangeswitch,
                                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                              ),
                                                                              child: Center(
                                                                                  child: Row(

                                                                                    children: [

                                                                                      ///Icon
                                                                                      Container(
                                                                                        //color: Colors.purple,
                                                                                        margin: EdgeInsets.only(left: 20),
                                                                                        child: SvgPicture.asset(
                                                                                          'assets/images/ic_webSite.svg',
                                                                                          //fit: BoxFit.contain,
                                                                                          width: 20,
                                                                                          height: 20,
                                                                                        ),
                                                                                      ),

                                                                                      SizedBox(width: 10,),

                                                                                      /// Text
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          //color: Colors.blue,
                                                                                          margin: EdgeInsets.only(right: 10),
                                                                                          child: Text(Strings.gotoweb,
                                                                                              textAlign: TextAlign.center,
                                                                                              textScaleFactor: 1.0,
                                                                                              style: TextStyle(
                                                                                                  fontFamily: Strings.font_semibold,
                                                                                                  fontSize: 13,
                                                                                                  letterSpacing: 0.5,
                                                                                                  color: CustomColors.grayback)
                                                                                          ),
                                                                                        ),
                                                                                      )

                                                                                    ],

                                                                                  )
                                                                              ),
                                                                            ),
                                                                            useCache: false,
                                                                            onTap: (){
                                                                              if(change==true){
                                                                                backOnceOne();
                                                                                launchFetchObtainPointsAds();
                                                                              }else{
                                                                                detectIntents();
                                                                                utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                              }
                                                                            },
                                                                          );

                                                                        }

                                                                    ),
                                                                  ),


                                                                  SizedBox(height: 20,),

                                                                ],
                                                              ),

                                                            ),



                                                          ),

                                                          SizedBox(height: 20,),

                                                          /// for do
                                                          /*Container(
                                                          child: Text(Strings.winmore,
                                                            style: TextStyle(
                                                                fontFamily: Strings.font_semiboldFe,
                                                                fontSize:20,
                                                                color: CustomColors.white),
                                                            textAlign: TextAlign.center,
                                                            textScaleFactor: 1.0,
                                                          ),
                                                        ),

                                                        SizedBox(height: 30,),

                                                        /// Go to for reward
                                                        widget.item.ads![itemAd]!.url! == "" ? Container(

                                                          child: SpringButton(
                                                            SpringButtonType.OnlyScale,
                                                            Container(
                                                              margin: EdgeInsets.only(left:60,right: 60 ),
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  color:CustomColors.orangeswitch,
                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                              ),
                                                              child: Center(
                                                                  child: Container(
                                                                    //margin: EdgeInsets.only(left: 20,right: 20),
                                                                    child: Text(Strings.backtoreward1,
                                                                      textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontFamily: Strings.font_semibold,
                                                                            fontSize: 12,
                                                                            letterSpacing: 0.5,
                                                                            color: CustomColors.grayback),
                                                                      textScaleFactor: 1.0,
                                                                    ),
                                                                  )
                                                              ),
                                                            ),
                                                            useCache: false,
                                                            onTap: (){
                                                              if(value1==true){ /// if header is active
                                                                //if(once==0){

                                                                  /// agregado
                                                                  backOnceOne();
                                                                  launchFetchObtainPointsAds();

                                                                //}
                                                              }
                                                            },
                                                          ),

                                                        ) : Container(),

                                                        widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                        utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ?
                                                        Container(
                                                          child: SpringButton(
                                                            SpringButtonType.OnlyScale,
                                                            Container(
                                                              margin: EdgeInsets.only(left:80,right: 80 ),
                                                              height: 40,
                                                              width: 170,
                                                              decoration: BoxDecoration(
                                                                  color:CustomColors.orangeswitch,
                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                              ),
                                                              child: Center(
                                                                  child: Row(

                                                                    children: [

                                                                      ///Icon
                                                                      Container(
                                                                        //color: Colors.purple,
                                                                        margin: EdgeInsets.only(left: 20),
                                                                        child: SvgPicture.asset(
                                                                          'assets/images/ic_calling.svg',
                                                                          //fit: BoxFit.contain,
                                                                          width: 20,
                                                                          height: 20,
                                                                        ),
                                                                      ),

                                                                      SizedBox(width: 10,),

                                                                      /// Text
                                                                      Expanded(
                                                                        child: Container(
                                                                          //color: Colors.blue,
                                                                          margin: EdgeInsets.only(right: 30),
                                                                          child: Text(Strings.gotocall,
                                                                              textAlign: TextAlign.center,
                                                                              textScaleFactor: 1.0,
                                                                              style: TextStyle(
                                                                                  fontFamily: Strings.font_semibold,
                                                                                  fontSize: 13,
                                                                                  letterSpacing: 0.5,
                                                                                  color: CustomColors.grayback)
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],

                                                                  )
                                                              ),
                                                            ),
                                                            useCache: false,
                                                            onTap: (){
                                                              backOnceOne();
                                                              launchFetchObtainPointsAds();
                                                            },
                                                          ),
                                                        ) :
                                                        utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ?
                                                        Container(
                                                          child: SpringButton(
                                                            SpringButtonType.OnlyScale,
                                                            Container(
                                                              margin: EdgeInsets.only(left:80,right: 80 ),
                                                              height: 40,
                                                              width: 170,
                                                              decoration: BoxDecoration(
                                                                  color:CustomColors.greenwhats,
                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                              ),
                                                              child: Center(
                                                                  child: Row(

                                                                    children: [

                                                                      ///Icon
                                                                      Container(
                                                                        //color: Colors.purple,
                                                                        margin: EdgeInsets.only(left: 20),
                                                                        child: SvgPicture.asset(
                                                                          'assets/images/ic_waChat.svg',
                                                                          //fit: BoxFit.contain,
                                                                          width: 20,
                                                                          height: 20,
                                                                        ),
                                                                      ),

                                                                      SizedBox(width: 10,),

                                                                      /// Text
                                                                      Expanded(
                                                                        child: Container(
                                                                          //color: Colors.blue,
                                                                          margin: EdgeInsets.only(right: 30),
                                                                          child: Text(Strings.gotowhats,
                                                                              textAlign: TextAlign.center,
                                                                              textScaleFactor: 1.0,
                                                                              style: TextStyle(
                                                                                  fontFamily: Strings.font_semibold,
                                                                                  fontSize: 13,
                                                                                  letterSpacing: 0.5,
                                                                                  color: CustomColors.grayback)
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],

                                                                  )
                                                              ),
                                                            ),
                                                            useCache: false,
                                                            onTap: (){
                                                              backOnceOne();
                                                              launchFetchObtainPointsAds();
                                                            },
                                                          ),
                                                        ) :
                                                        Container(
                                                          child: SpringButton(
                                                            SpringButtonType.OnlyScale,
                                                            Container(
                                                              margin: EdgeInsets.only(left:80,right: 80 ),
                                                              height: 40,
                                                              width: 194,
                                                              decoration: BoxDecoration(
                                                                  color:CustomColors.orangeswitch,
                                                                  borderRadius: BorderRadius.all(const Radius.circular(6))
                                                              ),
                                                              child: Center(
                                                                  child: Row(

                                                                    children: [

                                                                      ///Icon
                                                                      Container(
                                                                        //color: Colors.purple,
                                                                        margin: EdgeInsets.only(left: 20),
                                                                        child: SvgPicture.asset(
                                                                          'assets/images/ic_webSite.svg',
                                                                          //fit: BoxFit.contain,
                                                                          width: 20,
                                                                          height: 20,
                                                                        ),
                                                                      ),

                                                                      SizedBox(width: 10,),

                                                                      /// Text
                                                                      Expanded(
                                                                        child: Container(
                                                                          //color: Colors.blue,
                                                                          margin: EdgeInsets.only(right: 10),
                                                                          child: Text(Strings.gotoweb,
                                                                              textAlign: TextAlign.center,
                                                                              textScaleFactor: 1.0,
                                                                              style: TextStyle(
                                                                                  fontFamily: Strings.font_semibold,
                                                                                  fontSize: 13,
                                                                                  letterSpacing: 0.5,
                                                                                  color: CustomColors.grayback)
                                                                          ),
                                                                        ),
                                                                      )

                                                                    ],

                                                                  )
                                                              ),
                                                            ),
                                                            useCache: false,
                                                            onTap: (){
                                                              backOnceOne();
                                                              launchFetchObtainPointsAds();
                                                            },
                                                          ),
                                                        )*/

                                                        ],

                                                      ),
                                                    ),
                                                  ),


                                                ],

                                              ),
                                            ) :  /// View after see
                                            Container( /// Header
                                              width: MediaQuery.of(context).size.width,
                                              height: 85,
                                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                              decoration: BoxDecoration(
                                                //color: value1==false ? CustomColors.greyHeaderNowin : CustomColors.orangeHeaderWin,
                                                color: CustomColors.white.withOpacity(0.7),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 1), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[

                                                  /// Circular progress
                                                  value1==true ?
                                                  /// Logo gane
                                                  Container(width: 30, height: 30,)
                                                  /*Container(
                                                    alignment: Alignment.topLeft,
                                                    padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,),
                                                    child: Image(
                                                      width: 80,
                                                      height: 42,
                                                      image: AssetImage("assets/images/logohome.png"),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )*/ :
                                                  /// Circular progress
                                                  Container(
                                                      padding:EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 25 : 8,left: 10),
                                                      //color: Colors.green,
                                                      child: ValueListenableBuilder<int>(
                                                          valueListenable: notifierImageCounter,
                                                          builder: (contexts,value2,_){

                                                            return (value2>0 ? CircularPercentIndicator(
                                                              radius: 30.0,
                                                              lineWidth: 3.0,
                                                              percent: ((value2*100)/_startCounter)/100,
                                                              center: new Text(///grayalert1
                                                                value2.toString(),style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.orangeswitch, fontSize: 13,),
                                                                textScaleFactor: 1.0,
                                                              ),
                                                              progressColor: CustomColors.orangeswitch,
                                                              backgroundColor: CustomColors.white,
                                                            ) : Container());

                                                          }

                                                      )
                                                  ),

                                                  /// Points
                                                  /*InkWell(
                                                    onTap: (){
                                                      if(value1==true){ /// if header is active
                                                        if(once==0){

                                                          /// agregado
                                                          backOnceOne();
                                                          launchFetchObtainPointsAds();

                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      //color: Colors.yellow,
                                                      //padding: EdgeInsets.only(top: 3,bottom: 3),
                                                      decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        borderRadius: BorderRadius.all(const Radius.circular(20)),
                                                        border: Border.all(
                                                          width: 3,
                                                          color: value1==true ? CustomColors.white : Colors.transparent,
                                                        ),
                                                      ),
                                                      margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,right: value1==true ? 50 : 8,),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,

                                                        children: [

                                                          SizedBox(
                                                            width: 10,
                                                          ),

                                                          /// points
                                                          Container(
                                                            alignment: Alignment.center,
                                                            child: BorderedText(
                                                              strokeWidth: 7.0,
                                                              strokeColor: CustomColors.redBorderTextHeader,
                                                              child: Text(
                                                                "+"+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                //"+99999",
                                                                style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 30.0,),
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            width: 5,
                                                          ),

                                                          ///Coin image
                                                          Container(
                                                            child: SvgPicture.asset(
                                                              'assets/images/coins.svg',
                                                              fit: BoxFit.contain,
                                                              width: 25,
                                                              height: 25,
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            width: 10,
                                                          ),

                                                        ],

                                                      ),
                                                    ),
                                                  ),*/

                                                  /// Back
                                                  InkWell(
                                                    onTap: (){

                                                        /// agregado
                                                        backOnceOne();
                                                        Navigator.pop(context);

                                                    },
                                                    child: Container(
                                                      width: 40,height: 40,
                                                      //color: Colors.blue,
                                                      margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 29 : 10,right: 10),
                                                      alignment: Alignment.topRight,
                                                      child: SvgPicture.asset(
                                                          'assets/images/ic_close_orange.svg',
                                                          fit: BoxFit.cover,
                                                          //color: CustomColors.orangeswitch,
                                                        width: 30,height: 30,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ); /// Header

                                          }
                                      ),


                                    ],

                                  ) : Container(   /// Poll
                                      height: MediaQuery.of(context).size.height,
                                      color: CustomColors.graybackwallet,
                                      child: Stack(

                                        children: [

                                          _fields(context),

                                          PagerButton(context),

                                          ///Header
                                          /*ValueListenableBuilder<bool>(
                                              valueListenable: notifierActiveHeader,
                                              builder: (context,value1,_){
                                                return value1==true ?
                                                Container( /// Pre View Win
                                                  //width: MediaQuery.of(context).size.width,
                                                  //height: MediaQuery.of(context).size.height,
                                                  child: Stack(
                                                    alignment: Alignment.center,

                                                    children: [

                                                      /// Black back Container
                                                      Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: MediaQuery.of(context).size.height,
                                                        color: CustomColors.backBlackWin.withOpacity(0.35),
                                                      ),


                                                      /// Back
                                                      /*Positioned(
                                                      top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10,right: 20,
                                                        child: InkWell(
                                                          onTap: (){
                                                              /// agregado
                                                              backOnceOne();
                                                              Navigator.pop(context);

                                                          },
                                                          child: Container(
                                                            width: 30,height: 30,
                                                            //color: Colors.blue,
                                                            //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10,right: 20),
                                                            child: SvgPicture.asset(
                                                              'assets/images/ic_close_orange.svg',
                                                              fit: BoxFit.contain,
                                                              color: CustomColors.white,

                                                            ),
                                                          ),
                                                        ),
                                                      ),*/

                                                      /// Center Data
                                                      Container(
                                                        //width: MediaQuery.of(context).size.width,
                                                        //color: Colors.yellow,
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,


                                                            children: [

                                                              SizedBox(height: 20,),

                                                              /// Win
                                                              Container(

                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                                  children: [

                                                                    /// Win
                                                                    Container(
                                                                      child: Text("Gana "+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                        style: TextStyle(
                                                                            fontFamily: Strings.font_semiboldFe,
                                                                            fontSize:40,
                                                                            color: CustomColors.white),
                                                                        textAlign: TextAlign.center,
                                                                        textScaleFactor: 1.0,
                                                                      ),
                                                                    ),

                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),

                                                                    ///Coin image
                                                                    Container(
                                                                      child: SvgPicture.asset(
                                                                        'assets/images/coins.svg',
                                                                        fit: BoxFit.contain,
                                                                        width: 25,
                                                                        height: 25,
                                                                      ),
                                                                    ),

                                                                  ],

                                                                ),

                                                              ),

                                                              /*SizedBox(height: 10,),

                                                            /// for do
                                                            Container(
                                                              child: Text(formatValue == 1 ? Strings.fordovideo : formatValue == 2 ? Strings.fordoimage : Strings.fordopoll,
                                                                  style: TextStyle(
                                                                      fontFamily: Strings.font_medium,
                                                                      fontSize:15,
                                                                      color: CustomColors.white),
                                                                  textAlign: TextAlign.center,
                                                                textScaleFactor: 1.0,
                                                              ),
                                                            ),

                                                            /// aditional for do
                                                            widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                            Container(
                                                              margin: EdgeInsets.only(top: 5,left: 30, right: 30),
                                                              child: Text(utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ? Strings.gotoweb1 :
                                                              utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ? Strings.gotocall1 : Strings.gotowhats1,
                                                                  textScaleFactor: 1.0,
                                                                  style: TextStyle(
                                                                      fontFamily: Strings.font_medium,
                                                                      fontSize:15,
                                                                      color: CustomColors.white),
                                                                  textAlign: TextAlign.center
                                                              ),
                                                            ),*/


                                                              Card(
                                                                margin: EdgeInsets.only(top: 20,bottom: 20, left: 60,right: 60),
                                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                color: CustomColors.white,
                                                                elevation: 5,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                                child: Container(

                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [

                                                                      SizedBox(height: 20,),

                                                                      /// Image
                                                                      Container(
                                                                        //color: Colors.red,
                                                                        width: 180,
                                                                        //height: 80,
                                                                        child: Image.network(
                                                                          //"http://www.tusitio.com/image.png",
                                                                            widget.item.ads![itemAd]!.lgImages!,
                                                                            fit: BoxFit.contain,
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
                                                                            errorBuilder: (_, __, ___) {

                                                                              return Container(
                                                                                //color: Colors.red,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [

                                                                                    SvgPicture.asset(
                                                                                      'assets/images/ic_gane.svg',
                                                                                      fit: BoxFit.contain,
                                                                                      width: 180,
                                                                                    ),
                                                                                  ],

                                                                                ),
                                                                              );

                                                                            }

                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 15,),

                                                                      SizedBox(height: 20,),

                                                                      /// add number
                                                                      Container(
                                                                        child: Text(Strings.addnumber,
                                                                          style: TextStyle(
                                                                              fontFamily: Strings.font_semiboldFe,
                                                                              fontSize:18,
                                                                              color: CustomColors.black),
                                                                          textAlign: TextAlign.center,
                                                                          textScaleFactor: 1.0,
                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 10,),

                                                                      /// Number target
                                                                      ValueListenableBuilder<int>(
                                                                          valueListenable: singleton.notifierNumberReward,
                                                                          builder: (context,number,_){

                                                                            return Container(
                                                                              child: Text(number.toString(),
                                                                                style: TextStyle(
                                                                                    fontFamily: Strings.font_boldFe,
                                                                                    fontSize:30,
                                                                                    color: CustomColors.black),
                                                                                textAlign: TextAlign.center,
                                                                                textScaleFactor: 1.0,
                                                                              ),
                                                                            );

                                                                          }
                                                                      ),

                                                                      SizedBox(height: 10,),

                                                                      /// Number digit
                                                                      ValueListenableBuilder<String>(
                                                                          valueListenable: singleton.notifierNumberRewardDigit,
                                                                          builder: (context,number,_){

                                                                            return Container(
                                                                              width: 180,
                                                                              decoration: BoxDecoration(
                                                                                color: CustomColors.lightGrayNumbers,
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                              child: Container(
                                                                                margin: EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30),
                                                                                child: Text(number,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_boldFe,
                                                                                      fontSize:25,
                                                                                      color: CustomColors.black),
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                ),
                                                                              ),
                                                                            );

                                                                          }
                                                                      ),

                                                                      SizedBox(height: 10,),

                                                                      /// Keyboard
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 20,right: 20),
                                                                        width: 180,
                                                                        child: StaggeredGridView.countBuilder(
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          shrinkWrap: true,
                                                                          scrollDirection: Axis.vertical,
                                                                          crossAxisCount: 3,
                                                                          itemCount: 11,
                                                                          itemBuilder: (BuildContext context, int index) {

                                                                            return index==10 ?
                                                                            InkWell(
                                                                              onTap: (){
                                                                                singleton.notifierNumberRewardDigit.value= "";
                                                                                singleton.notifierNumberChange.value = false;
                                                                              },
                                                                              child: Container(
                                                                                height: 45,
                                                                                decoration: BoxDecoration(
                                                                                  color: CustomColors.lightGrayNumbers,
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                ),
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  //margin: EdgeInsets.all(20),
                                                                                  child: Text("Borrar",
                                                                                    style: TextStyle(
                                                                                        fontFamily: Strings.font_semiboldFe,
                                                                                        fontSize:25,
                                                                                        color: CustomColors.black),
                                                                                    textAlign: TextAlign.center,
                                                                                    textScaleFactor: 1.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ):
                                                                            InkWell(
                                                                              onTap: (){
                                                                                if(singleton.notifierNumberRewardDigit.value.length < 4){

                                                                                  if( index==9){
                                                                                    singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value +"0";
                                                                                  }else{
                                                                                    singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value + (index+1).toString();
                                                                                  }


                                                                                  print("Numero digitado: "+singleton.notifierNumberRewardDigit.value);
                                                                                  print("Numero genrado: "+singleton.notifierNumberReward.value.toString());
                                                                                  if(int.parse(singleton.notifierNumberRewardDigit.value) == singleton.notifierNumberReward.value){
                                                                                    singleton.notifierNumberChange.value = true;
                                                                                  }else{
                                                                                    singleton.notifierNumberChange.value = false;
                                                                                    //utils.openSnackBarInfo(context, Strings.erroraddnumber, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }

                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                width: 45,height: 45,
                                                                                decoration: BoxDecoration(
                                                                                  color: CustomColors.lightGrayNumbers,
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                ),
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  //color: Colors.blue,
                                                                                  //margin: EdgeInsets.all(20),
                                                                                  child: Text( index== 9 ? "0" : (index+1).toString(),
                                                                                    style: TextStyle(
                                                                                        fontFamily: Strings.font_semiboldFe,
                                                                                        fontSize:25,
                                                                                        color: CustomColors.black),
                                                                                    textAlign: TextAlign.center,
                                                                                    textScaleFactor: 1.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );

                                                                          } ,
                                                                          staggeredTileBuilder: (int index) {
                                                                            return index == 10 ? StaggeredTile.fit(2) : StaggeredTile.fit(1);
                                                                          },
                                                                          mainAxisSpacing: 7.0,
                                                                          crossAxisSpacing: 7.0,
                                                                          padding: const EdgeInsets.all(4),

                                                                        ),
                                                                      ),


                                                                      SizedBox(height: 20,),

                                                                      /// Go to for reward
                                                                      widget.item.ads![itemAd]!.url! == "" ? Container(

                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){
                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  margin: EdgeInsets.only(left:60,right: 60 ),
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.orangeswitch,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Container(
                                                                                        //margin: EdgeInsets.only(left: 20,right: 20),
                                                                                        child: Text(Strings.backtoreward1,
                                                                                            textScaleFactor: 1.0,
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                                fontFamily: Strings.font_semibold,
                                                                                                fontSize: 12,
                                                                                                letterSpacing: 0.5,
                                                                                                color: CustomColors.grayback
                                                                                            )
                                                                                        ),
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){
                                                                                  if(value1==true){ /// if header is active

                                                                                    if(change==true){
                                                                                      /// agregado
                                                                                      backOnceOne();
                                                                                      launchFetchObtainPointsAds();
                                                                                    }else{
                                                                                      detectIntents();
                                                                                      utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                    }

                                                                                  }
                                                                                },
                                                                              );
                                                                            }
                                                                        ),

                                                                      ) : Container(),

                                                                      /// Got to Call, Whatsapp or Url
                                                                      widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                                      utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ?
                                                                      Container(
                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){

                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                  height: 40,
                                                                                  width: 170,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.orangeswitch,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Row(

                                                                                        children: [

                                                                                          ///Icon
                                                                                          Container(
                                                                                            //color: Colors.purple,
                                                                                            margin: EdgeInsets.only(left: 20),
                                                                                            child: SvgPicture.asset(
                                                                                              'assets/images/ic_calling.svg',
                                                                                              //fit: BoxFit.contain,
                                                                                              width: 20,
                                                                                              height: 20,
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(width: 10,),

                                                                                          /// Text
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              //color: Colors.blue,
                                                                                              margin: EdgeInsets.only(right: 30),
                                                                                              child: Text(Strings.gotocall,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  textScaleFactor: 1.0,
                                                                                                  style: TextStyle(
                                                                                                      fontFamily: Strings.font_semibold,
                                                                                                      fontSize: 13,
                                                                                                      letterSpacing: 0.5,
                                                                                                      color: CustomColors.grayback)
                                                                                              ),
                                                                                            ),
                                                                                          )

                                                                                        ],

                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){

                                                                                  if(change==true){
                                                                                    backOnceOne();
                                                                                    launchFetchObtainPointsAds();
                                                                                  }else{
                                                                                    detectIntents();
                                                                                    utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }

                                                                                },
                                                                              );

                                                                            }
                                                                        ),
                                                                      ) :
                                                                      utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ?
                                                                      Container(
                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){

                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                  height: 40,
                                                                                  width: 170,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.greenwhats,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Row(

                                                                                        children: [

                                                                                          ///Icon
                                                                                          Container(
                                                                                            //color: Colors.purple,
                                                                                            margin: EdgeInsets.only(left: 20),
                                                                                            child: SvgPicture.asset(
                                                                                              'assets/images/ic_waChat.svg',
                                                                                              //fit: BoxFit.contain,
                                                                                              width: 20,
                                                                                              height: 20,
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(width: 10,),

                                                                                          /// Text
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              //color: Colors.blue,
                                                                                              margin: EdgeInsets.only(right: 30),
                                                                                              child: Text(Strings.gotowhats,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  textScaleFactor: 1.0,
                                                                                                  style: TextStyle(
                                                                                                      fontFamily: Strings.font_semibold,
                                                                                                      fontSize: 13,
                                                                                                      letterSpacing: 0.5,
                                                                                                      color: CustomColors.grayback)
                                                                                              ),
                                                                                            ),
                                                                                          )

                                                                                        ],

                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){
                                                                                  if(change==true){
                                                                                    backOnceOne();
                                                                                    launchFetchObtainPointsAds();
                                                                                  }else{
                                                                                    detectIntents();
                                                                                    utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }
                                                                                },
                                                                              );
                                                                            }

                                                                        ),
                                                                      ) :
                                                                      Container(
                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){
                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                  height: 40,
                                                                                  width: 194,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.orangeswitch,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Row(

                                                                                        children: [

                                                                                          ///Icon
                                                                                          Container(
                                                                                            //color: Colors.purple,
                                                                                            margin: EdgeInsets.only(left: 20),
                                                                                            child: SvgPicture.asset(
                                                                                              'assets/images/ic_webSite.svg',
                                                                                              //fit: BoxFit.contain,
                                                                                              width: 20,
                                                                                              height: 20,
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(width: 10,),

                                                                                          /// Text
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              //color: Colors.blue,
                                                                                              margin: EdgeInsets.only(right: 10),
                                                                                              child: Text(Strings.gotoweb,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  textScaleFactor: 1.0,
                                                                                                  style: TextStyle(
                                                                                                      fontFamily: Strings.font_semibold,
                                                                                                      fontSize: 13,
                                                                                                      letterSpacing: 0.5,
                                                                                                      color: CustomColors.grayback)
                                                                                              ),
                                                                                            ),
                                                                                          )

                                                                                        ],

                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){
                                                                                  if(change==true){
                                                                                    backOnceOne();
                                                                                    launchFetchObtainPointsAds();
                                                                                  }else{
                                                                                    detectIntents();
                                                                                    utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }
                                                                                },
                                                                              );

                                                                            }

                                                                        ),
                                                                      ),


                                                                      SizedBox(height: 20,),

                                                                    ],
                                                                  ),

                                                                ),

                                                              ),

                                                              SizedBox(height: 20,),

                                                              /// for do
                                                              /*Container(
                                                              child: Text(Strings.winmore,
                                                                style: TextStyle(
                                                                    fontFamily: Strings.font_semiboldFe,
                                                                    fontSize:20,
                                                                    color: CustomColors.white),
                                                                textAlign: TextAlign.center,
                                                                textScaleFactor: 1.0,
                                                              ),
                                                            ),

                                                            SizedBox(height: 30,),

                                                            /// Go to for reward
                                                            widget.item.ads![itemAd]!.url! == "" ? Container(

                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:60,right: 60 ),
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.orangeswitch,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Container(
                                                                        //margin: EdgeInsets.only(left: 20,right: 20),
                                                                        child: Text(Strings.backtoreward1,
                                                                          textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: Strings.font_semibold,
                                                                                fontSize: 12,
                                                                                letterSpacing: 0.5,
                                                                                color: CustomColors.grayback),
                                                                          textScaleFactor: 1.0,
                                                                        ),
                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  if(value1==true){ /// if header is active
                                                                    //if(once==0){

                                                                      /// agregado
                                                                      FocusScope.of(context).requestFocus(new FocusNode());
                                                                      backOnceOne();
                                                                      launchFetchAnswers(passAllAnswertoCompleted);

                                                                    //}
                                                                  }
                                                                },
                                                              ),

                                                            ) : Container(),

                                                            widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                            utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ?
                                                            Container(
                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:80,right: 80 ),
                                                                  height: 40,
                                                                  width: 170,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.orangeswitch,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Row(

                                                                        children: [

                                                                          ///Icon
                                                                          Container(
                                                                            //color: Colors.purple,
                                                                            margin: EdgeInsets.only(left: 20),
                                                                            child: SvgPicture.asset(
                                                                              'assets/images/ic_calling.svg',
                                                                              //fit: BoxFit.contain,
                                                                              width: 20,
                                                                              height: 20,
                                                                            ),
                                                                          ),

                                                                          SizedBox(width: 10,),

                                                                          /// Text
                                                                          Expanded(
                                                                            child: Container(
                                                                              //color: Colors.blue,
                                                                              margin: EdgeInsets.only(right: 30),
                                                                              child: Text(Strings.gotocall,
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_semibold,
                                                                                      fontSize: 13,
                                                                                      letterSpacing: 0.5,
                                                                                      color: CustomColors.grayback)
                                                                              ),
                                                                            ),
                                                                          )

                                                                        ],

                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                  backOnceOne();
                                                                  launchFetchAnswers(passAllAnswertoCompleted);
                                                                },
                                                              ),
                                                            ) :
                                                            utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ?
                                                            Container(
                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:80,right: 80 ),
                                                                  height: 40,
                                                                  width: 170,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.greenwhats,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Row(

                                                                        children: [

                                                                          ///Icon
                                                                          Container(
                                                                            //color: Colors.purple,
                                                                            margin: EdgeInsets.only(left: 20),
                                                                            child: SvgPicture.asset(
                                                                              'assets/images/ic_waChat.svg',
                                                                              //fit: BoxFit.contain,
                                                                              width: 20,
                                                                              height: 20,
                                                                            ),
                                                                          ),

                                                                          SizedBox(width: 10,),

                                                                          /// Text
                                                                          Expanded(
                                                                            child: Container(
                                                                              //color: Colors.blue,
                                                                              margin: EdgeInsets.only(right: 30),
                                                                              child: Text(Strings.gotowhats,
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_semibold,
                                                                                      fontSize: 13,
                                                                                      letterSpacing: 0.5,
                                                                                      color: CustomColors.grayback)
                                                                              ),
                                                                            ),
                                                                          )

                                                                        ],

                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                  backOnceOne();
                                                                  launchFetchAnswers(passAllAnswertoCompleted);
                                                                },
                                                              ),
                                                            ) :
                                                            Container(
                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:80,right: 80 ),
                                                                  height: 40,
                                                                  width: 194,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.orangeswitch,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Row(

                                                                        children: [

                                                                          ///Icon
                                                                          Container(
                                                                            //color: Colors.purple,
                                                                            margin: EdgeInsets.only(left: 20),
                                                                            child: SvgPicture.asset(
                                                                              'assets/images/ic_webSite.svg',
                                                                              //fit: BoxFit.contain,
                                                                              width: 20,
                                                                              height: 20,
                                                                            ),
                                                                          ),

                                                                          SizedBox(width: 10,),

                                                                          /// Text
                                                                          Expanded(
                                                                            child: Container(
                                                                              //color: Colors.blue,
                                                                              margin: EdgeInsets.only(right: 10),
                                                                              child: Text(Strings.gotoweb,
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_semibold,
                                                                                      fontSize: 13,
                                                                                      letterSpacing: 0.5,
                                                                                      color: CustomColors.grayback)
                                                                              ),
                                                                            ),
                                                                          )

                                                                        ],

                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                  backOnceOne();
                                                                  launchFetchAnswers(passAllAnswertoCompleted);
                                                                },
                                                              ),
                                                            )*/

                                                            ],

                                                          ),
                                                        ),
                                                      ),


                                                    ],

                                                  ),
                                                ) :  /// View after see
                                                Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 85,
                                                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                                  decoration: BoxDecoration(
                                                    //color: value1==false ? CustomColors.greyHeaderNowin : CustomColors.orangeHeaderWin,
                                                    color: CustomColors.white.withOpacity(0.7),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 1), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[

                                                      /// Circular progress
                                                      /*value1==true ?
                                                      /// Logo gane
                                                      Container(
                                                        alignment: Alignment.topLeft,
                                                        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,),
                                                        child: Image(
                                                          width: 80,
                                                          height: 42,
                                                          image: AssetImage("assets/images/logohome.png"),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ) :*/
                                                      ///
                                                      Container(
                                                        width: 40,
                                                        height: 40,
                                                      ),

                                                      /// Points
                                                      /*Expanded(
                                                          child:
                                                          InkWell(
                                                            onTap: (){
                                                              if(value1==true){ /// if header is active
                                                                if(once==0){

                                                                  /// agregado
                                                                  backOnceOne();
                                                                  launchFetchObtainPointsAds();

                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              color: Colors.yellow,
                                                              margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,right: 8,left: 8),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,

                                                                children: [

                                                                  /// points
                                                                  Container(
                                                                    alignment: Alignment.center,
                                                                    child: BorderedText(
                                                                      strokeWidth: 7.0,
                                                                      strokeColor: CustomColors.redBorderTextHeader,
                                                                      child: Text(
                                                                        "+"+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                        style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 30.0,),
                                                                        maxLines: 1,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),

                                                                  ///Coin image
                                                                  Container(
                                                                    child: SvgPicture.asset(
                                                                      'assets/images/coins.svg',
                                                                      fit: BoxFit.contain,
                                                                      width: 25,
                                                                      height: 25,
                                                                    ),
                                                                  ),

                                                                ],

                                                              ),
                                                            ),
                                                          )
                                                      ),*/
                                                      /*SpringButton(
                                                        SpringButtonType.OnlyScale,
                                                        Container(
                                                          //color: Colors.yellow,
                                                          padding: EdgeInsets.only(top: 3,bottom: 3),
                                                          decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius: BorderRadius.all(const Radius.circular(20)),
                                                            border: Border.all(
                                                              width: 2,
                                                              color: value1==true ? CustomColors.white : Colors.transparent,
                                                            ),
                                                          ),
                                                          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,right: value1==true ? 50 : 8,left: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,

                                                            children: [

                                                              SizedBox(
                                                                width: 20,
                                                              ),

                                                              /// points
                                                              Container(
                                                                alignment: Alignment.center,
                                                                child: BorderedText(
                                                                  strokeWidth: 7.0,
                                                                  strokeColor: CustomColors.redBorderTextHeader,
                                                                  child: Text(
                                                                    "+"+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 30.0,),
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                width: 5,
                                                              ),

                                                              ///Coin image
                                                              Container(
                                                                child: SvgPicture.asset(
                                                                  'assets/images/coins.svg',
                                                                  fit: BoxFit.contain,
                                                                  width: 25,
                                                                  height: 25,
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                width: 20,
                                                              ),

                                                            ],

                                                          ),
                                                        ),
                                                        useCache: false,
                                                        scaleCoefficient: value1==true ? 1.0 : 0.0,
                                                        onTap: (){
                                                          if(value1==true){ /// if header is active
                                                            if(once==0){

                                                              /// agregado
                                                              backOnceOne();
                                                              launchFetchObtainPointsAds();

                                                            }
                                                          }
                                                        },
                                                      ),*/
                                                      /*InkWell(
                                                        onTap: (){
                                                          if(value1==true){ /// if header is active
                                                            if(once==0){

                                                              /// agregado
                                                              backOnceOne();
                                                              //launchFetchObtainPointsAds();
                                                              launchFetchAnswers(passAllAnswertoCompleted);

                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          //color: Colors.yellow,
                                                          padding: EdgeInsets.only(top: 3,bottom: 3),
                                                          decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            borderRadius: BorderRadius.all(const Radius.circular(20)),
                                                            border: Border.all(
                                                              width: 3,
                                                              color: value1==true ? CustomColors.white : Colors.transparent,
                                                            ),
                                                          ),
                                                          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 23 : 8,right: value1==true ? 50 : 8,left: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,

                                                            children: [

                                                              SizedBox(
                                                                width: 20,
                                                              ),

                                                              /// points
                                                              Container(
                                                                alignment: Alignment.center,
                                                                child: BorderedText(
                                                                  strokeWidth: 7.0,
                                                                  strokeColor: CustomColors.redBorderTextHeader,
                                                                  child: Text(
                                                                    "+"+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.yellowTextHeader, fontSize: 30.0,),
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                width: 5,
                                                              ),

                                                              ///Coin image
                                                              Container(
                                                                child: SvgPicture.asset(
                                                                  'assets/images/coins.svg',
                                                                  fit: BoxFit.contain,
                                                                  width: 25,
                                                                  height: 25,
                                                                ),
                                                              ),

                                                              SizedBox(
                                                                width: 20,
                                                              ),

                                                            ],

                                                          ),
                                                        ),
                                                      ),*/

                                                      /// Back
                                                      InkWell(
                                                        onTap: (){

                                                          //widget.relaunch();
                                                          //if(once==0){

                                                            //once = once + 1;
                                                            /// agregado
                                                            backOnceOne();
                                                            //launchFetchObtainPointsAds();
                                                            Navigator.pop(context);
                                                          //}

                                                        },
                                                        child: Container(
                                                          //color: Colors.blue,
                                                          width: 40,height: 40,
                                                          margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 29 : 10,right: 10),
                                                          alignment: Alignment.topRight,
                                                          child: SvgPicture.asset(
                                                            'assets/images/ic_close_orange.svg',
                                                            fit: BoxFit.contain,
                                                            //color: CustomColors.orangeswitch,
                                                            width: 30,height: 30,
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ); /// Header

                                              }
                                          ),*/
                                            AppBar(),
                                          
                                          ValueListenableBuilder<bool>(
                                              valueListenable: notifierActiveHeader,
                                              builder: (context,value1,_){
                                                return value1==true ?
                                                Container( /// Pre View Win

                                                  child: Stack(
                                                    alignment: Alignment.center,

                                                    children: [

                                                      /// Black back Container
                                                      Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: MediaQuery.of(context).size.height,
                                                        color: CustomColors.backBlackWin.withOpacity(0.45),//0.35
                                                      ),


                                                      /// Back
                                                      /*Positioned(
                                                      top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10,right: 20,
                                                        child: InkWell(
                                                          onTap: (){
                                                              /// agregado
                                                              backOnceOne();
                                                              Navigator.pop(context);

                                                          },
                                                          child: Container(
                                                            width: 30,height: 30,
                                                            //color: Colors.blue,
                                                            //padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top > 0 ? 40 : 10,right: 20),
                                                            child: SvgPicture.asset(
                                                              'assets/images/ic_close_orange.svg',
                                                              fit: BoxFit.contain,
                                                              color: CustomColors.white,

                                                            ),
                                                          ),
                                                        ),
                                                      ),*/

                                                      /// Center Data
                                                      Container(
                                                        //width: MediaQuery.of(context).size.width,
                                                        //color: Colors.yellow,
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,


                                                            children: [

                                                              SizedBox(height: 20,),

                                                              /// Win
                                                              Container(

                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                                  children: [

                                                                    /// Win
                                                                    Container(
                                                                      child: Text("Gana "+singleton.formatter.format(double.parse(widget.item.ads![itemAd]!.pointsAds!)),
                                                                        style: TextStyle(
                                                                            fontFamily: Strings.font_semiboldFe,
                                                                            fontSize:40,
                                                                            color: CustomColors.white),
                                                                        textAlign: TextAlign.center,
                                                                        textScaleFactor: 1.0,
                                                                      ),
                                                                    ),

                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),

                                                                    ///Coin image
                                                                    Container(
                                                                      child: SvgPicture.asset(
                                                                        'assets/images/coins.svg',
                                                                        fit: BoxFit.contain,
                                                                        width: 25,
                                                                        height: 25,
                                                                      ),
                                                                    ),

                                                                  ],

                                                                ),

                                                              ),

                                                              /*SizedBox(height: 10,),

                                                            /// for do
                                                            Container(
                                                              child: Text(formatValue == 1 ? Strings.fordovideo : formatValue == 2 ? Strings.fordoimage : Strings.fordopoll,
                                                                  style: TextStyle(
                                                                      fontFamily: Strings.font_medium,
                                                                      fontSize:15,
                                                                      color: CustomColors.white),
                                                                  textAlign: TextAlign.center,
                                                                textScaleFactor: 1.0,
                                                              ),
                                                            ),

                                                            /// aditional for do
                                                            widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                            Container(
                                                              margin: EdgeInsets.only(top: 5,left: 30, right: 30),
                                                              child: Text(utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ? Strings.gotoweb1 :
                                                              utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ? Strings.gotocall1 : Strings.gotowhats1,
                                                                  textScaleFactor: 1.0,
                                                                  style: TextStyle(
                                                                      fontFamily: Strings.font_medium,
                                                                      fontSize:15,
                                                                      color: CustomColors.white),
                                                                  textAlign: TextAlign.center
                                                              ),
                                                            ),*/


                                                              Card(
                                                                margin: EdgeInsets.only(top: 20,bottom: 20, left: 60,right: 60),
                                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                color: CustomColors.white,
                                                                elevation: 5,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                                child: Container(

                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [

                                                                      SizedBox(height: 20,),

                                                                      /// Image
                                                                      Container(
                                                                        //color: Colors.red,
                                                                        width: 180,
                                                                        //height: 80,
                                                                        child: Image.network(
                                                                          //"http://www.tusitio.com/image.png",
                                                                            widget.item.ads![itemAd]!.lgImages!,
                                                                            fit: BoxFit.contain,
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
                                                                            errorBuilder: (_, __, ___) {

                                                                              return Container(
                                                                                //color: Colors.red,
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [

                                                                                    SvgPicture.asset(
                                                                                      'assets/images/ic_gane.svg',
                                                                                      fit: BoxFit.contain,
                                                                                      width: 180,
                                                                                    ),
                                                                                  ],

                                                                                ),
                                                                              );

                                                                            }

                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 15,),

                                                                      SizedBox(height: 20,),

                                                                      /// add number
                                                                      Container(
                                                                        child: Text(Strings.addnumber,
                                                                          style: TextStyle(
                                                                              fontFamily: Strings.font_semiboldFe,
                                                                              fontSize:18,
                                                                              color: CustomColors.black),
                                                                          textAlign: TextAlign.center,
                                                                          textScaleFactor: 1.0,
                                                                        ),
                                                                      ),

                                                                      SizedBox(height: 10,),

                                                                      /// Number target
                                                                      ValueListenableBuilder<int>(
                                                                          valueListenable: singleton.notifierNumberReward,
                                                                          builder: (context,number,_){

                                                                            return Container(
                                                                              child: Text(number.toString(),
                                                                                style: TextStyle(
                                                                                    fontFamily: Strings.font_boldFe,
                                                                                    fontSize:30,
                                                                                    color: CustomColors.black),
                                                                                textAlign: TextAlign.center,
                                                                                textScaleFactor: 1.0,
                                                                              ),
                                                                            );

                                                                          }
                                                                      ),

                                                                      SizedBox(height: 10,),

                                                                      /// Number digit
                                                                      ValueListenableBuilder<String>(
                                                                          valueListenable: singleton.notifierNumberRewardDigit,
                                                                          builder: (context,number,_){

                                                                            return Container(
                                                                              width: 180,
                                                                              decoration: BoxDecoration(
                                                                                color: CustomColors.lightGrayNumbers,
                                                                                borderRadius: BorderRadius.circular(5.0),
                                                                              ),
                                                                              child: Container(
                                                                                margin: EdgeInsets.only(top: 10,bottom: 10,left: 30,right: 30),
                                                                                child: Text(number,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_boldFe,
                                                                                      fontSize:25,
                                                                                      color: CustomColors.black),
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                ),
                                                                              ),
                                                                            );

                                                                          }
                                                                      ),

                                                                      SizedBox(height: 10,),

                                                                      /// Keyboard
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 20,right: 20),
                                                                        width: 180,
                                                                        child: StaggeredGridView.countBuilder(
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          shrinkWrap: true,
                                                                          scrollDirection: Axis.vertical,
                                                                          crossAxisCount: 3,
                                                                          itemCount: 11,
                                                                          itemBuilder: (BuildContext context, int index) {

                                                                            return index==10 ?
                                                                            InkWell(
                                                                              onTap: (){
                                                                                singleton.notifierNumberRewardDigit.value= "";
                                                                                singleton.notifierNumberChange.value = false;
                                                                              },
                                                                              child: Container(
                                                                                height: 45,
                                                                                decoration: BoxDecoration(
                                                                                  color: CustomColors.lightGrayNumbers,
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                ),
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  //margin: EdgeInsets.all(20),
                                                                                  child: Text("Borrar",
                                                                                    style: TextStyle(
                                                                                        fontFamily: Strings.font_semiboldFe,
                                                                                        fontSize:25,
                                                                                        color: CustomColors.black),
                                                                                    textAlign: TextAlign.center,
                                                                                    textScaleFactor: 1.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ):
                                                                            InkWell(
                                                                              onTap: (){
                                                                                if(singleton.notifierNumberRewardDigit.value.length < 4){

                                                                                  if( index==9){
                                                                                    singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value +"0";
                                                                                  }else{
                                                                                    singleton.notifierNumberRewardDigit.value = singleton.notifierNumberRewardDigit.value + (index+1).toString();
                                                                                  }


                                                                                  print("Numero digitado: "+singleton.notifierNumberRewardDigit.value);
                                                                                  print("Numero genrado: "+singleton.notifierNumberReward.value.toString());
                                                                                  if(int.parse(singleton.notifierNumberRewardDigit.value) == singleton.notifierNumberReward.value){
                                                                                    singleton.notifierNumberChange.value = true;
                                                                                  }else{
                                                                                    singleton.notifierNumberChange.value = false;
                                                                                    //utils.openSnackBarInfo(context, Strings.erroraddnumber, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }

                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                width: 45,height: 45,
                                                                                decoration: BoxDecoration(
                                                                                  color: CustomColors.lightGrayNumbers,
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                ),
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  //color: Colors.blue,
                                                                                  //margin: EdgeInsets.all(20),
                                                                                  child: Text( index== 9 ? "0" : (index+1).toString(),
                                                                                    style: TextStyle(
                                                                                        fontFamily: Strings.font_semiboldFe,
                                                                                        fontSize:25,
                                                                                        color: CustomColors.black),
                                                                                    textAlign: TextAlign.center,
                                                                                    textScaleFactor: 1.0,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );

                                                                          } ,
                                                                          staggeredTileBuilder: (int index) {
                                                                            return index == 10 ? StaggeredTile.fit(2) : StaggeredTile.fit(1);
                                                                          },
                                                                          mainAxisSpacing: 7.0,
                                                                          crossAxisSpacing: 7.0,
                                                                          padding: const EdgeInsets.all(4),

                                                                        ),
                                                                      ),


                                                                      SizedBox(height: 20,),

                                                                      /// Go to for reward
                                                                      widget.item.ads![itemAd]!.url! == "" ? Container(

                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){
                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  margin: EdgeInsets.only(left:60,right: 60 ),
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.orangeswitch,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Container(
                                                                                        //margin: EdgeInsets.only(left: 20,right: 20),
                                                                                        child: Text(Strings.backtoreward1,
                                                                                            textScaleFactor: 1.0,
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(
                                                                                                fontFamily: Strings.font_semibold,
                                                                                                fontSize: 12,
                                                                                                letterSpacing: 0.5,
                                                                                                color: CustomColors.grayback
                                                                                            )
                                                                                        ),
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){
                                                                                  if(value1==true){ /// if header is active

                                                                                    if(change==true){
                                                                                      /// agregado
                                                                                      backOnceOne();
                                                                                      launchFetchObtainPointsAds();
                                                                                    }else{
                                                                                      detectIntents();
                                                                                      utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                    }

                                                                                  }
                                                                                },
                                                                              );
                                                                            }
                                                                        ),

                                                                      ) : Container(),

                                                                      /// Got to Call, Whatsapp or Url
                                                                      widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                                      utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ?
                                                                      Container(
                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){

                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                  height: 40,
                                                                                  width: 170,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.orangeswitch,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Row(

                                                                                        children: [

                                                                                          ///Icon
                                                                                          Container(
                                                                                            //color: Colors.purple,
                                                                                            margin: EdgeInsets.only(left: 20),
                                                                                            child: SvgPicture.asset(
                                                                                              'assets/images/ic_calling.svg',
                                                                                              //fit: BoxFit.contain,
                                                                                              width: 20,
                                                                                              height: 20,
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(width: 10,),

                                                                                          /// Text
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              //color: Colors.blue,
                                                                                              margin: EdgeInsets.only(right: 30),
                                                                                              child: Text(Strings.gotocall,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  textScaleFactor: 1.0,
                                                                                                  style: TextStyle(
                                                                                                      fontFamily: Strings.font_semibold,
                                                                                                      fontSize: 13,
                                                                                                      letterSpacing: 0.5,
                                                                                                      color: CustomColors.grayback)
                                                                                              ),
                                                                                            ),
                                                                                          )

                                                                                        ],

                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){

                                                                                  if(change==true){
                                                                                    backOnceOne();
                                                                                    launchFetchObtainPointsAds();
                                                                                  }else{
                                                                                    detectIntents();
                                                                                    utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }

                                                                                },
                                                                              );

                                                                            }
                                                                        ),
                                                                      ) :
                                                                      utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ?
                                                                      Container(
                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){

                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                  height: 40,
                                                                                  width: 170,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.greenwhats,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Row(

                                                                                        children: [

                                                                                          ///Icon
                                                                                          Container(
                                                                                            //color: Colors.purple,
                                                                                            margin: EdgeInsets.only(left: 20),
                                                                                            child: SvgPicture.asset(
                                                                                              'assets/images/ic_waChat.svg',
                                                                                              //fit: BoxFit.contain,
                                                                                              width: 20,
                                                                                              height: 20,
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(width: 10,),

                                                                                          /// Text
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              //color: Colors.blue,
                                                                                              margin: EdgeInsets.only(right: 30),
                                                                                              child: Text(Strings.gotowhats,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  textScaleFactor: 1.0,
                                                                                                  style: TextStyle(
                                                                                                      fontFamily: Strings.font_semibold,
                                                                                                      fontSize: 13,
                                                                                                      letterSpacing: 0.5,
                                                                                                      color: CustomColors.grayback)
                                                                                              ),
                                                                                            ),
                                                                                          )

                                                                                        ],

                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){
                                                                                  if(change==true){
                                                                                    backOnceOne();
                                                                                    launchFetchObtainPointsAds();
                                                                                  }else{
                                                                                    detectIntents();
                                                                                    utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }
                                                                                },
                                                                              );
                                                                            }

                                                                        ),
                                                                      ) :
                                                                      Container(
                                                                        child: ValueListenableBuilder<bool>(
                                                                            valueListenable: singleton.notifierNumberChange,
                                                                            builder: (context,change,_){
                                                                              return SpringButton(
                                                                                SpringButtonType.OnlyScale,
                                                                                Container(
                                                                                  //margin: EdgeInsets.only(left:80,right: 80 ),
                                                                                  height: 40,
                                                                                  width: 194,
                                                                                  decoration: BoxDecoration(
                                                                                      color:CustomColors.orangeswitch,
                                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                                  ),
                                                                                  child: Center(
                                                                                      child: Row(

                                                                                        children: [

                                                                                          ///Icon
                                                                                          Container(
                                                                                            //color: Colors.purple,
                                                                                            margin: EdgeInsets.only(left: 20),
                                                                                            child: SvgPicture.asset(
                                                                                              'assets/images/ic_webSite.svg',
                                                                                              //fit: BoxFit.contain,
                                                                                              width: 20,
                                                                                              height: 20,
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(width: 10,),

                                                                                          /// Text
                                                                                          Expanded(
                                                                                            child: Container(
                                                                                              //color: Colors.blue,
                                                                                              margin: EdgeInsets.only(right: 10),
                                                                                              child: Text(Strings.gotoweb,
                                                                                                  textAlign: TextAlign.center,
                                                                                                  textScaleFactor: 1.0,
                                                                                                  style: TextStyle(
                                                                                                      fontFamily: Strings.font_semibold,
                                                                                                      fontSize: 13,
                                                                                                      letterSpacing: 0.5,
                                                                                                      color: CustomColors.grayback)
                                                                                              ),
                                                                                            ),
                                                                                          )

                                                                                        ],

                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                useCache: false,
                                                                                onTap: (){
                                                                                  if(change==true){
                                                                                    backOnceOne();
                                                                                    launchFetchObtainPointsAds();
                                                                                  }else{
                                                                                    detectIntents();
                                                                                    utils.openSnackBarInfo(context, Strings.wrongcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                                                                                  }
                                                                                },
                                                                              );

                                                                            }

                                                                        ),
                                                                      ),


                                                                      SizedBox(height: 20,),

                                                                    ],
                                                                  ),

                                                                ),

                                                              ),

                                                              SizedBox(height: 20,),

                                                              /// for do
                                                              /*Container(
                                                              child: Text(Strings.winmore,
                                                                style: TextStyle(
                                                                    fontFamily: Strings.font_semiboldFe,
                                                                    fontSize:20,
                                                                    color: CustomColors.white),
                                                                textAlign: TextAlign.center,
                                                                textScaleFactor: 1.0,
                                                              ),
                                                            ),

                                                            SizedBox(height: 30,),

                                                            /// Go to for reward
                                                            widget.item.ads![itemAd]!.url! == "" ? Container(

                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:60,right: 60 ),
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.orangeswitch,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Container(
                                                                        //margin: EdgeInsets.only(left: 20,right: 20),
                                                                        child: Text(Strings.backtoreward1,
                                                                          textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: Strings.font_semibold,
                                                                                fontSize: 12,
                                                                                letterSpacing: 0.5,
                                                                                color: CustomColors.grayback),
                                                                          textScaleFactor: 1.0,
                                                                        ),
                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  if(value1==true){ /// if header is active
                                                                    //if(once==0){

                                                                      /// agregado
                                                                      FocusScope.of(context).requestFocus(new FocusNode());
                                                                      backOnceOne();
                                                                      launchFetchAnswers(passAllAnswertoCompleted);

                                                                    //}
                                                                  }
                                                                },
                                                              ),

                                                            ) : Container(),

                                                            widget.item.ads![itemAd]!.url! == "" ? Container() :
                                                            utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "telf" ?
                                                            Container(
                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:80,right: 80 ),
                                                                  height: 40,
                                                                  width: 170,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.orangeswitch,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Row(

                                                                        children: [

                                                                          ///Icon
                                                                          Container(
                                                                            //color: Colors.purple,
                                                                            margin: EdgeInsets.only(left: 20),
                                                                            child: SvgPicture.asset(
                                                                              'assets/images/ic_calling.svg',
                                                                              //fit: BoxFit.contain,
                                                                              width: 20,
                                                                              height: 20,
                                                                            ),
                                                                          ),

                                                                          SizedBox(width: 10,),

                                                                          /// Text
                                                                          Expanded(
                                                                            child: Container(
                                                                              //color: Colors.blue,
                                                                              margin: EdgeInsets.only(right: 30),
                                                                              child: Text(Strings.gotocall,
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_semibold,
                                                                                      fontSize: 13,
                                                                                      letterSpacing: 0.5,
                                                                                      color: CustomColors.grayback)
                                                                              ),
                                                                            ),
                                                                          )

                                                                        ],

                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                  backOnceOne();
                                                                  launchFetchAnswers(passAllAnswertoCompleted);
                                                                },
                                                              ),
                                                            ) :
                                                            utils.linkCallOrWhatsApp(widget.item.ads![itemAd]!.url!) == "whatsapp" ?
                                                            Container(
                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:80,right: 80 ),
                                                                  height: 40,
                                                                  width: 170,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.greenwhats,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Row(

                                                                        children: [

                                                                          ///Icon
                                                                          Container(
                                                                            //color: Colors.purple,
                                                                            margin: EdgeInsets.only(left: 20),
                                                                            child: SvgPicture.asset(
                                                                              'assets/images/ic_waChat.svg',
                                                                              //fit: BoxFit.contain,
                                                                              width: 20,
                                                                              height: 20,
                                                                            ),
                                                                          ),

                                                                          SizedBox(width: 10,),

                                                                          /// Text
                                                                          Expanded(
                                                                            child: Container(
                                                                              //color: Colors.blue,
                                                                              margin: EdgeInsets.only(right: 30),
                                                                              child: Text(Strings.gotowhats,
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_semibold,
                                                                                      fontSize: 13,
                                                                                      letterSpacing: 0.5,
                                                                                      color: CustomColors.grayback)
                                                                              ),
                                                                            ),
                                                                          )

                                                                        ],

                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                  backOnceOne();
                                                                  launchFetchAnswers(passAllAnswertoCompleted);
                                                                },
                                                              ),
                                                            ) :
                                                            Container(
                                                              child: SpringButton(
                                                                SpringButtonType.OnlyScale,
                                                                Container(
                                                                  margin: EdgeInsets.only(left:80,right: 80 ),
                                                                  height: 40,
                                                                  width: 194,
                                                                  decoration: BoxDecoration(
                                                                      color:CustomColors.orangeswitch,
                                                                      borderRadius: BorderRadius.all(const Radius.circular(6))
                                                                  ),
                                                                  child: Center(
                                                                      child: Row(

                                                                        children: [

                                                                          ///Icon
                                                                          Container(
                                                                            //color: Colors.purple,
                                                                            margin: EdgeInsets.only(left: 20),
                                                                            child: SvgPicture.asset(
                                                                              'assets/images/ic_webSite.svg',
                                                                              //fit: BoxFit.contain,
                                                                              width: 20,
                                                                              height: 20,
                                                                            ),
                                                                          ),

                                                                          SizedBox(width: 10,),

                                                                          /// Text
                                                                          Expanded(
                                                                            child: Container(
                                                                              //color: Colors.blue,
                                                                              margin: EdgeInsets.only(right: 10),
                                                                              child: Text(Strings.gotoweb,
                                                                                  textAlign: TextAlign.center,
                                                                                  textScaleFactor: 1.0,
                                                                                  style: TextStyle(
                                                                                      fontFamily: Strings.font_semibold,
                                                                                      fontSize: 13,
                                                                                      letterSpacing: 0.5,
                                                                                      color: CustomColors.grayback)
                                                                              ),
                                                                            ),
                                                                          )

                                                                        ],

                                                                      )
                                                                  ),
                                                                ),
                                                                useCache: false,
                                                                onTap: (){
                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                  backOnceOne();
                                                                  launchFetchAnswers(passAllAnswertoCompleted);
                                                                },
                                                              ),
                                                            )*/

                                                            ],

                                                          ),
                                                        ),
                                                      ),


                                                    ],

                                                  ),
                                                ) :  /// View after see
                                                Container();/// Header
                                              }
                                          ),
                                          

                                        ],

                                      )
                                  );
                                }

                              }

                          )

                      ),
                    ),
                  ),
                )
            );

          }

      );

  }

  /// Back var once to cero
  void backOnceOne(){

    //intents = 0;
    Future.delayed( Duration(milliseconds: 2000), () {
      once = 0;
      resetNumberCode();
    });

    singleton.notifierNumberChange.value = false; 
  }


  /// Polls List
  Widget _fields(BuildContext context){

    return Container(
      //color: CustomColors.bluebackProfile,

      child: ValueListenableBuilder<double>(
          valueListenable: singleton.notifierHeightViewQuestions,
          builder: (contexts,value2,_){

            return AnimatedContainer(
              height: value2,
              duration: Duration(milliseconds: 550),
              curve: Curves.fastOutSlowIn,
              margin: EdgeInsets.only(top: 180,bottom: 10,left: 20,right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(20)
                ),
                color: CustomColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),

              child: Stack(

                children: [

                  /// Poll
                  Container(
                    //height: value2,
                    //color: Colors.blue,
                    child: SingleChildScrollView(
                      child: ValueListenableBuilder<List<QuestionAds>>(
                          valueListenable: singleton.notifierQuestionAds,
                          builder: (context,value1,_){

                            return ValueListenableBuilder<int>( ///  item selected (question)
                                valueListenable: singleton.notifieriTemQuestion,
                                builder: (contexts,value,_){

                                  return FadeTransition(
                                    opacity: controllerAnima,
                                    child: Column(
                                      children: [

                                        //SizedBox(height: 10,),

                                        /// Image
                                        Stack(
                                          children: [

                                            /// Image
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context).size.width,
                                              height: 131,
                                              /*child: CachedNetworkImage(
                                                  imageUrl: widget.item.ads![itemAd]!.lgImages!,
                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),

                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  fit: BoxFit.contain,
                                                  useOldImageOnUrlChange: false,
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 131,
                                                ),*/
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topRight: const Radius.circular(20),
                                                  topLeft: const Radius.circular(20)
                                                ),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: widget.item.ads![itemAd]!.lgImages!,
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
                                                  height: 131,
                                                ),
                                              ),
                                            ),

                                            ///Icon
                                            InkWell(
                                              onTap: (){
                                                controllerButtons.reverse();
                                                singleton.notifierHeightViewQuestions.value = 382;
                                                Future.delayed(const Duration(milliseconds: 200), () {
                                                  utils.heightViewWinPoint();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              /*child: Container(
                                                margin: EdgeInsets.only(top: 7,right: 7),
                                                alignment: Alignment.topRight,
                                                child: SvgPicture.asset(
                                                  'assets/images/x1.svg',
                                                  fit: BoxFit.contain,
                                                  //color: CustomColors.greyplaceholder

                                                ),
                                              ),*/
                                              child: Container(
                                                margin: EdgeInsets.only(top: 7,right: 7),
                                                alignment: Alignment.topRight,
                                                child: ClipOval(
                                                  child: ValueListenableBuilder<SegmentationCustom>(
                                                  valueListenable: singleton.notifierValidateSegmentation,
                                                          builder: (context,value22,_){

                                                    return Container(
                                                      color: value22.code == 1 || value22.code == 102 || value22.code == 120 ? CustomColors.blueback : value22.data!.styles!.colorHeader!.toColors(),
                                                      height: 32,
                                                      width: 32,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: SvgPicture.asset(
                                                          'assets/images/x1.svg',
                                                          fit: BoxFit.contain,
                                                          //color: CustomColors.greyplaceholder
                                                        ),
                                                      ),
                                                    );

                                                  }

                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),

                                        /*/// Question title
                                        FadeTransition(
                                          opacity: controllerAnima,
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            child: Text(value1[value]!.question!,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 15,),
                                            ),
                                          ),
                                        ),

                                        /// Textfield
                                        Card(
                                          margin: EdgeInsets.only(left: 20,right: 20),
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          color: CustomColors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: CustomColors.graycountry, width: 1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),

                                          child: Container(
                                            height: 120,
                                            margin: EdgeInsets.all(10),
                                            child: TextField(
                                              //value1[value]!.answersAds![index-1]!.answersuser!.length
                                              enabled: value1[value]!.answersAds![0]!.answersuser!.length > 0 ? value1[value]!.answersAds![0]!.answersuser![0]!.from != "End" ? true : false : true,
                                              onEditingComplete: (){
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                              },
                                              textInputAction: TextInputAction.done,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                filled: true,
                                                //contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                                fillColor: Colors.transparent,
                                                hintText: Strings.writesome,
                                                hintStyle: TextStyle(
                                                    fontFamily: Strings.font_regular,
                                                    fontSize: 15,
                                                    color: CustomColors.grayTextemptyhome),
                                                counterText: "",
                                                contentPadding: EdgeInsets.symmetric(vertical: 30),
                                                hintMaxLines: 2,
                                              ),
                                              style: TextStyle(
                                                  fontFamily: Strings.font_regular,
                                                  fontSize: 15,
                                                  color: CustomColors.grayTextemptyhome),
                                              controller: _controllerComment,
                                              maxLines: null,
                                              maxLength: 120,
                                              expands: true,
                                              keyboardType: TextInputType.multiline,
                                              onTap: (){
                                                cahngeheight("edit");
                                              },
                                              onSubmitted: (Value){
                                                cahngeheight("done");
                                              },

                                            ),


                                          ),

                                        ),

                                        /// Limit Characters
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(Strings.maxletters,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.blacktextmax, fontSize: 11,),
                                          ),
                                        ),

                                        ValueListenableBuilder<double>(
                                            valueListenable: notifierHeightQuestions,
                                            builder: (contexts,value,_){

                                              return SizedBox(height: value,);
                                            }

                                        ),*/

                                        /// Questions
                                        ListView.builder(
                                          //physics: const AlwaysScrollableScrollPhysics(),
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          padding: EdgeInsets.only(left: 0,right: 0,),
                                          //itemCount: value1.code == 1 ? 5 : value1.code == 102 ? 0 : value1.data![itemsubcate]!.questions!.length ==0 ? 0 : value1.data![itemsubcate]!.questions![value]!.answers!.length + 1,
                                          itemCount: value1[value].answersAds!.length + 1,
                                          controller: _scrollController,
                                          itemBuilder: (BuildContext context, int index){

                                            if(index==0){

                                              /// Question Title
                                              return FadeTransition(
                                                opacity: controllerAnima,
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: Text(value1[value]!.question!.toUpperCase(),
                                                    textAlign: TextAlign.left,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blackquestions, fontSize: 26,),
                                                  ),
                                                ),
                                              );

                                            }else{

                                              if(value1[value]!.type! == 3){ /// Unique answer

                                                return InkWell(
                                                  onTap: (){


                                                    if(detectedTap(value1[value]!.answersAds!) == true){ /// Lets tap

                                                      for( int i = 0; i < value1[value]!.answersAds!.length; i++) {

                                                        if(i==index-1){

                                                          if(value1[value]!.answersAds![i]!.answersuser!.length > 0){ /// data exist

                                                            List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                            pre[value]!.answersAds![i]!.answersuser!.removeAt(0);
                                                            singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                            singleton.notifierQuestionAds.value = pre;

                                                          }else{/// No data exist

                                                            Answersuser item = Answersuser(answer: "",check: true,from: "list");
                                                            List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                            pre[value]!.answersAds![i]!.answersuser!.add(item);
                                                            singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                            singleton.notifierQuestionAds.value = pre;

                                                          }

                                                        }else{

                                                          if(value1[value]!.answersAds![i]!.answersuser!.length > 0){ /// data exist

                                                            List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                            pre[value]!.answersAds![i]!.answersuser!.removeAt(0);
                                                            singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                            singleton.notifierQuestionAds.value = pre;

                                                          }

                                                        }

                                                      }

                                                    }

                                                  },
                                                  child: FadeTransition(
                                                    opacity: controllerAnima,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),

                                                      child: Column(

                                                        children: [

                                                          Row(

                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                            children: [

                                                              ///Check icon
                                                              Container(
                                                                padding: EdgeInsets.only(left: 10, ),
                                                                child: SvgPicture.asset(
                                                                  value1[value]!.answersAds![index-1]!.answersuser!.length > 0 ? 'assets/images/ic_check.svg' : 'assets/images/ic_lesstext.svg',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),

                                                              /// Question
                                                              Expanded(
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                                  child: Text(
                                                                    value1[value]!.answersAds![index-1]!.answers!,
                                                                    textAlign: TextAlign.left,
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 25,),
                                                                  ),
                                                                ),
                                                              ),


                                                            ],

                                                          ),

                                                          SizedBox(height: index == value1[value]!.answersAds!.length ? 90 : 0,)

                                                        ],

                                                      ),

                                                    ),
                                                  ),
                                                );

                                              }else if(value1[value]!.type! == 2){ /// True or false answer

                                                return InkWell(
                                                  onTap: (){

                                                    if(detectedTap(value1[value]!.answersAds!) == true){ /// Lets tap

                                                      for( int i = 0; i < value1[value]!.answersAds!.length; i++) {

                                                        if(i==index-1){

                                                          if(value1[value]!.answersAds![i]!.answersuser!.length > 0){ /// data exist

                                                            List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                            pre[value]!.answersAds![i]!.answersuser!.removeAt(0);
                                                            singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                            singleton.notifierQuestionAds.value = pre;

                                                          }else{/// No data exist

                                                            Answersuser item = Answersuser(answer: "",check: true,from: "list");
                                                            List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                            pre[value]!.answersAds![i]!.answersuser!.add(item);
                                                            singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                            singleton.notifierQuestionAds.value = pre;

                                                          }

                                                        }else{

                                                          if(value1[value]!.answersAds![i]!.answersuser!.length > 0){ /// data exist

                                                            List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                            pre[value]!.answersAds![i]!.answersuser!.removeAt(0);
                                                            singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                            singleton.notifierQuestionAds.value = pre;

                                                          }

                                                        }

                                                      }

                                                    }

                                                  },
                                                  child: FadeTransition(
                                                    opacity: controllerAnima,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),

                                                      child: Column(

                                                        children: [

                                                          Row(

                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                            children: [

                                                              ///Check icon
                                                              Container(
                                                                padding: EdgeInsets.only(left: 10, ),
                                                                child: SvgPicture.asset(
                                                                  value1[value]!.answersAds![index-1]!.answersuser!.length > 0 ? 'assets/images/ic_check.svg' : 'assets/images/ic_lesstext.svg',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),

                                                              /// Question
                                                              Expanded(
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                                  child: Text(value1[value]!.answersAds![index-1]!.answers!,
                                                                    textAlign: TextAlign.left,
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 25,),
                                                                  ),
                                                                ),
                                                              ),


                                                            ],

                                                          ),

                                                          SizedBox(height: index == value1[value]!.answersAds!.length ? 90 : 0,)

                                                        ],

                                                      ),

                                                    ),
                                                  ),
                                                );

                                              }else if(value1[value]!.type! == 4){ /// Multiple answer

                                                return InkWell(
                                                  onTap: (){

                                                    if(detectedTap(value1[value]!.answersAds!) == true){ /// Lets tap

                                                      if(value1[value]!.answersAds![index-1]!.answersuser!.length > 0){ /// data exist

                                                        List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                        pre[value]!.answersAds![index-1]!.answersuser!.removeAt(0);
                                                        singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                        singleton.notifierQuestionAds.value = pre;

                                                      }else{/// No data exist

                                                        Answersuser item = Answersuser(answer: "",check: true,from: "list");
                                                        List<QuestionAds> pre = singleton.notifierQuestionAds.value;
                                                        pre[value]!.answersAds![index-1]!.answersuser!.add(item);
                                                        singleton.notifierQuestionAds.value = <QuestionAds>[];
                                                        singleton.notifierQuestionAds.value = pre;

                                                      }

                                                    }

                                                  },
                                                  child: FadeTransition(
                                                    opacity: controllerAnima,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),

                                                      child: Column(

                                                        children: [

                                                          Row(

                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                            children: [

                                                              ///Check icon
                                                              Container(
                                                                padding: EdgeInsets.only(left: 10, ),
                                                                child: SvgPicture.asset(
                                                                  value1[value]!.answersAds![index-1]!.answersuser!.length > 0 ? 'assets/images/ic_check.svg' : 'assets/images/ic_lesstext.svg',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),

                                                              /// Question
                                                              Expanded(
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                                  child: Text(value1[value]!.answersAds![index-1]!.answers!,
                                                                    textAlign: TextAlign.left,
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 25,),
                                                                  ),
                                                                ),
                                                              ),


                                                            ],

                                                          ),

                                                          SizedBox(height: index == value1[value]!.answersAds!.length ? 90 : 0,)

                                                        ],

                                                      ),

                                                    ),
                                                  ),
                                                );

                                              }else{ /// Text Answer

                                                return FadeTransition(
                                                  opacity: controllerAnima,
                                                  child: Column(
                                                    children: [

                                                      /// Textfield
                                                      Card(
                                                        margin: EdgeInsets.only(left: 20,right: 20),
                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                        color: CustomColors.white,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(color: CustomColors.graycountry, width: 1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),

                                                        child: Container(
                                                          height: 120,
                                                          margin: EdgeInsets.all(10),
                                                          child: TextField(
                                                            //value1[value]!.answersAds![index-1]!.answersuser!.length
                                                            enabled: value1[value]!.answersAds![0]!.answersuser!.length > 0 ? value1[value]!.answersAds![0]!.answersuser![0]!.from != "End" ? true : false : true,
                                                            onEditingComplete: (){
                                                              FocusScope.of(context).requestFocus(new FocusNode());
                                                            },
                                                            textInputAction: TextInputAction.done,
                                                            decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              filled: true,
                                                              //contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                                              fillColor: Colors.transparent,
                                                              hintText: Strings.writesome,
                                                              /*hintStyle: TextStyle(
                                                                  fontFamily: Strings.font_regular,
                                                                  fontSize: 15,
                                                                  color: CustomColors.grayTextemptyhome),*/
                                                              hintStyle: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.grayTextemptyhome, fontSize: 20,),
                                                              counterText: "",
                                                              contentPadding: EdgeInsets.symmetric(vertical: 30),
                                                              hintMaxLines: 2,
                                                            ),
                                                            style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 20,),
                                                            controller: _controllerComment,
                                                            maxLines: null,
                                                            maxLength: 120,
                                                            expands: true,
                                                            keyboardType: TextInputType.multiline,
                                                            onTap: (){
                                                              cahngeheight("edit");
                                                            },
                                                            onSubmitted: (Value){
                                                              cahngeheight("done");
                                                            },

                                                          ),


                                                        ),

                                                      ),

                                                      /// Limit Characters
                                                      Container(
                                                        alignment: Alignment.bottomRight,
                                                        padding: EdgeInsets.only(right: 20),
                                                        child: Text(Strings.maxletters,
                                                          textAlign: TextAlign.right,
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 20,),
                                                        ),
                                                      ),

                                                      ValueListenableBuilder<double>(
                                                          valueListenable: notifierHeightQuestions,
                                                          builder: (contexts,value,_){

                                                            return SizedBox(height: value,);
                                                          }

                                                      ),

                                                    ],
                                                  ),
                                                );

                                              }

                                            }

                                          },

                                        )

                                      ],
                                    ),
                                  );

                                }

                            );

                          }

                      ),

                    ),
                  ),


                ],

              ),

            );

          }

      ),

    );

  }

  /// scroll when is Textfield
  void cahngeheight(String editorNormal){

    if(editorNormal == "edit"){
      notifierHeightQuestions.value = 150;
      _scrollController.animateTo(150, duration: new Duration(milliseconds: 100), curve: Curves.fastOutSlowIn);
    }else{
      notifierHeightQuestions.value = 10;
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn);
    }

  }

  /// Detect if you can tap on the answers
  bool detectedTap(List<AnswersAds> value1){

    bool maketap = true;


    for (int i = 0; i < value1.length ; i++) {

      /*print(value1.data![itemsubcate]!.name);
      print(value1.data![itemsubcate]!.questions![value]!.question);
      print(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answers);
      print(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.toString());
      print(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length);*/

      if(value1[i]!.answersuser!.length > 0){

        if(value1[i]!.answersuser![0]!.from == "End"){
          singleton.notifierMakeTapAnswer.value = false;
          maketap = false;
          break;
        }

      }

    }


    return maketap;

  }

  /// Pager and Buttons
  Widget PagerButton(BuildContext context){

    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeTransition(
        opacity: controllerButtons,
        child: Container(
          margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
          height: 90,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: CustomColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [

              SizedBox(height: 5,),

              ///Paginador
              Container(

                child: ValueListenableBuilder<List<QuestionAds>>(
                    valueListenable: singleton.notifierQuestionAds,
                    builder: (context,value1,_){

                      return ValueListenableBuilder<int>(
                          valueListenable: singleton.notifieriTemQuestion,
                          builder: (contexts,value,_){

                            return PageViewIndicator(
                              length: value1.length,
                              currentIndex: value,
                              currentColor: CustomColors.blueback,
                              otherColor: CustomColors.graydots.withOpacity(0.4),
                              currentSize: 10,
                              otherSize: 7,
                              //margin: EdgeInsets.all(5),
                              borderRadius: 9999.0,
                              alignment: MainAxisAlignment.center,
                              animationDuration: Duration(milliseconds: 750),
                            );

                          }

                      );

                    }

                ),

              ),

              SizedBox(height: 5,),

              ///Buttons
              Container(
                padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                child: ValueListenableBuilder<SegmentationCustom>(
                    valueListenable: singleton.notifierValidateSegmentation,
                    builder: (context,value2,_){

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [

                          /// back
                          Expanded( /// If first question no show
                            child: singleton.notifieriTemQuestion.value == 0 ? Container() : Container(
                              child: ArgonButton(
                                height: 41,
                                width: 300,
                                borderRadius: 40.0,
                                color: CustomColors.white,
                                child: Container(
                                  width: double.infinity,
                                  height: 41,
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.all(const Radius.circular(21)),
                                    border: Border.all(
                                      width: 1,
                                      color: value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.bordebuttons : value2.data!.styles!.colorHeader!.toColors(),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: <Widget>[


                                        /// languaje
                                        Expanded(
                                          child: Container(
                                            //color: Colors.red,
                                            //margin: EdgeInsets.only(left: 10,right: 40),
                                            child: AutoSizeText(
                                              Strings.back,
                                              textAlign: TextAlign.center,
                                              textScaleFactor: 1.0,
                                              //maxLines: 1,
                                              style: TextStyle(fontFamily: Strings.font_boldFe, color: value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.orangeborderpopup : value2.data!.styles!.colorHeader!.toColors(), fontSize: 16.0,),
                                              //maxLines: 1,
                                            ),
                                          ),
                                        ),

                                      ],

                                    ),
                                  ),
                                ),
                                loader: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    //padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                      backgroundColor: CustomColors.greyborderbutton,
                                      valueColor: AlwaysStoppedAnimation<Color>(CustomColors.greyborderbutton),
                                    ),
                                  ),
                                ),
                                onTap: (startLoading, stopLoading, btnState) {
                                  if(btnState == ButtonState.Idle){

                                    startLoading();
                                    if(singleton.notifieriTemQuestion.value == 0){
                                      singleton.notifieriTemQuestion.value = 0;
                                    }else singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value - 1;
                                    controllerAnima.reset();
                                    controllerAnima.forward();
                                    PutTextIntoTexfield();
                                    Future.delayed(const Duration(milliseconds: 200), () {
                                      stopLoading();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 20,
                          ),

                          /// save
                          Expanded(
                            child: Container(
                              child: ValueListenableBuilder<List<QuestionAds>>(
                                  valueListenable: singleton.notifierQuestionAds,
                                  builder: (context,value1,_){

                                    return ValueListenableBuilder<int>(
                                        valueListenable: singleton.notifieriTemSubCategory,
                                        builder: (contexts,itemsubcate,_){

                                          return ArgonButton(
                                            height: 41,
                                            width: 300,
                                            borderRadius: 40.0,
                                            color: CustomColors.orangeborderpopup,
                                            child: Container(
                                              width: double.infinity,
                                              height: 41,
                                              decoration: BoxDecoration(
                                                color: value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.orangeborderpopup : value2.data!.styles!.colorHeader!.toColors(),
                                                borderRadius: BorderRadius.all(const Radius.circular(21)),
                                                border: Border.all(
                                                  width: 1,
                                                  color: value2.code == 1 || value2.code == 102 || value2.code == 120 ? CustomColors.orangeborderpopup : value2.data!.styles!.colorHeader!.toColors(),
                                                ),
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,

                                                  children: <Widget>[


                                                    /// languaje
                                                    Expanded(
                                                      child: Container(
                                                        //color: Colors.red,
                                                        //margin: EdgeInsets.only(left: 10,right: 40),
                                                        child: AutoSizeText(
                                                          singleton.notifierSubCategoriesProfile.value.code == 1 ? Strings.save1 : singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length - 1 == singleton.notifieriTemQuestion.value ? Strings.save : Strings.save1,
                                                          textAlign: TextAlign.center,
                                                          textScaleFactor: 1.0,
                                                          //maxLines: 1,
                                                          style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 16.0,),
                                                          //maxLines: 1,
                                                        ),
                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),
                                            ),
                                            loader: Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                //padding: EdgeInsets.all(10),
                                                child: CircularProgressIndicator(
                                                  backgroundColor: CustomColors.white,
                                                  valueColor: AlwaysStoppedAnimation<Color>(CustomColors.white),
                                                ),
                                              ),
                                            ),
                                            onTap: (startLoading, stopLoading, btnState) {
                                              if(btnState == ButtonState.Idle){

                                                cahngeheight("done");
                                                startLoading();
                                                controllerAnima.reset();
                                                controllerAnima.forward();
                                                _validateSendAnsw(context, stopLoading);

                                              }
                                            },
                                          );

                                        }

                                    );

                                  }

                              ),
                            ),
                          ),


                        ],

                      );

                    }

                ),
              ),


            ],

          ),

        ),
      ),
    );

  }

  ///Validate And Send Answers
  _validateSendAnsw(BuildContext context,Function stop) async{

    //print(singleton.notifieriTemQuestion.value);

    callonlyonce = false;

    /// Type Text Answer
    if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.type! == 1){ /// Text Answer

      /// Answer exist
      if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.answersAds![0]!.answersuser!.length >0){/// Answer exist

        /// Only list
        if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.answersAds![0]!.answersuser![0]!.from == "list"){
          AddTypeTextToVector(stop);

        }else{/// answer on endpoint
          NextQuestion();
          stop();
        }

      }else{ /// Answer no exist

        if(_controllerComment.text != ""){ /// Comment Textfield full
          AddTypeTextToVector(stop);

        }else{ /// empty Textfield
          utils.openSnackBarInfo(context, Strings.emptyanswer, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          stop();
        }

      }


    }else{ /// the other types of questions

      if(singleton.notifierQuestionAds.value.length - 1 != singleton.notifieriTemQuestion.value){
        safeAllowsToTap(singleton.notifieriTemQuestion.value + 1);
      }else{

        lastItemsubcategory(singleton.notifieriTemQuestion.value);
      }

      stop();

    }

  }

  ///sure lets tap on last question
  void lastItemsubcategory(int itemquestion){

    ///detect if the question has ws data
    singleton.notifierMakeTapAnswer.value = true;
    var goto = "YES";
    var isnotAnswer = "NO";

    for (int i = 0; i < singleton.notifierQuestionAds.value[itemquestion]!.answersAds!.length ; i++) {
      if(singleton.notifierQuestionAds.value[itemquestion]!.answersAds![i]!.answersuser!.length > 0){
        isnotAnswer = "YES";
        if(singleton.notifierQuestionAds.value[itemquestion]!.answersAds![i]!.answersuser![0]!.from == "End"){
          singleton.notifierMakeTapAnswer.value = false;
          goto = "NO";
          break;
        }
      }
    }

    if(isnotAnswer=="NO"){
      utils.openSnackBarInfo(context, Strings.emptyanswer, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
    }else if(goto == "YES"){
      _controllerComment.text = "";
      NextQuestion();
      return; /// Puesto ahorita
    }

    ///Subcategory is not completed
    /*if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length==0){

      if(callonlyonce==false){
        launchFetchAnswers(passAllAnswertoCompleted);
        callonlyonce=true;
      }


    }else{ /// Go to next subcategory
      _controllerComment.text = "";


      /// if it is not the last subcategory
      if(singleton.notifierSubCategoriesProfile.value.data!.length -1 != singleton.notifieriTemSubCategory.value){

        /// If the subcategory is complete
        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser![0]!.subCategoryStatus== "completed"){
          singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value + 1;
          singleton.notifieriTemQuestion.value = 0;

        }else{/// If the subcategory is incomplete

          if(callonlyonce==false){
            launchFetchAnswers(passAllAnswertoCompleted);
            callonlyonce=true;
          }

        }

      }


    }*/

  }

  /// sure lets tap on next question
  void safeAllowsToTap(int nextquestion){


    var goto = "NO";
    var runnextquestion = "NO";
    var item = nextquestion-1;
    if(nextquestion>0){ /// detect if the subcategory only has one question

      ///detect if the current question is type 1 and does not execute next question method
      if(singleton.notifierQuestionAds.value[item]!.type! != 1){
        runnextquestion = "YES";
      }

      for (int i = 0; i < singleton.notifierQuestionAds.value[item]!.answersAds!.length ; i++) {

        if(singleton.notifierQuestionAds.value[item]!.answersAds![i]!.answersuser!.length > 0){
          goto = "YES";
          break;
        }

      }

    }else{
      goto = "YES";
      NextQuestion();
    }



    if(goto == "YES"){

      ///detect if the following question has ws data
      singleton.notifierMakeTapAnswer.value = true;
      for (int i = 0; i < singleton.notifierQuestionAds.value[nextquestion]!.answersAds!.length ; i++) {

        if(singleton.notifierQuestionAds.value[nextquestion]!.answersAds![i]!.answersuser!.length > 0){

          if(singleton.notifierQuestionAds.value[nextquestion]!.answersAds![i]!.answersuser![0]!.from == "End"){
            singleton.notifierMakeTapAnswer.value = false;
            break;
          }

        }

      }
      _controllerComment.text = "";

      if(runnextquestion=="YES"){
        NextQuestion();
      }else {

        if((nextquestion == singleton.notifierQuestionAds.value.length -1) && singleton.notifierQuestionAds.value[nextquestion]!.type! == 1){
          NextQuestion();
        }

      }
      //stop();

    }else{
      if(goto=="NO"){
        utils.openSnackBarInfo(context, Strings.emptyanswer, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
      }

    }


  }

  ///Go to Next Question
  void NextQuestion(){

      /// last question of the subcategory
        if(singleton.notifierQuestionAds.value.length - 1 == singleton.notifieriTemQuestion.value){

          /*if(singleton.notifierQuestionAds.value.length == 2){ /// if next question is  text (two question text consecu)

            if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value + 1].type == 1){
              singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value + 1; /// Next question
            }

          }else{*/

            singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value;

            print(singleton.notifierQuestionAds.value.length-1 );
            print("Item de pregunta " + singleton.notifieriTemQuestion.value.toString());

            if(callonlyonce==false){
              //launchFetchAnswers(passAllAnswertoCompleted);
              FocusScope.of(context).requestFocus(new FocusNode());

              ///detect if the current question is type 1 and does not answer
                if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.type! == 1){  /// Puesto cuando hay 2 preguntas de texto
                  if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.answersAds![0].answersuser!.length > 0){
                    if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.answersAds![0].answersuser![0]!.answer! != ""){
                      this.changeColorHeader();
                      callonlyonce=true;
                    }
                  }else{
                      blockchangeColorHeader();
                      callonlyonce=true;
                  }
                }else {
                  this.changeColorHeader();
                  callonlyonce=true;
                }

              //this.changeColorHeader();
              //callonlyonce=true;
            }





      }else singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value + 1; /// Next question


    PutTextIntoTexfield();
  }

  /// Add Type 1 Answers to Vector
  void AddTypeTextToVector(Function stop){

    var vect = [];
    vect.add(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.answersAds![0]!.id);
    Answersuser item = Answersuser(answer: _controllerComment.text,check: true,from: "list");
    List<QuestionAds> pre = singleton.notifierQuestionAds.value;
    pre[singleton.notifieriTemQuestion.value]!.answersAds![0]!.answersuser!.add(item);
    singleton.notifierQuestionAds.value = <QuestionAds>[];
    singleton.notifierQuestionAds.value = pre;

    if(singleton.notifierQuestionAds.value.length - 1 != singleton.notifieriTemQuestion.value){
      safeAllowsToTap(singleton.notifieriTemQuestion.value + 1);
      NextQuestion();
    }else{
      safeAllowsToTap(singleton.notifieriTemQuestion.value);
    }

    stop();

  }

  ///put text in Texfield
  void PutTextIntoTexfield(){

    if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.type! == 1){ /// Text Answer
      if(singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.answersAds![0]!.answersuser!.length > 0){
        var value = singleton.notifierQuestionAds.value[singleton.notifieriTemQuestion.value]!.answersAds![0]!.answersuser![0]!.answer;
        reloadText(value!);
      }
    }

  }

  /// Launch Answer Endpoint
  void launchFetchAnswers(Function stop)async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');


        var vectQuestions = [];


        ///cycle through vector of questions of that subcategory
        for (int i = 0; i < singleton.notifierQuestionAds.value.length ; i++){

          /*ProfilesubcategoriesDataQuestions question = singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![i]!;
          print(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![i]!.question);
          List<ProfilesubcategoriesDataQuestionsAnswers?>? answers = question.answers;*/

          List<AnswersAds>? answers = singleton.notifierQuestionAds.value[i].answersAds;

          var vectAnsers = [];
          var answer = "";

          for (int y = 0; y < answers!.length ; y++){ /// walk through answers vector


            if(answers![y]!.answersuser!.length >0){ ///check if your answer was answered
              vectAnsers.add(answers![y]!.id);
              /*answer = answers![y]!.answersuser![0]!.answer!;

              if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length >0){

                if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser![0]!.subCategoryStatus == "incomplete"){
                  if(answers![y]!.answersuser![0]!.from != "End"){
                    vectAnsers.add(answers![y]!.id); /// add id answer
                  }
                }

              }else{
                vectAnsers.add(answers![y]!.id);
              }*/
            }

          }


          if(vectAnsers.length==0){ /// That question has no added answer
            utils.openSnackBarInfo(context, Strings.emptyanswer1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
            break;
          }else {

            Map<String, dynamic> itemsQuestion = {
              "questionAdsId": singleton.notifierQuestionAds.value[i].id,
              "answersAds": vectAnsers,
              "type": singleton.notifierQuestionAds.value[i].type!,
              //"answer": singleton.notifierQuestionAds.value[i].type! == 1 ? answer : "",
              "answer": singleton.notifierQuestionAds.value[i].type! == 1 ? singleton.notifierQuestionAds.value[i].answersAds![0]!.answersuser![0]!.answer! : "",
            };

            vectQuestions.add(itemsQuestion);

          }


        }

        if(vectQuestions.length==0){ /// That question has no added answer
          utils.openSnackBarInfo(context, Strings.emptyanswer1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          return;

        }else{
          _controllerComment.text = "";
          utils.openProgress(context);
          servicemanager.fetchSendAnswerGaneRoom(context, vectQuestions, stop);

        }


        /// If the subcategory has not been submitted
        /*if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length == 0){

          /// If the questions are answered equal to the number of questions
          if(vectQuestions.length == singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length){
            _controllerComment.text = "";
            utils.openProgress(context);
            //stop();
            servicemanager.fetchSendAnswer(context, vectQuestions, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.id!, stop);

          }

        }else if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser![0]!.subCategoryStatus== "incomplete"){
          ///if the subcategory is incomplete or one more question was added
          _controllerComment.text = "";
          utils.openProgress(context);
          //stop();
          servicemanager.fetchSendAnswer(context, vectQuestions, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.id!, stop);

        }*/



      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Pass all answers to completed
  void passAllAnswertoCompleted(){

    /*Profilesubcategories categories = singleton.notifierSubCategoriesProfile.value;
    ProfilesubcategoriesData categoryItem = categories.data![singleton.notifieriTemSubCategory.value]!;
    ProfilesubcategoriesDataSubcategorysuser Subcategorysuser = ProfilesubcategoriesDataSubcategorysuser(from: "End",subCategoryStatus: "completed");
    categoryItem.subcategoryuser!.add(Subcategorysuser);

    for (int i = 0; i < categoryItem!.questions!.length ; i++){

      ProfilesubcategoriesDataQuestions question = singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![i]!;
      List<ProfilesubcategoriesDataQuestionsAnswers?>? answers = question.answers;

      for (int y = 0; y < answers!.length ; y++){ /// walk through answers vector

        if(answers![y]!.answersuser!.length >0){ ///check if your answer was answered
          answers![y]!.answersuser![0]!.from = "End"; ///pass the response as if it were a ws
        }

      }

    }

    singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
    singleton.notifierSubCategoriesProfile.value = categories;


    /// run coin animation
    if(singleton.notifierSubCategoriesProfile.value.data!.length -1 == singleton.notifieriTemSubCategory.value){
      widget.onAnimationCoin();
    }*/
    showAlertWonPoints();

  }

  ///Reload textfield
  void reloadText(String value){
    _controllerComment.text = value;
  }



  @override
  void dispose() {
    /*if(widget.item.ads![itemAd-1]!.formatValue == 1){/// Video
      singleton.controller.removeListener(checkVideo);
      singleton.controller.dispose();
    }*/

    if(formatValue==1){
      if(prefs.authToken=="0"){
        singleton.controller!.dispose();
      }

      stopvideocontroller();
    }

    //if(formatValue==3){
      controllerAnima.dispose();
      controllerButtons.dispose();
    //}


    super.dispose();
  }

  /// Go back
  void back(){

    //if(relaun == 1){
      widget.relaunch();
    //}

    if(once==0){
      once = once + 1;
      Navigator.pop(singleton.navigatorKey.currentContext!);
    }

  }

  /// Obtain Points Ads
  void launchFetchObtainPointsAds()async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        Future.delayed(const Duration(milliseconds: 400), () {
          utils.openProgress(context);
          servicemanager.fetchObtainPointsLookRoom(context,showAlertWonPoints);
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
  void showAlertWonPoints(){
    relaun = 1;

    //singleton.notifierOffsetTapGane.value = [singleton.valuenotifierOffsetTapCategory[0],singleton.valuenotifierOffsetTapCategory[1]];
    //singleton.notifierOffsetInitialTapGane.value = [singleton.valuenotifierOffsetInitialTapCategory[0],singleton.valuenotifierOffsetInitialTapCategory[1]];

    Future.delayed(const Duration(milliseconds: 100), () {

      this.blockchangeColorHeader();

      //dialogWinPoints(singleton.navigatorKey.currentContext!, Strings.greatwin, Strings.activate4, Strings.activate3,onNextAd,widget.item!.ads![itemAd]!.pointsAds);
      utils.VibrateAndMusic();
      goWinView = 1;
      //Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: WinsPoints(points: widget.item!.ads![itemAd]!.pointsAds, image: widget.item.ads![itemAd]!.adImages!, onNextAd: onNextAd,back: isTheLast(), callWeb: widget.item.ads![itemAd]!.url!,) ));
      //utils.callOrWebView(widget.item.ads![itemAd]!.url!);
      showCupertinoModalPopup(context: context, builder:
          (context) => WinsPoints(points: widget.item!.ads![itemAd]!.pointsAds, image: widget.item.ads![itemAd]!.adImages!, onNextAd: onNextAd,back: isTheLast(), callWeb: widget.item.ads![itemAd]!.url!, aditionalPoints: widget.item!.pointsAdditional,)
      );


    });


  }

  /// Is the last
  bool isTheLast(){
    var itemAd1 = itemAd+1;
    if(itemAd1 >= widget.item.ads!.length){
      return true;
    }else {
      return false;
    }

  }

  /// Next Ad
  void onNextAd(){

    widget.relaunch();

    utils.addUserPoint(int.tryParse(widget.item.ads![itemAd]!.pointsAds ?? ""));

    if(widget.item.ads![itemAd]!.formatValue == 1){/// Current Ad is Video
      singleton.controller!.removeListener(checkVideo);
      singleton.controller!.pause();
    }

    itemAd = itemAd+1;

    if(outScreen == true){
      outScreen = false;
      back();

    }else{
      if(itemAd >= widget.item.ads!.length){ /// Last Ad
        outScreen = false;
        itemAd = itemAd-1;
        widget.relaunch();
        Navigator.pop(singleton.navigatorKey.currentContext!);

      }else{ /// Goto next Ad
        outScreen = false;
        singleton.idAds = widget.item.ads![itemAd]!.id!;
        singleton.format = widget.item.ads![itemAd]!.formatValue!;
        //singleton.notifierPointsGaneRoom.value = widget.item.ads![itemAd]!.pointsAds!; /// OJO antes estaba este activo
        notifierformatValue.value = 0;
        notifierformatValue.value =  widget.item!.ads![itemAd]!.formatValue!;
        formatValue = widget.item!.ads![itemAd]!.formatValue!;

        if(widget.item.ads![itemAd]!.formatValue == 3){ /// Poll
          singleton.notifierQuestionAds.value = widget.item.ads![itemAd]!.questionAds!;
        }else{
          singleton.notifierQuestionAds.value = <QuestionAds>[];
        }
        once = 0;
        LoadInitialSetting();

      }

    }


  }

  Future<List<SiteModel>> Vimeo(String url) async {
    var result = <SiteModel>[];
    //var parse = Parse();

    /// get data from url
    var r = await http.get(Uri.parse(url));

    var body = r.body;
    //var decoded = jsonDecode(body);
    //var json = decoded[0];

    /// get html data
    var html = r.body.split('clip_page_config = ')[1].split('}};')[0] + '}}';

    /// json decode
    var data = json.decode(html);

    /// get config
    var config = data['player']['config_url'];

    /// get data from config url
     r = await http.get(Uri.parse('$config'));

    //var urls= "https://player.vimeo.com/video/757593070/config?autopause=1&byline=0&collections=1&context=Vimeo%5CController%5CClipController.main&default_to_hd=1&h=f55887c4c6&outro=nothing&portrait=0&share=1&speed=1&title=0&watch_trailer=0&s=8670374a71625fc667c1f3bfa5313a8ec3dec555_1665187957";
    //r = await http.get(Uri.parse(urls));[

    /// json decode
     data = json.decode(r.body);

    /// get progressive
    /*var progressive = data['request']['files']['progressive'];


    /// list for each
    progressive.forEach((_progressive) {
      /// get quality
      var quality = _progressive['quality'];

      /// get link
      var link = _progressive['url'];

      /// add data to result list
      result.add(SiteModel(quality: '$quality', link: '$link'));
    });*/

    var progressive = data['request']['files']['hls']['cdns']['akfire_interconnect_quic']['url'];

    if(progressive.contains("?query_string_ranges=1")){
      var juststream = progressive.split("?query_string_ranges=1");
      progressive = juststream[0];
    }

    var progressive1 = data['request']['files']['dash']['cdns']['akfire_interconnect_quic']['url'];
    var progressive2 = data['request']['files']['dash']['cdns']['akfire_interconnect_quic']['avc_url'];
    result.add(SiteModel(quality: '240p', link: '$progressive'));
    result.add(SiteModel(quality: '240p', link: '$progressive1'));
    result.add(SiteModel(quality: '240p', link: '$progressive2'));


    /// result list sort by quality
    //result.sort((a, b) => parse.quality(a).compareTo(parse.quality(b)));
    result.sort((a, b) => a.quality!.compareTo(b.quality!));
    print(result);

    /// return result list
    return result;
  }


}


///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderWallet1,
        builder: (context,value2,_){

          return AnimatedContainer(
            //color: Colors.green,
            height: value2,
            duration: Duration(milliseconds: 300),
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

                      child: ValueListenableBuilder<SegmentationCustom>(
                          valueListenable: singleton.notifierValidateSegmentation,
                          builder: (context,valueseg,_){

                            if(valueseg.code == 1 ){
                              /*return Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );*/
                              return SvgPicture.asset(
                                'assets/images/headerprofile.svg',
                                fit: BoxFit.fill,
                              );
                            }else if(valueseg.code == 100){
                              return Container(
                                color: valueseg.data!.styles!.colorHeader!.toColors(),
                              );
                            }else if(valueseg.code == 102){
                              return value2 > 90.0 ? SvgPicture.asset(
                                'assets/images/headerprofile.svg',
                                fit: BoxFit.fill,
                              ) : Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );
                            }else{
                              return SvgPicture.asset(
                                'assets/images/headerprofile.svg',
                                fit: BoxFit.fill,
                              );
                            }

                          }

                      )

                  ),

                  Container(
                    child: Column(

                      children: [

                        /// Header
                        Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              ///Logo
                              Container(
                                alignment: Alignment.topLeft,
                                //color: Colors.blue,
                                padding: EdgeInsets.only(top: 35,left: 20),
                                child:InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );
                                  },
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

                              /// UserImage
                              /*Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5,right: 25,top: 35),
                                  //%height: 103,
                                  //color: Colors.blue,
                                  child: Column(

                                    children: [

                                      ///UserImage
                                      InkWell(
                                        onTap: (){
                                          //imagePicker.showDialog(context);

                                          dialogSetting(context);
                                        },
                                        child: Stack(

                                          children: [

                                            ClipOval(
                                              child: Container(
                                                color: Colors.white,
                                                height: 50,
                                                width: 50,
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left: 2.5,top: 2.5),
                                              //alignment: Alignment.center,
                                              child: ClipOval(
                                                child: ValueListenableBuilder<Getprofile>(
                                                    valueListenable: singleton.notifierUserProfile,
                                                    builder: (context,value1,_){

                                                      return CachedNetworkImage(
                                                        width: 45,
                                                        height: 45,
                                                        imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                        placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                          width: 45,
                                                          height: 45,
                                                        ),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        fit: BoxFit.cover,
                                                        useOldImageOnUrlChange: false,

                                                      );

                                                    }

                                                ),

                                              ),
                                            ),

                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: ClipOval(
                                                child: SvgPicture.asset(
                                                  'assets/images/herradura.svg',
                                                  fit: BoxFit.cover,
                                                  width: 21,
                                                  height: 21,
                                                ),
                                              ),
                                            ),

                                          ],

                                        ),
                                      ),
                                    ],


                                  ),

                                ),
                              ),*/

                              Expanded(
                                child: Container(
                                  height: 10,
                                  //color: Colors.red,
                                ),
                              ),

                              ///Coins
                              /*SpringButton(
                                SpringButtonType.OnlyScale,
                                Container(
                                  padding: EdgeInsets.only(right: 10,top: 40 ),
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
                                            textScaleFactor: 1.0,
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

                        /// Data
                        Container(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 5),
                          height: 93,
                          //height: 103,
                          //color: Colors.red,
                          child: Column(

                            children: [

                              ///UserImage
                              /*InkWell(
                                onTap: (){
                                  //imagePicker.showDialog(context);
                                },
                                child: Stack(

                                  children: [

                                    ClipOval(
                                      child: Container(
                                        color: Colors.white,
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 2.5,top: 2.5),
                                      //alignment: Alignment.center,
                                      child: ClipOval(
                                        child: ValueListenableBuilder<Getprofile>(
                                            valueListenable: singleton.notifierUserProfile,
                                            builder: (context,value1,_){

                                              return CachedNetworkImage(
                                                width: 45,
                                                height: 45,
                                                imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                  width: 45,
                                                  height: 45,
                                                ),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                fit: BoxFit.cover,
                                                useOldImageOnUrlChange: false,

                                              );

                                            }

                                        ),

                                      ),
                                    ),

                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: ClipOval(
                                        child: SvgPicture.asset(
                                          'assets/images/icono5.svg',
                                          fit: BoxFit.cover,
                                          width: 27,
                                          height: 27,
                                        ),
                                      ),
                                    ),

                                  ],

                                ),
                              ),*/

                              SizedBox(height: 5,),

                              /// username
                              /*Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: ValueListenableBuilder<Getprofile>(
                                    valueListenable: singleton.notifierUserProfile,
                                    builder: (context,value1,_){

                                      return Text(value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.fullname!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 14,),
                                        textScaleFactor: 1.0,
                                      );

                                    }

                                ),
                              ),*/
                              Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(Strings.encuesta,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 31,),
                                    textScaleFactor: 1.0,
                                  )
                              ),


                              Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(Strings.encuesta1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 13.5,),
                                    textScaleFactor: 1.0,
                                  )
                              ),

                              SizedBox(height: 5,),

                              ///Progressbar
                              /*Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                height: 12,
                                child: ValueListenableBuilder<TotalpointProfileCategories>(
                                    valueListenable: singleton.notifierPointsProfileCategories,
                                    builder: (context,value,_){

                                      return LiquidLinearProgressIndicator(
                                        value: (value.code == 1 || value.code == 102 || value.code == 120) ? 0.0 : ((value.data!.totalUser! * 100)/value.data!.point!)/100, // Defaults to 0.5.
                                        valueColor: AlwaysStoppedAnimation(CustomColors.blueBack), // Defaults to the current Theme's accentColor.
                                        backgroundColor: CustomColors.white.withOpacity(0.6), // Defaults to the current Theme's backgroundColor.
                                        borderColor: CustomColors.white.withOpacity(0.6),
                                        borderWidth: 0.0,
                                        borderRadius: 6.0,
                                        direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                        center: Text(""),
                                      );

                                    }

                                ),
                              ),

                              SizedBox(height: 5,),

                              ///Percentage
                              ValueListenableBuilder<TotalpointProfileCategories>(
                                  valueListenable: singleton.notifierPointsProfileCategories,
                                  builder: (context,value,_){

                                    return Container(

                                      child: Container(
                                        child: Text(singleton.formatter.format((value.data!.totalUser! * 100)/value.data!.point!) + "%",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 15,),
                                          textScaleFactor: 1.0,
                                        ),
                                      ),

                                    );

                                  }

                              ),*/

                            ],


                          ),

                        ),

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

}