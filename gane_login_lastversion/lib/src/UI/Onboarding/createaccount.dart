import 'dart:io';

import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:email_validator/email_validator.dart';
//import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/countries.dart';
import 'package:gane/src/UI/Onboarding/countrieslist.dart';
import 'package:gane/src/UI/Onboarding/loginphone.dart';
import 'package:gane/src/UI/Onboarding/onboarding_provider.dart';
import 'package:gane/src/UI/Onboarding/tyc.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_message.dart';
import 'package:gane/src/Widgets/dialog_savenumber.dart';
import 'package:gane/src/Widgets/dialog_sim.dart';
import 'package:gane/src/Widgets/dialog_tooltip.dart';
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
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';


class CreateAccount extends StatefulWidget{

  final from;

  CreateAccount({this.from});

  _stateCreateAccount createState()=> _stateCreateAccount();
}

class _stateCreateAccount extends State<CreateAccount> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  var imgCountry = "";
  var name = "";

  bool visibleUpdateApp = false;
  bool visibleOptionalUpdateApp = false;
  //var _controllerPhone = new MaskedTextController(text: '', mask: '000-000-0000');
  //final _controllerPhone = MaskedTextController(mask: '000-000-0000');
  var _controllerName = TextEditingController();
  var _controllerEmail = TextEditingController();
  var _controllerReferral = TextEditingController();
  var _controllerScanBarCode = TextEditingController();
  //final _focusNodeQuantity = FocusNode();

  //late AnimationController controller;
  //late Animation<double> animation;


  late final notifierVisibleButtoms = ValueNotifier(0); /// 0= No views, 1= View Buttons, 2= View SMS Code, 3= View portability
  late final notifierCorrect = ValueNotifier("0");
  late TextEditingController textEditingController;
  //late StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  final notifierErrorView = ValueNotifier(true);
  //late final notifierValueYButtons = ValueNotifier(0.0);

  final notifierTopScroll = ValueNotifier(150.0);

  final notifierHavechip = ValueNotifier(0);

  late OnboardingProvider onboardingProvider;
  var _controllerPhone = new MaskedTextController(text: '', mask: '000-000-0000');
  var _controllerPhone1 = new MaskedTextController(text: '', mask: '000-000-0000');
  var _controllerNIP = TextEditingController();
  final notifierBlosckTextfield = ValueNotifier(true);

  double yCode = 0;
  var BarCOde = "";
  var BarCOdenumbergane = "";
  FocusNode _focusNode = FocusNode();


  @override
  void initState(){
    notifierCorrect.value = "0";
    BarCOdenumbergane = "";
    BarCOde = "";
    textEditingController = TextEditingController();


    /*errorController = StreamController<ErrorAnimationType>();



    controller = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this,  );
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn,);

    /// Free Text Animation
    animation = CurvedAnimation(
        parent: controller,
        curve: Interval(0.0,1.0)
    );

    /// With Text Animation

    controller.forward(from: 0.0);*/

    WidgetsBinding.instance!.addPostFrameCallback((_){


      //notifierValueYButtons.value = MediaQuery.of(context).size.height ;

      notifierTopScroll.value = MediaQuery.of(context).size.height / 2 + 60;
      Future.delayed(const Duration(milliseconds: 450), () {

        if(singleton.isOffline == false){
        }
        launchFetch();

      });
      _controllerPhone.text = singleton.numberPhone;
      onboardingProvider.haveChip = -1;
      onboardingProvider.keepNumber = -1;

      print(WidgetsBinding.instance.window.viewInsets.bottom);

      //_focusName.addListener(_onFocusChange);
      //_focusRefrer.addListener(_onFocusChange);




    });

    super.initState();
  }

  void _onFocusChange() {
    //debugPrint("Focus: ${_focus.hasFocus.toString()}");

    onboardingProvider.focusReferarOrName = 1;
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
        //servicemanager.fetchCountriesList(context);
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
    /*_controllerPhone.dispose();
    textEditingController.dispose();
    _focusNodeQuantity.dispose();
    errorController.close();
    controller.dispose();*/
    _controllerPhone.dispose();
    textEditingController.dispose();

    /*_focusName.removeListener(_onFocusChange);
    _focusName.dispose();

    _focusRefrer.removeListener(_onFocusChange);
    _focusRefrer.dispose();*/

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    onboardingProvider = Provider.of<OnboardingProvider>(context);
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                onWillPop: backHandle.callToast,
                //onWillPop: _willPopCallback,
                child: Scaffold(
                  key: _scaffoldKey,

                  body: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle.dark,
                     /*Container(
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

                    /*child:Stack(
                      children: [

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



                       /* /// Logo and text
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
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
                                child: Text(Strings.ganeis,
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 40,),
                                ),
                              ),

                            ],
                          ),
                        ),*/

                       Container(
                           padding: const EdgeInsets.only(top: 90),
                           height: MediaQuery.of(context).size.height,
                           child: _fields(context)
                       ),

                        /// Back Icon
                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                builder: (context) => LoginPhone()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10,top: 40),
                            child: SvgPicture.asset(
                              'assets/images/back.svg',
                              fit: BoxFit.contain,
                              //color: CustomColors.greyplaceholder,
                            ),
                          ),
                        ),

                        /// Form validade email
                        /*Positioned(

                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ValueListenableBuilder<double>(
                                  valueListenable: singleton.notifierValueYButtons,
                                  builder: (contexts,value,_){

                                    return  Visibility(
                                      //visible: value == 0.0 ? false : true,
                                      visible: false,
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

                                          child: viewSMSCode(singleton.navigatorKey.currentContext!)

                                      ),
                                    );

                                  }

                              )
                          )*/

                      ],
                    ),*/

                      child:_fields(context)


                  ),
                ),
              )
          );

        }

    );



  }

  /// Fields List
  Widget _fields(BuildContext context){
    double height = MediaQuery.of(context).size.height;

    return Container(
      //margin: EdgeInsets.only(top: 35),
      child: Stack(

        children: [

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

          /// Logo and title
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Text(Strings.ganeis,
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 40,),
                  ),
                ),

                SizedBox(height: 30,),

              ],
            ),
          ),

          ///Scroll white form
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Container(
                    height: (
                        onboardingProvider.haveChip == -1 && WidgetsBinding.instance.window.viewInsets.bottom == 0.0) ? MediaQuery.of(context).size.height/1.75  /// No selected have chip
                        : (onboardingProvider.haveChip == 1 && WidgetsBinding.instance.window.viewInsets.bottom == 0.0 && onboardingProvider.keepNumber == -1) ? MediaQuery.of(context).size.height/2.7  /// Yes have chip, No selected keep number, and keyboard close
                        : (onboardingProvider.haveChip == 2 && WidgetsBinding.instance.window.viewInsets.bottom == 0.0 && onboardingProvider.keepNumber == -1) ? MediaQuery.of(context).size.height/3.0 /// No have chip, No selected keep number, and keyboard close
                     : (onboardingProvider.keepNumber == -1 && WidgetsBinding.instance.window.viewInsets.bottom == 0.0) ? MediaQuery.of(context).size.height/3.0 ///  No selected keep number, and keyboard close
                        : (onboardingProvider.keepNumber == 2 && WidgetsBinding.instance.window.viewInsets.bottom == 0.0) ? MediaQuery.of(context).size.height/5.7 /// No  keep number, and keyboard close
                        : (onboardingProvider.focusReferarOrName == 1  && onboardingProvider.haveChip == -1  && onboardingProvider.keepNumber == -1) ? MediaQuery.of(context).size.height/3.5
                        : 80, /// Keyboarcd open
                    //color: Colors.blue
                ),

                /// white form
                Expanded(
                    child: SingleChildScrollView(
                        child:/// White Form
                        Container(
                          alignment: Alignment.bottomCenter,
                          //width: MediaQuery.of(context).size.width,
                          //height: MediaQuery.of(context).size.height - value1,
                          margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0),
                              bottomLeft: Radius.circular(16.0),
                            ),
                            color: CustomColors.white,

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            //mainAxisSize: MainAxisSize.min,

                            children: [

                              /// Name
                              Container(
                                padding: EdgeInsets.only(top: 25,left: 30, right: 30),
                                child: Text(Strings.namelastnameinsert,
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                ),
                              ),
                              SizedBox(height: 15,),
                              _fieldName(),
                              SizedBox(height: 10,),

                              /// Refer number
                              Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Text(Strings.referral,
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                ),
                              ),
                              SizedBox(height: 15,),
                              _fieldReferral(),
                              SizedBox(height: 10,),


                              /// Have Chip gane
                              Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Text(Strings.haveganechip,
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Container(
                                padding: EdgeInsets.only(left: 30,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    /// Yes
                                    InkWell(
                                      onTap: (){
                                        onboardingProvider.haveChip = 1;
                                        onboardingProvider.keepNumber = -1;
                                        clearForm();
                                      },
                                      child: Row(

                                        children: [

                                          ClipOval(
                                            child: Container(
                                              color: onboardingProvider.haveChip == 1 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(Strings.correct,
                                            textAlign: TextAlign.left,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                          ),

                                        ],

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                    /// No
                                    InkWell(
                                      onTap: (){
                                        onboardingProvider.haveChip = 2;
                                        onboardingProvider.keepNumber = -1;
                                        clearForm();
                                      },
                                      child: Row(

                                        children: [

                                          ClipOval(
                                            child: Container(
                                              color: onboardingProvider.haveChip == 2 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(Strings.incorrect,
                                            textAlign: TextAlign.left,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                          ),

                                        ],

                                      ),
                                    ),

                                    Expanded(child: Container())

                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),


                              /// scan or telf  onboardingProvider.keepNumber == 1 ||
                              /*onboardingProvider.keepNumber == -1 ? Container() : Container(
                                padding: EdgeInsets.only(left: 30, right: 30),

                                child: RichText(
                                  textScaleFactor: 1.0,
                                  text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 17.0,
                                    ),
                                    children: [

                                      TextSpan(text: Strings.telfscan + "   ",style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,)),

                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTapDown: (TapDownDetails details) => _onTapDown1(details),
                                          child: SvgPicture.asset(
                                            'assets/images/info.svg',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                              ), //keep telf = NO
                              onboardingProvider.keepNumber == -1 ? Container() :SizedBox(height: 15,),
                              onboardingProvider.keepNumber == -1 ? Container() :_fieldScanOrTelf(),
                              onboardingProvider.keepNumber == -1 ? Container() :SizedBox(height: 20,),*/
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: RichText(
                                  textScaleFactor: 1.0,
                                  text: new TextSpan(
                                    style: new TextStyle(
                                      fontSize: 17.0,
                                    ),
                                    children: [

                                      TextSpan(text: Strings.telfscan + "   ",style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,)),

                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTapDown: (TapDownDetails details) => _onTapDown1(details),
                                          child: SvgPicture.asset(
                                            'assets/images/info.svg',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),


                              ), //keep telf = NO
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() :SizedBox(height: 15,),
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() :_fieldScanOrTelf(),
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() :SizedBox(height: 20,),

                              /// Keep your number
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Text(Strings.keepnumber,
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                ),
                              ), //have chip = SI
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 15,),
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : Container(
                                padding: EdgeInsets.only(left: 30,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    /// Yes
                                    InkWell(
                                      onTap: (){
                                        onboardingProvider.keepNumber = 1;
                                        clearForm();
                                      },
                                      child: Row(

                                        children: [

                                          ClipOval(
                                            child: Container(
                                              color: onboardingProvider.keepNumber == 1 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(Strings.correct,
                                            textAlign: TextAlign.left,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                          ),

                                        ],

                                      ),
                                    ),

                                    SizedBox(width: 20,),

                                    /// No
                                    InkWell(
                                      onTap: (){
                                        onboardingProvider.keepNumber = 2;
                                        clearForm();
                                      },
                                      child: Row(

                                        children: [

                                          ClipOval(
                                            child: Container(
                                              color: onboardingProvider.keepNumber == 2 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Text(Strings.incorrect,
                                            textAlign: TextAlign.left,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                          ),

                                        ],

                                      ),
                                    ),

                                    Expanded(child: Container())

                                  ],
                                ),
                              ),
                              onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 20,),


                              /// Number textfield
                              onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Text(Strings.yournumber,
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                ),
                              ), //have chip = NO
                              onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 15,),
                              onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : _fieldPhone(),
                              onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 20,),

                              /// Number conserv
                              onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : Container(
                                padding: EdgeInsets.only(left: 30, right: 30),
                                child: Text(Strings.keepnumber1,
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                ),
                              ),
                              onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : SizedBox(height: 15,),
                              onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : _fieldPhone1(),
                              onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : SizedBox(height: 20,),

                              /// Number NIP
                              onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : Container(
                                  padding: EdgeInsets.only(left: 30, right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Expanded(
                                        child: Text(Strings.keepnumber2,
                                          textAlign: TextAlign.left,
                                          textScaleFactor: 1.0,
                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                        ),
                                      ),

                                      GestureDetector(

                                        onTapDown: (TapDownDetails details) => _onTapDown(details),
                                        child: SvgPicture.asset(
                                          'assets/images/info.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),

                                      SizedBox(width: 17,),

                                      Expanded(child: _fieldNIP()),

                                    ],
                                  )
                              ),
                              onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : SizedBox(height: 20,),

                              /// continue Button
                              onboardingProvider.haveChip == -1 ? Container() : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 80),
                                child: ArgonButton(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  borderRadius: 10.0,
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
                                  loader: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      //padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        backgroundColor: CustomColors.white,
                                        valueColor: AlwaysStoppedAnimation<Color>(CustomColors.orangeborderpopup),
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
                              onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 20,),


                            ],

                          ),
                          //),


                        ),
                     )
                ),

              ]
          ),

          /// Back Icon
          InkWell(
            onTap: (){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(
                  builder: (context) => LoginPhone()));
            },
            child: Container(
              margin: EdgeInsets.only(left: 10,top: 40),
              child: SvgPicture.asset(
                'assets/images/back.svg',
                fit: BoxFit.contain,
                //color: CustomColors.greyplaceholder,
              ),
            ),
          ),

        ],


      ),
    );
  }

  /// Fields List
  Widget _fields1(BuildContext context){

    return ValueListenableBuilder<double>(
        valueListenable: notifierTopScroll,
        builder: (context,value1,_){

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.blue,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                            child: Text(Strings.ganeis,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 40,),
                            ),
                          ),

                          SizedBox(height: 30,),

                     ],
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  /// White Form
                  Container(
                    alignment: Alignment.bottomCenter,
                      //width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height - value1,
                      margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                        ),
                        color: CustomColors.white,

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,

                        children: [

                          /// Name
                          Container(
                            padding: EdgeInsets.only(top: 25,left: 30, right: 30),
                            child: Text(Strings.namelastnameinsert,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                            ),
                          ),
                          SizedBox(height: 15,),
                          _fieldName(),
                          SizedBox(height: 10,),

                          /// Refer number
                          Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(Strings.referral,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                            ),
                          ),
                          SizedBox(height: 15,),
                          _fieldReferral(),
                          SizedBox(height: 10,),


                          /// Have Chip gane
                          Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(Strings.haveganechip,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            padding: EdgeInsets.only(left: 30,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                /// Yes
                                InkWell(
                                  onTap: (){
                                    onboardingProvider.haveChip = 1;
                                    onboardingProvider.keepNumber = -1;
                                    clearForm();
                                  },
                                  child: Row(

                                    children: [

                                      ClipOval(
                                        child: Container(
                                          color: onboardingProvider.haveChip == 1 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(Strings.correct,
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                      ),

                                    ],

                                  ),
                                ),

                                SizedBox(width: 20,),

                                /// No
                                InkWell(
                                  onTap: (){
                                    onboardingProvider.haveChip = 2;
                                    onboardingProvider.keepNumber = -1;
                                    clearForm();
                                  },
                                  child: Row(

                                    children: [

                                      ClipOval(
                                        child: Container(
                                          color: onboardingProvider.haveChip == 2 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(Strings.incorrect,
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                      ),

                                    ],

                                  ),
                                ),

                                Expanded(child: Container())

                              ],
                            ),
                          ),
                          SizedBox(height: 20,),


                          /// Keep your number
                          onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(Strings.keepnumber,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                            ),
                          ), //have chip = SI
                          onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 15,),
                          onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : Container(
                            padding: EdgeInsets.only(left: 30,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                /// Yes
                                InkWell(
                                  onTap: (){
                                    onboardingProvider.keepNumber = 1;
                                    clearForm();
                                  },
                                  child: Row(

                                    children: [

                                      ClipOval(
                                        child: Container(
                                          color: onboardingProvider.keepNumber == 1 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(Strings.correct,
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                      ),

                                    ],

                                  ),
                                ),

                                SizedBox(width: 20,),

                                /// No
                                InkWell(
                                  onTap: (){
                                    onboardingProvider.keepNumber = 2;
                                    clearForm();
                                  },
                                  child: Row(

                                    children: [

                                      ClipOval(
                                        child: Container(
                                          color: onboardingProvider.keepNumber == 2 ? CustomColors.orangeborderpopup : CustomColors.graycountry.withOpacity(0.6),
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(Strings.incorrect,
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 17,),
                                      ),

                                    ],

                                  ),
                                ),

                                Expanded(child: Container())

                              ],
                            ),
                          ),
                          onboardingProvider.haveChip == 2 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 20,),


                          /// Number textfield
                          onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(Strings.yournumber,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                            ),
                          ), //have chip = NO
                          onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 15,),
                          onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : _fieldPhone(),
                          onboardingProvider.haveChip == 1 || onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 20,),

                          /// Number conserv
                          onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text(Strings.keepnumber1,
                              textAlign: TextAlign.left,
                              textScaleFactor: 1.0,
                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                            ),
                          ),
                          onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : SizedBox(height: 15,),
                          onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : _fieldPhone1(),
                          onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : SizedBox(height: 20,),




                          /// Number NIP
                          onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : Container(
                              padding: EdgeInsets.only(left: 30, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Expanded(
                                    child: Text(Strings.keepnumber2,
                                      textAlign: TextAlign.left,
                                      textScaleFactor: 1.0,
                                      style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                                    ),
                                  ),

                                  GestureDetector(

                                    onTapDown: (TapDownDetails details) => _onTapDown(details),
                                    child: SvgPicture.asset(
                                      'assets/images/info.svg',
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  SizedBox(width: 17,),

                                  Expanded(child: _fieldNIP()),

                                ],
                              )
                          ),
                          onboardingProvider.keepNumber == 2 || onboardingProvider.keepNumber == -1 ? Container() : SizedBox(height: 20,),


                          /// scan or telf  onboardingProvider.keepNumber == 1 ||
                          onboardingProvider.keepNumber == -1 ? Container() : Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            /*child: Text(Strings.telfscan,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1.0,
                                style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,),
                              ),*/
                            child: RichText(
                              textScaleFactor: 1.0,
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontSize: 17.0,
                                ),
                                children: [

                                  TextSpan(text: Strings.telfscan + "   ",style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 17,)),

                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTapDown: (TapDownDetails details) => _onTapDown1(details),
                                      child: SvgPicture.asset(
                                        'assets/images/info.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),


                          ), //keep telf = NO
                          onboardingProvider.keepNumber == -1 ? Container() :SizedBox(height: 15,),
                          onboardingProvider.keepNumber == -1 ? Container() :_fieldScanOrTelf(),
                          onboardingProvider.keepNumber == -1 ? Container() :SizedBox(height: 20,),

                          /// continue Button
                          onboardingProvider.haveChip == -1 ? Container() : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 80),
                            child: ArgonButton(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              borderRadius: 10.0,
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
                          onboardingProvider.haveChip == -1 ? Container() : SizedBox(height: 20,),


                        ],

                      ),
                      //),


                    ),

                ],
              ),
            ),
          );

        }

    );
  }

  void clearForm(){

    BarCOdenumbergane="";
    _controllerPhone.text = "";
    _controllerPhone1.text = "";
    _controllerNIP.text = "";
    _controllerScanBarCode.text = "";
  }

  /// Obtain offset NIP
  _onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    yCode = y;
    // or user the local position method to get the offset
    //print(details.localPosition);
    //print("tap down " + x.toString() + ", " + y.toString());

    dialogTootip(context, x, y);

  }

  /// Obtain offset number gane
  _onTapDown1(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    yCode = y;
    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());

    dialogSIM(context, x, y);
    //dialogMessage(context, "Ups, no parece correcto, porfavor ingresalo de nuevo", y);
    //dialogSaveNumber(context, "1234567897", y);

  }

  /// Obtain offset BarCode
  _onTapDownBarCode(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    yCode = y;

    // or user the local position method to get the offset
    print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());

    //dialogMessage(context, "Ups, no parece correcto, porfavor ingresalo de nuevo", y);
    //dialogSaveNumber(context, "1234567897", y);
    scanQR();
  }

  ///Scan QR Code
  Future<void> scanQR() async {

    BarCOde = "";
    BarCOdenumbergane = "";
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);

      if(barcodeScanRes != "-1"){
        BarCOde = barcodeScanRes;

        launchFetchBarcode();
      }

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;


  }


  /// Fetch barcode number
  void launchFetchBarcode()async{
    try {
      _controllerScanBarCode.text = "";

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        utils.openProgress(context);
        servicemanager.fetchValidateBarCode(context, BarCOde).then((value){
          if(value.code==100){
            BarCOdenumbergane = value.data!.sim!.mSISDN!;
            _controllerScanBarCode.text = value.data!.sim!.iCC!;
            dialogSaveNumber(context, value.data!.sim!.mSISDN!, yCode);
            FlutterClipboard.copy(value.data!.sim!.mSISDN!).then(( value ) => print('copied'));

          }else{
            //utils.openSnackBarInfo(context, value.message!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
            dialogMessage(context, value.message!, yCode);
          }

        });
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

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

                          var time = 350;
                          if(singleton.isIOS == false){
                            time = utils.ValueDuration();
                          }

                          singleton.notifierCountriesList.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );
                          singleton.notifierCountriesListSearch.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );

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
                                            color: CustomColors.graytext),
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
                                          //notifierVisibleButtoms.value = 1;
                                          cahngeheight("edit");
                                          onboardingProvider.focusReferarOrName = 0;
                                        },
                                        onSubmitted: (Value){
                                          cahngeheight("done");
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

  ///Create telf field conserv
  Widget _fieldPhone1() {
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

                /*SizedBox(
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

                          var time = 350;
                          if(singleton.isIOS == false){
                            time = utils.ValueDuration();
                          }

                          singleton.notifierCountriesList.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );
                          singleton.notifierCountriesListSearch.value = Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] );

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
                ),*/

                ///TextField
                Expanded(
                    child: Container(
                      //color: Colors.red,
                        margin: EdgeInsets.only(left: 10,right: 10),
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
                                        controller: _controllerPhone1,
                                        //focusNode: _focusNodeQuantity,
                                        keyboardType: TextInputType.phone,
                                        //enabled: value1,
                                        style: TextStyle(
                                            fontFamily: Strings.font_regularFe,
                                            fontSize: 17,
                                            color: CustomColors.graytext),
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
                                          _controllerPhone1.updateMask('000-000-0000',moveCursorToEnd: true);
                                        },
                                        onTap: (){
                                          //notifierVisibleButtoms.value = 1;
                                          cahngeheight("edit");
                                          onboardingProvider.focusReferarOrName = 0;
                                        },
                                        onSubmitted: (Value){
                                          cahngeheight("done");
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

  //Create NIPº field
  Widget _fieldNIP() {
    return Container(
        decoration: BoxDecoration(
            color: CustomColors.graycountry.withOpacity(0.6),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        //margin: EdgeInsets.only(left: 20, right: 20),
        child:  Container(
          //color: Colors.red,
            margin: EdgeInsets.only(left: 10,right: 10),
            alignment: Alignment.centerLeft,
            child: TextField(
              textAlign: TextAlign.center,
              maxLength: 5,
              controller: _controllerNIP,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                  fontFamily: Strings.font_regularFe,
                  fontSize: 17,
                  color: CustomColors.graytext),
              decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  filled: true,
                  contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                  fillColor: Colors.transparent,
                  hintText: "",
                  hintStyle: TextStyle(
                      fontFamily: Strings.font_regularFe,
                      fontSize: 17,
                      color: CustomColors.grayplaceholder)

              ),
              maxLines: 1,
              onChanged: (value){
                //_controllerPhone1.updateMask('000-000-0000',moveCursorToEnd: true);
              },
              onTap: (){
                //notifierVisibleButtoms.value = 1;
                cahngeheight("edit");
                onboardingProvider.focusReferarOrName = 0;
              },
              onSubmitted: (Value){
                cahngeheight("done");
              },

              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            )
        )
    );
  }

  void cahngeheight(String editorNormal){

    if(editorNormal == "edit"){
      //notifierTopScroll.value = 50.0;
      notifierTopScroll.value = MediaQuery.of(context).size.height / 2 -140;
    }else{
      //notifierTopScroll.value = 180.0;
      notifierTopScroll.value = MediaQuery.of(context).size.height / 2 + 60;
    }

  }

  /// View SMS Code
  Container viewSMSCode(BuildContext contexts) {
    return Container(
      //color: Colors.green,
        margin: EdgeInsets.only(left: 30,right: 30),
        child: Column(

          children: [

            /// Send email
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: ///Accept TyC
              Center(
                child: Container(

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
                        new TextSpan(text: Strings.emailcode,style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 13.0,
                        )),
                        new TextSpan(text: Strings.emailcode1,style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangeback, fontSize: 13.0,
                        )),
                      ],
                    ),
                  ),

                ),
              ),
            ),

            ///Accept TyC
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
                            Navigator.push(context, Transition(child: TyC(url: Strings.urlpriva, title: Strings.tyc1,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
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
                            Navigator.push(context, Transition(child: TyC(url: Strings.urltyc, title: Strings.tyc3,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
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
              //padding: EdgeInsets.only(left: 30,right: 30,),
              child: ValueListenableBuilder<String>(
                  valueListenable: notifierCorrect,
                  builder: (context,value,_){

                    return PinCodeTextField(
                      //autoFocus: true,
                      textStyle: TextStyle(fontFamily: Strings.font_bold, color: value=="0" || value=="1" ? CustomColors.orangeback : CustomColors.reddelete, fontSize: 35.0,),
                      length: 4,
                      //obscureText: false,
                      //animationType: AnimationType.fade,
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
                      //errorAnimationController: errorController,
                      controller: textEditingController,
                      //focusNode: _focusNodeQuantity,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onCompleted: (v) {
                        print("Completed");
                        FocusScope.of(context).requestFocus(new FocusNode());
                        /*if(singleton.notifierVerifyAccountCode.value.code == 100){
                          notifierCorrect.value = "1";

                        }else{
                          notifierCorrect.value = "2";
                          utils.openSnackBarInfo(context, Strings.errorcode, "assets/images/ic_alert.png",CustomColors.white,"error");

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
              /*child: PinCodeTextField(appContext: context, length: 4, onChanged: (value) {
                print(value);

              },
                pinTheme: PinTheme(

                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  borderWidth: 1,
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: CustomColors.greybackSMS,//
                  selectedColor: CustomColors.greyborderSMS ,//oscuro
                  activeColor: CustomColors.greyborderSMS,
                  disabledColor: Colors.deepPurple,
                  inactiveColor: CustomColors.greyborderSMS,
                  inactiveFillColor: CustomColors.greybackSMS,
                  selectedFillColor: CustomColors.greybackSMS,//oscuro

                ),
                animationDuration: Duration(milliseconds: 100),
                backgroundColor: Colors.white,
                enableActiveFill: true,
                //controller: textEditingController,
                //errorAnimationController: errorController,
                enabled: true,
                /*focusNode: _focusNodeQuantity,*/

              ),*/
            ),

            ///Re sent sms
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10,bottom: 15,),

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

                      new TextSpan(text: Strings.rnorecivesms,
                          style: TextStyle(
                            fontFamily: Strings.font_bold, color: CustomColors.orangeback, fontSize: 13.0,
                            decoration: TextDecoration.underline,
                            decorationColor: CustomColors.orangeback,
                          ),
                          recognizer: new TapGestureRecognizer()..onTap = () {
                            //FocusScope.of(context).requestFocus(new FocusNode());
                            servicemanager.fetchValidateEmail(context, _controllerEmail.text);
                          }
                      ),
                    ],
                  ),
                ),

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
                                    Strings.hide,
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                    //maxLines: 1,
                                    style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.greyborderbutton, fontSize: 13.0,),
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
                          //singleton.notifierValueYButtons.value = 0;
                          //notifierCorrect.value = "0";
                          //startLoading();
                          //stopLoading();

                          //FocusScope.of(context).requestFocus(new FocusNode());
                          //notifierValueYButtons.value = MediaQuery.of(context).size.height ;
                          //_validateform(context,stopLoading);

                          //utils.openSnackBarInfo(context, "Cuenta completa, irás al Home próximamente", "assets/images/ic_alert.png",CustomColors.white,"success");

                          Navigator.pushReplacement(context, Transition(child: PrincipalContainer()) );

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
                      width: 340,
                      borderRadius: 40.0,
                      color: CustomColors.orangeback,
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: CustomColors.orangeback,
                          borderRadius: BorderRadius.all(const Radius.circular(40)),
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
                                    Strings.winpoint,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    //maxLines: 1,
                                    style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 13.0,),
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
                          //singleton.notifierValueYButtons.value = 0;
                          //notifierCorrect.value = "0";
                          startLoading();
                          //FocusScope.of(context).requestFocus(new FocusNode());
                          _validateMailCode(context,stopLoading);
                          //notifierValueYButtons.value = MediaQuery.of(context).size.height ;
                          //Navigator.push(context, Transition(child: CreateAccount(), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
                          //Navigator.pushReplacement(context, Transition(child: PrincipalContainer()) );

                        }
                      },
                    ),
                  ),
                ),


              ],

            ),

            SizedBox(height: 20,),

          ],

        )
    );
  }

  ///Create telf field
  Widget _fieldName() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(10)),
          color: CustomColors.graycountry.withOpacity(0.6),
          border: Border.all(color: CustomColors.graycountry.withOpacity(0.6), width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(left: 10,right: 10),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //enableSuggestions: false,
                              controller: _controllerName,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_regular,
                                  fontSize: 14,
                                  color: CustomColors.graytext),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.name,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 14,
                                      color: CustomColors.grayplaceholder)

                              ),
                              maxLines: 1,
                              onChanged: (value){
                                notifierVisibleButtoms.value = 1;
                                //_controllerPhone.updateMask('000-0000-0000',moveCursorToEnd: true);

                              },
                              onTap: (){
                                notifierVisibleButtoms.value = 1;
                                cahngeheight("edit");
                                onboardingProvider.focusReferarOrName = 1;
                              },
                              onSubmitted: (Value){
                                cahngeheight("done");
                              },

                              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            )
                        ),


                      ],
                    )
                )
            ),


          ],
        ),
      ),

    );
  }

  ///Create telf field
  Widget _fieldMail() {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(23)),
          color: CustomColors.white,
          border: Border.all(color: CustomColors.orangeback, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(left: 10,right: 30),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //enableSuggestions: false,
                              controller: _controllerEmail,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontFamily: Strings.font_regular,
                                  fontSize: 15,
                                  color: CustomColors.graytext),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 20,right: 20),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.email,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.grayplaceholder)

                              ),
                              maxLines: 1,
                              onChanged: (value){
                                notifierVisibleButtoms.value = 1;

                                //_controllerPhone.updateMask('000-0000-0000',moveCursorToEnd: true);
                              },
                              onTap: (){
                                notifierVisibleButtoms.value = 1;
                                cahngeheight("edit");
                              },
                              onSubmitted: (Value){
                                cahngeheight("done");
                              },

                              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            )
                        ),


                      ],
                    )
                )
            ),


          ],
        ),
      ),

    );
  }

  ///Create telf field
 /* Widget _fieldPhone() {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(23)),
          color: CustomColors.white,
          border: Border.all(color: CustomColors.orangeback, width: 1),
        ),
        
        child: Row(
              children: <Widget>[
                

                Expanded(
                    child: Container(
                      //color: Colors.red,
                        margin: EdgeInsets.only(left: 10,right: 10),
                        alignment: Alignment.centerLeft,
                        child: Stack(
                          children: <Widget>[


                            Container(
                                child: TextField(
                                  //autofocus: true,
                                  maxLength: 13,
                                  enabled: false,
                                  //enableSuggestions: false,
                                  controller: _controllerPhone,
                                  //focusNode: _focusNodeQuantity,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 14,
                                      color: CustomColors.graytext),
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      filled: true,
                                      contentPadding: EdgeInsets.only( top: 10, bottom: 10,),
                                      fillColor: Colors.transparent,
                                      hintText: Strings.lineagane,
                                      hintStyle: TextStyle(
                                          fontFamily: Strings.font_regular,
                                          fontSize: 14,
                                          color: CustomColors.grayplaceholder)

                                  ),
                                  maxLines: 1,
                                  onChanged: (value){
                                    notifierVisibleButtoms.value = 1;
                                    //_controllerPhone.updateMask('000-0000-0000',moveCursorToEnd: true);
                                  },
                                  onTap: (){
                                    notifierVisibleButtoms.value = 1;
                                  },

                                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                )
                            ),


                          ],
                        )
                    )
                ),

                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: SvgPicture.asset(
                    'assets/images/ic_check_validated.svg',
                    fit: BoxFit.contain,
                    width: 30,
                    height: 30,
                    color: CustomColors.greencheck,
                  ),
                )


              ],
            ),
      ),
      
    );
  }*/

  ///Create referral field
  Widget _fieldReferral() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(10)),
          color: CustomColors.graycountry.withOpacity(0.6),
          border: Border.all(color: CustomColors.graycountry.withOpacity(0.6), width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(left: 10,right: 10),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //enableSuggestions: false,
                              controller: _controllerReferral,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontFamily: Strings.font_regular,
                                  fontSize: 14,
                                  color: CustomColors.graytext),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.referral1,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 14,
                                      color: CustomColors.grayplaceholder)

                              ),
                              maxLines: 1,
                              onChanged: (value){
                                notifierVisibleButtoms.value = 1;
                                //_controllerPhone.updateMask('000-0000-0000',moveCursorToEnd: true);

                              },
                              onTap: (){
                                notifierVisibleButtoms.value = 1;
                                cahngeheight("edit");
                                onboardingProvider.focusReferarOrName = 1;
                              },
                              onSubmitted: (Value){
                                cahngeheight("done");
                              },

                              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            )
                        ),


                      ],
                    )
                )
            ),


          ],
        ),
      ),

    );
  }

  ///Create Scan field
  Widget _fieldScanOrTelf() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(10)),
          color: CustomColors.graycountry.withOpacity(0.6),
          border: Border.all(color: CustomColors.graycountry.withOpacity(0.6), width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              maxLength: 20,
                              controller: _controllerScanBarCode,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_regular,
                                  fontSize: 14,
                                  color: CustomColors.graytext),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                  fillColor: Colors.transparent,
                                  hintText: "",
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 14,
                                      color: CustomColors.grayplaceholder)

                              ),
                              maxLines: 1,
                              focusNode: _focusNode,
                              onChanged: (value){
                                //notifierVisibleButtoms.value = 1;
                                showOverlaidTag(context, value);

                              },
                              onTap: (){
                                //notifierVisibleButtoms.value = 1;
                                cahngeheight("edit");
                                onboardingProvider.focusReferarOrName = 0;
                              },
                              onSubmitted: (Value){
                                cahngeheight("done");
                              },



                              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            )
                        ),


                      ],
                    )
                )
            ),

            GestureDetector(
              /*onTap: (){
                scanQR();
              },*/
              onTapDown: (TapDownDetails details) => _onTapDownBarCode(details),
              child: SvgPicture.asset(
                  'assets/images/scan.svg',
                  fit: BoxFit.contain
              ),
            ),

            SizedBox(
              width: 10,
            ),

          ],
        ),
      ),

    );
  }


  showOverlaidTag(BuildContext context, String newText) async {

    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: TextStyle(
            fontFamily: Strings.font_regular,
            fontSize: 14,
            color: CustomColors.graytext),
        text: newText,
      ),
    );
    painter.layout();

    print(_focusNode.offset.dy + painter.height);
    yCode = _focusNode.offset.dy + painter.height;
    if(newText.length==20){
      BarCOde = newText;
      launchFetchBarcode();
    }

    /*OverlayState? overlayState = Overlay.of(context);
    OverlayEntry suggestionTagoverlayEntry = OverlayEntry(builder: (context) {
      return Positioned(

        // Decides where to place the tag on the screen.
        top: _focusNode.offset.dy + painter.height + 3,
        left: _focusNode.offset.dx + painter.width + 10,

        // Tag code.
        child: Material(
            elevation: 4.0,
            color: Colors.lightBlueAccent,
            child: Text(
              'Show tag here',
              style: TextStyle(
                fontSize: 20.0,
              ),
            )),
      );
    });
    overlayState!.insert(suggestionTagoverlayEntry);

    // Removes the over lay entry from the Overly after 500 milliseconds
    await Future.delayed(Duration(milliseconds: 500));
    suggestionTagoverlayEntry.remove();*/
  }



  ///Validate form
  _validateform(BuildContext context,Function function)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    var number = _controllerPhone.text;
    number = number.replaceAll("-", " ");

    var number1 = _controllerPhone1.text;
    number1 = number1.replaceAll("-", " ");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        if(singleton.isOffline){
          setState(() {
            singleton.isOffline = singleton.isOffline;
          });

        }else{

          //RegExp rex =RegExp('^[a-zA-Z\u00f1\u00d1]+ ?([a-zA-Z\u00f1\u00d1]+\$){1}');
          RegExp rex =RegExp('^[a-zA-Z\u00f1\u00d1\u00e1\u00c1\u00e9\u00c9\u00ed\u00cd\u00f3\u00d3\u00fa\u00da\u0020]+ ?([a-zA-Z\u00f1\u00d1\u00e1\u00c1\u00e9\u00c9\u00ed\u00cd\u00f3\u00d3\u00fa\u00da\u0020]+\$){1}');
          print(rex.hasMatch(_controllerName.text.trim()));

          if(_controllerScanBarCode.text.isNotEmpty){
            BarCOdenumbergane = _controllerScanBarCode.text.trim();
          }

          if (_controllerName.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorName, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if ( rex.hasMatch(_controllerName.text.trim()) == false) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorName11, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerName.text.trim().length < 4) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorName111, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }
          /*else if (_controllerPhone.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errornotelf, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          } else if (number.length < 10) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errornotelf1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }*/else if (onboardingProvider.haveChip == -1) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorhavechip, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          } else{


            if (onboardingProvider.keepNumber == -1 && onboardingProvider.haveChip == 1) {
              Future.delayed(const Duration(milliseconds: 500), () {
                function();
              });
              utils.openSnackBarInfo(context, Strings.errorkeepnumber, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

            }else if(onboardingProvider.haveChip == 2){ /// No have chip gane

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
                      launchcreateAcc(function);
                    }

            }else  if(onboardingProvider.keepNumber == 2){ /// Yes in Have a chip and NO want keep number

                    if(BarCOdenumbergane == ""){
                      Future.delayed(const Duration(milliseconds: 500), () {
                        function();
                      });
                      utils.openSnackBarInfo(context, Strings.errorbarcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                    }else if (_controllerScanBarCode.text.trim().length < 10) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        function();
                      });
                      utils.openSnackBarInfo(context, Strings.errorchiopscan, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                    }else{
                      launchcreateAcc(function);
                    }


            }else{/// Yes in Have a chip and  YES want keep number

                      if (_controllerPhone1.text.trim().isEmpty ) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          function();
                        });
                        utils.openSnackBarInfo(context, Strings.errorkeepnumber1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                      }else if (number1.length < 10) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          function();
                        });
                        utils.openSnackBarInfo(context, Strings.errornotelf1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                      }else if (_controllerNIP.text.trim().isEmpty ) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          function();
                        });
                        utils.openSnackBarInfo(context, Strings.errornip, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                      }else if (_controllerNIP.text.trim().length < 4) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          function();
                        });
                        utils.openSnackBarInfo(context, Strings.errornip1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                      }else if(BarCOdenumbergane == ""){
                        Future.delayed(const Duration(milliseconds: 500), () {
                          function();
                        });
                        utils.openSnackBarInfo(context, Strings.errorbarcode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                      }else if (_controllerScanBarCode.text.trim().length < 10) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          function();
                        });
                        utils.openSnackBarInfo(context, Strings.errorchiopscan, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

                      }else{
                        launchcreateAcc(function);
                      }


            }



          }


        }
      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      ConnectionStatusSingleton.getInstance().checkConnection();
    }



  }

  void launchcreateAcc(Function function){
    utils.openProgress(singleton.navigatorKey.currentContext!);

    Future.delayed(const Duration(milliseconds: 50), () {
      var tel = _controllerPhone.text;
      tel = tel.replaceAll("-", "");
      //tel = singleton.notifierCallingCode.value+tel;

      singleton.codeReferral = _controllerReferral.text.trim();

      var tel1 = _controllerPhone1.text;
      tel1 = tel1.replaceAll("-", "");

      servicemanager.fetchCreateAccount(context, tel, _controllerName.text, _controllerReferral.text, function, onboardingProvider, _controllerNIP.text.trim(), tel1, BarCOdenumbergane);

    });

  }

  ///Validate form
  _validateMailCode(BuildContext context,Function function)async{

    FocusScope.of(context).requestFocus(new FocusNode());



    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        if(singleton.isOffline){
          setState(() {
            singleton.isOffline = singleton.isOffline;
          });

        }else{

          if (textEditingController.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorMailCode, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else{

            Future.delayed(const Duration(milliseconds: 50), () {

              servicemanager.fetchCreateAccountValidateCode(context, textEditingController.text, function);

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

