import 'dart:convert';
import 'dart:io';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/planchip.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Home/RechargePlain/paymethods.dart';
import 'package:gane/src/UI/Home/citieslistado.dart';
import 'package:gane/src/UI/Home/colinieslistado.dart';
import 'package:gane/src/UI/Home/completeprof.dart';
import 'package:gane/src/UI/Home/stateslistado.dart';

import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/Onboarding/loginphone.dart';

import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/home_provider.dart';
import 'package:gane/src/Utils/image_picker_handler.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Widgets/dialog_disableaccount.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class PideSimForm extends StatefulWidget{

  final from;

  PideSimForm({this.from});

  _statePideSimForm createState()=> _statePideSimForm();
}

class _statePideSimForm extends State<PideSimForm> with   WidgetsBindingObserver{

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
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  late HomeProvider provider;

  final _controllerPhone = MaskedTextController(mask: '000-000-0000');
  var _controllerName = TextEditingController();
  var _controllerLastName = TextEditingController();
  var _controllerEmail = TextEditingController();
  var _controllerAddress = TextEditingController();
  var _controllerExterior = TextEditingController();
  var _controllerInterior = TextEditingController();
  var _controllerZipCode = TextEditingController();
  var _controllerColinia = TextEditingController();
  var _controllerCity = TextEditingController();
  var _controllerState = TextEditingController();
  var _controllerAddressReference = TextEditingController();

  late File _image;
  late AnimationController _controllerImage;
  late ImagePickerHandler imagePicker;



  @override
  void initState(){

    singleton.codeReferral = "";
    singleton.state = "";
    singleton.city = "";
    singleton.colonia = "";
    singleton.zipcode = "";
    singleton.tokenTC = "";

    singleton.lastname = "";
    singleton.address = "";
    singleton.exterior = "";
    singleton.interior = "";



    singleton.GaneOrMira = "gane";


    WidgetsBinding.instance!.addPostFrameCallback((_){

      print(singleton.notifierUserProfile.value.data!.user!.id);
      Future.delayed(const Duration(milliseconds: 50), () {

        _controllerName.text = singleton.notifierUserProfile.value.data!.user!.fullname!;
        _controllerEmail.text = singleton.notifierUserProfile.value.data!.user!.email!;
        _controllerPhone.text = singleton.notifierUserProfile.value.data!.user!.phoneNumber!;

      });


      print(MediaQuery.of(context).devicePixelRatio);
      print(MediaQuery.of(context).size.height);

    });

    super.initState();
  }

