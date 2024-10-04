import 'dart:io';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/profilecategories.dart';
import 'package:gane/src/Models/profilesubcategories.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/UI/Home/profileDetail.dart';
import 'package:gane/src/UI/Notifications/notifications.dart';
import 'package:gane/src/UI/principalcontainer.dart';
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
import 'package:page_transition/page_transition.dart';
import 'package:spring_button/spring_button.dart';
import 'package:transition/transition.dart';
import 'package:badges/badges.dart' as badges;


class CategoryDetail extends StatefulWidget{

  final category;
  final VoidCallback onAnimationCoin;
  final Result categoryItem;

  CategoryDetail({this.category, required this.onAnimationCoin, required this.categoryItem});

  _stateCategoryDetail createState()=> _stateCategoryDetail();
}

class _stateCategoryDetail extends State<CategoryDetail> with  TickerProviderStateMixin, WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  late StreamSubscription _connectionChangeStream;

  List<Map<String,dynamic>> arrayAwards = [{'title':'Estudios','select':'1'},
    {'title':'Nivel','select':'0'},{'title':'Grado','select':'0'},
    {'title':'Finanzas','select':'0'},{'title':'Trabajo','select':'0'},
  ];

  List<Map<String,dynamic>> arrayQuestions = [{'title':'Tu formación obedece a:','select':'0'},
    {'title':'Selecciona los campos que actualmente te interesan:','select':'0'}
  ];

  List<Map<String,dynamic>> arrayAnswers = [{'title':'Tu formación obedece a:','select':'0'},{'title':'Primaria','select':'0'},
    {'title':'Secundaria','select':'0'},{'title':'Título Profesional','select':'0'},
    {'title':'Técnico','select':'0'},{'title':'Tecnólogo','select':'0'},
    {'title':'Posgrado','select':'0'},{'title':'Ninguno','select':'0'},
  ];

  final controlador = PageController(initialPage: 0);
  var _controllerComment = TextEditingController();
  late AnimationController controllerAnima;
  late Animation<double> animationIn;

  late AnimationController controllerButtons;
  late Animation<double> animationButtons;
  bool callonlyonce = false;

  @override
  void initState(){
    singleton.notifierHeightHeaderWallet1.value = 160.0;

    singleton.notifierCompleteCategory.value = "NO";
    singleton.notifieriTemSubCategory.value = 0;
    singleton.notifieriTemQuestion.value = 0;
    launchFetch();
    controllerAnima = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this,  );
    animationIn = Tween(
        begin: 0.0,
        end: 1.0
    ).animate( controllerAnima);
    controllerAnima.forward();


    controllerButtons = AnimationController(duration: const Duration(milliseconds: 150), vsync: this,  );
    animationButtons = Tween(
        begin: 0.0,
        end: 1.0
    ).animate( controllerButtons);

    Future.delayed(const Duration(milliseconds: 600), () {
      controllerButtons.forward();

    });


    /*controllerAnima.forward().whenComplete(() {

    });*/

    WidgetsBinding.instance!.addPostFrameCallback((_){
      //utils.initUserLocation(context);
      Future.delayed(const Duration(milliseconds: 180), () {
        singleton.notifierHeightViewQuestions.value = MediaQuery.of(context).size.height - 60;
      });


    });

    super.initState();
  }

  void launchFetch()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchSubCategoriesProfile(context,reloadText);
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
    controllerAnima.dispose();
    super.dispose();
  }

  ///Reload textfield
  void reloadText(String value){
    _controllerComment.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                  onWillPop: backHandle.callToast,
                  child: Stack(

                    children: [

                      Scaffold(
                        //resizeToAvoidBottomInset: false,
                        key: _scaffoldKey,
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

                          Container(
                              height: MediaQuery.of(context).size.height,
                              color: CustomColors.graybackwallet,
                              child: Stack(

                                children: [

                                  _fields(context),

                                  AppBar(),

                                ],

                              )
                          ),
                        ),
                      ),

                      /// Pager and Buttons
                      PagerButton(context),

                    ],

                  )
              )
          );

        }

    );
  }

  /// Fields List
  Widget _fields(BuildContext context){

    return Container(
      margin: EdgeInsets.only(top: 160),
      //color: CustomColors.bluebackProfile,

      child: ValueListenableBuilder<double>(
          valueListenable: singleton.notifierHeightViewQuestions,
          builder: (contexts,value2,_){

            return AnimatedContainer(
              //height: value2,
              duration: Duration(milliseconds: 550),
              curve: Curves.fastOutSlowIn,
              //margin: EdgeInsets.only(top: 40,bottom: 10,left: 20,right: 20),
              margin: EdgeInsets.only(top: 20,bottom: 10,left: 20,right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(const Radius.circular(20)),
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

              child: Stack(

                children: [

                  /// Pager and Buttons
                  //PagerButton(context),

                  ///Questions
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,

                    children: [

                      /// header User name and coins
                      Header(context),

                      /// Categories List and Questions
                      Expanded(
                        child: ValueListenableBuilder<Profilesubcategories>(
                            valueListenable: singleton.notifierSubCategoriesProfile,
                            builder: (context,value1,_){

                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(

                                  children: [

                                    /// Label category
                                    /*Container(
                                      padding: EdgeInsets.only(left: 10, right: 10,top: 15),
                                      child: Text(Strings.category,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.graycategory1.withOpacity(0.5), fontSize: 15,),
                                        textScaleFactor: 1.0,
                                      ),
                                    ),*/


                                    /// Category
                                    Container(
                                        //color: Colors.green.withOpacity(0.2),
                                      width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(left: 15, right: 15),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            //mainAxisSize: MainAxisSize.max,
                                            children: [


                                              ///Image icon
                                              Container(
                                                //color: Colors.blue,
                                                child: CachedNetworkImage(
                                                  width: 42,
                                                  height: 42,
                                                  imageUrl: widget.categoryItem.cImages!,
                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                    width: 42,
                                                    height: 42,
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  useOldImageOnUrlChange: false,
                                                  color: widget.categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 :  HexColor(widget.categoryItem.color!) ,
                                                  //color: categoryItem.categoryStatus == "completed" ? CustomColors.graycategory2 : CustomColors.blueBack,

                                                ),
                                              ),

                                              const SizedBox(width: 10,),

                                              Flexible(
                                                child: Container(
                                                  //color: Colors.red,
                                                  child: Text(
                                                    widget.category.toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blueback, fontSize: 26,),
                                                    textScaleFactor: 1.0,
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),


                                      ),

                                    /// Categories List
                                    Container(
                                        height: value1.code == 102 ? 0 : 40,
                                        //color: Colors.red,

                                        child: Stack(

                                          children: [

                                            /// Table
                                            Container(
                                              //color: Colors.red,
                                              child: Center(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.only(top: 0,left: 0,right: 0),
                                                  scrollDirection: Axis.horizontal,
                                                  //itemCount: arrayAwards.length,
                                                  itemCount: value1.code == 1 ? 5 : value1.data!.length,
                                                  itemBuilder: (BuildContext context, int index){

                                                    if(value1.code==1){ ///preloading
                                                      return utils.PreloadingSubCategories();

                                                    }else{/// Item
                                                      return InkWell(
                                                        onTap: (){
                                                          //singleton.notifieriTemSubCategory.value = index;
                                                          //singleton.notifieriTemQuestion.value = 0;
                                                          //PutTextIntoTexfield();
                                                        },
                                                        child: Container(

                                                          child: ValueListenableBuilder(
                                                              valueListenable: singleton.notifieriTemSubCategory,
                                                              builder: (contexts,value,_){

                                                                return Column(
                                                                  mainAxisAlignment: MainAxisAlignment.end,

                                                                  children: [

                                                                    ///Category name
                                                                    Align(
                                                                      alignment: Alignment.bottomCenter,
                                                                      child: Container(
                                                                        //color: Colors.yellow,
                                                                        padding: EdgeInsets.only(left: 10, right: 10,bottom: 5,top: 10),
                                                                        child: Text(value1.data![index]!.name!.toUpperCase(),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(fontFamily: Strings.font_boldFe, color: value == index ? CustomColors.blackquestions : CustomColors.blackquestions, fontSize: 13,),
                                                                          textScaleFactor: 1.0,
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    /// Line select
                                                                    Align(
                                                                      alignment: Alignment.bottomCenter,
                                                                      child: Container(
                                                                        width: 60,
                                                                        height: 2.0,
                                                                        color: value == index ? CustomColors.blueback : Colors.transparent,
                                                                      ),
                                                                    )

                                                                  ],

                                                                );

                                                              }

                                                          ),

                                                        ),
                                                      );
                                                    }


                                                  },

                                                ),
                                              ),
                                            ),

                                            /// Gray line
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                height: 1.0,
                                                color: CustomColors.graycountry,
                                              ),
                                            )

                                          ],

                                        )
                                    ),

                                    ///Questions Table
                                    ValueListenableBuilder<String>(
                                        valueListenable: singleton.notifierCompleteCategory,
                                        builder: (contexts,value,_){

                                          if(value=="YES"){ /// Complete category
                                            return utils.completeCategories();

                                          }else{

                                            return ValueListenableBuilder<int>(
                                                valueListenable: singleton.notifieriTemSubCategory,
                                                builder: (contexts,itemsubcate,_){

                                                  return ValueListenableBuilder<int>( ///  item selected (question)
                                                      valueListenable: singleton.notifieriTemQuestion,
                                                      builder: (contexts,value,_){

                                                        return ListView.builder(
                                                          physics: NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.vertical,
                                                          padding: EdgeInsets.only(top: 20,left: 0,right: 0,),
                                                          //itemCount: value==0 ? arrayAnswers.length + 1 : 2,
                                                          itemCount: value1.code == 1 ? 5 : value1.code == 102 ? 0 : value1.data![itemsubcate]!.questions!.length ==0 ? 0 : value1.data![itemsubcate]!.questions![value]!.answers!.length + 1,
                                                          itemBuilder: (BuildContext context, int index){

                                                            if(value1.code == 1){ /// Preloading
                                                              return utils.PreloadingQuestions();

                                                            }else if(value1.code == 102){ /// No data
                                                              return utils.emptyCategories('assets/images/emptycatego.svg');

                                                            }else{ /// Data x type

                                                              if(value1.data![itemsubcate]!.questions!.length>0){

                                                                if(index==0){

                                                                  /// Question Title
                                                                  return FadeTransition(
                                                                    opacity: controllerAnima,
                                                                    child: Container(
                                                                      padding: EdgeInsets.all(15),
                                                                      child: Text(value1.data![itemsubcate]!.questions![value]!.question!.toUpperCase(),
                                                                        textAlign: TextAlign.left,
                                                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.blackquestions, fontSize: 26,),
                                                                        textScaleFactor: 1.0,
                                                                      ),
                                                                    ),
                                                                  );

                                                                }else{

                                                                  //print("tipo: " + value1.data![itemsubcate]!.questions![value]!.type!.id.toString());
                                                                  if(value1.data![itemsubcate]!.questions![value]!.type!.id == 3){ /// Unique answer

                                                                    return InkWell(
                                                                      onTap: (){


                                                                        if(detectedTap(value1, itemsubcate, value) == true){ /// Lets Tap

                                                                          for( int i = 0; i < value1.data![itemsubcate]!.questions![value]!.answers!.length; i++) {

                                                                            if(i==index-1){

                                                                              if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length > 0){ /// data exist

                                                                                Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                                pre.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.removeAt(0);
                                                                                singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                                singleton.notifierSubCategoriesProfile.value = pre;


                                                                              }else{/// No data exist
                                                                                ProfilesubcategoriesDataQuestionsAnswersAnswersuser item = ProfilesubcategoriesDataQuestionsAnswersAnswersuser(answer: "",check: true,from: "list");
                                                                                Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                                pre.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.add(item);
                                                                                singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                                singleton.notifierSubCategoriesProfile.value = pre;

                                                                              }

                                                                            }else{

                                                                              if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length > 0){ /// data exist

                                                                                Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                                pre.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.removeAt(0);
                                                                                singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                                singleton.notifierSubCategoriesProfile.value = pre;

                                                                              }

                                                                            }

                                                                          }

                                                                        }


                                                                      },
                                                                      child: FadeTransition(
                                                                        opacity: controllerAnima,
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(10),

                                                                          child: Column(

                                                                            children: [

                                                                              Row(

                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                                children: [

                                                                                  ///Check icon
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(left: 10, ),
                                                                                    child: SvgPicture.asset(
                                                                                      value1.data![itemsubcate]!.questions![value]!.answers![index-1]!.answersuser!.length > 0 ? 'assets/images/ic_check.svg' : 'assets/images/ic_lesstext.svg',
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),

                                                                                  /// Question
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                                                      child: Text(value1.data![itemsubcate]!.questions![value]!.answers![index-1]!.answers!,
                                                                                        textAlign: TextAlign.left,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 25,),
                                                                                        textScaleFactor: 1.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),


                                                                                ],

                                                                              ),

                                                                              SizedBox(height: index == value1.data![itemsubcate]!.questions![value]!.answers!.length ? 90 : 0,)

                                                                            ],

                                                                          ),

                                                                        ),
                                                                      ),
                                                                    );

                                                                  }else if(value1.data![itemsubcate]!.questions![value]!.type!.id == 2){ /// True or false answer

                                                                    return InkWell(
                                                                      onTap: (){

                                                                        /*bool maketap = true;
                                                                for (int i = 0; i < value1.data![itemsubcate]!.questions![value]!.answers!.length ; i++) {

                                                                  if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length > 0){

                                                                    if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser![0]!.from == "End"){
                                                                      singleton.notifierMakeTapAnswer.value = false;
                                                                      maketap = false;
                                                                      break;
                                                                    }

                                                                  }

                                                                }*/

                                                                        if(detectedTap(value1, itemsubcate, value) == true){ /// Lets tap

                                                                          for( int i = 0; i < value1.data![itemsubcate]!.questions![value]!.answers!.length; i++) {

                                                                            if(i==index-1){

                                                                              if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length > 0){ /// data exist

                                                                                Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                                pre.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.removeAt(0);
                                                                                singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                                singleton.notifierSubCategoriesProfile.value = pre;


                                                                              }else{/// No data exist
                                                                                ProfilesubcategoriesDataQuestionsAnswersAnswersuser item = ProfilesubcategoriesDataQuestionsAnswersAnswersuser(answer: "",check: true,from: "list");
                                                                                Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                                pre.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.add(item);
                                                                                singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                                singleton.notifierSubCategoriesProfile.value = pre;

                                                                              }

                                                                            }else{

                                                                              if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length > 0){ /// data exist

                                                                                Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                                pre.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.removeAt(0);
                                                                                singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                                singleton.notifierSubCategoriesProfile.value = pre;

                                                                              }

                                                                            }

                                                                          }

                                                                        }

                                                                      },
                                                                      child: FadeTransition(
                                                                        opacity: controllerAnima,
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(10),

                                                                          child: Column(

                                                                            children: [

                                                                              Row(

                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                                children: [

                                                                                  ///Check icon
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(left: 10, ),
                                                                                    child: SvgPicture.asset(
                                                                                      value1.data![itemsubcate]!.questions![value]!.answers![index-1]!.answersuser!.length > 0 ? 'assets/images/ic_check.svg' : 'assets/images/ic_lesstext.svg',
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),

                                                                                  /// Question
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                                                      child: Text(value1.data![itemsubcate]!.questions![value]!.answers![index-1]!.answers!,
                                                                                        textAlign: TextAlign.left,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 25,),
                                                                                        textScaleFactor: 1.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),


                                                                                ],

                                                                              ),

                                                                              SizedBox(height: index == value1.data![itemsubcate]!.questions![value]!.answers!.length ? 90 : 0,)

                                                                            ],

                                                                          ),

                                                                        ),
                                                                      ),
                                                                    );

                                                                  }else if(value1.data![itemsubcate]!.questions![value]!.type!.id == 4){ /// Multiple answer

                                                                    return InkWell(
                                                                      onTap: (){

                                                                        if(detectedTap(value1, itemsubcate, value) == true){/// Lets tap

                                                                          if(value1.data![itemsubcate]!.questions![value]!.answers![index-1]!.answersuser!.length > 0){ /// data exist

                                                                            Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                            pre.data![itemsubcate]!.questions![value]!.answers![index-1]!.answersuser!.removeAt(0);
                                                                            singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                            singleton.notifierSubCategoriesProfile.value = pre;


                                                                          }else{/// No data exist
                                                                            ProfilesubcategoriesDataQuestionsAnswersAnswersuser item = ProfilesubcategoriesDataQuestionsAnswersAnswersuser(answer: "",check: true,from: "list");
                                                                            Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
                                                                            pre.data![itemsubcate]!.questions![value]!.answers![index-1]!.answersuser!.add(item);
                                                                            singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
                                                                            singleton.notifierSubCategoriesProfile.value = pre;

                                                                          }

                                                                        }

                                                                      },
                                                                      child: FadeTransition(
                                                                        opacity: controllerAnima,
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(10),

                                                                          child: Column(

                                                                            children: [

                                                                              Row(

                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                                                children: [

                                                                                  ///Check icon
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(left: 10, ),
                                                                                    child: SvgPicture.asset(
                                                                                      value1.data![itemsubcate]!.questions![value]!.answers![index-1]!.answersuser!.length > 0 ? 'assets/images/ic_check.svg' : 'assets/images/ic_lesstext.svg',
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),

                                                                                  /// Question
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                                                      child: Text(value1.data![itemsubcate]!.questions![value]!.answers![index-1]!.answers!,
                                                                                        textAlign: TextAlign.left,
                                                                                        style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 25,),
                                                                                        textScaleFactor: 1.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),


                                                                                ],

                                                                              ),

                                                                              SizedBox(height: index == value1.data![itemsubcate]!.questions![value]!.answers!.length ? 90 : 0,)

                                                                            ],

                                                                          ),

                                                                        ),
                                                                      ),
                                                                    );

                                                                  }else{ /// Text Answer     ///if(value1.data![itemsubcate]!.questions![value]!.type!.id == 1){ /// Text Answer

                                                                    return FadeTransition(
                                                                      opacity: controllerAnima,
                                                                      child: Column(
                                                                        children: [

                                                                          Card(
                                                                            margin: EdgeInsets.only(left: 20,right: 20),
                                                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                            color: CustomColors.white,
                                                                            elevation: 0,
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(color: CustomColors.graycountry, width: 1),
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),

                                                                            child: Container(
                                                                              height: 120,
                                                                              margin: EdgeInsets.all(10),
                                                                              child: TextField(
                                                                                //enabled: (value1.data![itemsubcate]!.questions![value]!.answers![0]!.answersuser!.length > 0) ? (value1.data![itemsubcate]!.questions![value]!.answers![0]!.answersuser![0]!.from == "list") ? true : false ,
                                                                                enabled: value1.data![itemsubcate]!.questions![value]!.answers![0]!.answersuser!.length > 0 ? value1.data![itemsubcate]!.questions![value]!.answers![0]!.answersuser![0]!.from != "End" ? true : false : true,
                                                                                onEditingComplete: (){
                                                                                  FocusScope.of(context).requestFocus(new FocusNode());
                                                                                },
                                                                                textInputAction: TextInputAction.done,
                                                                                decoration: InputDecoration(
                                                                                  border: InputBorder.none,
                                                                                  filled: true,
                                                                                  //contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                                                                  fillColor: Colors.transparent,
                                                                                  hintText: Strings.writesome,
                                                                                  hintStyle: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.grayTextemptyhome, fontSize: 20,),
                                                                                  counterText: "",
                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 30),
                                                                                  hintMaxLines: 2,
                                                                                ),
                                                                                style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 20,),
                                                                                controller: _controllerComment,
                                                                                maxLines: null,
                                                                                maxLength: 120,
                                                                                expands: true,
                                                                                keyboardType: TextInputType.multiline,

                                                                              ),


                                                                            ),

                                                                          ),

                                                                          Container(
                                                                            alignment: Alignment.bottomRight,
                                                                            padding: EdgeInsets.only(right: 20),
                                                                            child: Text(Strings.maxletters,
                                                                              textAlign: TextAlign.right,
                                                                              style: TextStyle(fontFamily: Strings.font_mediumFe, color: CustomColors.blackquestionsanswers, fontSize: 20,),
                                                                              textScaleFactor: 1.0,
                                                                            ),
                                                                          ),

                                                                          SizedBox(height: 10,)

                                                                        ],
                                                                      ),
                                                                    );

                                                                  }/*else { /// if the category was completed

                                                            return Container(
                                                              height: 150, color: Colors.red,
                                                            );

                                                          }*/

                                                                }


                                                              }else return Container();

                                                            }



                                                          },

                                                        );

                                                      }

                                                  );

                                                }

                                            );

                                          }

                                        }
                                    ),

                                    /*ExpandablePageView.builder(
                                    onPageChanged: _onPageViewChange,
                                    controller: controlador,
                                    animateFirstPage: true,
                                    itemCount: value1.code == 1 ? 5 : value1.code == 102 ? 1 : value1.data![0].questions!.length,
                                    itemBuilder: (context, indexPage) {
                                      /*return Container(
                                        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),height: (index+1)*200,
                                      );*/

                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.only(top: 20,left: 0,right: 0,),
                                        //itemCount: value==0 ? arrayAnswers.length + 1 : 2,
                                        itemCount: value1.code == 1 ? 5 : value1.code == 102 ? 1 : value1.data![0].questions![indexPage].answers!.length + 1,
                                        itemBuilder: (BuildContext context, int index){

                                          if(value1.code == 1){ /// Preloading
                                            return utils.PreloadingQuestions();

                                          }else if(value1.code == 102){ /// No data
                                            return utils.emptyCategories('assets/images/emptycatego.svg');

                                          }else{ /// Data x type

                                            if(index==0){

                                              /// Question Title
                                              return FadeTransition(
                                                opacity: controllerAnima,
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: Text(value1.data![0].questions![indexPage].question!,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 15,),
                                                  ),
                                                ),
                                              );

                                            }else{

                                              if(value1.data![0].questions![indexPage].type!.id == 3){ /// Unique answer

                                                return InkWell(
                                                  onTap: (){
                                                    /*setState(() {
                                                          if(arrayAnswers[index-1]["select"] == "0"){
                                                            arrayAnswers[index-1]["select"] = "1";
                                                          }else{
                                                            arrayAnswers[index-1]["select"] = "0";
                                                          }

                                                        });*/
                                                  },
                                                  child: FadeTransition(
                                                    opacity: controllerAnima,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),

                                                      child: Column(

                                                        children: [

                                                          Row(

                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                            children: [

                                                              ///Check icon
                                                              Container(
                                                                padding: EdgeInsets.only(left: 10, ),
                                                                child: SvgPicture.asset(
                                                                  'assets/images/ic_lesstext.svg',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),

                                                              /// Question
                                                              Expanded(
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                                  child: Text(value1.data![0].questions![indexPage].answers![index-1].answers!,
                                                                    textAlign: TextAlign.left,
                                                                    style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 15,),
                                                                  ),
                                                                ),
                                                              ),


                                                            ],

                                                          ),

                                                          SizedBox(height: index == value1.data![0].questions![indexPage].answers!.length ? 90 : 0,)

                                                        ],

                                                      ),

                                                    ),
                                                  ),
                                                );

                                              }else if(value1.data![0].questions![indexPage].type!.id == 2){ /// Tru or false answer

                                                return InkWell(
                                                  onTap: (){
                                                    /*setState(() {
                                                          if(arrayAnswers[index-1]["select"] == "0"){
                                                            arrayAnswers[index-1]["select"] = "1";
                                                          }else{
                                                            arrayAnswers[index-1]["select"] = "0";
                                                          }

                                                        });*/
                                                  },
                                                  child: FadeTransition(
                                                    opacity: controllerAnima,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),

                                                      child: Column(

                                                        children: [

                                                          Row(

                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                            children: [

                                                              ///Check icon
                                                              Container(
                                                                padding: EdgeInsets.only(left: 10, ),
                                                                child: SvgPicture.asset(
                                                                  'assets/images/ic_lesstext.svg',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),

                                                              /// Question
                                                              Expanded(
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                                  child: Text(value1.data![0].questions![indexPage].answers![index-1].answers!,
                                                                    textAlign: TextAlign.left,
                                                                    style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 15,),
                                                                  ),
                                                                ),
                                                              ),


                                                            ],

                                                          ),

                                                          SizedBox(height: index == value1.data![0].questions![indexPage].answers!.length ? 90 : 0,)

                                                        ],

                                                      ),

                                                    ),
                                                  ),
                                                );

                                              }else if(value1.data![0].questions![indexPage].type!.id == 4){ /// Multiple answer

                                                return InkWell(
                                                  onTap: (){
                                                    /*setState(() {
                                                          if(arrayAnswers[index-1]["select"] == "0"){
                                                            arrayAnswers[index-1]["select"] = "1";
                                                          }else{
                                                            arrayAnswers[index-1]["select"] = "0";
                                                          }

                                                        });*/
                                                  },
                                                  child: FadeTransition(
                                                    opacity: controllerAnima,
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),

                                                      child: Column(

                                                        children: [

                                                          Row(

                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                            children: [

                                                              ///Check icon
                                                              Container(
                                                                padding: EdgeInsets.only(left: 10, ),
                                                                child: SvgPicture.asset(
                                                                  'assets/images/ic_lesstext.svg',
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),

                                                              /// Question
                                                              Expanded(
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                                  child: Text(value1.data![0].questions![indexPage].answers![index-1].answers!,
                                                                    textAlign: TextAlign.left,
                                                                    style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.greyplaceholder, fontSize: 15,),
                                                                  ),
                                                                ),
                                                              ),


                                                            ],

                                                          ),

                                                          SizedBox(height: index == value1.data![0].questions![indexPage].answers!.length ? 90 : 0,)

                                                        ],

                                                      ),

                                                    ),
                                                  ),
                                                );

                                              }else{ /// Text Answer

                                                return FadeTransition(
                                                  opacity: controllerAnima,
                                                  child: Column(
                                                    children: [

                                                      Card(
                                                        margin: EdgeInsets.only(left: 20,right: 20),
                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                        color: CustomColors.white,
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                          side: BorderSide(color: CustomColors.graycountry, width: 1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),

                                                        child: Container(
                                                          height: 120,
                                                          margin: EdgeInsets.all(10),
                                                          child: TextField(

                                                            onEditingComplete: (){
                                                              FocusScope.of(context).requestFocus(new FocusNode());
                                                            },
                                                            textInputAction: TextInputAction.done,
                                                            decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              filled: true,
                                                              //contentPadding: EdgeInsets.only( top: 10, bottom: 10),
                                                              fillColor: Colors.transparent,
                                                              hintText: Strings.writesome,
                                                              hintStyle: TextStyle(
                                                                  fontFamily: Strings.font_regular,
                                                                  fontSize: 15,
                                                                  color: CustomColors.grayTextemptyhome),
                                                              counterText: "",
                                                              contentPadding: EdgeInsets.symmetric(vertical: 30),
                                                              hintMaxLines: 2,
                                                            ),
                                                            style: TextStyle(
                                                                fontFamily: Strings.font_regular,
                                                                fontSize: 15,
                                                                color: CustomColors.grayTextemptyhome),
                                                            controller: _controllerComment,
                                                            maxLines: null,
                                                            maxLength: 120,
                                                            expands: true,
                                                            keyboardType: TextInputType.multiline,

                                                          ),


                                                        ),

                                                      ),

                                                      Container(
                                                        alignment: Alignment.bottomRight,
                                                        padding: EdgeInsets.only(right: 20),
                                                        child: Text(Strings.maxletters,
                                                          textAlign: TextAlign.right,
                                                          style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.blacktextmax, fontSize: 11,),
                                                        ),
                                                      ),

                                                      SizedBox(height: 10,)

                                                    ],
                                                  ),
                                                );

                                              }

                                            }

                                          }



                                        },

                                      );

                                    },
                                  ),*/


                                  ],

                                ),
                              );

                            }

                        ),
                      ),

                      //SizedBox(height: 90,)
                    ],

                  ),

                ],

              ),

            );

          }

      ),

    );

  }

  /// Detect if you can tap on the answers
  bool detectedTap(Profilesubcategories value1, int itemsubcate, int value){

    bool maketap = true;

    //if(value1.data![itemsubcate]!.subcategoryuser!.length == 0){ /// It has not been finished

    for (int i = 0; i < value1.data![itemsubcate]!.questions![value]!.answers!.length ; i++) {

      print(value1.data![itemsubcate]!.name);
      print(value1.data![itemsubcate]!.questions![value]!.question);
      print(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answers);
      print(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.toString());
      print(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length);
      if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser!.length > 0){

        if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser![0]!.from == "End"){
          singleton.notifierMakeTapAnswer.value = false;
          maketap = false;
          break;
        }

        ///if the subcategory is completed o incomplete
        /*if(value1.data![itemsubcate]!.subcategoryuser!.length > 0){

            ///if the subcategory is completed and comes from ws
            if(value1.data![itemsubcate]!.subcategoryuser![0]!.subCategoryStatus == "incomplete"){

              if(value1.data![itemsubcate]!.questions![value]!.answers![i]!.answersuser![0]!.from == "End"){
                singleton.notifierMakeTapAnswer.value = false;
                maketap = false;
                break;
              }

            }

          }*/


      }

    }

    /*}else { /// has been finished
      maketap = false;
    }*/

    return maketap;

  }

  ///Detect page number
  _onPageViewChange(int page) {
    print("Current Page: " + page.toString());
    singleton.notifieriTemQuestion.value = page;
    int previousPage = page;
    if(page != 0) previousPage--;
    else previousPage = 2;
    print("Previous page: $previousPage");
  }

  /// Pager and Buttons
  Widget PagerButton(BuildContext context){

    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeTransition(
        opacity: controllerButtons,
        child: Container(
          margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
          height: 90,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            color: CustomColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [

              SizedBox(height: 5,),

              ///Paginador
              Container(

                child: ValueListenableBuilder<Profilesubcategories>(
                    valueListenable: singleton.notifierSubCategoriesProfile,
                    builder: (context,value1,_){

                      return ValueListenableBuilder<int>(
                          valueListenable: singleton.notifieriTemQuestion,
                          builder: (contexts,value,_){

                            return ValueListenableBuilder<int>(
                                valueListenable: singleton.notifieriTemSubCategory,
                                builder: (contexts,itemsubcate,_){

                                  return PageViewIndicator(
                                    length: (value1.code == 1 || value1.code ==  102) ? 0 : value1.data![itemsubcate]!.questions!.length,
                                    currentIndex: value,
                                    currentColor: CustomColors.blueback,
                                    otherColor: CustomColors.graydots.withOpacity(0.4),
                                    currentSize: 10,
                                    otherSize: 7,
                                    //margin: EdgeInsets.all(5),
                                    borderRadius: 9999.0,
                                    alignment: MainAxisAlignment.center,
                                    animationDuration: Duration(milliseconds: 750),
                                  );

                                }

                            );

                          }

                      );

                    }

                ),

              ),

              SizedBox(height: 5,),

              ///Buttons
              Container(
                padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [

                    /// back
                    Expanded(
                      child: Container(
                        child: ArgonButton(
                          height: 41,
                          width: 300,
                          borderRadius: 40.0,
                          color: CustomColors.white,
                          child: Container(
                            width: double.infinity,
                            height: 41,
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.all(const Radius.circular(21)),
                              border: Border.all(
                                width: 1,
                                color: CustomColors.bordebuttons,
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
                                        Strings.back.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        //maxLines: 1,
                                        style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.orangeborderpopup, fontSize: 16.0,),
                                        textScaleFactor: 1.0,
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
                              //_validateform(context,stopLoading);
                              //singleton.notifierCahngeType.value = 0;
                              startLoading();
                              if(singleton.notifieriTemQuestion.value == 0){
                                singleton.notifieriTemQuestion.value = 0;
                              }else {
                                /*var val = singleton.notifieriTemSubCategory.value;
                                singleton.notifieriTemSubCategory.value = 0;
                                singleton.notifieriTemSubCategory.value = val;
                                singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value;
                                singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value - 1; /// Next question*/
                                singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value - 1;
                              }


                              controllerAnima.reset();
                              controllerAnima.forward();
                              PutTextIntoTexfield();
                              Future.delayed(const Duration(milliseconds: 200), () {
                                stopLoading();
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    /// save
                    Expanded(
                      child: Container(
                        child: ValueListenableBuilder<Profilesubcategories>(
                            valueListenable: singleton.notifierSubCategoriesProfile,
                            builder: (context,value1,_){

                              return ValueListenableBuilder<int>(
                                  valueListenable: singleton.notifieriTemSubCategory,
                                  builder: (contexts,itemsubcate,_){

                                    return ArgonButton(
                                      height: 41,
                                      width: 300,
                                      borderRadius: 40.0,
                                      color: CustomColors.orangeborderpopup,
                                      child: Container(
                                        width: double.infinity,
                                        height: 41,
                                        decoration: BoxDecoration(
                                          color: CustomColors.orangeborderpopup,
                                          borderRadius: BorderRadius.all(const Radius.circular(21)),
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
                                                    //singleton.notifierSubCategoriesProfile.value.code == 1 ? Strings.save1 : singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length - 1 == singleton.notifieriTemQuestion.value ? Strings.save : Strings.save1,
                                                    singleton.notifierSubCategoriesProfile.value.code == 1 ? Strings.save1 : singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length - 1 == singleton.notifieriTemQuestion.value ? Strings.save : Strings.save1,
                                                    textAlign: TextAlign.center,
                                                    //maxLines: 1,
                                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 16.0,),
                                                    textScaleFactor: 1.0,
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

                                          if(singleton.notifierCompleteCategory.value!="YES"){ /// No finish all category

                                            //singleton.notifierCahngeType.value = 1;
                                            //controlador.jumpToPage(1);
                                            startLoading();

                                            /*if(value1.code == 1 || value1.code ==  102 ){ /// Preloading o no data
                                          singleton.notifieriTemQuestion.value = 0;

                                        }else if(value1.data![itemsubcate]!.questions!.length - 1 == singleton.notifieriTemQuestion.value){ /// Final questions
                                          singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value;

                                        }else singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value + 1; /// Next question

                                        */
                                            controllerAnima.reset();
                                            controllerAnima.forward();

                                            _validateSendAnsw(context, stopLoading);

                                          }


                                        }
                                      },
                                    );

                                  }

                              );

                            }

                        ),
                      ),
                    ),


                  ],

                ),
              ),

            ],

          ),

        ),
      ),
    );

  }


  ///Validate And Send Answers
  _validateSendAnsw(BuildContext context,Function stop) async{




    callonlyonce = false;

    /// Type Text Answer
    if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.type!.id == 1){ /// Text Answer

      /// Answer exist
      if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.answersuser!.length >0){/// Answer exist

        /// Only list
        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.answersuser![0]!.from == "list"){
          //var vect = [];
          //vect.add(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.id);
          //servicemanager.fetchSendAnswer(context, vect, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.id!, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.id!, _controllerComment.text, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.type!.id!, stop);
          AddTypeTextToVector(stop);

        }else{/// answer on endpoint
          NextQuestion();
          stop();
        }

      }else{ /// Answer no exist

        if(_controllerComment.text != ""){ /// Comment Textfield full
          AddTypeTextToVector(stop);
          //servicemanager.fetchSendAnswer(context, vect, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.id!, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.id!, _controllerComment.text, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.type!.id!, stop);

        }else{ /// empty Textfield
          utils.openSnackBarInfo(context, Strings.emptyanswer, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          stop();
        }

      }


    }else{ /// the other types of questions

      if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length - 1 != singleton.notifieriTemQuestion.value){
        safeAllowsToTap(singleton.notifieriTemQuestion.value + 1);
      }else{
        //safeAllowsToTap(singleton.notifieriTemQuestion.value);
        lastItemsubcategory(singleton.notifieriTemQuestion.value);
      }

      //NextQuestion();
      stop();

    }





  }

  ///sure lets tap on last question
  void lastItemsubcategory(int itemquestion){

    ///detect if the question has ws data
    singleton.notifierMakeTapAnswer.value = true;
    var goto = "YES";
    var isnotAnswer = "NO";

    for (int i = 0; i < singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![itemquestion]!.answers!.length ; i++) {
      if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![itemquestion]!.answers![i]!.answersuser!.length > 0){
        isnotAnswer = "YES";
        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![itemquestion]!.answers![i]!.answersuser![0]!.from == "End"){
          singleton.notifierMakeTapAnswer.value = false;
          goto = "NO";
          break;
        }
      }
    }

    if(isnotAnswer=="NO"){
      utils.openSnackBarInfo(context, Strings.emptyanswer, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
    }else if(goto == "YES"){
      _controllerComment.text = "";
      NextQuestion();
      return; /// Puesto ahorita
    }

    ///Subcategory is not completed
    if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length==0){

      if(callonlyonce==false){
        launchFetchAnswers(passAllAnswertoCompleted);
        callonlyonce=true;
      }


    }else{ /// Go to next subcategory
      _controllerComment.text = "";

      /// if it is not the last subcategory
      /*if(singleton.notifierSubCategoriesProfile.value.data!.length -1 != singleton.notifieriTemSubCategory.value){
        singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value + 1;
        singleton.notifieriTemQuestion.value = 0;
      }*/

      /// if it is not the last subcategory
      if(singleton.notifierSubCategoriesProfile.value.data!.length -1 != singleton.notifieriTemSubCategory.value){

        /// If the subcategory is complete
        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser![0]!.subCategoryStatus== "completed"){
          singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value + 1;
          singleton.notifieriTemQuestion.value = 0;

        }else{/// If the subcategory is incomplete

          if(callonlyonce==false){
            launchFetchAnswers(passAllAnswertoCompleted);
            callonlyonce=true;
          }

        }



      }else { /// Last subcategory and its completed from ws

              servicemanager.fetchCategoriesProfile(context,"borrar");
              singleton.notifierCompleteCategory.value = "YES";





              Future.delayed(const Duration(milliseconds: 1200), () {

                Navigator.pop(context);

              });

      }


    }

  }


  /// sure lets tap on next question
  void safeAllowsToTap(int nextquestion){


    var goto = "NO";
    var runnextquestion = "NO";
    var item = nextquestion-1;
    if(nextquestion>0){ /// detect if the subcategory only has one question


      /*if(nextquestion == singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length -1){
        item = item + 1;
      }*/

      ///detect if the current question is type 1 and does not execute next question method
      if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![item]!.type!.id != 1){
        runnextquestion = "YES";
      }

      for (int i = 0; i < singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![item]!.answers!.length ; i++) {

        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![item]!.answers![i]!.answersuser!.length > 0){
          goto = "YES";
          break;
        }

      }

    }else{
      goto = "YES";
      NextQuestion();
    }



    if(goto == "YES"){

      ///detect if the following question has ws data
      singleton.notifierMakeTapAnswer.value = true;
      for (int i = 0; i < singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![nextquestion]!.answers!.length ; i++) {

        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![nextquestion]!.answers![i]!.answersuser!.length > 0){

          if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![nextquestion]!.answers![i]!.answersuser![0]!.from == "End"){
            singleton.notifierMakeTapAnswer.value = false;
            break;
          }

        }

      }
      _controllerComment.text = "";

      if(runnextquestion=="YES"){
        NextQuestion();
      }else {

        if((nextquestion == singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length -1) && singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![nextquestion]!.type!.id == 1){
          NextQuestion();
        }

      }
      //stop();

    }else{
      if(goto=="NO"){
        utils.openSnackBarInfo(context, Strings.emptyanswer, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
      }

    }


  }

  ///Go to Next Question
  void NextQuestion(){
    if(singleton.notifierSubCategoriesProfile.value.code == 1 || singleton.notifierSubCategoriesProfile.value.code ==  102 ){ /// Preloading o no data
      singleton.notifieriTemQuestion.value = 0;

    }else if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length - 1 == singleton.notifieriTemQuestion.value){ /// Final questions
      singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value;

      print(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length-1 );
      print("Item de pregunta" + singleton.notifieriTemQuestion.value.toString());

      /// last question of the subcategory
      if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length - 1 == singleton.notifieriTemQuestion.value){

        ///Subcategory is not completed
        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length==0){

          if(callonlyonce==false){
            launchFetchAnswers(passAllAnswertoCompleted);
            callonlyonce=true;
          }


        }else{ /// Go to next subcategory
          _controllerComment.text = "";

          ///Puesto ahorita
          if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser![0]!.subCategoryStatus== "incomplete"){
            ///if the subcategory is incomplete or one more question was added
            _controllerComment.text = "";
            if(callonlyonce==false){
              launchFetchAnswers(passAllAnswertoCompleted);
              callonlyonce=true;
            }

          }else{

            /// if it is not the last subcategory
            if(singleton.notifierSubCategoriesProfile.value.data!.length -1 != singleton.notifieriTemSubCategory.value){
              singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value + 1;
              singleton.notifieriTemQuestion.value = 0;
            }

          }

          /// if it is not the last subcategory
          /*if(singleton.notifierSubCategoriesProfile.value.data!.length -1 != singleton.notifieriTemSubCategory.value){
            singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value + 1;
            singleton.notifieriTemQuestion.value = 0;
          }*/


        }

      }

    }else {
      /*var val = singleton.notifieriTemSubCategory.value;
      singleton.notifieriTemSubCategory.value = 0;
      singleton.notifieriTemSubCategory.value = val;
      singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value;
      singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value + 1; /// Next question*/
      singleton.notifieriTemQuestion.value = singleton.notifieriTemQuestion.value + 1; /// Next question
    }


    PutTextIntoTexfield();
  }

  /// Add Type 1 Answers to Vector
  void AddTypeTextToVector(Function stop){

    var vect = [];
    vect.add(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.id);
    ProfilesubcategoriesDataQuestionsAnswersAnswersuser item = ProfilesubcategoriesDataQuestionsAnswersAnswersuser(answer: _controllerComment.text,check: true,from: "list");
    Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
    pre.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.answersuser!.add(item);
    singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
    singleton.notifierSubCategoriesProfile.value = pre;

    if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length - 1 != singleton.notifieriTemQuestion.value){
      safeAllowsToTap(singleton.notifieriTemQuestion.value + 1);
      NextQuestion();
    }else{
      safeAllowsToTap(singleton.notifieriTemQuestion.value);
    }

    //NextQuestion();
    stop();
  }

  ///put text in Texfield
  void PutTextIntoTexfield(){

    if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.type!.id == 1){ /// Text Answer
      if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.answersuser!.length > 0){
        var value = singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.answersuser![0]!.answer;
        reloadText(value!);
      }
    }
  }

  /// Launch Answer Endpoint
  void launchFetchAnswers(Function stop)async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');


        var vectQuestions = [];


        ///cycle through vector of questions of that subcategory
        for (int i = 0; i < singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length ; i++){


          ProfilesubcategoriesDataQuestions question = singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![i]!;
          print(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![i]!.question);
          List<ProfilesubcategoriesDataQuestionsAnswers?>? answers = question.answers;
          var vectAnsers = [];
          var answer = "";

          for (int y = 0; y < answers!.length ; y++){ /// walk through answers vector


            if(answers![y]!.answersuser!.length >0){ ///check if your answer was answered
              answer = answers![y]!.answersuser![0]!.answer!;
              //vectAnsers.add(answers![y]!.id); /// add id answer

              if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length >0){

                if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser![0]!.subCategoryStatus == "incomplete"){
                  if(answers![y]!.answersuser![0]!.from != "End"){
                    vectAnsers.add(answers![y]!.id); /// add id answer
                  }
                }

              }else{
                vectAnsers.add(answers![y]!.id);
              }

            }

          }

          /*if(vectAnsers.length==0){ /// That question has no added answer
            utils.openSnackBarInfo(context, Strings.emptyanswer1, "assets/images/ic_alert.png",CustomColors.white,"error");
            break;
          }else {

            Map<String, dynamic> itemsQuestion = {
              "questionId": question.id,
              "answersId": vectAnsers,
              "type": question.type!.id,
              "answer": question.type!.id == 1 ? answer : "",
            };

            vectQuestions.add(itemsQuestion);

          }*/

          /// If the subcategory is offline
          if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length == 0){

            if(vectAnsers.length==0){ /// That question has no added answer
              utils.openSnackBarInfo(context, Strings.emptyanswer1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
              break;
            }else {

              Map<String, dynamic> itemsQuestion = {
                "questionId": question.id,
                "answersId": vectAnsers,
                "type": question.type!.id,
                "answer": question.type!.id == 1 ? answer : "",
              };

              vectQuestions.add(itemsQuestion);

            }

          }else{

            if(vectAnsers.length>0){
              Map<String, dynamic> itemsQuestion = {
                "questionId": question.id,
                "answersId": vectAnsers,
                "type": question.type!.id,
                "answer": question.type!.id == 1 ? answer : "",
              };

              vectQuestions.add(itemsQuestion);
            }

          }



        }

        if(vectQuestions.length==0){ /// That question has no added answer
          utils.openSnackBarInfo(context, Strings.emptyanswer1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          return;
        }

        /// If the subcategory has not been submitted
        /*if(vectQuestions.length == singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length){
          _controllerComment.text = "";
          utils.openProgress(context);
          //stop();
          servicemanager.fetchSendAnswer(context, vectQuestions, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.id!, stop);

        }*/

        /// If the subcategory has not been submitted
        if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser!.length == 0){

          /// If the questions are answered equal to the number of questions
          if(vectQuestions.length == singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions!.length){
            _controllerComment.text = "";
            utils.openProgress(context);
            //stop();
            servicemanager.fetchSendAnswer(context, vectQuestions, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.id!, stop);

          }

        }else if(singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.subcategoryuser![0]!.subCategoryStatus== "incomplete"){
          ///if the subcategory is incomplete or one more question was added
          _controllerComment.text = "";
          utils.openProgress(context);
          //stop();
          servicemanager.fetchSendAnswer(context, vectQuestions, singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.id!, stop);

        }

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }

  /// Pass all answers to completed
  void passAllAnswertoCompleted(){

    Profilesubcategories categories = singleton.notifierSubCategoriesProfile.value;
    ProfilesubcategoriesData categoryItem = categories.data![singleton.notifieriTemSubCategory.value]!;
    ProfilesubcategoriesDataSubcategorysuser Subcategorysuser = ProfilesubcategoriesDataSubcategorysuser(from: "End",subCategoryStatus: "completed");
    categoryItem.subcategoryuser!.add(Subcategorysuser);

    for (int i = 0; i < categoryItem!.questions!.length ; i++){

      ProfilesubcategoriesDataQuestions question = singleton.notifierSubCategoriesProfile.value.data![singleton.notifieriTemSubCategory.value]!.questions![i]!;
      List<ProfilesubcategoriesDataQuestionsAnswers?>? answers = question.answers;

      for (int y = 0; y < answers!.length ; y++){ /// walk through answers vector

        if(answers![y]!.answersuser!.length >0){ ///check if your answer was answered
          answers![y]!.answersuser![0]!.from = "End"; ///pass the response as if it were a ws
        }

      }

    }

    singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
    singleton.notifierSubCategoriesProfile.value = categories;


    /// run coin animation
    if(singleton.notifierSubCategoriesProfile.value.data!.length -1 == singleton.notifieriTemSubCategory.value){
      widget.onAnimationCoin();
    }else{
      servicemanager.fetchPointProfileCategories(context);
    }

  }

  /// header User info
  Widget Header(BuildContext context){

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20) ),
        //color: CustomColors.blueText,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,

        children: [

          ///Icon
          InkWell(
            onTap: (){
              controllerButtons.reverse();
              singleton.notifierHeightViewQuestions.value = 382;
              Future.delayed(const Duration(milliseconds: 200), () {
                utils.heightViewWinPoint();
                Navigator.pop(context);
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 5,right: 5),
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                'assets/images/x.svg',
                fit: BoxFit.contain,
                //color: CustomColors.greyplaceholder

              ),
            ),
          ),


          /* ///UserImage
          Stack(
            children: [

              ClipOval(
                child: Container(
                  color: Colors.white,
                  height: 65,
                  width: 65,
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 2.5,top: 2.5),
                child: ClipOval(
                  child: ValueListenableBuilder<Getprofile>(
                      valueListenable: singleton.notifierUserProfile,
                      builder: (context,value1,_){

                        return CachedNetworkImage(
                          width: 60,
                          height: 60,
                          imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                          //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                          placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                            width: 60,
                            height: 60,
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                          useOldImageOnUrlChange: false,

                        );

                      }

                  ),

                ),
              ),
            ],

          ),

          SizedBox(height: 4,),

          /// username
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ValueListenableBuilder<Getprofile>(
                valueListenable: singleton.notifierUserProfile,
                builder: (context,value1,_){

                  return Text(value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.fullname!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 18,),
                    textScaleFactor: 1.0,
                  );

                }

            ),
          ),

          SizedBox(height: 10,),

          ///UserImage, Points
          /*Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [


                ///UserImage
                Stack(
                  children: [

                    ClipOval(
                      child: Container(
                        color: Colors.white,
                        height: 65,
                        width: 65,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(left: 2.5,top: 2.5),
                      child: ClipOval(
                        child: ValueListenableBuilder<Getprofile>(
                            valueListenable: singleton.notifierUserProfile,
                            builder: (context,value1,_){

                              return CachedNetworkImage(
                                width: 60,
                                height: 60,
                                imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                  width: 60,
                                  height: 60,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                                useOldImageOnUrlChange: false,

                              );

                            }

                        ),

                      ),
                    ),
                  ],

                ),

                ///Points
                Container(
                  //color: Colors.red,
                  child: Row(

                    children: [

                      ///Image Coins
                      Container(
                        padding: EdgeInsets.only(right: 5,left: 5),
                        //color: Colors.red,
                        /*child: Image(
                          width: 40,
                          height: 40,
                          image: AssetImage("assets/images/coins.png"),
                          fit: BoxFit.contain,
                        ),*/
                        child: SvgPicture.asset(
                          'assets/images/coins.svg',
                          fit: BoxFit.contain,
                          width: 30,
                          height: 30,
                        ),
                      ),

                      ///Value Coins
                      Column(

                        children: [

                          ///Count Points
                          ValueListenableBuilder<double>(
                              valueListenable: singleton.notifierPointsProfile,
                              builder: (context,value,_){

                                return Container(
                                  child: Text(singleton.formatter.format(value),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 25,),
                                  ),
                                );

                              }

                          ),

                          /// Points
                          Container(
                            child: Text(Strings.points,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: Strings.font_regular, color: CustomColors.white, fontSize: 12,),
                            ),
                          ),


                        ],

                      )

                    ],

                  ),
                ),


              ],

            ),

          ),*/

          SizedBox(height: 15,),

          ///Progressbar
          Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            height: 12,
            child: ValueListenableBuilder<TotalpointProfileCategories>(
                valueListenable: singleton.notifierPointsProfileCategories,
                builder: (context,value,_){

                  return LiquidLinearProgressIndicator(
                    value: (value.code == 1 || value.code == 102 || value.code == 120) ? 0.0 : ((value.data!.totalUser! * 100)/value.data!.point!)/100, // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(CustomColors.orangeback), // Defaults to the current Theme's accentColor.
                    backgroundColor: CustomColors.white.withOpacity(0.6), // Defaults to the current Theme's backgroundColor.
                    borderColor: CustomColors.white.withOpacity(0.6),
                    borderWidth: 0.0,
                    borderRadius: 6.0,
                    direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                    center: Text(""),
                  );

                }

            ),
          ),

          SizedBox(height: 10,),*/

        ],

      ),

    );

  }

}


