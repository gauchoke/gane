import 'dart:io';

import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gane/src/Models/buyplan.dart';
import 'package:gane/src/Models/planescompra.dart';
import 'package:gane/src/UI/Home/RechargePlain/buyplan.dart';
import 'package:gane/src/UI/Home/RechargePlain/paymethods.dart';
import 'package:gane/src/UI/Home/completeprof.dart' as widget;
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/UI/Onboarding/tyc1.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transition/transition.dart';

class RechargePlainViewForm extends StatefulWidget{

  @override
  _RechargePlainViewStateForm createState() => _RechargePlainViewStateForm();
}

class _RechargePlainViewStateForm extends State<RechargePlainViewForm> {
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  var _controllerName = TextEditingController();
  var _controllerLastName = TextEditingController();
  var _controllerMail = TextEditingController();


  @override
  void initState(){

    WidgetsBinding.instance!.addPostFrameCallback((_){
      singleton.emailPideChip = "";
      singleton.fullnamePideCHip = "";
    });

    super.initState();

  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        servicemanager.fetchPlanes(context, "borrar");

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }

  /// Reset Load
  void _onRefresh() async{
    _refreshController.refreshCompleted();
    launchFetch();
  }

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder<bool>(
      valueListenable: singleton.notifierIsOffline,
      builder: (contexts,value2,_){
        if (value2 == true) {
          return Nointernet();
        } else {
          return Scaffold(
            backgroundColor: CustomColors.backformPide,
            body: Stack(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _appBar(),

                Container(
                  margin: EdgeInsets.only(top: 75),
                  color: CustomColors.backformPide,
                  width: double.infinity,
                  child: SingleChildScrollView(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// reload text
                          Container(
                            margin: EdgeInsets.only(top: 35,left:20),
                            child: Text(Strings.rechargeAccount1,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.black, fontSize: 20,),
                            ),
                          ),

                          SizedBox(height: 15,),

                          /// Plan text
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(singleton.plan,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.black, fontSize: 13,),
                            ),
                          ),

                          SizedBox(height: 25,),

                          /// Form
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            //padding: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: 10,),

                                /// Name Textfield
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: new TextSpan(
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                        //color: Colors.black,
                                      ),
                                      children: <TextSpan>[

                                        new TextSpan(text: Strings.names,
                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 12,),
                                        ),

                                        new TextSpan(text: "*",
                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.orangeborderpopup, fontSize: 12,),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: _fieldName(),
                                ),
                                SizedBox(height: 20,),

                                /// Last Name Textfield
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: new TextSpan(
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                        //color: Colors.black,
                                      ),
                                      children: <TextSpan>[

                                        new TextSpan(text: Strings.lastnames,
                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 12,),
                                        ),

                                        new TextSpan(text: "*",
                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.orangeborderpopup, fontSize: 12,),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: _fieldLastName(),
                                ),
                                SizedBox(height: 20,),

                                /// Mail Textfield
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: new TextSpan(
                                      style: new TextStyle(
                                        fontSize: 12.0,
                                        //color: Colors.black,
                                      ),
                                      children: <TextSpan>[

                                        new TextSpan(text: Strings.email1,
                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.black, fontSize: 12,),
                                        ),

                                        new TextSpan(text: "*",
                                          style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.orangeborderpopup, fontSize: 12,),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: _fieldLastMail(),
                                ),
                                SizedBox(height: 20,),

                                /// Create account Button
                                Container(
                                  alignment: Alignment.center,
                                  child: ArgonButton(
                                    height: 45,
                                    width: MediaQuery.of(context).size.width,
                                    borderRadius: 10.0,
                                    color: CustomColors.orangeborderpopup,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: CustomColors.orangeborderpopup,
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
                                                  Strings.processpay,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor: 1.0,
                                                  //maxLines: 1,
                                                  style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 17.0,),
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
                                      child: SizedBox(
                                        width: 45,height: 45,
                                        child: CircularProgressIndicator(
                                          backgroundColor: CustomColors.white,
                                          valueColor: AlwaysStoppedAnimation<Color>(CustomColors.orangeborderpopup),
                                        ),
                                      ),
                                    ),
                                    onTap: (startLoading, stopLoading, btnState) {
                                      if(btnState == ButtonState.Idle){

                                        startLoading();
                                        _validateform(context, stopLoading);


                                      }
                                    },
                                  ),
                                ),

