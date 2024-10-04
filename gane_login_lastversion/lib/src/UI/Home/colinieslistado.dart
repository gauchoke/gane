import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Models/citieslist.dart';
import 'package:gane/src/Models/colinieslist.dart';
import 'package:gane/src/Models/countries.dart';

import 'package:flutter/material.dart';
import 'package:gane/src/Models/states.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/backHandle.dart';


class ColoniesListados extends StatefulWidget{

  final from;

  ColoniesListados({this.from});

  _stateColoniesListados createState()=> _stateColoniesListados();
}

class _stateColoniesListados extends State<ColoniesListados> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;
  var _controllerSearchBar = TextEditingController();


  @override
  void initState(){

    WidgetsBinding.instance!.addPostFrameCallback((_){
      Future.delayed(const Duration(milliseconds: 450), () {
        singleton.notifierColiniesListSearch.value = colonList(code: 1,message: "No hay nada", status: false, data: DatacolonList(colonies:<Colonies>[] ) );
        launchFetch();
      });

    });

    super.initState();
  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        //utils.openProgress(context);
        servicemanager.fetchColonias(context,singleton.state,singleton.city);

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
      color: CustomColors.orangeback1,

      child: Stack(

        children: [

          Container(
            height: MediaQuery.of(context).size.height - 80,
            margin: EdgeInsets.only(top: 80),
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

              children: [



                /// Seach Text
                Container(
                  padding: EdgeInsets.only(top: 20,left: 10, right: 10),
                  /*child: Text(Strings.search1,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 15,),
                  ),*/
                  child: Row(
                    children: [

                      ///Icon
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: SvgPicture.asset(
                            'assets/images/back.svg',
                            fit: BoxFit.contain,
                            color: CustomColors.greyplaceholder
                            ,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text(Strings.searchcities,
                            textAlign: TextAlign.left,
                            textScaleFactor: 1.0,
                            style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 15,),
                          ),
                        ),
                      )

                    ],

                  ),
                ),

                ///SearchBar
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                  alignment: Alignment.topCenter,
                  //color: Colors.red,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.all(const Radius.circular(10)),
                      border: Border.all(
                        width: 1,
                        color: CustomColors.graysearch,
                      ),
                    ),
                    child: SearchBar(context),
                  ),
                ),

                ///Table
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(top: 20,left: 30,right: 30),
                      //height: 250,
                      width: double.infinity,
                      child: ValueListenableBuilder<colonList>(
                          valueListenable: singleton.notifierColiniesListSearch,
                          builder: (context,value,_){

                            return ListView.builder(
                              padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                              scrollDirection: Axis.vertical,
                              itemCount: value.code== 1 ? 10 : value.data!.colonies!.length,
                              itemBuilder: (BuildContext context, int index){

                                return value.code==1 ? utils.PreloadRefarreal() :
                                InkWell(
                                  onTap: (){
                                    singleton.colonia = value.data!.colonies![index]!.name!;
                                    print(singleton.colonia);
                                    singleton.zipcode = value.data!.colonies![index]!.zipCode!;
                                    print(singleton.zipcode);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    //color:Colors.red,

                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[

                                        Container(
                                          //color:Colors.yellow,
                                          margin: EdgeInsets.only(top: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,

                                            children: <Widget>[

                                              ///Title
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(right: 10,),
                                                  child: Text(value.data!.colonies![index]!.name!,
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontFamily: Strings.font_regular,
                                                          fontSize:17,
                                                          color: CustomColors.black),
                                                      textAlign: TextAlign.start),
                                                ),
                                              ),

                                            ],

                                          ),
                                        ),

                                        ///Line
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          height: 1,
                                          color: CustomColors.grayunselected,
                                        )

                                      ],

                                    ),

                                  ),
                                );

                              },

                            );

                          }

                      )

                  ),
                ),


              ],

            ),

          )


        ],

      ),

    );
  }

  ///SearchBar
  Widget SearchBar(BuildContext context){

    return Row(
      children: <Widget>[

        ///Icon
        Container(
          padding: EdgeInsets.only(left: 15),
          child: SvgPicture.asset(
              'assets/images/ic_search.svg',
              fit: BoxFit.contain
          ),
        ),

        ///search
        Expanded(
            child: Container(
              //color: Colors.yellow,
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: <Widget>[
                    Visibility(
                      //visible: _showPwd ? false : true,
                        child: TextField(
                          enableSuggestions: false,
                          //key: Key('txfSearchBar'),
                          controller: _controllerSearchBar,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              //contentPadding: EdgeInsets.only(left: 7, top: 7, bottom: 7),
                              fillColor: Colors.transparent,
                              hintText: Strings.search,
                              hintStyle: TextStyle(
                                  fontFamily: Strings.font_medium,
                                  fontSize: 15,
                                  color: CustomColors.grayplacesearch)),
                          style: TextStyle(
                              fontFamily: Strings.font_medium,
                              fontSize: 15,
                              color: CustomColors.graytext1),
                          maxLines: 1,
                          //onChanged: _onMessageChanged,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          onSubmitted: (term){
                            print(term);
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          onChanged: _onMessageChanged,
                          textInputAction: TextInputAction.search,
                          autocorrect: false,

                        )),
                  ],
                )
            )
        ),

      ],
    );

  }

  ///Search country
  void _onMessageChanged(String value) {


    if (value.trim().isEmpty) {

      FocusScope.of(context).requestFocus(new FocusNode());

      singleton.notifierColiniesListSearch.value = colonList(code: 1,message: "No hay nada", status: false, data: DatacolonList(colonies:<Colonies>[] ) );
      singleton.notifierColiniesListSearch.value = singleton.notifierColiniesList.value;
      return;

    }else{


      singleton.notifierColiniesListSearch.value = colonList(code: 100,message: "No hay nada", status: false, data: DatacolonList(colonies:<Colonies>[] ) );
      List<Colonies>? data = [] ;

      for (int i = 0; i < singleton.notifierColiniesList.value.data!.colonies!.length ; i++) {
        var country = singleton.notifierColiniesList.value.data!.colonies![i]!.name!.toLowerCase();
        country = utils.changeAccents(country);

        var myvalue =  value.toLowerCase();
        myvalue = utils.changeAccents(myvalue);

        if (country.contains(myvalue)){
          data?.add(singleton.notifierColiniesList.value.data!.colonies![i]);
          print("");
        }
      }

      singleton.notifierColiniesListSearch.value.data!.colonies = data;
      return;
    }



  }




}