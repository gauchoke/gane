import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gane/src/Models/buyplan.dart';
import 'package:gane/src/Models/planescompra.dart';
import 'package:gane/src/UI/Home/RechargePlain/buyplan.dart';
import 'package:gane/src/UI/Home/RechargePlain/paymethods.dart';
import 'package:gane/src/UI/Home/completeprof.dart' as widget;
import 'package:gane/src/UI/Home/formpidechip.dart';
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

class RechargePlainView extends StatefulWidget{
  @override
  _RechargePlainViewState createState() => _RechargePlainViewState();
}

class _RechargePlainViewState extends State<RechargePlainView> {
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState(){

    WidgetsBinding.instance!.addPostFrameCallback((_){
      launchFetch();
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
          return  value2 == true ? Nointernet() :Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appBar(),
                Container(
                  margin: EdgeInsets.only(top: 35,left:20),
                  child: Text(Strings.checkPlans,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: Strings.font_semiboldFe, color: CustomColors.black, fontSize: 20,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left:20,bottom: 35),
                  child: Text(Strings.choseLike,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: Strings.font_regularFe, color: CustomColors.backBlackWin, fontSize: 16,),
                  ),
                ),
                /*InkWell(
                  onTap: (){
                    utils.callOrWebView("https://api.whatsapp.com/send?phone=5215585263805&text=Gane%20Moni%20500MB%20por%20\$30");
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                      child:  SvgPicture.asset("assets/images/ic_plan_one.svg",),
                  ),
                ),
                InkWell(
                  onTap: (){
                    utils.callOrWebView("https://api.whatsapp.com/send?phone=5215585263805&text=Gane%20Moni%202GB%20por%20\$80");
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                    child:  SvgPicture.asset("assets/images/ic_plan_two.svg",),
                  ),
                ),
                InkWell(
                  onTap: (){
                    utils.callOrWebView("https://api.whatsapp.com/send?phone=5215585263805&text=Gane%20Moni%205GB%20por%20\$125");
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                    child:  SvgPicture.asset("assets/images/ic_plan_three.svg",),
                  ),
                )*/
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      //height: 250,
                      width: double.infinity,
                      child: ValueListenableBuilder<PlanesCompra>(
                          valueListenable: singleton.notifierlanesCompra,
                          builder: (context,value,_){

                            return ListView.builder(
                              padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                              scrollDirection: Axis.vertical,
                              itemCount: value.code == 1 ? 5 : value.code == 102 ? 0 : value.code == 120 ? 0 : value.data!.items!.length,
                              itemBuilder: (BuildContext context, int index){

                                if(value.code == 1 ){
                                  return utils.PreloadBanner();

                                }else if(value.code == 102 ){
                                  return utils.emptyHome(value.message!, "", "assets/images/emptyhome.svg");

                                }else{
                                  return InkWell(
                                    onTap: (){

                                      //Navigator.push(singleton.navigatorKey.currentContext!, Transition(child: BuyPlan(url: value.data!.items![index]!.url!, title: value.data!.items![index]!.name!,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

                                      singleton.idPlan = value.data!.items![index]!.id!;
                                      singleton.plan = value.data!.items![index]!.name!;
                                      singleton.planvalue = value.data!.items![index]!.price!.toString();
                                      singleton.notifierBuyPlan.value = BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() );

                                      var time = 350;
                                      if(singleton.isIOS == false){
                                        time = utils.ValueDuration();
                                      }

                                      /*Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time),
                                          child: Payment(idPlan: value.data!.items![index]!.id!,Plan: value.data!.items![index]!.name!,PlanValue: value.data!.items![index]!.price!.toString(),title: Strings.rechargeAccount,),
                                          reverseDuration: Duration(milliseconds: time)
                                      )).then((value) {
                                        if(value=="relaunch"){
                                        }

                                      });*/

                                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time),
                                          child: RechargePlainViewForm(),
                                          reverseDuration: Duration(milliseconds: time)
                                      )).then((value) {
                                        if(value=="relaunch"){
                                        }

                                      });

                                      },
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                      //child:  SvgPicture.asset(value.data!.items![index]!.photoUrl!,),
                                      child: Image.network(
                                        value.data!.items![index]!.photoUrl!,
                                          // "https://i.pinimg.com/originals/b7/5a/71/b75a7117c51def402c60bafcef9e02c5.jpg",
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
                              },
                            );
                          }
                      )
                  ),
                ),
              ],
            ),
          );
        },
    );
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