                                SizedBox(height: 20,),

                              ],
                            ),
                          )

                        ],
                      )
                  ),
                ),

              ],
            ),
          );
        }
      },
    );
  }

  ///Create Name field
  Widget _fieldName() {
    return Container(
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
                            controller: _controllerName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: Strings.font_mediumFe,
                                fontSize: 14,
                                color: CustomColors.graytext),
                            decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                filled: true,
                                contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                fillColor: Colors.transparent,
                                hintText: Strings.insertname,
                                hintStyle: TextStyle(
                                    fontFamily: Strings.font_mediumFe,
                                    fontSize: 14,
                                    color: CustomColors.grayplaceholder)

                            ),
                            maxLines: 1,
                            onChanged: (value){
                              //_controllerPhone.updateMask('000-0000-0000',moveCursorToEnd: true);
                            },
                            onTap: (){

                            },
                            onSubmitted: (Value){
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
    );
  }

  ///Create Last Name field
  Widget _fieldLastName() {
    return Container(
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
                            controller: _controllerLastName,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: Strings.font_mediumFe,
                                fontSize: 14,
                                color: CustomColors.graytext),
                            decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                filled: true,
                                contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                fillColor: Colors.transparent,
                                hintText: Strings.insertlastname,
                                hintStyle: TextStyle(
                                    fontFamily: Strings.font_mediumFe,
                                    fontSize: 14,
                                    color: CustomColors.grayplaceholder)

                            ),
                            maxLines: 1,
                            onChanged: (value){
                              //_controllerPhone.updateMask('000-0000-0000',moveCursorToEnd: true);
                            },
                            onTap: (){

                            },
                            onSubmitted: (Value){
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
    );
  }

  ///Create Mail field
  Widget _fieldLastMail() {
    return Container(
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
                            controller: _controllerMail,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: Strings.font_mediumFe,
                                fontSize: 14,
                                color: CustomColors.graytext),
                            decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                filled: true,
                                contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                fillColor: Colors.transparent,
                                hintText: Strings.insertlastmail,
                                hintStyle: TextStyle(
                                    fontFamily: Strings.font_mediumFe,
                                    fontSize: 14,
                                    color: CustomColors.grayplaceholder)

                            ),
                            maxLines: 1,
                            onChanged: (value){
                              //_controllerPhone.updateMask('000-0000-0000',moveCursorToEnd: true);
                            },
                            onTap: (){

                            },
                            onSubmitted: (Value){
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
    );
  }

  ///Validate form
  _validateform(BuildContext context,Function function)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    //var number = _controllerPhone.text;
    //number = number.replaceAll("-", " ");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        if(singleton.isOffline){
          setState(() {
            singleton.isOffline = singleton.isOffline;
          });

        }else{

          if (_controllerName.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorName1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerName.text.trim().length < 3) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorNameminname, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerLastName.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorLastName, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerLastName.text.trim().length < 3) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorNameminlastname, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerMail.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorMail, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (EmailValidator.validate(_controllerMail.text.trim()) == false  ){
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorMail1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else{
            //launchFetch();
            function();

            singleton.emailPideChip = _controllerMail.text.trim();
            singleton.fullnamePideCHip = _controllerName.text.trim() + _controllerLastName.text.trim();

            singleton.name = _controllerName.text.trim();
            singleton.lastname = _controllerLastName.text.trim();
            singleton.email = _controllerMail.text.trim();

            var time = 350;
            if(singleton.isIOS == false){
              time = utils.ValueDuration();
            }

            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time),
                child: Payment(idPlan: singleton.idPlan,Plan: singleton.plan,PlanValue: singleton.planvalue.toString(),title: Strings.rechargeAccount,),
                reverseDuration: Duration(milliseconds: time)
            )).then((value) {
              if(value=="relaunch"){
              }

            });


          }


        }
      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }



  }


  Widget _appBar(){
    return new Container(
      //color: CustomColors.white,
      width: MediaQuery.of(context).size.width,
      //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: CustomColors.orangeOne,
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
                  'assets/images/ic_backwhite.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30,right: 40),
              child: Container(
                child: AutoSizeText(
                  Strings.rechargeAccount,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,

                  maxLines: 3,
                  style: TextStyle(fontSize: 19.0,fontFamily: Strings.font_bold, color: Colors.white,),
                  //maxLines: 1,
                ),
              ),

            ),
          ),

        ],
      ),
    );
  }
}