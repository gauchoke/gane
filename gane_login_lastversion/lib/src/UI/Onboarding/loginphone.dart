import 'dart:io';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/countries.dart';
import 'package:gane/src/UI/Onboarding/countrieslist.dart';
import 'package:gane/src/UI/Onboarding/createaccount.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_error.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:transition/transition.dart';


class LoginPhone extends StatefulWidget{

  final from;

  LoginPhone({this.from});

  _stateLoginPhone createState()=> _stateLoginPhone();
}

class _stateLoginPhone extends State<LoginPhone> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  //var _controllerPhone = TextEditingController();
  //final formatter = new NumberFormat("#,###.##", "es_CO");
  bool visibleTotalShopingCart = false;

  var imgCountry = "";
  var name = "";

  bool visibleUpdateApp = false;
  bool visibleOptionalUpdateApp = false;
  //var _controllerPhone = new MaskedTextController(text: '', mask: '000-000-0000');
  //final _controllerPhone = MaskedTextController(mask: '000-000-0000');
  var _controllerPhone = new MaskedTextController(text: '', mask: '000-000-0000');

  final notifierBack = ValueNotifier("in");
  final notifierBlosckTextfield = ValueNotifier(true);
  final _focusNodeQuantity = FocusNode();

  /*late AnimationController controller;
  late AnimationController controllerback;
  late Animation<double> animation;
  late Animation<double> animationWith;
  late Animation<double> animationback;*/

  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> animationWith;
  late Animation<double> animationLogo;

  late AnimationController controllerin;
  late Animation<double> animationIn;

  late AnimationController controllerButtomView;
  //Tween<double> animationButtomView = Tween(begin: 1, end: 1.02);
  late Animation<double> animationButtomView;




  //final notifierVisibleButtoms = ValueNotifier(0); /// 0= No views, 1= View Buttons, 2= View SMS Code, 3= View portability
  //final notifierCorrect = ValueNotifier("0");
  late TextEditingController textEditingController = TextEditingController();
  //late StreamController<ErrorAnimationType> errorController;
  late StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  final notifierErrorView = ValueNotifier(true);
  final notifierAnim = ValueNotifier(0); /// 0 = forward, 1= reverse


  /// setUp Animation In


  ///setUp AnimationIn



  void setUpAnimationIn(){
    controllerin = AnimationController(duration: const Duration(milliseconds: 1450), vsync: this,  );
    /// Free Text Animation
    animationIn = Tween(
        begin: 1.0,
        end: 3.0
    ).animate( CurvedAnimation(
        parent: controllerin,
        curve: Interval(0.0,1.0)
    ),);

    controllerin.forward(from: 0.0);

    controllerin.forward().whenComplete(() {
      Future.delayed(const Duration(milliseconds: 750), () {
        controllerin.reverse();
        controller.forward(from: 0.0);
      });
    });

  }

  ///setUp Animation Out
  void setUpAnimationOut(){

    controller = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this,  );

    /// Free Text Animation
    animation = Tween(
        begin: 2.0,
        end: 1.0
    ).animate( CurvedAnimation(
        parent: controller,
        curve: Interval(0.0,0.5)
    ),);

    /// With Text Animation
    animationWith = CurvedAnimation(
        parent: controller,
        curve: Interval(0.3,0.6)
    );

    //controller.forward(from: 0.0);

    /// Logo  Animation
    animationLogo = CurvedAnimation(
        parent: controller,
        curve: Interval(0.2,0.9)
    );




  }

  ///setup Animation Buttom View
  void setupAnimationButtomView(){
    /*controllerButtomView = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    Future.delayed(const Duration(seconds: 4), () {
      controllerButtomView.forward(from: 0.0);
      controllerButtomView.forward().whenComplete(() {
        controllerButtomView.reverse();
      });
    });*/

    controllerButtomView = AnimationController(
        vsync: this, duration: Duration(milliseconds: 160));

    animationButtomView = Tween(begin: 1.0, end: -2.0).animate(controllerButtomView);

    Future.delayed(const Duration(seconds: 4), () {
      controllerButtomView.forward();
      controllerButtomView.forward().whenComplete(() {
        controllerButtomView.reverse();
      });
    });

  }

  @override
  void initState(){

    notifierBlosckTextfield.value = true;
    //textEditingController = TextEditingController();
    errorController = StreamController<ErrorAnimationType>();

    setUpAnimationIn();
    setUpAnimationOut();
    setupAnimationButtomView();

    singleton.notifierCorrect.value = "0";

    WidgetsBinding.instance!.addPostFrameCallback((_){
      utils.initUserLocation(context);
      Future.delayed(const Duration(milliseconds: 450), () {
        //launchFetch();
        utils.loadCountries();
      });


      /*listenCode();
      Future.delayed(const Duration(milliseconds: 150), () {
        listenCode1();
      });*/


      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: CustomColors.orangeborderpopup

      ));

    });

    super.initState();
  }

  /// Sent code from example
  void listenCode()async {
    //SmsAutoFill().listenForCode();
    /*await SmsAutoFill().getAppSignature.then((value){
      print(value);
    });*/


  }

  /// Listen sms code from url
  void listenCode1()async {
    //SmsAutoFill().listenForCode();
  }

  onValueChange() {
    if (_controllerPhone.selection.start < 0) {
      print(_controllerPhone.text.length);
      _controllerPhone.selection = new TextSelection.fromPosition(
          new TextPosition(offset: _controllerPhone.text.length+1)
      );
    }
  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        // utils.dialogLoading(context);
        //utils.openProgress(context);
        servicemanager.fetchCountriesList(context);
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
    _controllerPhone.dispose();
    //textEditingController.dispose();
    //_focusNodeQuantity.dispose();
    //errorController.close();
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(singleton.isOffline);
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                onWillPop: backHandle.callToast,
                child: Scaffold(
                  key: _scaffoldKey,
                  /*drawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: DrawerMenu()),*/
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

                    _fields(context),
                  ),
                ),
              )
          );

        }

    );
  }

  /// Fields List
  Widget _fields(BuildContext context){

    return Container(
      //width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: 35),
      /*decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(90.0),
        ),
        gradient: LinearGradient(
            colors: CustomColors.gradientSplash,
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomCenter
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),*/

      child: Stack(

        children: <Widget>[

          ///Image
          /*Positioned(
            top: MediaQuery.of(context).size.width/1.3,
            left:  0,
            right: 0,
            child: Container(
                width: 239,
                height: 234,
              //color: Colors.green,
              child: Image(
                image: AssetImage(
                    'assets/images/Componente.png'
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),*/

          /*Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image:
                                AssetImage(
                                    'assets/images/fondo.png'
                                )
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(90.0),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),

            ),
          ),

          ///Gane Logo
          Positioned(
            top: MediaQuery.of(context).size.width/2.4,
            left:  0,
            right: 0,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context,_){

                return Container(
                    child: Opacity(
                        opacity: animationLogo.value,
                        /*child: Image(
                          image: AssetImage("assets/images/ic_gane.png"),
                          width: 191.0,
                          height:100.0,
                        )*/
                      child: SvgPicture.asset(
                        'assets/images/ic_gane.svg',
                        fit: BoxFit.contain,
                      ),
                    )

                );

              },
            ),
          ),

          /// Text Animations
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Column(

              children: [

                /// Your line
                Text(Strings.inyourline,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                  style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 24,),
                ),

                /// Text animation
                AnimatedBuilder(
                  animation: Listenable.merge([controller,controllerin]),
                  builder: (context,_){

                    return Container(
                        child: Column(

                            children: [

                              /// Text animation
                              Transform.scale(
                                scale: animationIn.value,
                                child: Column(

                                  children: [

                                    /// Free Text
                                    Container(
                                      //padding: EdgeInsets.only(top: value1== 0 ? 10*animationIn.value : animation.value),
                                      padding: EdgeInsets.only(top: animationIn.value == 1 ? 10 : 23*animationIn.value  ),
                                      child: Text(Strings.free,
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontFamily: Strings.font_regurarvolks, color: CustomColors.white, fontSize: 30,),
                                      ),
                                    ),

                                    /// With Text
                                    Opacity(
                                      opacity: animationWith.value,
                                      child: Text(Strings.withc,
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 24,),
                                      ),
                                    ),

                                    ///Logo
                                    /*Opacity(
                                                opacity: animationWith.value,
                                                child: Image(
                                                  image: AssetImage("assets/images/ic_gane.png"),
                                                  width: 191.0,
                                                  height:100.0,
                                                )
                                            )*/

                                  ],

                                ),
                              ),

                              ///Animation Logo
                              /*Opacity(
                                  opacity: animationWith.value,
                                  child: Container(
                                    //color: Colors.yellow,
                                    child: Lottie.asset(
                                        'assets/images/logo.json',
                                        height: 250,
                                        repeat: false
                                      //controller: controller,

                                    ),

                                  ),
                              ),*/


                            ],

                          )

                    );

                  },
                ),

                /*Container(
                  //color: Colors.blue,
                  alignment: Alignment.center,
                      /*child: Lottie.asset('assets/images/login.json',animate: true, repeat: false),*/
                      child: Image(
                          width: 250,
                          height: 500,
                          image: AssetImage(
                              'assets/images/login.gif'
                          ),
                          fit: BoxFit.cover,
                        ),


                ),*/



              ],

            ),

          ),*/

          /// Background
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              image: AssetImage("assets/images/fondo.png"),
              fit: BoxFit.cover,
            ),
          ),

          /// Logo and text
          Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                /// Logo
                Center(
                  child: SvgPicture.asset(
                    'assets/images/ic_gane.svg',
                    fit: BoxFit.contain,
                    width: 191.0,
                    height:100.0,
                  ),
                ),

                /// Text
                Padding(
                  padding: const EdgeInsets.only(left: 50,right: 50),
                  child: Text(
                    Strings.ganeis,
                    //utils.appLanguage("ganeis"),
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 40,),
                  ),
                ),

              ],
            ),
          ),

          /// Form
          /*Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: /*ScaleTransition(
              scale: animationButtomView.animate(CurvedAnimation(parent: controllerButtomView, curve: Curves.elasticOut)),
              child: */
              AnimatedBuilder(
                animation: animationButtomView,
                builder: (context, child) {

                  return Transform.translate(
                    offset: Offset(0, animationButtomView.value),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
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

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          /// Gane number
                          Container(
                            padding: EdgeInsets.only(top: 25,left: 40, right: 30),
                            child: Text(Strings.loginlinegane,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.bluelogin, fontSize: 15,),
                            ),
                          ),

                          SizedBox(height: 10,),

                          _fieldPhone(),

                          ValueListenableBuilder<int>(
                              valueListenable: singleton.notifierVisibleButtoms,
                              builder: (context,value,_){

                                return SizedBox(height: value == 0 || value == 1 ? 30 : 5,);

                              }

                          ),

                          /// Buttons
                          ValueListenableBuilder<int>(
                              valueListenable: singleton.notifierVisibleButtoms,
                              builder: (context1,value,_){

                                return
                                  value == 0 ? Container() : /// No View
                                  value == 1 ? viewButtons(context1) : /// View Buttons
                                  value == 2 ? viewSMSCode(context1) : /// View SMS Code
                                  value == 3 ? viewNoRegister(context1) : /// View SMS Code
                                  Container(
                                    height: 30,
                                  );

                                /*return Stack(

                                  children: [

                                    Visibility(
                                      visible: value == 0 ? true : false,
                                      child: Container(),
                                    ),

                                    Visibility(
                                      visible: value == 1? true : false,
                                      child: viewButtons(context1),
                                    ),

                                    Visibility(
                                      visible: value == 2 ? true : false,
                                      child: viewSMSCode(context1),
                                    ),

                                    Visibility(
                                      visible: value == 3 ? true : false,
                                      child: viewNoRegister(context1),
                                    ),

                                    Visibility(
                                      visible: value == 4 ? true : false,
                                      child: Container(height: 30,),
                                    ),

                                  ],

                                );*/

                              }

                          ),



                        ],

                      ),

                    ),
                  );

                }

              ),
            //),
          )*/
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: /*ScaleTransition(
              scale: animationButtomView.animate(CurvedAnimation(parent: controllerButtomView, curve: Curves.elasticOut)),
              child: */
            AnimatedBuilder(
                animation: animationButtomView,
                builder: (context, child) {

                  return Transform.translate(
                    offset: Offset(0, animationButtomView.value),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                        ),
                        color: CustomColors.white,

                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          /// Gane number
                          Container(
                            padding: EdgeInsets.only(top: 25,left: 20, right: 20),
                            child: Text(Strings.youhaveaccount,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                            ),
                          ),

                          SizedBox(height: 15,),

                          _fieldPhone(),

                          /*ValueListenableBuilder<int>(
                              valueListenable: singleton.notifierVisibleButtoms,
                              builder: (context,value,_){

                                return SizedBox(height: value == 0 || value == 1 ? 30 : 5,);

                              }

                          ),*/

                          SizedBox(height: 10,),

                          /// Buttons
                          ValueListenableBuilder<int>(
                              valueListenable: singleton.notifierVisibleButtoms,
                              builder: (context1,value,_){

                                return value == 0 ? viewInitial(context1) : /// Initial view
                                value == 1 ? viewInitial(context1) : /// View Buttons
                                ///  value == 1 ? viewButtons(context1) : /// View Buttons
                                value == 2 ? viewSMSCode(context1) : /// View SMS Code
                                value == 3 ? viewNoRegister(context1) : /// View SMS Code
                                Container(
                                  height: 30,
                                );
                              }
                          ),



                        ],

                      ),

                    ),
                  );

                }

            ),
            //),
          )



        ],

      ),


    );
  }

  /// Initial view from
  Widget viewInitial(BuildContext context){

    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [

        /// Accept Button
        Container(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: ArgonButton(
            height: 45,
            width: 200,
            borderRadius: 10.0,
            color: CustomColors.orangeback,
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: CustomColors.orangeback,
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
                        //color: Colors.red,
                        //margin: EdgeInsets.only(left: 10,right: 40),
                        child: AutoSizeText(
                          Strings.allin,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          //maxLines: 1,
                          style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 14.0,),
                          //maxLines: 1,
                        ),
                      ),
                    ),

                  ],

                ),
              ),
            ),
            loader: SizedBox(
              width: 20,height: 20,
              child: CircularProgressIndicator(
                backgroundColor: CustomColors.white,
                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.orangeborderpopup),
              ),
            ),
            onTap: (startLoading, stopLoading, btnState) {
              if(btnState == ButtonState.Idle){
                //textEditingController = TextEditingController();
                notifierBlosckTextfield.value = false;
                startLoading();
                _validateform(context,stopLoading);
              }
            },
          ),
        ),

        SizedBox(height: 15,),

        Container(height: 2,color: CustomColors.graycountry.withOpacity(0.6),margin: EdgeInsets.only(left: 20,right: 20),),

        /// No have account
        Container(
          padding: EdgeInsets.only(top: 15,left: 20, right: 20),
          child: Text(Strings.donothaveaccount,
            textAlign: TextAlign.left,
            textScaleFactor: 1.0,
            style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
          ),
        ),

        SizedBox(height: 10,),

        /// Create account Button
        Container(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: ArgonButton(
            height: 45,
            width: 200,
            borderRadius: 10.0,
            color: CustomColors.blueonboardgin,
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: CustomColors.blueonboardgin,
                borderRadius: BorderRadius.all(const Radius.circular(10)),
                border: Border.all(
                  width: 1,
                  color: CustomColors.blueonboardgin,
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
                          Strings.creaaccount,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          //maxLines: 1,
                          style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 14.0,),
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
                // notifierBlosckTextfield.value = false;
                //startLoading();
                //_validateform(context,stopLoading);

                singleton.notifierCorrect.value = "";
                //singleton.notifierVisibleButtoms.value = 1;

                singleton.numberPhone = _controllerPhone.text;

                var time = 350;
                if(singleton.isIOS == false){
                  time = utils.ValueDuration();
                }

                Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: CreateAccount(),
                    reverseDuration: Duration(milliseconds: time)
                ));

              }
            },
          ),
        ),

        SizedBox(height: 20,),


      ],

    );

  }

  /// View Buttons
  Container viewButtons(BuildContext context) {
    return Container(
      //color: Colors.yellow,
        margin: EdgeInsets.only(left: 30,right: 30,),
        child: Column(

          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                /// Cancel
                Expanded(
                  child: Container(
                    child: ArgonButton(
                      height: 45,
                      width: 300,
                      borderRadius: 40.0,
                      color: CustomColors.white,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.all(const Radius.circular(10)),
                          border: Border.all(
                            width: 1,
                            color: CustomColors.orangeborderpopup,
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
                                    Strings.activate2,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    //maxLines: 1,
                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.orangeborderpopup, fontSize: 14.0,),
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
                          //textEditingController = TextEditingController();
                          notifierBlosckTextfield.value = true;
                          startLoading();
                          FocusScope.of(context).requestFocus(new FocusNode());
                          singleton.notifierVisibleButtoms.value = 0;
                          //_validateform(context,stopLoading);
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(
                  width: 20,
                ),

                /// Continue
                Expanded(
                  child: Container(
                    child: ArgonButton(
                      height: 45,
                      width: 300,
                      borderRadius: 40.0,
                      color: CustomColors.orangeback,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomColors.orangeback,
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
                                  //color: Colors.red,
                                  //margin: EdgeInsets.only(left: 10,right: 40),
                                  child: AutoSizeText(
                                    Strings.activate3,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    //maxLines: 1,
                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 14.0,),
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
                          //textEditingController = TextEditingController();
                          notifierBlosckTextfield.value = false;
                          startLoading();
                          //FocusScope.of(context).requestFocus(new FocusNode());
                          //notifierVisibleButtoms.value = 2;
                          _validateform(context,stopLoading);
                        }
                      },
                    ),
                  ),
                ),


              ],

            ),

            SizedBox(height: 30,),

          ],

        )
    );
  }

  /// View SMS Code
  Container viewSMSCode(BuildContext context) {
    return Container(
      //color: Colors.green,
      //margin: EdgeInsets.only(left: 10,right: 40),
        child: Column(

          children: [

            ///Accept TyC
            Center(
              child: Container(
                //margin: EdgeInsets.only(bottom: 20),
                margin: EdgeInsets.only(left: 30,right: 30,bottom: 20),

                child: RichText(
                  textScaleFactor: 1.0,
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 15.0,
                      //color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: Strings.tyc,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.blacktyc, fontSize: 9.0,
                      )),
                      new TextSpan(text: Strings.tyc1,
                          style: TextStyle(
                            fontFamily: Strings.font_medium, color: CustomColors.orangeback, fontSize: 9.0,
                            decoration: TextDecoration.underline,
                            decorationColor: CustomColors.orangeback,
                          ),
                          recognizer: new TapGestureRecognizer()..onTap = () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            //Navigator.push(context, Transition(child: TyC(url: "https://bazzaio.com/terminos-y-condiciones/", title: Strings.tyc1,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                            var time = 350;
                            if(singleton.isIOS == false){
                              time = utils.ValueDuration();
                            }

                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: Strings.urlpriva, title: Strings.tyc1,),
                                reverseDuration: Duration(milliseconds: time)
                            ));

                          }
                      ),
                      new TextSpan(text: Strings.tyc2,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.blacktyc, fontSize: 9.0,
                      )),
                      new TextSpan(text: Strings.tyc3,
                          style: TextStyle(
                            fontFamily: Strings.font_medium, color: CustomColors.orangeback, fontSize: 9.0,
                            decoration: TextDecoration.underline,
                            decorationColor: CustomColors.orangeback,
                          ),
                          recognizer: new TapGestureRecognizer()..onTap = () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            //Navigator.push(context, Transition(child: TyC(url: "https://bazzaio.com/terminos-y-condiciones/", title: Strings.tyc3,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                            var time = 350;
                            if(singleton.isIOS == false){
                              time = utils.ValueDuration();
                            }

                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: TyC(url: Strings.urltyc, title: Strings.tyc1,),
                                reverseDuration: Duration(milliseconds: time)
                            ));

                          }
                      ),
                    ],
                  ),
                ),

              ),
            ),

            /// Message
            //utils.error(),

            ///Pin Text
            Container(
              padding: EdgeInsets.only(left: 30,right: 30,),
              child: ValueListenableBuilder<String>(
                  valueListenable: singleton.notifierCorrect,
                  builder: (context,value,_){

                    return PinCodeTextField(
                      autoFocus: true,
                      textStyle: TextStyle(fontFamily: Strings.font_regularFe, color: value=="0" || value=="1" ? CustomColors.black : CustomColors.black, fontSize: 35.0,),
                      length: 4,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        borderWidth: 1,
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeFillColor: value=="0" || value=="1" ? CustomColors.greybackSMS : CustomColors.redlight,//
                        selectedColor: value=="0" || value=="1" ? CustomColors.greyborderSMS : CustomColors.redlight,//oscuro
                        activeColor: value=="0" || value=="1" ? CustomColors.greyborderSMS : CustomColors.redlight,
                        disabledColor: Colors.deepPurple,
                        inactiveColor: value=="0" || value=="1" ? CustomColors.greyborderSMS : CustomColors.redlight,
                        inactiveFillColor: value=="0" || value=="1" ? CustomColors.greybackSMS : CustomColors.redlight,
                        selectedFillColor: value=="0" || value=="1" ? CustomColors.greybackSMS : CustomColors.redlight,//oscuro

                      ),
                      animationDuration: Duration(milliseconds: 100),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      controller: textEditingController,
                      focusNode: _focusNodeQuantity,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onCompleted: (v) {
                        print("Completed");
                        FocusScope.of(context).requestFocus(new FocusNode());
                        print(singleton.codeSMS);
                        /*if(v == singleton.codeSMS.toString()){

                          if(singleton.notifierVerifyPhone.value.code == 102){ /// New User

                            //textEditingController = TextEditingController();
                            singleton.notifierCorrect.value = "";
                            singleton.notifierVisibleButtoms.value = 1;

                            singleton.numberPhone = _controllerPhone.text;
                            //Navigator.push(context, Transition(child: CreateAccount(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                            var time = 350;
                            if(singleton.isIOS == false){
                              time = utils.ValueDuration();
                            }

                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: CreateAccount(),
                                reverseDuration: Duration(milliseconds: time)
                            ));


                          }else{ /// Home
                            singleton.notifierCorrect.value = "0";

                            //prefs.authToken = singleton.notifierVerifyPhone.value.data!.authToken!;
                            print(prefs.authToken);

                            Future.delayed(const Duration(milliseconds: 250), () {
                              Navigator.pushReplacement(context, Transition(child: PrincipalContainer()) );
                            });

                          }


                        }else{
                          singleton.notifierError.value = [false, "","RED"];
                          singleton.notifierCorrect.value = "2";
                          utils.openSnackBarInfo(context, Strings.errorcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
                        }*/
                      },
                      onChanged: (value) {
                        print(value);

                      },
                      onSubmitted: (v){
                        print("");
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      }, appContext: context,
                    );

                  }
              ),

            ),


            ///Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                /// Cancel
                Expanded(
                  child: Container(
                    child: ArgonButton(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 40.0,
                      color: CustomColors.white,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.all(const Radius.circular(10)),
                          border: Border.all(
                            width: 1,
                            color: CustomColors.orangeborderpopup,
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
                                  child: AutoSizeText(
                                    Strings.activate2,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    //maxLines: 1,
                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.orangeborderpopup, fontSize: 14.0,),
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
                          singleton.notifierCorrect.value = "";
                          startLoading();
                          stopLoading();
                          singleton.notifierVisibleButtoms.value = 0;


                          Navigator.pushReplacement(
                              context, MaterialPageRoute(
                              builder: (context) => LoginPhone()));

                          //_validateform(context,stopLoading);
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

                /// Continue
                Expanded(
                  child: Container(
                    child: ArgonButton(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 40.0,
                      color: CustomColors.orangeback,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomColors.orangeback,
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
                                  //color: Colors.red,
                                  //margin: EdgeInsets.only(left: 10,right: 40),
                                  child: AutoSizeText(
                                    Strings.activate3,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    //maxLines: 1,
                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 14.0,),
                                    //maxLines: 1,
                                  ),
                                ),
                              ),

                            ],

                          ),
                        ),
                      ),
                      loader: SizedBox(
                        width: 20,height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: CustomColors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(CustomColors.orangeborderpopup),
                        ),
                      ),
                      onTap: (startLoading, stopLoading, btnState) {
                        if(btnState == ButtonState.Idle){

                          singleton.numberPhone = _controllerPhone.text;
                          launchFetchValidateSMS(stopLoading);
                          /*Future.delayed(const Duration(seconds: 6), () {
                            stopLoading();
                          });*/

                        }
                      },
                    ),
                  ),
                ),


              ],

            ),

            const SizedBox(height: 30,),

            ///Re sent sms
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10,bottom: 15,),

                child: ValueListenableBuilder<String>(
                    valueListenable: singleton.notifierTimerText,
                    builder: (context, value1,_){

                      return RichText(
                        textScaleFactor: 1.0,
                        text: new TextSpan(
                          // Note: Styles for TextSpans must be explicitly defined.
                          // Child text spans will inherit styles from parent
                          style: new TextStyle(
                            fontSize: 15.0,
                            //color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(text: Strings.rnorecivesms +  " " + value1,
                                style: TextStyle(
                                  fontFamily: Strings.font_regularFe, color: value1 == "" ? CustomColors.orangeborderpopup : CustomColors.grayTextemptyhome, fontSize: 13.0,
                                  decoration: TextDecoration.underline,
                                  decorationColor: value1 == "" ? CustomColors.orangeborderpopup : CustomColors.grayTextemptyhome,
                                ),
                                recognizer: new TapGestureRecognizer()..onTap = () {
                                  //FocusScope.of(context).requestFocus(new FocusNode());

                                  if(value1== ""){

                                    textEditingController.text = "";
                                    _resendvalidateform(context);
                                    utils.timerReSentSMS();

                                  }

                                }
                            ),
                          ],
                        ),
                      );

                    }

                ),

              ),
            ),

            //SizedBox(height: 10,),

          ],

        )
    );
  }

  void launchFetchValidateSMS(Function stop)async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        var tel = _controllerPhone.text;
        tel = tel.replaceAll("-", "");
        utils.openProgress(context);
        servicemanager.fetchValidateNumber(context, tel, textEditingController.text, stop, (){});
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// View NoRegister
  Container viewNoRegister(BuildContext context) {
    return Container(
      //color: Colors.yellow,
        margin: EdgeInsets.only(left: 40,right: 40,),
        child: Column(

          children: [

            ///Text No register
            Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 20),

                child: RichText(
                  textScaleFactor: 1.0,
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 15.0,
                      //color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: Strings.numberregister,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.greyplaceholder, fontSize: 10.0,
                      )),
                      new TextSpan(text: Strings.numberregister1,style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.greyplaceholder, fontSize: 10.0,
                      )),
                      new TextSpan(text: Strings.numberregister2,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.greyplaceholder, fontSize: 10.0,
                      )),
                      new TextSpan(text: Strings.numberregister3,
                          style: TextStyle(
                            fontFamily: Strings.font_bold, color: CustomColors.blueText, fontSize: 10.0,
                            decoration: TextDecoration.underline,
                            decorationColor: CustomColors.blueText,
                          ),
                          recognizer: new TapGestureRecognizer()..onTap = () {
                            //FocusScope.of(context).requestFocus(new FocusNode());

                          }
                      ),
                    ],
                  ),
                ),

              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                /// Cancel
                Expanded(
                  child: Container(
                    child: ArgonButton(
                      height: 45,
                      width: 300,
                      borderRadius: 40.0,
                      color: CustomColors.white,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.all(const Radius.circular(40)),
                          border: Border.all(
                            width: 1,
                            color: CustomColors.greyborderbutton,
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
                                    Strings.activate2,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    //maxLines: 1,
                                    style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.greyborderbutton, fontSize: 14.0,),
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
                          stopLoading();
                          //FocusScope.of(context).requestFocus(new FocusNode());
                          singleton.notifierVisibleButtoms.value = 1;
                          //_validateform(context,stopLoading);
                        }
                      },
                    ),
                  ),
                ),

              ],

            ),

            SizedBox(height: 30,),

          ],

        )
    );
  }

  ///Create telf field
  Widget _fieldPhone() {
    return Container(
        decoration: BoxDecoration(
            color: CustomColors.graycountry.withOpacity(0.6),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(

          children: [

            Row(
              children: <Widget>[

                SizedBox(
                  width: 15,
                ),

                SvgPicture.asset(
                    'assets/images/telf.svg',
                    fit: BoxFit.contain
                ),


                ///Calling Code
                ValueListenableBuilder<String>(
                    valueListenable: singleton.notifierCallingCode,
                    builder: (context,value1,_){

                      return InkWell(
                        onTap: (){
                          //Navigator.push(context, Transition(child: CountriesList(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                          singleton.notifierCorrect.value = "";
                          singleton.notifierVisibleButtoms.value = 0;


                          var time = 350;
                          if(singleton.isIOS == false){
                            time = utils.ValueDuration();
                          }

                          singleton.notifierCountriesList.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );
                          singleton.notifierCountriesListSearch.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );

                          utils.loadCountries();

                          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: CountriesList(),
                              reverseDuration: Duration(milliseconds: time)
                          ));


                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4,bottom: 4,left: 10,right: 10),
                              child: Text(value1, textAlign: TextAlign.center,textScaleFactor: 1.0,
                                style: TextStyle(
                                  color: CustomColors.black,
                                  fontSize: 15.0,fontFamily: Strings.font_regularFe,

                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                    }

                ),

                ///Line
                Container(
                  width: 10,
                ),

                ///TextField
                Expanded(
                    child: Container(
                      //color: Colors.red,
                        margin: EdgeInsets.only(left: 5,right: 10),
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: <Widget>[


                            Container(
                                child: ValueListenableBuilder<bool>(
                                    valueListenable: notifierBlosckTextfield,
                                    builder: (context,value1,_){

                                      return TextField(
                                        //autofocus: true,
                                        maxLength: 13,
                                        //enableSuggestions: false,
                                        controller: _controllerPhone,
                                        //focusNode: _focusNodeQuantity,
                                        keyboardType: TextInputType.phone,
                                        //enabled: value1,
                                        style: TextStyle(
                                            fontFamily: Strings.font_regularFe,
                                            fontSize: 17,
                                            color: CustomColors.black),
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none,
                                            filled: true,
                                            contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                            fillColor: Colors.transparent,
                                            hintText: Strings.loginlinegane,
                                            hintStyle: TextStyle(
                                                fontFamily: Strings.font_regularFe,
                                                fontSize: 17,
                                                color: CustomColors.grayplaceholder)

                                        ),
                                        maxLines: 1,
                                        onChanged: (value){
                                          //singleton.notifierVisibleButtoms.value = 1;
                                          _controllerPhone.updateMask('000-000-0000',moveCursorToEnd: true);
                                        },
                                        onTap: (){
                                          //singleton.notifierVisibleButtoms.value = 1;
                                        },

                                        //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      );

                                    }

                                )
                            ),


                          ],
                        )
                    )
                ),

              ],
            ),


          ],

        )
    );
  }


  ///Validate form
  _validateform(BuildContext context,Function function)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    var number = _controllerPhone.text;
    number = number.replaceAll("-", " ");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        if(singleton.isOffline){
          setState(() {
            singleton.isOffline = singleton.isOffline;
          });

        }else{

          if (_controllerPhone.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errornotelf, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          } else if (number.length < 10) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errornotelf1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else{

            Future.delayed(const Duration(milliseconds: 50), () {

              var tel = _controllerPhone.text;
              tel = tel.replaceAll("-", "");
              //tel = singleton.notifierCallingCode.value+tel;
              singleton.numberPhone = _controllerPhone.text;

              servicemanager.fetchVerifyNumber(context, tel, function).then((value) {
                print(value);
                if(singleton.notifierVerifyPhone.value.code == 102){
                  var time = 350;
                  if(singleton.isIOS == false){
                    time = utils.ValueDuration();
                  }

                  /*Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: CreateAccount(),
                      reverseDuration: Duration(milliseconds: time)
                  ));*/
                }
              });
            });


          }


        }
      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      ConnectionStatusSingleton.getInstance().checkConnection();
    }



  }

  ///Validate form
  _resendvalidateform(BuildContext context)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    var number = _controllerPhone.text;
    number = number.replaceAll("-", " ");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        if(singleton.isOffline){
          setState(() {
            singleton.isOffline = singleton.isOffline;
          });

        }else{

          if (_controllerPhone.text.trim().isEmpty) {
            utils.openSnackBarInfo(context, Strings.errornotelf, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          } else if (number.length < 10) {
            utils.openSnackBarInfo(context, Strings.errornotelf1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else{

            Future.delayed(const Duration(milliseconds: 50), () {
              //utils.dialogLoading(context);
              //utils.openProgress(context);
              var tel = _controllerPhone.text;
              tel = tel.replaceAll("-", "");
              //tel = singleton.notifierCallingCode.value+tel;
              servicemanager.fetchReSendVerifyNumber(context, tel);
            });


          }


        }
      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      ConnectionStatusSingleton.getInstance().checkConnection();
    }



  }

}