  /// fetch states
  void launchFetchStates()async{
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        utils.openProgress(context);
        servicemanager.fetchStates(context);

      }

    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Fetch Cities
  void launchFetchCities()async{
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        utils.openProgress(context);
        servicemanager.fetchCities(context, singleton.state);

      }

    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Fetch Colonia
  void launchFetchColonias()async{
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        utils.openProgress(context);
        servicemanager.fetchCities(context, singleton.state);

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
    return ValueListenableBuilder<bool>(
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

    return Container(
      //padding: EdgeInsets.only(top: 100),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 20,right: 20),
        margin: EdgeInsets.only(top: 90),
        child: ValueListenableBuilder<Getprofile>(
            valueListenable: singleton.notifierUserProfile,
            builder: (context,value2,_){

              return SingleChildScrollView(

                child: Container(
                  margin: EdgeInsets.only(top: 20,bottom: 20),
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [


                      /// Plan Chip
                      Container(
                          child: ValueListenableBuilder<ChipPlans>(
                              valueListenable: singleton.notifierPlanChip,
                              builder: (context,value,_){

                                return value.code == 1 ? utils.PreloadBanner():
                                InkWell(
                                  onTap: (){


                                    singleton.idPlan = value.data!.plan!.id!;
                                    singleton.plan = value.data!.plan!.name!;
                                    singleton.planvalue = value.data!.plan!.price!.toString();
                                    //singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );

                                    var time = 350;
                                    if(singleton.isIOS == false){
                                      time = utils.ValueDuration();
                                    }
                                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: PideSimForm(),
                                        reverseDuration: Duration(milliseconds: time)
                                    )).then((value) {
                                    });

                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                    //child:  SvgPicture.asset(value.data!.items![index]!.photoUrl!,),
                                    child: Image.network(
                                        value.data!.plan!.photoUrl!,
                                        fit: BoxFit.contain,
                                        frameBuilder: (_, image, loadingBuilder, __) {
                                          if (loadingBuilder == null) {
                                            return const SizedBox(
                                              child: Center(
                                                  child: CircularProgressIndicator(
                                                    color: Color(0xFFFF4D00),
                                                    //color: CustomColors.orangeback,
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
                                                //color: CustomColors.orangeback,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (_, __, ___) {

                                          //setState(() {});
                                          return Container(
                                            child: Icon(Icons.error,color: CustomColors.orangeback,size: 40,),
                                          );

                                        }

                                    ),

                                  ),
                                );
                              }
                          )
                      ),

                      /// title
                      Container(
                        child: Text(Strings.please,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                          textScaleFactor: 1.0,
                        ),
                      ),

                      SizedBox(height: 30,),

                      /// Name
                      Container(
                        child: Text(Strings.names,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      SizedBox(height: 10,),
                      _fieldName(),
                      SizedBox(height: 20,),

                      /// LastName
                      Container(
                        child: Text(Strings.lastnames,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      SizedBox(height: 10,),
                      _fieldLastName(),
                      SizedBox(height: 20,),

                      /// Mail
                      Container(
                        child: Text(Strings.email,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      SizedBox(height: 10,),
                      _fieldMail(),
                      SizedBox(height: 20,),

                      /// Telf
                      Container(
                        child: Text(Strings.telfco,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      SizedBox(height: 10,),
                      _fieldPhone(),
                      SizedBox(height: 20,),

                      /// Address
                      Container(
                        child: Text(Strings.address,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      SizedBox(height: 10,),
                      _fieldAddress(),
                      SizedBox(height: 20,),


                      /// Interior / Exterior
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Esteriors
                                  Container(
                                    child: Text(Strings.exterior,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  _fieldExterior(),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),

                            SizedBox(width: 10,),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Interiors
                                Container(
                                  child: Text(Strings.interior,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                _fieldInterior(),
                                SizedBox(height: 20,),
                              ],
                            ),
                            )

                          ],
                        ),
                      ),


                      /// Address reference
                      Container(
                        child: Text(Strings.addressreference,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                          textScaleFactor: 1.0,
                        ),
                      ),
                      SizedBox(height: 10,),
                      _fieldAddressReference(),
                      SizedBox(height: 20,),

                      /// City / State
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// Interiors
                                  Container(
                                    child: Text(Strings.state,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  _fieldState(),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Esteriors
                                  Container(
                                    child: Text(Strings.city,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  _fieldCity(),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),

                      /// ZipCode / Colonia
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// Interiors
                                  Container(
                                    child: Text(Strings.Colonia,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  _fieldColonia(),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),

                            SizedBox(width: 10,),

                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Esteriors
                                  Container(
                                    child: Text(Strings.zipcode,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 15,),
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  _fieldZipCode(),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),


                      SizedBox(height: 20,),

                      /// Pay
                      SpringButton(
                        SpringButtonType.OnlyScale,
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: CustomColors.blueback,
                            borderRadius: BorderRadius.all(const Radius.circular(10)),
                            border: Border.all(
                              width: 1,
                              color: CustomColors.graybackhome,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: <Widget>[

                                /// languaje
                                Expanded(
                                  child: Container(
                                    child: AutoSizeText(
                                      Strings.paypro,
                                      textScaleFactor: 1.0,
                                      textAlign: TextAlign.center,
                                      //maxLines: 1,
                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 16.0,),
                                      //maxLines: 1,
                                    ),
                                  ),
                                ),

                              ],

                            ),
                          ),
                        ),
                        useCache: false,
                        onTap: (){
                          _validateform(context, (){});
                        },

                        //onTapDown: (_) => decrementCounter(),

                      ),

                      SizedBox(height: 20,),

                    ],
                  ),

                ),

              );

            }

        ),

      ),

    );

  }


  ///Create name field
  Widget _fieldName() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerName,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.names,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create lastname field
  Widget _fieldLastName() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerLastName,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.lastnames,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create email field
  Widget _fieldMail() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerEmail,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.email,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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
  Widget _fieldPhone() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerPhone,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.addemei,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create Address field
  Widget _fieldAddress() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerAddress,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.address,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create Address reference field
  Widget _fieldAddressReference() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerAddressReference,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.addressreference,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create Exterior field
  Widget _fieldExterior() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerExterior,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.exterior,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create interior field
  Widget _fieldInterior() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              controller: _controllerInterior,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.interior,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create zipcode field
  Widget _fieldZipCode() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.lightGrayNumbers,
          border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
        ),

        child: Row(
          children: <Widget>[


            Expanded(
                child: Container(
                  //color: Colors.red,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //maxLength: 13,
                              //enableSuggestions: false,
                              enabled: false,
                              controller: _controllerZipCode,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontFamily: Strings.font_mediumFe,
                                  fontSize: 15,
                                  color: CustomColors.black),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.zipcode,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.graytextimei)

                              ),
                              maxLines: 1,
                              onChanged: (value){

                              },
                              onTap: (){

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

  ///Create colonia field
  Widget _fieldColonia() {
    return InkWell(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        if(singleton.city == ""){
          utils.openSnackBarInfo(context, Strings.searchcities, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
        }else{
          var time = 350;
          if(singleton.isIOS == false){
            time = utils.ValueDuration();
          }
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: ColoniesListados(),
              reverseDuration: Duration(milliseconds: time)
          )).then((value) {
            _controllerColinia.text = singleton.colonia;
            _controllerZipCode.text = singleton.zipcode;
          });
        }

      },

      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(const Radius.circular(14)),
            color: CustomColors.lightGrayNumbers,
            border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
          ),

          child: Row(
            children: <Widget>[


              Expanded(
                  child: Container(
                    //color: Colors.red,
                      margin: EdgeInsets.only(right: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[

                          Expanded(
                            child: Container(
                                child: TextField(
                                  //autofocus: true,
                                  //maxLength: 13,
                                  //enableSuggestions: false,
                                  enabled: false,
                                  controller: _controllerColinia,
                                  //focusNode: _focusNodeQuantity,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontFamily: Strings.font_mediumFe,
                                      fontSize: 15,
                                      color: CustomColors.black),
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      filled: true,
                                      contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                      fillColor: Colors.transparent,
                                      hintText: Strings.Colonia,
                                      hintStyle: TextStyle(
                                          fontFamily: Strings.font_regular,
                                          fontSize: 15,
                                          color: CustomColors.graytextimei)

                                  ),
                                  maxLines: 1,
                                  onChanged: (value){

                                  },
                                  onTap: (){

                                  },

                                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                )
                            ),
                          ),

                          Container(
                            child: Icon(Icons.arrow_drop_down,color: CustomColors.black,),
                          )


                        ],
                      )
                  )
              ),


            ],
          ),
        ),

      ),
    );
  }

  ///Create City field
  Widget _fieldCity() {
    return InkWell(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        if(singleton.state == ""){
          utils.openSnackBarInfo(context, Strings.searchstates, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
        }else{
          var time = 350;
          if(singleton.isIOS == false){
            time = utils.ValueDuration();
          }
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: CitiesListados(),
              reverseDuration: Duration(milliseconds: time)
          )).then((value) {
            _controllerCity.text = singleton.city;
          });
        }

      },
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(const Radius.circular(14)),
            color: CustomColors.lightGrayNumbers,
            border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
          ),

          child: Row(
            children: <Widget>[


              Expanded(
                  child: Container(
                    //color: Colors.red,
                      margin: EdgeInsets.only(right: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[

                          Expanded(
                            child: Container(
                                child: TextField(
                                  //autofocus: true,
                                  //maxLength: 13,
                                  //enableSuggestions: false,
                                  enabled: false,
                                  controller: _controllerCity,
                                  //focusNode: _focusNodeQuantity,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontFamily: Strings.font_mediumFe,
                                      fontSize: 15,
                                      color: CustomColors.black),
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      filled: true,
                                      contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                      fillColor: Colors.transparent,
                                      hintText: Strings.city,
                                      hintStyle: TextStyle(
                                          fontFamily: Strings.font_regular,
                                          fontSize: 15,
                                          color: CustomColors.graytextimei)

                                  ),
                                  maxLines: 1,
                                  onChanged: (value){

                                  },
                                  onTap: (){

                                  },

                                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                )
                            ),
                          ),

                          Container(
                            child: Icon(Icons.arrow_drop_down,color: CustomColors.black,),
                          )


                        ],
                      )
                  )
              ),


            ],
          ),
        ),

      ),
    );
  }

  ///Create State field
  Widget _fieldState() {
    return InkWell(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
        var time = 350;
        if(singleton.isIOS == false){
          time = utils.ValueDuration();
        }
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: StatesListados(),
            reverseDuration: Duration(milliseconds: time)
        )).then((value) {
          _controllerState.text = singleton.state;
          _controllerCity.text = "";
        });
      },
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(const Radius.circular(14)),
            color: CustomColors.lightGrayNumbers,
            border: Border.all(color: CustomColors.lightGrayNumbers, width: 1),
          ),

          child: Row(
            children: <Widget>[


              Expanded(
                  child: Container(
                    //color: Colors.red,
                      margin: EdgeInsets.only(right: 5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[

                          Expanded(
                            child: Container(
                                child: TextField(
                                  //autofocus: true,
                                  //maxLength: 13,
                                  //enableSuggestions: false,
                                  enabled: false,
                                  controller: _controllerState,
                                  //focusNode: _focusNodeQuantity,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontFamily: Strings.font_mediumFe,
                                      fontSize: 15,
                                      color: CustomColors.black),
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      filled: true,
                                      contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                      fillColor: Colors.transparent,
                                      hintText: Strings.state,
                                      hintStyle: TextStyle(
                                          fontFamily: Strings.font_regular,
                                          fontSize: 15,
                                          color: CustomColors.graytextimei)

                                  ),
                                  maxLines: 1,
                                  onChanged: (value){

                                  },
                                  onTap: (){

                                  },

                                  //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                )
                            ),
                          ),

                          Container(
                            child: Icon(Icons.arrow_drop_down,color: CustomColors.black,),
                          )


                        ],
                      )
                  )
              ),


            ],
          ),
        ),

      ),
    );
  }


  ///Validate form
  _validateform(BuildContext context,Function function)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    var number = _controllerPhone.text;

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
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errorName1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerLastName.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errorLastName, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerExterior.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errorexterior, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerInterior.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errorinterior, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerAddress.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.erroradddress, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerEmail.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errorMail, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (EmailValidator.validate(_controllerEmail.text.trim()) == false  ){
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errorMail1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerPhone.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errornotelf, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          } else if (number.length < 10) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.errornotelf1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (singleton.state== "") {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.searchstates, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (singleton.city== "") {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.searchcities, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (singleton.colonia== "") {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.searchcolinia, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else{

            Future.delayed(const Duration(milliseconds: 50), () {
              var tel = _controllerPhone.text;
              tel = tel.replaceAll("-", "");

              singleton.name = _controllerName.text;
              singleton.lastname = _controllerLastName.text;
              singleton.email = _controllerEmail.text;
              singleton.telf = tel;
              singleton.address = _controllerAddress.text;
              singleton.exterior = _controllerExterior.text;
              singleton.interior = _controllerInterior.text;
              singleton.addressreference = _controllerAddressReference.text;


              FocusScope.of(singleton.navigatorKey.currentContext!).requestFocus(new FocusNode());
                var time = 350;
                if(singleton.isIOS == false){
                  time = utils.ValueDuration();
                }
              Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: Payment(idPlan: singleton.idPlan,Plan: singleton.plan,PlanValue: singleton.planvalue,title: Strings.payship,type: "chip",),
              reverseDuration: Duration(milliseconds: time)
              )).then((value) {
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


}

///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderGrid,
        builder: (context,value2,_){

          return AnimatedContainer(
            height: 90,
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
                    /*child: SvgPicture.asset(
                    'assets/images/headernew.svg',
                    fit: BoxFit.fill,

                  ),*/
                    child: Image(
                      image: AssetImage("assets/images/headernew.png"),
                      fit: BoxFit.fill,
                    )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    /// Back
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25, left: 10),
                        child: Container(
                          child: SvgPicture.asset(
                            'assets/images/back.svg',
                            fit: BoxFit.contain,
                            //color: CustomColors.black,
                          ),
                        ),
                      ),
                    ),

                    ///Logo
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        //color: Colors.blue,
                        padding: EdgeInsets.only(top: 35,left: 10),
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
                      ),
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
