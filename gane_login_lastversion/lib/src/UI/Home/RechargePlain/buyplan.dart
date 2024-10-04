import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:spring_button/spring_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


class BuyPlan extends StatefulWidget{
  final title;
  final url;
  final lauchPhone;

  BuyPlan({this.title, this.url, this.lauchPhone});

  _BuyPlan createState()=> _BuyPlan();
}

class _BuyPlan extends State<BuyPlan> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  //late WebViewController controller;
  //final Completer<WebViewController> _controller = Completer<WebViewController>();
  late InAppWebViewController controller;

  @override
  void initState(){


    WidgetsBinding.instance!.addPostFrameCallback((_){

      if(widget.lauchPhone != null){
        //utils.launchCaller(widget.lauchPhone);
      }

      /*_webView.stateChanged.listen((state) {
        // state.type: enum (didStatrt and didFinish)
        // state.url
      });

      _webView.didReceiveMessage.listen((message) {
        // message.name
        // message.data (should be a Map/List/String)
        print(message.name);
      });*/

    });

    setState(() {


    });


    super.initState();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      singleton.isOffline = !hasConnection;
    });
  }

  @override
  void dispose() {
    //singleton.indexBeforeSelectedMarker=0;
    ////pr.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    singleton.contextGlobal = context;
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: Scaffold(
                /*key: _scaffoldKey,
              drawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: DrawerMenu()),*/
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

                            _appBar(),

                            _fields(context1),


                          ],
                        ),


                      );

                    },


                  )

              )
          );

        }

    );


  }

  /// Header
  Widget _appBar(){
    return new Container(
      //color: CustomColors.white,
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: CustomColors.white,
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

          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/back.svg',
                  fit: BoxFit.contain,
                  color: CustomColors.black,
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30,right: 40),
              child: Container(
                child: AutoSizeText(
                  widget.title,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,

                  maxLines: 3,
                  style: TextStyle(fontSize: 19.0,fontFamily: Strings.font_bold, color: CustomColors.black,),
                  //maxLines: 1,
                ),
              ),

            ),
          ),

        ],
      ),
    );
  }

  /// Fields List
  Widget _fields(BuildContext context){

    return Container(
      //color: Colors.red,
      margin: EdgeInsets.only(top: 90),


      /*child: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
        onPageFinished: (url) {
          //_controller.evaluateJavascript("console.log('Hello')");
        },
        navigationDelegate: (action) {
          if (action.url ==
              "https://stackoverflow.com/users/login?ssrc=head&returnurl=https%3a%2f%2fstackoverflow.com%2f") {
            return NavigationDecision.prevent;
          } else {
            return NavigationDecision.navigate;
          }
        },
        debuggingEnabled: true,
      ),*/

      child: InAppWebView(
        //initialUrlRequest: URLRequest(url: Uri.parse(Uri.encodeFull(widget.url))),
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),


        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
              userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
              javaScriptEnabled: true, useShouldOverrideUrlLoading: true, javaScriptCanOpenWindowsAutomatically:true
          ),
          android: AndroidInAppWebViewOptions(
              initialScale: 100
          ),
          ios: IOSInAppWebViewOptions(),
        ),


        onWebViewCreated: (controllerrr) {
          controller = controllerrr;
        },



        shouldOverrideUrlLoading: (controller, navigationAction) async {
        },

        onProgressChanged: (controller, progress) {
          print(progress.toString());
        },
        onLoadError: (controller, url, i, s) async {
        },
        onLoadHttpError: (controller, url, i, s) async {

        },

      ),



    );
  }

  NavigationDecision _interceptNavigation(NavigationRequest request) {
    if (request.url == "https://github.com/flutter/flutter/issues") {
      return NavigationDecision.prevent;
    }
    if (request.url.contains("umuieme")) {
      launch(request.url);
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }


  _launchURL(String url) async {
    //url = url.replaceAll("+", "");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*/// Lister js Function
  JavascriptChannel _scriptGameOver(BuildContext context){

    return JavascriptChannel(
        name: "Print",
        onMessageReceived: (JavascriptMessage message){
          print(message.message);
        }
    );

  }

  /// Lister js Function
  JavascriptChannel _scriptWin(BuildContext context){

    return JavascriptChannel(
        name: "Postascript",
        onMessageReceived: (JavascriptMessage message){
          print(message.message);
        }
    );

  }*/



}

