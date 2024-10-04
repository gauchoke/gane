import 'dart:io';
import 'dart:ui';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/countries.dart';
import 'package:gane/src/UI/Onboarding/countrieslist.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:gane/src/Utils/utils.dart';

class dialogValidateTelf extends StatefulWidget {
  final Function validate;
  dialogValidateTelf({Key? key,required this.validate,}) : super(key: key);

  @override
  _dialogValidateTelfState createState() => _dialogValidateTelfState();
}

class _dialogValidateTelfState extends State<dialogValidateTelf> {
  final singleton = Singleton();
  final prefs = SharePreference();
  var _controllerPhone = new MaskedTextController(text: '', mask: '000-000-0000');
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState(){

    WidgetsBinding.instance!.addPostFrameCallback((_){
      singleton.notifierCorrect.value = "0";
      _controllerPhone.text = singleton.notifierUserProfile.value.data!.user!.phoneNumber!;
      singleton.notifierCallingCode.value = singleton.notifierUserProfile.value.data!.user!.phonePrefix!;
      prefs.indiCountry = singleton.notifierUserProfile.value.data!.user!.phonePrefix!;

      fetchSendCode(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.black.withOpacity(.3),
      body: Stack(

        children: [

          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          _body(context)

        ],

      ),
    );
  }

  Widget _body(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            width: double.infinity,
            color: Colors.transparent,
            // margin: EdgeInsets.symmetric(horizontal: 30),
            child:  Container(
              margin: const EdgeInsets.symmetric(horizontal: 13),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: CustomColors.white
              ),
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[


                      SizedBox(height: 20,),

                      /// sure logout
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(Strings.validateteld,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 18,
                                  color: CustomColors.black))
                      ),

                      SizedBox(height: 15,),

                      _fieldPhone(),

                      SizedBox(height: 15,),

                      viewSMSCode(context)

                    ]),
              )
            )
        )
      ],
    );
  }

  ///Create telf field
  Widget _fieldPhone() {
    return Container(
        decoration: BoxDecoration(
            color: CustomColors.lightGrayNumbers.withOpacity(0.6),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        //margin: EdgeInsets.only(left: 20, right: 20),
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
                                child: TextField(
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

  /// View SMS Code
  Container viewSMSCode(BuildContext context) {
    return Container(
      //color: Colors.green,
      // margin: EdgeInsets.only(left: 40,right: 40),
        child: Column(

          children: [

            ///Accept TyC
            /*Center(
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
          ),*/


            ///Pin Text
            Container(
              //padding: EdgeInsets.only(left: 30,right: 30,),
              child: ValueListenableBuilder<String>(
                  valueListenable: singleton.notifierCorrect,
                  builder: (context,value,_){

                    return PinCodeTextField(
                      textStyle: TextStyle(fontFamily: Strings.font_regularFe, color: value=="0" || value=="1" ? CustomColors.black : CustomColors.black, fontSize: 35.0,),
                      length: 4,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        borderWidth: 1,
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeFillColor: value=="0" || value=="1" ? CustomColors.lightGrayNumbers.withOpacity(0.6) : CustomColors.redlight,//
                        selectedColor: value=="0" || value=="1" ? CustomColors.lightGrayNumbers.withOpacity(0.6) : CustomColors.redlight,//oscuro
                        activeColor: value=="0" || value=="1" ? CustomColors.lightGrayNumbers.withOpacity(0.6): CustomColors.redlight,
                        disabledColor: Colors.deepPurple,
                        inactiveColor: value=="0" || value=="1" ? CustomColors.lightGrayNumbers.withOpacity(0.6) : CustomColors.redlight,
                        inactiveFillColor: value=="0" || value=="1" ? CustomColors.lightGrayNumbers.withOpacity(0.6) : CustomColors.redlight,
                        selectedFillColor: value=="0" || value=="1" ? CustomColors.lightGrayNumbers.withOpacity(0.6) : CustomColors.redlight,//oscuro

                      ),
                      animationDuration: Duration(milliseconds: 100),
                      backgroundColor: Colors.white,
                      enableActiveFill: true,
                      controller: textEditingController,
                      //focusNode: _focusNodeQuantity,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onCompleted: (v) {
                        print("Completed");
                        FocusScope.of(context).requestFocus(new FocusNode());
                        print(singleton.codeSMS);

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
                          singleton.notifierCorrect.value = "";
                          startLoading();
                          stopLoading();
                          singleton.notifierVisibleButtoms.value = 0;

                          Navigator.pop(context);

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

                          _resendvalidateform(context, stopLoading);

                        }
                      },
                    ),
                  ),
                ),


              ],

            ),

            SizedBox(height: 10,),

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
                                    fetchSendCode(context);
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

            SizedBox(height: 10,),

          ],

        )
    );
  }

  /// Send code sms
  fetchSendCode(BuildContext context,)async{

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

          Future.delayed(const Duration(milliseconds: 50), () {

            servicemanager.fetchVerifyNumber(context, singleton.notifierUserProfile.value.data!.user!.phoneNumber!, (){} ).then((value) {
              print(value);

            });
          });


        }
      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }



  }

  ///Validate form
  _resendvalidateform(BuildContext context, Function stop)async{

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
            stop();
            utils.openSnackBarInfo(context, Strings.errornotelf, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          } else if (number.length < 10) {
            stop();
            utils.openSnackBarInfo(context, Strings.errornotelf1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (textEditingController.text.trim().isEmpty) {
            stop();
            utils.openSnackBarInfo(context, Strings.errorcode1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          } else if (number.length < 4) {
            stop();
            utils.openSnackBarInfo(context, Strings.errorcode2, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else{

            launchFetchValidateSMS(stop);

          }


        }
      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }



  }

  /// Validate SMS
  void launchFetchValidateSMS(Function stop)async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        var tel = _controllerPhone.text;
        tel = tel.replaceAll("-", "");
        utils.openProgress(context);
        servicemanager.fetchValidateNumber(context, tel, textEditingController.text, stop, widget.validate);
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }


}

