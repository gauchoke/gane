import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_nopoints.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';

class CampaignDetail extends StatefulWidget{

  final format;
  final sequenceornot;
  final VoidCallback onWonCoin;
  final ResultSL item;

  CampaignDetail({this.format, required this.onWonCoin, required this.item, this.sequenceornot});

  _stateCampaignDetail createState()=> _stateCampaignDetail();
}

class _stateCampaignDetail extends State<CampaignDetail> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  int formatValue = 0;

  var onceVideo = 0;
  var once = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  /*
  @override
  void initState(){


    formatValue = widget.item!.ads![0]!.formatValue!;
    LoadInitialSetting();
    launchFetchClickSecuence();

    WidgetsBinding.instance!.addPostFrameCallback((_){

      Future.delayed( Duration(milliseconds: 0), () {
        singleton.GaneOrMira = "mira";
        double points = double.parse(widget.item.ads![0]!.pointsAds!) + double.parse(widget.item.pointsAdditional!);
        //dialogWinPointsCampaings(context, Strings.seevideo, launchVideo, Strings.reward, widget.item.ads![0]!.lgImages!,widget.item.ads![0]!.adImages!, points.toString(), widget.item.ads![0]!.formatValue!);
      });

    });

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

    singleton.notifierSeePlay.value = false;
    singleton.urls = [];
    singleton.notifierVideoLoaded.value = false;
    if(widget.item.ads![0]!.formatValue == 1){ /// Video
      //initVideo("https://vod-progressive.akamaized.net/exp=1647993343~acl=%2Fvimeo-prod-skyfire-std-us%2F01%2F3935%2F15%2F394675185%2F1676012569.mp4~hmac=e847118604ac340181b2393ef18ecc398b28ba760b171c9190d88c4949f960ed/vimeo-prod-skyfire-std-us/01/3935/15/394675185/1676012569.mp4");
      //initVideo("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4");
      //ponerlo si algo no funciona
      videoPlay();
    }else{/// Image
      singleton.notifierVideoLoaded.value = true;
    }


    WidgetsBinding.instance!.addPostFrameCallback((_){

      /*//Future.delayed( Duration(milliseconds: widget.item.ads![0]!.formatValue == 1 ? 700 : 400), () {
      Future.delayed( Duration(milliseconds: 50), () {

        singleton.GaneOrMira = "mira";
        dialogWinPointsCampaings(context, Strings.seevideo, launchVideo, Strings.reward, widget.item.ads![0]!.lgImages!,widget.item.ads![0]!.adImages!, widget.item.ads![0]!.pointsAds!, widget.item.ads![0]!.formatValue!);

      });*/


      /// Play video when you can't find the 720p
      Future.delayed(const Duration(seconds: 4), () {
        loadIfNotLoad();
      });


    });

  }

  /// Get Vimeo video url
  void videoPlay() async{

    var url = widget.item.ads![0]!.vimeoUrl!;
    //var url = 'https://vimeo.com/265111898';
    url = url.replaceAll("video/", "");
    url = url.replaceAll("player.", "");

    var check = await DirectLink.check(url);
    check!.forEach((element) {
      print(element.quality);
      print(element.link);
      singleton.urls.add(element.link);

      /*if(element.quality == '720p'){
        print("Find 720p");

        setState(() {
          initVideo(element.link);
          Future.delayed(const Duration(seconds: 1), () {
            singleton.notifierVideoLoaded.value = true;
          });
        });

      }*/

      if(element.quality == '240p'){
        print("Find 240p");

        setState(() {
          initVideo(element.link);
          /*Future.delayed(const Duration(seconds: 1), () {
            singleton.notifierVideoLoaded.value = true;
          });*/
        });
      }

    });

  }

  /// Video controller initialization
  void initVideo(String url){

    singleton.controller = VideoPlayerController.network(
        url
    );

    // Initialize the controller and store the Future for later use.
    singleton.initializeVideoPlayerFuture = singleton.controller.initialize();

    // Use the controller to loop the video.
    singleton.controller.setLooping(false);

    singleton.controller.addListener(checkVideo);

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
        setState(() {
          initVideo(singleton.urls![singleton.urls.length-1]);
          Future.delayed(const Duration(seconds: 1), () {
            //singleton.notifierVideoLoaded.value = true;
          });
        });
      }

    }

  }

  ///Check status video
  void checkVideo(){


    // Implement your calls inside these conditions' bodies :
    if(singleton.controller.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    //print("Segundos: "+ _controller.value.position.inSeconds.toString());
    //print("Total: "+ _controller.value.duration.inSeconds.toString());
    singleton.notifierSecondsVideo.value = singleton.controller.value.position.inSeconds;
    print("Video Segundos: "+ singleton.controller.value.duration.toString());
    print("Video actual Segundos: "+ singleton.controller.value.position.inSeconds.toString());

    if(singleton.controller.value.duration.toString() != "0:00:00.000000"){

      Future.delayed(const Duration(seconds: 1), () {

        if(singleton.notifierVideoLoaded.value == false){/// agregado
          launchVideo();
        }///

        singleton.notifierVideoLoaded.value = true;
      });

    }

    if(singleton.controller.value.position == singleton.controller.value.duration) {
      print('video Ended');
      //singleton.controller.removeListener(() { });
      //singleton.controller.removeListener(checkVideo);

      if(singleton.controller.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
        singleton.controller.removeListener(checkVideo);

        if(singleton.urls.length>0){
          Random random = new Random();
          int randomNumber = random.nextInt(singleton.urls.length-1);
          print(randomNumber);

          setState(() {
            //initVideo(singleton.urls[randomNumber]);
            //singleton.notifierSeePlay.value = true;

            if(singleton.controller.value.duration.toString() == "0:00:00.000000"){
              onceVideo = 0;
            }

            if(onceVideo == 0){
              dispoandWait();
              onceVideo = 1;
              initVideo(singleton.urls[randomNumber]);
              //singleton.controller.addListener(checkVideo);
            }

          });
        }
        //loadIfNotLoad();
      }else {

        if(once==0){

          /// agregado
          /*once = once + 1;
          widget.onWonCoin();
          Navigator.pop(context);*/
        }

      }


    }


  }

  /// New
  void dispoandWait() async{ /// Verificar si funciona
    await singleton.controller.dispose();
    await Future<void>.delayed(Duration(milliseconds: 200));
  }

  /// Play video from button popup
  void launchVideo(){
    singleton.controller.play();
  }

  /// Back Phone Button
  Future<bool> callToast() async {

    singleton.controller.pause();
    if(singleton.notifierSecondsVideo.value== 0 || singleton.notifierSecondsVideo.value<int.parse(widget.item.ads![0]!.timeVisible!)){
      dialogNoWinPoints(context, Strings.nopoints, Strings.nopoints1, Strings.out2, Strings.resume,launchVideo,singleton.notifierPointsGaneRoom.value);
      return false;
    }else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {

    return singleton.isOffline?  Nointernet() : OKToast(
        child: WillPopScope(
          onWillPop: callToast,
          //onWillPop: () async => false,

          child: Scaffold(
            backgroundColor: CustomColors.black,
            key: _scaffoldKey,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: widget.item.ads![0]!.formatValue == 1 ? Stack( /// Video Player
                fit:  StackFit.expand ,
                children: [

                  /// Video Player
                  Hero(
                    tag: widget.item.id!,
                    child: ValueListenableBuilder<bool>(
                              valueListenable: singleton.notifierVideoLoaded,
                              builder: (context,value1,_){

                                return value1==true ? Container(

                                  child: FutureBuilder(
                                    future: singleton.initializeVideoPlayerFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        // If the VideoPlayerController has finished initialization, use
                                        // the data it provides to limit the aspect ratio of the video.
                                        return SizedBox.expand(
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: SizedBox(
                                                width: singleton.controller.value.size?.width ?? 0,
                                                height: singleton.controller.value.size?.height ?? 0,
                                                child: AspectRatio(
                                                    aspectRatio: singleton.controller.value.aspectRatio,
                                                    child: VideoPlayer(singleton.controller)
                                                ),
                                              ),
                                            )
                                        );

                                      } else {
                                        // If the VideoPlayerController is still initializing, show a
                                        // loading spinner.
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    },
                                  ),

                                ) : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: CustomColors.gradientPreWinPoints,
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        stops: [
                                          0.5,
                                          1.0
                                        ]
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [

                                      /// Animation
                                      Lottie.asset(
                                        'assets/images/wincoinspre.json',
                                        repeat: true,
                                        fit:BoxFit.cover,
                                      ),

                                      Positioned(
                                          bottom: 60,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 30,right: 30),
                                            child: AutoSizeText(
                                              Strings.messageprewinpoint,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.black, fontSize: 16,),
                                              //maxLines: 1,
                                            ),
                                          )
                                      )

                                    ],

                                  ),

                                );/// agregado;

                              }

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
                                  return (value2== 0 || value2<int.parse(widget.item.ads![0]!.timeVisible!)) ? CircularPercentIndicator(
                                    radius: 45.0,
                                    lineWidth: 4.0,
                                    //percent: ((value2*100)/singleton.controller.value.duration.inSeconds)/100,
                                    percent: ((value2*100)/int.parse(widget.item.ads![0]!.timeVisible!))/100,
                                    center: new Text(
                                      (int.parse(widget.item.ads![0]!.timeVisible!) - value2).toString(),style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 14,),
                                    ),
                                    progressColor: CustomColors.grayalert1,
                                  ) : InkWell(
                                    onTap: (){

                                      if(once==0){
                                        once = once + 1;
                                        widget.onWonCoin();
                                        Navigator.pop(context);
                                      }

                                    },
                                    child: Container(
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



                  /// Home
                  Positioned(
                      top: 30,
                      left: 10,
                      child: InkWell(
                        onTap: (){

                          singleton.controller.pause();
                          /*if(singleton.notifierSecondsVideo.value== 0 || singleton.notifierSecondsVideo.value<int.parse(widget.item.ads![0]!.timeVisible!)){
                            dialogNoWinPoints(context, Strings.nopoints, Strings.nopoints1, Strings.out2, Strings.resume,launchVideo,singleton.notifierPointsGaneRoom.value);
                          }else{
                            if(once==0){
                              once = once + 1;
                              widget.onWonCoin();
                              Navigator.pop(context);
                            }
                          }*/

                          /// agregado
                          dialogNoWinPoints(context, Strings.nopoints, Strings.nopoints1, Strings.out2, Strings.resume,launchVideo,singleton.notifierPointsGaneRoom.value);


                        },
                        child: Container(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                            'assets/images/ic_home.svg',
                            fit: BoxFit.contain,
                            //color: CustomColors.greyplaceholder
                          ),
                        ),
                      )
                  ),

                ],
              ) : Stack ( /// Image

                children: [

                  ///Image
                  Hero(
                    tag: widget.item.id!,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:
                      /*CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.item.ads![0]!.adImages!,
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
                      ),*/
                      CachedNetworkImage(
                        imageUrl: widget.item.ads![0]!.adImages!,
                        placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                        useOldImageOnUrlChange: false,

                      ),
                    ),
                  ),

                  Positioned(
                    top: 35,
                    right: 10,
                    child: InkWell(
                      onTap: (){

                        if(once==0){
                          once = once + 1;
                          widget.onWonCoin();
                          Navigator.pop(context);
                        }

                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(
                          'assets/images/ic_close_mira.svg',
                          fit: BoxFit.contain,
                          //color: CustomColors.greyplaceholder
                        ),
                      ),
                    ),
                  ),

                  /// Home
                  Positioned(
                      top: 30,
                      left: 10,
                      child: InkWell(
                        onTap: (){

                          /// agregado
                          dialogNoWinPoints(context, Strings.nopoints, Strings.nopoints1, Strings.out2, Strings.resume,launchVideo,singleton.notifierPointsGaneRoom.value);

                        },
                        child: Container(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                            'assets/images/ic_home.svg',
                            fit: BoxFit.contain,
                            //color: CustomColors.greyplaceholder
                          ),
                        ),
                      )
                  ),

                ],
              ),

            ),
          ),
        )
    );

  }

  @override
  void dispose() {
    if(widget.item.ads![0]!.formatValue == 1){/// Video
      singleton.controller.removeListener(checkVideo);
      singleton.controller.dispose();
    }

    super.dispose();
  }*/


}
