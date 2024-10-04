import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gane/src/Models/buyplan.dart';
import 'package:gane/src/Models/creditcardslist.dart';
import 'package:gane/src/Models/notificationslist.dart';
import 'package:gane/src/UI/Notifications/notificationsdetail.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/input_formatters.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_deleteTC.dart';
import 'package:gane/src/Widgets/dialog_deletenotification.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spring_button/spring_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_barcodes/barcodes.dart';


import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:transition/transition.dart';
//import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget{
  final idPlan;
  final Plan;
  final PlanValue;
  final type;
  final title;

  Payment({this.idPlan, this.Plan, this.PlanValue, this.type, this.title});

  @override
  _Payment createState() => new _Payment();

}

class _Payment extends State<Payment>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  final notifierTab = ValueNotifier(0);
  final notifierCashPayment = ValueNotifier(false);
  final notifierTCPayment = ValueNotifier(false);


  var _controllerName = TextEditingController();
  var _controllerNumberCard = TextEditingController();
  var _controllerDateCard = TextEditingController();
  var _controllerCvv = TextEditingController();

  final notifierTapNotification = ValueNotifier(true);
  final notifierTCSelected = ValueNotifier(0);

  int itemdelete = -1;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  var type = "GN";

  final VectorTC = [];

  var date = [];
  var year = "";
  var month = "";
  var name = "";
  var tcnumber = "";
  var cvv = "";
  var cardId = 0;
  ScrollController _scrollController = new ScrollController();
  late InAppWebViewController _webViewController;
  var comprado = "NO";

  BuyPlans copia = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );


  @override
  void initState(){
    singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );
    singleton.tokenTC = "";
    comprado = "NO";

    //launchFetch();
    //notifierCashPayment.value = !notifierCashPayment.value;
    //notifierTCPayment.value = false;
    singleton.notifierCreditCardList.value = TCList(code: 1,message: "No hay nada", status: false, data: DataTCList(items: <ItemsTCList>[] ));
    WidgetsBinding.instance!.addPostFrameCallback((_){

      if(widget.type=="chip"){
        launchFetchTCPayChip();
      }else{
        launchFetchTC();
      }



      print(widget.idPlan);
      print(widget.Plan);
      print(widget.PlanValue);

      Future.delayed(const Duration(seconds: 3), () {
        //pr.update(message: "Consultando Distribuidores");

        _controllerName.text = singleton.notifierUserProfile.value.data!.user!.fullname!;
        print(prefs.authToken);
        //print(Strings.urlBase2+"?planId="+widget.idPlan.toString()+"&token="+prefs.authToken);

      });

      /*singleton.tokenTC ="";
      if(singleton.notifierCreditCardList.value.code == 100){
        cardId = singleton.notifierCreditCardList.value.data!.items![0].id!;
        notifierTCSelected.value=0;
      }else{
        cardId = 0;
      }

      notifierTCPayment.value = !notifierTCPayment.value;
      notifierCashPayment.value = false;

      if(widget.type=="chip"){
        copia = singleton.notifierBuyPlan.value;
        singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );
      }else{
        singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );
      }

      goTop();*/

    });

    super.initState();
  }

  /// Cash recharge
  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        utils.openProgress(context);
        servicemanager.fetchCreatePlan(context, widget.idPlan);
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }

  /// FetchCreditCards recharge
  void launchFetchTC()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        utils.openProgress(context);
        servicemanager.fetchCreditCardsList(context).then((value){

          /*for(int i=0;i<singleton.notifierCreditCardList.value.data!.items!.length ; i++){
            VectorTC.add(Cards(singleton.notifierCreditCardList.value.data!.items![i]));
          }
          print(VectorTC);*/
          if(singleton.notifierCreditCardList.value.code == 100){
            cardId = singleton.notifierCreditCardList.value.data!.items![0].id!;
            notifierTCSelected.value=0;
          }


        });
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }


  /// Cash pay chip
  void launchFetchPayChip()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        utils.openProgress(context);
        servicemanager.fetchCreatePlan(context, widget.idPlan);
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }

  /// FetchCreditCards pay chip
  void launchFetchTCPayChip()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        utils.openProgress(context);
        servicemanager.fetchCreditCardsList(context).then((value){

          /*for(int i=0;i<singleton.notifierCreditCardList.value.data!.items!.length ; i++){
            VectorTC.add(Cards(singleton.notifierCreditCardList.value.data!.items![i]));
          }
          print(VectorTC);*/
          if(singleton.notifierCreditCardList.value.code == 100){
            cardId = singleton.notifierCreditCardList.value.data!.items![0].id!;
            notifierTCSelected.value=0;
          }


        });
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }

  @override
  void dispose() {
    super.dispose();
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
            backgroundColor: CustomColors.graychat,
            body: Stack(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AppBar(context),



                Container(
                  margin: EdgeInsets.only(top: 75),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          margin: EdgeInsets.only(top: 35,left:20),
                          child: Text(Strings.paymethods,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 20,),
                          ),
                        ),

                        SizedBox(height: 20,),

                        /// Cash Payment
                        InkWell(
                          onTap: (){
                            cardId = 0;
                            notifierCashPayment.value = !notifierCashPayment.value;
                            notifierTCPayment.value = false;
                            if(widget.type=="chip"){

                              if(comprado == "NO"){
                                singleton.tokenTC = "";
                                utils.openProgress(context);
                                servicemanager.fetchSendChip(context, singleton.name, singleton.lastname, singleton.email, singleton.telf,singleton.address,
                                    singleton.exterior, singleton.interior,"cash");
                                comprado = "YES";
                              }else{
                                //utils.openSnackBarInfo(context, Strings.compradoCrash, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
                                singleton.notifierBuyPlan.value = copia;
                              }

                            }else{

                              if(comprado == "NO"){
                                singleton.tokenTC = "";
                                comprado = "YES";
                              }else{
                                singleton.notifierBuyPlan.value = singleton.notifierBuyPlan.value;
                              }

                              launchFetch();
                            }

                            goTop();
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child: Column(

                                children: [

                                  /// Item Cash
                                  Row(

                                    children: [

                                      ValueListenableBuilder<bool>(
                                          valueListenable: notifierCashPayment,
                                          builder: (contexts,value2,_){

                                            return SvgPicture.asset(
                                              value2== false ? 'assets/images/btn_radial_btn1.svg' : 'assets/images/btn_radial_btn.svg',
                                              fit: BoxFit.contain,
                                            );

                                          }

                                      ),

                                      SizedBox(width: 15,),

                                      Expanded(
                                        child: Container(
                                            child: AutoSizeText(
                                              Strings.cash,
                                              textAlign: TextAlign.left,
                                              textScaleFactor: 1.0,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 16.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                              //maxLines: 1,
                                            )
                                        ),
                                      ),

                                    ],

                                  ),

                                  ValueListenableBuilder<BuyPlans>(
                                      valueListenable: singleton.notifierBuyPlan,
                                      builder: (context,value,_){

                                        return value.code==1 || value.code==102 || value.code==120 ? Container():
                                        Container(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [

                                              SizedBox(height: 15,),

                                              /// Reference info
                                              RichText(
                                                textScaleFactor: 1.0,
                                                text: new TextSpan(
                                                  // Note: Styles for TextSpans must be explicitly defined.
                                                  // Child text spans will inherit styles from parent
                                                  style: new TextStyle(
                                                    fontSize: 12.0,
                                                    //color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    new TextSpan(text: Strings.textpayment,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                                    )),
                                                    new TextSpan(text: widget.PlanValue,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                                    )),
                                                    new TextSpan(text: Strings.textpayment1,style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.grayalert1, fontSize: 12.0,
                                                    )),

                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: 15,),
                                              /// steps
                                              Container(
                                                  child: AutoSizeText(
                                                    Strings.steps,
                                                    textAlign: TextAlign.left,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                    //maxLines: 1,
                                                  )
                                              ),

                                              SizedBox(height: 15,),
                                              /// steps
                                              Container(
                                                  child: AutoSizeText(
                                                    Strings.steps1,
                                                    textAlign: TextAlign.left,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                    //maxLines: 1,
                                                  )
                                              ),

                                              SizedBox(height: 10,),
                                              /// steps
                                              Container(
                                                  child: AutoSizeText(
                                                    Strings.steps2,
                                                    textAlign: TextAlign.left,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                    //maxLines: 1,
                                                  )
                                              ),

                                              SizedBox(height: 10,),
                                              /// steps
                                              Container(
                                                  child: AutoSizeText(
                                                    Strings.steps3,
                                                    textAlign: TextAlign.left,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                    //maxLines: 1,
                                                  )
                                              ),


                                              SizedBox(height: 35,),

                                              /// Name & reason charge
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children: [

                                                    /// Name
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          /// Name
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.name1,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 1,
                                                                style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                          /// User name
                                                          Container(
                                                              child: AutoSizeText(
                                                                value.data!.item!.fullname!,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 2,
                                                                style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                        ],

                                                      ),
                                                    ),

                                                    SizedBox(width: 15,),

                                                    /// reason charge
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          /// reason charge
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.reaseoncharge,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 1,
                                                                style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                          /// reason charge
                                                          Container(
                                                              child: AutoSizeText(
                                                                widget.Plan,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 2,
                                                                style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                        ],

                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),

                                              SizedBox(height: 15,),

                                              /// Paymethod & Order id
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children: [

                                                    /// Paymethod
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          /// Name
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.paymethods1,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 1,
                                                                style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                          /// Paymethod
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.cash,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 2,
                                                                style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                        ],

                                                      ),
                                                    ),

                                                    SizedBox(width: 15,),

                                                    /// Order id
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          /// orderid
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.orderid,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 1,
                                                                style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                          /// orderid
                                                          Container(
                                                              child: AutoSizeText(
                                                                value.data!.item!.order!,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 2,
                                                                style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                        ],

                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),

                                              SizedBox(height: 15,),

                                              /// Bussiness & Expiration date
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                  children: [

                                                    /// business
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          /// business
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.business,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 1,
                                                                style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                          /// business
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.business1,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 2,
                                                                style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                        ],

                                                      ),
                                                    ),

                                                    SizedBox(width: 15,),

                                                    /// expirationdate
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [

                                                          /// rexpirationdate
                                                          Container(
                                                              child: AutoSizeText(
                                                                Strings.expirationdate,
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 1,
                                                                style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                          /// expirationdate
                                                          Container(
                                                              child: AutoSizeText(
                                                                timsStamToDate(value.data!.item!.expiresAt!),
                                                                textAlign: TextAlign.left,
                                                                textScaleFactor: 1.0,
                                                                maxLines: 2,
                                                                style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                                                //maxLines: 1,
                                                              )
                                                          ),

                                                        ],

                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),

                                              SizedBox(height: 25,),

                                              /// paymentid
                                              Container(
                                                  child: AutoSizeText(
                                                    Strings.paymentid,
                                                    textAlign: TextAlign.left,
                                                    textScaleFactor: 1.0,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 12.0,fontFamily: Strings.font_medium, color: CustomColors.grayalert1,),
                                                    //maxLines: 1,
                                                  )
                                              ),

                                              SizedBox(height: 15,),

                                              ///paymentid number
                                              Center(
                                                  child: Container(
                                                    height: 200,
                                                    child: SfBarcodeGenerator(
                                                      value:  value.data!.item!.reference!,
                                                      //symbology: QRCode(),
                                                    ),
                                                  )
                                              ),
                                              SizedBox(height: 20,),

                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: CustomColors.graychat,
                                                  borderRadius: BorderRadius.all(const Radius.circular(15)),
                                                ),
                                                child: Container(
                                                    margin: EdgeInsets.all(15),
                                                    child: AutoSizeText(
                                                      value.data!.item!.reference!,
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: 1.0,
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_semibold, color: CustomColors.black,),
                                                      //maxLines: 1,
                                                    )
                                                ),

                                              ),

                                              SizedBox(height: 25,),


                                              ///Continue
                                              Container(
                                                child: SpringButton(
                                                  SpringButtonType.OnlyScale,
                                                  Container(
                                                    margin: EdgeInsets.only(left:30,right: 30 ),
                                                    height: 40,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color:CustomColors.orangeswitch,
                                                        borderRadius: BorderRadius.all(const Radius.circular(6))
                                                    ),
                                                    child: Center(
                                                        child: Row(

                                                          children: [

                                                            /// Text
                                                            Expanded(
                                                              child: Container(
                                                                //color: Colors.blue,
                                                                child: Text(Strings.savecontinue,
                                                                    textAlign: TextAlign.center,
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(
                                                                        fontFamily: Strings.font_semibold,
                                                                        fontSize: 13,
                                                                        letterSpacing: 0.5,
                                                                        color: CustomColors.white)
                                                                ),
                                                              ),
                                                            )

                                                          ],

                                                        )
                                                    ),
                                                  ),
                                                  useCache: false,
                                                  onTap: (){
                                                    FlutterClipboard.copy(value.data!.item!.reference!).then(( value ) => print('copied'));
                                                    utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, Strings.copyred, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

                                                  },
                                                ),
                                              ),

                                              SizedBox(height: 5,),

                                            ],

                                          ),

                                        );

                                      }

                                  ),

                                ],

                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 25,),

                        /// TC payment
                        Card(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            // margin: EdgeInsets.all(20),
                            margin: EdgeInsets.only(top: 20,bottom: 20,),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: [

                                /// Item TC
                                InkWell(
                                  onTap: (){
                                    //print("Url Web Conekta: " + widget.type == "chip" ? Strings.urlBase3 : Strings.urlBase2 +"?planId="+widget.idPlan.toString()+"&token="+prefs.authToken);

                                    singleton.tokenTC ="";
                                    if(singleton.notifierCreditCardList.value.code == 100){
                                      cardId = singleton.notifierCreditCardList.value.data!.items![0].id!;
                                      notifierTCSelected.value=0;
                                    }else{
                                      cardId = 0;
                                    }

                                    notifierTCPayment.value = !notifierTCPayment.value;
                                    notifierCashPayment.value = false;

                                    if(widget.type=="chip"){
                                      copia = singleton.notifierBuyPlan.value;
                                      singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );
                                    }else{
                                      singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );
                                    }

                                    goTop();

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20,right: 20,),
                                    child: Row(

                                      children: [

                                        ValueListenableBuilder<bool>(
                                            valueListenable: notifierTCPayment,
                                            builder: (contexts,value2,_){

                                              return SvgPicture.asset(
                                                value2== false ? 'assets/images/btn_radial_btn1.svg' : 'assets/images/btn_radial_btn.svg',
                                                fit: BoxFit.contain,
                                              );

                                            }

                                        ),

                                        SizedBox(width: 15,),

                                        Expanded(
                                          child: Container(
                                              child: AutoSizeText(
                                                Strings.tc,
                                                textAlign: TextAlign.left,
                                                textScaleFactor: 1.0,
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 16.0,fontFamily: Strings.font_semibold, color: Colors.black,),
                                                //maxLines: 1,
                                              )
                                          ),
                                        ),

                                      ],

                                    ),
                                  ),
                                ),

                                /// TC List
                                ValueListenableBuilder<bool>(
                                    valueListenable: notifierTCPayment,
                                    builder: (context,value,_){
                                      return value == false ? Container() :
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 600,
                                          //color: Colors.red,
                                          child: InAppWebView(

                                            initialOptions: InAppWebViewGroupOptions(
                                              crossPlatform: InAppWebViewOptions(

                                                //javaScriptCanOpenWindowsAutomatically: true,mediaPlaybackRequiresUserGesture: true, clearCache: true
                                                  javaScriptEnabled: true, useShouldOverrideUrlLoading: true, javaScriptCanOpenWindowsAutomatically:true,clearCache: true

                                              ),
                                              android: AndroidInAppWebViewOptions(
                                                // on Android you need to set supportMultipleWindows to true,
                                                // otherwise the onCreateWindow event won't be called
                                                supportMultipleWindows: true,
                                                needInitialFocus: true,
                                                useHybridComposition: true,
                                              ),
                                              ios: IOSInAppWebViewOptions(
                                                suppressesIncrementalRendering: true,

                                              ),

                                            ),

                                            onWebViewCreated: (InAppWebViewController controller) {
                                              _webViewController = controller;

                                              _webViewController.addJavaScriptHandler(handlerName:'flutter', callback: (args) {

                                                notifierCashPayment.value = false;
                                                notifierTCPayment.value = false;
                                                utils.openProgress(singleton.navigatorKey.currentContext!);

                                                print(args);
                                                var args1 = args[0].toString();
                                                print(args1);
                                                var enco = json.encode(args1);
                                                enco = enco.replaceAll('\\"', '"');
                                                enco = enco.replaceAll('"{', '{');
                                                enco = enco.substring(0, enco.length - 1);
                                                print(enco);
                                                var decode = json.decode(enco);
                                                print(decode);

                                                if(decode["type"]=="error"){
                                                  notifierCashPayment.value = false;
                                                  notifierTCPayment.value = false;

                                                  if(enco.contains("message")){
                                                    utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, decode["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
                                                    //utils.stopLoading();
                                                    Future.delayed(const Duration(milliseconds: 3700), () {
                                                      Navigator.pop(singleton.navigatorKey.currentContext!);
                                                    });
                                                  }else{
                                                    utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, "La tarjeta no ha sido encontrada" , "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
                                                    //utils.stopLoading();
                                                    Future.delayed(const Duration(milliseconds: 3700), () {
                                                      Navigator.pop(singleton.navigatorKey.currentContext!);
                                                    });
                                                  }
                                                }else{

                                                  if(widget.type=="chip"){
                                                    singleton.tokenTC = decode["id"]!;
                                                    servicemanager.fetchSendChip(context, singleton.name, singleton.lastname, singleton.email, singleton.telf,singleton.address,
                                                        singleton.exterior, singleton.interior,"tc").then((value) {
                                                      notifierCashPayment.value = false;
                                                      notifierTCPayment.value = false;
                                                      //utils.stopLoading();
                                                      /*Future.delayed(const Duration(milliseconds: 3700), () {
                                                          Navigator.pop(singleton.navigatorKey.currentContext!);
                                                        });*/
                                                    });

                                                  }else{
                                                    utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, decode["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
                                                    servicemanager.fetchUserProfile1(context);
                                                    servicemanager.fetchSettings(context);
                                                    servicemanager.fetchPointUserPoints(context);
                                                    servicemanager.fetchListPointsUser1(context, "borrar");
                                                    servicemanager.fetchValidateSegmentation(context);


                                                    Future.delayed(const Duration(milliseconds: 3700), () {
                                                      Navigator.pop(singleton.navigatorKey.currentContext!);
                                                      Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 4,)) );
                                                    });
                                                  }

                                                }


                                              });

                                            },
                                            onLoadStart:  (controller, consoleMessage) {
                                              print(consoleMessage);
                                            },

                                            onConsoleMessage: (controller, consoleMessage) {
                                              print(consoleMessage);
                                            },

                                            onUpdateVisitedHistory: (controller, url, androidIsReload) {
                                              print(url);
                                            },

                                            //initialUrlRequest: URLRequest(url: Uri.parse( widget.type == "chip" ? Strings.urlBase3 : Strings.urlBase2 +"?planId="+widget.idPlan.toString()+"&token="+prefs.authToken)),
                                            initialUrlRequest: URLRequest(url: WebUri(widget.type == "chip" ? Strings.urlBase3 : Strings.urlBase2 +"?planId="+widget.idPlan.toString()+"&token="+prefs.authToken)),

                                          )
                                      );
                                    }

                                ),


                              ],

                            ),
                          ),
                        ),

                        SizedBox(height: 25,),

                      ],
                    ),
                  ),
                ),


              ],
            ),
          );
        }
      },
    );
  }

  /// AppBar
  Widget AppBar(BuildContext context){
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
                  widget.title,
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

  /// Item Credit Card
  Widget Cards(ItemsTCList item, int index){

    return InkWell(
      onTap: (){

        cardId = singleton.notifierCreditCardList.value.data!.items![index].id!;
        notifierTCSelected.value=index;
        /*date = _controllerDateCard.text.split("/");
        year = date[1];
        month = date[0];
        name = _controllerName.text.replaceAll(" ", "%20");
        tcnumber = _controllerNumberCard.text.replaceAll("-", "");
        cvv = _controllerCvv.text;*/

      },
      child: ValueListenableBuilder<int>(
          valueListenable: notifierTCSelected,
          builder: (context,value2,_){

            return Container(
              //padding: EdgeInsets.only(left: 20,bottom: 10),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: CustomColors.bonusback,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: value2==index ? CustomColors.greenbutton : Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[

                      /// Delete botton
                      InkWell(
                        onTap: (){
                          notifierTCSelected.value=index;
                          dialogDleteTC(context, deleteTC);
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            //color: Colors.red,
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(top: 10,right: 10),
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: SvgPicture.asset(
                                'assets/images/iconobasurero.svg',
                                fit: BoxFit.contain,
                                color: CustomColors.grayalert,
                              ),
                            ),
                          ),
                        ),
                      ),

                      ///Data
                      Container(
                        //color: Colors.red,
                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 15,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            ///Image
                            Container(
                              width: 40,
                              height: 40,
                              child: Image(
                                width: 40,
                                height: 40,
                                image: AssetImage('assets/images/'+item.franchise!+".png",),
                                fit: BoxFit.contain,
                              ),
                            ),

                            ///Data
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  //color:Colors.green,
                                  child: Container(
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: <Widget>[

                                        ///Name
                                        Container(
                                          //color: Colors.blue,
                                          child: AutoSizeText(
                                            item.franchise!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_bold, color: CustomColors.textcolor,),
                                            //maxLines: 1,
                                          ),
                                        ),

                                        ///Count
                                        Container(
                                          //color: Colors.yellow,
                                          child: AutoSizeText(
                                            "**** **** **** "+item.cardNumber!,
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 15.0,fontFamily: Strings.font_medium, color: CustomColors.textcolor,),
                                            //maxLines: 1,
                                          ),
                                        ),


                                      ],

                                    ),
                                  ),

                                ),
                              ),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                    ],

                  ),
                )
            );

          }

      ),
    );

  }

  /// Go to top table scroll
  void goTop(){
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  /// fetch Delete TC
  void deleteTC(BuildContext context)async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        utils.openProgress(context);
        servicemanager.fetchDeleteTC(context,singleton.notifierCreditCardList.value.data!.items![notifierTCSelected.value]!.id!.toString()).then((value){
          launchFetchTC();
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }
  }

  /// Change timestamp to date
  String  timsStamToDate(String time){

    var date = "";

    var timestamp1 = int.parse(time); // timestamp in seconds
    final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1 * 1000);
    print(date1);

    date = DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(DateTime.fromMillisecondsSinceEpoch(timestamp1 * 1000));
    //DateTime sdate = DateTime.parse(date1);
    //var millis = 978296400000;
    //var dt = DateTime.fromMillisecondsSinceEpoch(millis);

    date = DateFormat.yMMMMd(ui.window.locale.toLanguageTag().toString()).format(date1);
    var hour = DateFormat.Hm(ui.window.locale.toLanguageTag().toString()).format(date1);
// 12 Hour format:
    var d12 = DateFormat('MM/dd/yyyy, hh:mm a').format(date1); // 12/31/2000, 10:00 PM

// 24 Hour format:
    var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(date1) ;

    return date+ " a las " + hour;

  }


  ///Create Name field
  Widget _fieldName() {
    return Container(
      //padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.greybackSMS,
        ),

        child: Row(
          children: <Widget>[

            Expanded(
                child: Container(
                  //color: Colors.lightBlueAccent,
                    margin: EdgeInsets.only(right: 5),
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
                                  fontFamily: Strings.font_regularFe,
                                  fontSize: 15,
                                  color: CustomColors.grayalert1),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.name,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regularFe,
                                      fontSize: 15,
                                      color: CustomColors.grayalert1.withOpacity(0.6))

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
      ),

    );
  }

  ///Create TC number field
  Widget _fieldTCnumber() {
    return Container(
      //padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.greybackSMS,
        ),

        child: Row(
          children: <Widget>[

            Expanded(
                child: Container(
                  //color: Colors.lightBlueAccent,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //enableSuggestions: false,
                              controller: _controllerNumberCard,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(16),
                                new CardNumberInputFormatter()
                              ],
                              style: TextStyle(
                                  fontFamily: Strings.font_regularFe,
                                  fontSize: 15,
                                  color: CustomColors.grayalert1),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.tcnumber1,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regularFe,
                                      fontSize: 15,
                                      color: CustomColors.grayalert1.withOpacity(0.5))

                              ),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              textInputAction: TextInputAction.done,
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
      ),

    );
  }

  ///Create Date field
  Widget _fieldDate() {
    return Container(
      //padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.greybackSMS,
        ),

        child: Row(
          children: <Widget>[

            Expanded(
                child: Container(
                  //color: Colors.lightBlueAccent,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //enableSuggestions: false,
                              controller: _controllerDateCard,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(6),
                                new CardMonthInputFormatter()
                              ],
                              style: TextStyle(
                                  fontFamily: Strings.font_regularFe,
                                  fontSize: 15,
                                  color: CustomColors.grayalert1),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.datetc1,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regularFe,
                                      fontSize: 15,
                                      color: CustomColors.grayalert1.withOpacity(0.6))

                              ),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              textInputAction: TextInputAction.done,
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
      ),

    );
  }

  ///Create Cvv field
  Widget _fieldCVV() {
    return Container(
      //padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.greybackSMS,
        ),

        child: Row(
          children: <Widget>[

            Expanded(
                child: Container(
                  //color: Colors.lightBlueAccent,
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: <Widget>[


                        Container(
                            child: TextField(
                              //autofocus: true,
                              //enableSuggestions: false,
                              controller: _controllerCvv,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                new LengthLimitingTextInputFormatter(3),
                              ],
                              style: TextStyle(
                                  fontFamily: Strings.font_regularFe,
                                  fontSize: 15,
                                  color: CustomColors.grayalert1),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.cvv1,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regularFe,
                                      fontSize: 15,
                                      color: CustomColors.grayalert1.withOpacity(0.6))

                              ),
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              textInputAction: TextInputAction.done,
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
      ),

    );
  }

  ///Pay with TC
  _validateMailCode(BuildContext context)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');


        date = [];
        year = "";
        month = "";
        name = "";
        tcnumber = "";
        cvv = "";


        if (_controllerName.text.trim().isEmpty) {
          utils.openSnackBarInfo(context, Strings.emptyname, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        }else if (_controllerNumberCard.text.trim().isEmpty) {
          utils.openSnackBarInfo(context, Strings.emptytcnumber, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        }else if (_controllerDateCard.text.trim().isEmpty) {
          utils.openSnackBarInfo(context, Strings.emptydate, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        }else if (_controllerCvv.text.trim().isEmpty) {
          utils.openSnackBarInfo(context, Strings.emptycvv, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        }else{

          date = _controllerDateCard.text.split("/");
          year = date[1];
          month = date[0];
          name = _controllerName.text.replaceAll(" ", "%20");
          tcnumber = _controllerNumberCard.text.replaceAll("-", "");
          cvv = _controllerCvv.text;

          Future.delayed(const Duration(milliseconds: 50), () {

            utils.openProgress(context);
            servicemanager.fetchPaymentCreditCard(context, widget.idPlan, name, tcnumber, month, year,cvv, notifierTapNotification.value).then((value){
              if(value==100){
                Future.delayed(const Duration(milliseconds: 1500), () {
                  Navigator.pop(singleton.navigatorKey.currentContext!);
                });
              }
            });


          });

        }



      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      ConnectionStatusSingleton.getInstance().checkConnection();
    }



  }

  ///Pay with TC saved
  _validatePayWithTC(BuildContext context)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');


        if (cardId==0) {
          utils.openSnackBarInfo(context, Strings.errorTC, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        }else{

          Future.delayed(const Duration(milliseconds: 50), () {
            utils.openProgress(context);
            servicemanager.fetchPaymentCreditCardSaved(context, widget.idPlan,cardId).then((value){
              if(value==100){
                Future.delayed(const Duration(milliseconds: 1500), () {
                  Navigator.pop(singleton.navigatorKey.currentContext!);
                });
              }
            });
          });

        }



      }


    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      ConnectionStatusSingleton.getInstance().checkConnection();
    }



  }



}