///AppBar
class AppBar extends StatelessWidget{
  final singleton = Singleton();
  @override

  Widget build(BuildContext context) {

    return ValueListenableBuilder<double>(
        valueListenable: singleton.notifierHeightHeaderWallet1,
        builder: (context,value2,_){

          return AnimatedContainer(
            //color: Colors.green,
            height: value2,
            duration: Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width,

            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Stack(

                children: [

                  ///Background
                  Container(
                    //margin: EdgeInsets.only(left: 30),
                    //color: CustomColors.orange,
                      height: value2,
                      width: MediaQuery.of(context).size.width,
                      /*child: value2 > 90.0 ? SvgPicture.asset(
                      'assets/images/headerprofile.svg',
                      fit: BoxFit.fill,
                    ) : Image(
                      image: AssetImage("assets/images/headernew.png"),
                      fit: BoxFit.fill,
                    ),*/

                      child: ValueListenableBuilder<SegmentationCustom>(
                          valueListenable: singleton.notifierValidateSegmentation,
                          builder: (context,valueseg,_){

                            if(valueseg.code == 1 ){
                              /*return Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );*/
                              return SvgPicture.asset(
                                'assets/images/headerprofile.svg',
                                fit: BoxFit.fill,
                              );
                            }else if(valueseg.code == 100){
                              return Container(
                                color: valueseg.data!.styles!.colorHeader!.toColors(),
                              );
                            }else if(valueseg.code == 102){
                              return value2 > 90.0 ? SvgPicture.asset(
                                'assets/images/headerprofile.svg',
                                fit: BoxFit.fill,
                              ) : Image(
                                image: AssetImage("assets/images/headernew.png"),
                                fit: BoxFit.fill,
                              );
                            }else{
                              return SvgPicture.asset(
                                'assets/images/headerprofile.svg',
                                fit: BoxFit.fill,
                              );
                            }

                          }

                      )

                  ),

                  Container(
                    child: Column(

                      children: [

                        /// Header
                        Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              ///Logo
                              Container(
                                alignment: Alignment.topLeft,
                                //color: Colors.blue,
                                padding: EdgeInsets.only(top: 35,left: 20),
                                child:InkWell(
                                  onTap: (){
                                    Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 0,)) );
                                  },
                                  /*child: SvgPicture.asset(
                                      'assets/images/logohome.svg',
                                      fit: BoxFit.contain,
                                      width: 80,
                                      height: 42,
                                    ),*/

                                  child: ValueListenableBuilder<SegmentationCustom>(
                                      valueListenable: singleton.notifierValidateSegmentation,
                                      builder: (context,value2,_){
                                        return value2.code == 1 ? SvgPicture.asset(
                                          'assets/images/logohome.svg',
                                          fit: BoxFit.contain,
                                          width: 80,
                                          height: 42,
                                        ) :
                                        value2.code==100 ? CachedNetworkImage(
                                          imageUrl: value2.data!.styles!.logoHeader!,
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Image(
                                            image: AssetImage('assets/images/ic_gane.png'),
                                            color: CustomColors.graylines.withOpacity(0.6),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          useOldImageOnUrlChange: true,
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.contain,
                                          width: 80,
                                          height: 42,
                                        ) :
                                        SvgPicture.asset(
                                          'assets/images/logohome.svg',
                                          fit: BoxFit.contain,
                                          width: 80,
                                          height: 42,
                                        ) ;
                                      }

                                  ),

                                ),
                              ),

                              /// UserImage
                              /*Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5,right: 25,top: 35),
                                  //%height: 103,
                                  //color: Colors.blue,
                                  child: Column(

                                    children: [

                                      ///UserImage
                                      InkWell(
                                        onTap: (){
                                          //imagePicker.showDialog(context);

                                          dialogSetting(context);
                                        },
                                        child: Stack(

                                          children: [

                                            ClipOval(
                                              child: Container(
                                                color: Colors.white,
                                                height: 50,
                                                width: 50,
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left: 2.5,top: 2.5),
                                              //alignment: Alignment.center,
                                              child: ClipOval(
                                                child: ValueListenableBuilder<Getprofile>(
                                                    valueListenable: singleton.notifierUserProfile,
                                                    builder: (context,value1,_){

                                                      return CachedNetworkImage(
                                                        width: 45,
                                                        height: 45,
                                                        imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                        placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                          width: 45,
                                                          height: 45,
                                                        ),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        fit: BoxFit.cover,
                                                        useOldImageOnUrlChange: false,

                                                      );

                                                    }

                                                ),

                                              ),
                                            ),

                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: ClipOval(
                                                child: SvgPicture.asset(
                                                  'assets/images/herradura.svg',
                                                  fit: BoxFit.cover,
                                                  width: 21,
                                                  height: 21,
                                                ),
                                              ),
                                            ),

                                          ],

                                        ),
                                      ),
                                    ],


                                  ),

                                ),
                              ),*/

                              Expanded(
                                child: Container(
                                  height: 10,
                                  //color: Colors.red,
                                ),
                              ),

                              ///Coins
                              /*SpringButton(
                                SpringButtonType.OnlyScale,
                                Container(
                                  padding: EdgeInsets.only(right: 10,top: 40 ),
                                  //color: Colors.red,
                                  child: ValueListenableBuilder<Userpoints>(

                                      valueListenable: singleton.notifierUserPoints,
                                      builder: (context,value,_){

                                        return Badge(
                                          position: BadgePosition.topEnd(end: value.code == 1 || value.code == 102 ? -4 : int.parse(value.data!.result!) < 10 ? 0 : -10,),
                                          toAnimate: true,
                                          animationType: BadgeAnimationType.scale,
                                          showBadge: value.code == 1 && value.code == 102 ? false :  true,
                                          badgeColor: CustomColors.blueBack,
                                          /*badgeContent: Text(
                                  //"9",
                                  singleton.formatter.format(double.parse(value.code == 1 || value.code == 102 ? "0" : value.data!.result!)),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                ),*/
                                          badgeContent: AnimatedFlipCounter(
                                            duration: Duration(milliseconds: 2000),
                                            /*value: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? int.parse(value.data!.result!) : ( double.parse(value.data!.result!) / 1000),
                                  fractionDigits: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? 0 : 1, // decimal precision
                                  suffix: value.code == 1 || value.code == 102 ? "" : int.parse(value.data!.result!) < 1000 ? "" : "K",*/

                                            value: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? int.parse(value.data!.result!) : ( double.parse(value.data!.result!) / 1000),
                                            fractionDigits: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? 0 : int.parse(value.data!.result!) > 9999 ? 0 : 1, // decimal precision
                                            suffix: value.code == 1 || value.code == 102 ? "" : int.parse(value.data!.result!) < 1000 ? "" : "K",

                                            textStyle: TextStyle(fontSize: value.code == 1 || value.code == 102 ? 9.0 : int.parse(value.data!.result!) < 1000 ? 9.0 : 8.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                          ),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/coins.svg',
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                            /*child: Container(
                                              child: Stack(
                                                alignment: Alignment.center,

                                                children: [

                                                  Image(
                                                    image: AssetImage("assets/images/circuloonline.png"),
                                                    fit: BoxFit.contain,
                                                    width: 30,
                                                    height: 30,
                                                    //color: "#00A86B".toColors(),
                                                  ),

                                                  Image(
                                                    image: AssetImage("assets/images/monedaonline.png"),
                                                    fit: BoxFit.contain,
                                                    width: 30,
                                                    height: 30,
                                                    color: "#00A86B".toColors(),
                                                  )

                                                ],

                                              ),
                                            )*/
                                        );

                                      }


                                  ),

                                ),
                                useCache: false,
                                onTap: (){

                                  /*Navigator.push(
                          context,
                          PageRouteBuilder<dynamic>(
                            transitionDuration: const Duration(milliseconds: 400),
                            reverseTransitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => MyWallet(),
                            transitionsBuilder: (
                                BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation,
                                Widget child,
                                ) {
                              final Tween<Offset> offsetTween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
                              final Animation<Offset> slideInFromTheRightAnimation = offsetTween.animate(animation);
                              return SlideTransition(
                                  position: slideInFromTheRightAnimation,
                                  child: child
                              );
                            },
                          ),
                        );*/

                                  Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 4,)) );


                                },

                                //onTapDown: (_) => decrementCounter(),

                              ),*/

                              /// User image
                              InkWell(
                                onTap: (){
                                  //Navigator.pushReplacement(context, Transition(child: PrincipalContainer(selectedIndex: 3,)) );
                                  //dialogSetting(context);
                                  var time = 350;
                                  if(singleton.isIOS == false){
                                    time = utils.ValueDuration();
                                  }
                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: ProfileDetail(),
                                      reverseDuration: Duration(milliseconds: time)
                                  ));

                                },
                                child: Container(
                                  //color: Colors.green,
                                  margin: EdgeInsets.only(right: 10, top: 40,),
                                  alignment: Alignment.topCenter,
                                  child: Stack(

                                    children: [

                                      ClipOval(
                                        child: Container(
                                          color: Colors.white,
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left: 1.2,top: 1.2),
                                        //alignment: Alignment.center,
                                        child: ClipOval(
                                          child: ValueListenableBuilder<Getprofile>(
                                              valueListenable: singleton.notifierUserProfile,
                                              builder: (context,value1,_){

                                                return CachedNetworkImage(
                                                  width: 29,
                                                  height: 29,
                                                  imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                  //imageUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                                                  placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                    width: 29,
                                                    height: 29,
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  useOldImageOnUrlChange: false,

                                                );

                                              }

                                          ),

                                        ),
                                      ),

                                    ],

                                  ),
                                ),
                              ),

                              ///Notifications
                              SpringButton(
                                SpringButtonType.OnlyScale,
                                Container(
                                  padding: EdgeInsets.only(right: 15,top: 40,),
                                  //color: Colors.blue,
                                  child: ValueListenableBuilder<String>(
                                      valueListenable: singleton.notifierNotificationCount,
                                      builder: (context,value,_){

                                        /*return Badge(
                                          //position: BadgePosition.topEnd(top: 2,end: 0),
                                          position: BadgePosition.topEnd(end: -2,),
                                          toAnimate: true,
                                          animationType: BadgeAnimationType.scale,
                                          showBadge: value == "0" ? false : true,
                                          //showBadge: true,
                                          badgeColor: CustomColors.blueBack,
                                          badgeContent: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                            textScaleFactor: 1.0,
                                          ),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/notifications.svg',
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        );*/

                                        return badges.Badge(
                                          badgeContent: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 9.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                          ),
                                          showBadge: value == "0" ? false : true,
                                          badgeStyle: badges.BadgeStyle(
                                            badgeColor: CustomColors.blueBack,
                                          ),
                                          position: BadgePosition.topEnd(end: -2,),
                                          child: Container(
                                            child: SvgPicture.asset(
                                              'assets/images/notifications.svg',
                                              fit: BoxFit.contain,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                        );

                                      }

                                  ),

                                ),
                                useCache: false,
                                onTap: (){

                                  /*Navigator.push(
                                    context,
                                    PageRouteBuilder<dynamic>(
                                      transitionDuration: const Duration(milliseconds: 400),
                                      reverseTransitionDuration: const Duration(milliseconds: 400),
                                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Notificationss(),
                                      transitionsBuilder: (
                                          BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secondaryAnimation,
                                          Widget child,
                                          ) {
                                        final Tween<Offset> offsetTween = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0));
                                        final Animation<Offset> slideInFromTheRightAnimation = offsetTween.animate(animation);
                                        return SlideTransition(
                                            position: slideInFromTheRightAnimation,
                                            child: child
                                        );
                                      },
                                    ),
                                  );*/

                                  var time = 350;
                                  if(singleton.isIOS == false){
                                    time = utils.ValueDuration();
                                  }

                                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: Notificationss(),
                                      reverseDuration: Duration(milliseconds: time)
                                  ));

                                },


                              ),


                            ],
                          ),
                        ),

                        /// Data
                        Container(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 5),
                          height: 93,
                          //height: 103,
                          //color: Colors.red,
                          child: Column(

                            children: [

                              ///UserImage
                              /*InkWell(
                                onTap: (){
                                  //imagePicker.showDialog(context);
                                },
                                child: Stack(

                                  children: [

                                    ClipOval(
                                      child: Container(
                                        color: Colors.white,
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(left: 2.5,top: 2.5),
                                      //alignment: Alignment.center,
                                      child: ClipOval(
                                        child: ValueListenableBuilder<Getprofile>(
                                            valueListenable: singleton.notifierUserProfile,
                                            builder: (context,value1,_){

                                              return CachedNetworkImage(
                                                width: 45,
                                                height: 45,
                                                imageUrl: value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.photoUrl!,
                                                placeholder: (context, url) => Image(image: AssetImage('assets/images/ic_gane.png'),
                                                  width: 45,
                                                  height: 45,
                                                ),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                fit: BoxFit.cover,
                                                useOldImageOnUrlChange: false,

                                              );

                                            }

                                        ),

                                      ),
                                    ),

                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: ClipOval(
                                        child: SvgPicture.asset(
                                          'assets/images/icono5.svg',
                                          fit: BoxFit.cover,
                                          width: 27,
                                          height: 27,
                                        ),
                                      ),
                                    ),

                                  ],

                                ),
                              ),*/

                              SizedBox(height: 5,),

                              /// username
                              /*Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: ValueListenableBuilder<Getprofile>(
                                    valueListenable: singleton.notifierUserProfile,
                                    builder: (context,value1,_){

                                      return Text(value1.code == 1 || value1.code == 102 ? "" : value1.data!.user!.fullname!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 14,),
                                        textScaleFactor: 1.0,
                                      );

                                    }

                                ),
                              ),*/
                              Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(Strings.encuesta,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Strings.font_boldFe, color: CustomColors.white, fontSize: 31,),
                                    textScaleFactor: 1.0,
                                  )
                              ),


                              Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(Strings.encuesta1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 13.5,),
                                    textScaleFactor: 1.0,
                                  )
                              ),

                              SizedBox(height: 5,),

                              ///Progressbar
                              /*Container(
                                margin: EdgeInsets.only(left: 20,right: 20),
                                height: 12,
                                child: ValueListenableBuilder<TotalpointProfileCategories>(
                                    valueListenable: singleton.notifierPointsProfileCategories,
                                    builder: (context,value,_){

                                      return LiquidLinearProgressIndicator(
                                        value: (value.code == 1 || value.code == 102 || value.code == 120) ? 0.0 : ((value.data!.totalUser! * 100)/value.data!.point!)/100, // Defaults to 0.5.
                                        valueColor: AlwaysStoppedAnimation(CustomColors.blueBack), // Defaults to the current Theme's accentColor.
                                        backgroundColor: CustomColors.white.withOpacity(0.6), // Defaults to the current Theme's backgroundColor.
                                        borderColor: CustomColors.white.withOpacity(0.6),
                                        borderWidth: 0.0,
                                        borderRadius: 6.0,
                                        direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                        center: Text(""),
                                      );

                                    }

                                ),
                              ),

                              SizedBox(height: 5,),

                              ///Percentage
                              ValueListenableBuilder<TotalpointProfileCategories>(
                                  valueListenable: singleton.notifierPointsProfileCategories,
                                  builder: (context,value,_){

                                    return Container(

                                      child: Container(
                                        child: Text(singleton.formatter.format((value.data!.totalUser! * 100)/value.data!.point!) + "%",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 15,),
                                          textScaleFactor: 1.0,
                                        ),
                                      ),

                                    );

                                  }

                              ),*/

                            ],


                          ),

                        ),

                      ],

                    ),
                  ),



                ],

              ),
            ),


          );

        }

    );

  }

}






