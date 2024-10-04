import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gane/src/Models/accesstok.dart';
import 'package:gane/src/Models/altanplan.dart';
import 'package:gane/src/Models/altanplane1.dart';
import 'package:gane/src/Models/answers_res.dart';
import 'package:gane/src/Models/bannerWall.dart';
import 'package:gane/src/Models/buyplan.dart';
import 'package:gane/src/Models/citieslist.dart';
import 'package:gane/src/Models/colinieslist.dart';
import 'package:gane/src/Models/countries.dart';
import 'package:gane/src/Models/createuser.dart';
import 'package:gane/src/Models/creditcardslist.dart';
import 'package:gane/src/Models/databarcode.dart';
import 'package:gane/src/Models/gamelist.dart';
import 'package:gane/src/Models/gamelistn.dart';
import 'package:gane/src/Models/generalnotification.dart';
import 'package:gane/src/Models/getprofile.dart';
import 'package:gane/src/Models/notificationslist.dart';
import 'package:gane/src/Models/planaltandetail.dart';
import 'package:gane/src/Models/planaltandetail1.dart';
import 'package:gane/src/Models/planchip.dart';
import 'package:gane/src/Models/planescompra.dart';
import 'package:gane/src/Models/profilecategories.dart';
import 'package:gane/src/Models/profilesubcategories.dart';
import 'package:gane/src/Models/referrals.dart';
import 'package:gane/src/Models/roomlook.dart';
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/settingsuser.dart';
import 'package:gane/src/Models/states.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/useraltam.dart';
import 'package:gane/src/Models/userpointlist.dart';
import 'package:gane/src/Models/userpointlist1.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/Models/validatecodemail.dart';
import 'package:gane/src/Models/validatesims.dart';
import 'package:gane/src/Models/verifyphone.dart';
import 'package:gane/src/Models/verifyphonenumber.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as permi;
import 'package:video_player/video_player.dart';


class Singleton {

  static final Singleton _instance = new Singleton._internal();
  //factory Singleton() => _instance;

  factory Singleton() {
    return _instance;
  }

  Singleton._internal() {
    // init things inside this
  }

  late Singleton singleton;

  /*bool get isIOS => false;
  set isIOS(bool iosand) {}*/



  bool get opencamera => false;
  set opencamera(bool isOffline) {}

  bool get opengallery => false;
  set opengallery(bool isOffline) {}

  /*bool get isOffline => false;
  set isOffline(bool isOffline) {}*/

  /*bool get serviceEnabled => false;
  set serviceEnabled(bool iosand) {}*/

  //final notifierError = ValueNotifier([false, "","RED"]);
  final notifierError = ValueNotifier([true, Strings.resentcod,"RED"]);



  //set packageInfo(PackageInfo packageInfo) {}
  late PackageInfo packageInfo;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late final location = Location();
  late PermissionStatus permissionGranted;
  late LocationData locationData;
  double lon = 0.0;
  double lat = 0.0;
  late bool serviceEnabled;
  late BuildContext contextGlobal;
  var codeSMS = "";
  var numberPhone = "";
  var codeMail = "";
  var authToken = "";
  var GaneOrMira = "";
  var typeInternetConnection = "";
  bool isOffline = false;


  final notifierAccessToken = ValueNotifier(AccessToken(status: false,message: "No hay nada", code: 1, data: DataA(accessToken: "") ));
  final notifierCountriesList = ValueNotifier(Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] ));
  final notifierCountriesListSearch = ValueNotifier(Countries(code: 1,message: "No hay nada", status: false, data: <CountriesData>[] ));
  //final notifierVerifyPhone = ValueNotifier(Verifyphone(code: 1,message: "No hay nada", status: false, data: Data() ));
  final notifierVerifyPhone = ValueNotifier(Verifyphone1(code: 1,message: "No hay nada", status: false,  ));
  final notifierVerifyPhones = ValueNotifier(Verifyphone(code: 1,message: "No hay nada", status: false,  ));
  final notifierCreateAccount = ValueNotifier(Createuser(code: 1,message: "No hay nada", status: false, data: CreateuserData() ));
  final notifierVerifyAccountCode = ValueNotifier(Validatecodemail(code: 1,message: "No hay nada", status: false,  ));
  final notifierCategoriesProfile = ValueNotifier(Profilecategories(code: 1,message: "No hay nada", status: false, ));
  final notifierSubCategoriesProfile = ValueNotifier(Profilesubcategories(code: 1,message: "No hay nada", status: false, ));
  final notifierAnswerResponse = ValueNotifier(AnswersRes(code: 1,message: "No hay nada", status: false, ));
  final notifierPointsProfileCategories = ValueNotifier(TotalpointProfileCategories(code: 1,message: "No hay nada", status: false, ));
  final notifierLookRoom = ValueNotifier(Roomlook(code: 1,message: "No hay nada", status: false, ));
  final notifierAnswerRoom = ValueNotifier(Roomlook(code: 1,message: "No hay nada", status: false, ));
  final notifierGamesRoom = ValueNotifier(Gamelist(code: 1,message: "No hay nada", status: false, ));
  final notifierGamesRoomN = ValueNotifier(GamelistN(code: 1,message: "No hay nada", status: false, ));
  final notifierUserPoints = ValueNotifier(Userpoints(code: 1,message: "No hay nada", status: false, data: DataPU(result: "0") ));
  final notifierListUserPoints = ValueNotifier(Userpointlist(code: 1,message: "No hay nada", status: false, ));
  final notifierListUserPoints1 = ValueNotifier(Userpointlist1(code: 1,message: "No hay nada", status: false, ));
  final notifierGeneralnotification = ValueNotifier(Generalnotification(code: 1,message: "No hay nada", status: false, ));
  final notifierListNotfications = ValueNotifier(Notificationslist(code: 1,message: "No hay nada", status: false, ));
  final notifierSettingUser = ValueNotifier(Settingsuser(code: 1,message: "No hay nada", status: false, ));
  final notifierUserProfile = ValueNotifier(Getprofile(code: 1,message: "No hay nada", status: false, ));
  final notifierUseraltan = ValueNotifier(UserAltan(code: 1,message: "No hay nada", status: false, ));
  final notifierUseraltanPlan = ValueNotifier(AltanPLane(code: 1,message: "No hay nada", status: false, data: DataAP(plan: Plan(missingDay: "0",gbAvailable: "0",gbUsed: "0",totalGd: "0"  ) ) ));
  final notifierBannerAltan = ValueNotifier(BannerWallet(code: 1,message: "No hay nada", status: false, data: DataW(item: ItemW( callingCode: "", photoUrl: "", sms: "", whatsapp: "")) ));
  final notifierlanesCompra = ValueNotifier(PlanesCompra(code: 1,message: "No hay nada", status: false, data: DataPlanesCompra() ));
  final notifierBuyPlan = ValueNotifier(BuyPlans(code: 1,message: "No hay nada", status: false, data: DataBuyPlan() ));
  final notifierCreditCardList = ValueNotifier(TCList(code: 1,message: "No hay nada", status: false, data: DataTCList(items: <ItemsTCList>[] )));
  final notifierReferralData = ValueNotifier(ReferralData(code: 1,message: "No hay nada", status: false,  ));
  final notifierStatesList = ValueNotifier(statesList(code: 1,message: "No hay nada", status: false, data: DatastatesList(states:<States>[] ) ));
  final notifierStatesListSearch = ValueNotifier(statesList(code: 1,message: "No hay nada", status: false, data: DatastatesList(states:<States>[] ) ));
  final notifierCitiesList = ValueNotifier(cityList(code: 1,message: "No hay nada", status: false, data: DatacityList(cities:<Cities>[] ) ));
  final notifierCitiesListtSearch = ValueNotifier(cityList(code: 1,message: "No hay nada", status: false, data: DatacityList(cities:<Cities>[] ) ));
  final notifierColiniesList = ValueNotifier(colonList(code: 1,message: "No hay nada", status: false, data: DatacolonList(colonies:<Colonies>[] ) ));
  final notifierColiniesListSearch = ValueNotifier(colonList(code: 1,message: "No hay nada", status: false, data: DatacolonList(colonies:<Colonies>[] ) ));
  final notifierPlanChip = ValueNotifier(ChipPlans(code: 1,message: "No hay nada", status: false,  ));
  final notifierPlansDetailsAltan = ValueNotifier(PlansAltanDetails(code: 1,message: "No hay nada", status: false,  ));
  final notifierValidateSImCard = ValueNotifier(ValidatesSimsCard(code: 1,message: "No hay nada", status: false,  ));
  final notifierValidateSegmentation = ValueNotifier(SegmentationCustom(code: 1,message: "No hay nada", status: false,  ));
  final notifierValidateBarCode = ValueNotifier(BarCodeData(code: 1,message: "No hay nada", status: false, ));

  final notifierUseraltanPlan1 = ValueNotifier(AltanPLane1(code: 1,message: "No hay nada", status: false, data: DataAP1(gbFull: Sms(name: "-",value: "0"),minute: Sms(name: "-",value: "0"),sms: Sms(name: "-",value: "0"),velRed: Sms(name: "-",value: "0"), plans: <Plans11>[]) ));
  final notifierPlansDetailsAltan1 = ValueNotifier(PlansAltanDetails1(code: 1,message: "No hay nada", status: false, data: DataPlansAltanDetails1(plans: <Plans1>[]) ));
  final notifierHallRoom = ValueNotifier(Roomlook(code: 1,message: "No hay nada", status: false, ));

  final notifierCallingCode = ValueNotifier("");
  final notifierCallOrLink = ValueNotifier("");
  final notifierCompleteCategory = ValueNotifier("NO");
  final notifierVisibleButtoms = ValueNotifier(0);
  final notifierCorrect = ValueNotifier("");
  final notifierValueYButtons = ValueNotifier(0.0);
  final notifierHeightViewQuestions = ValueNotifier(352.0);
  final notifieriTemQuestion = ValueNotifier(0);
  final notifieriTemSubCategory = ValueNotifier(0);
  final notifierMakeTapAnswer = ValueNotifier(true);
  final notifierOffsetTapCategory = ValueNotifier([0.0,0.0]);
  final notifierOffsetInitialTapCategory = ValueNotifier([0.0,0.0]);
  final notifierOffsetTapGane = ValueNotifier([0.0,0.0]);
  final notifierOffsetInitialTapGane = ValueNotifier([0.0,0.0]);
  final notifierPointsProfile = ValueNotifier(0.0);
  final notifierPointsUser = ValueNotifier(0.0);
  final formatter = new NumberFormat("#,###.#", "en_US");//#,###.##
  final formatter1 = new NumberFormat("#,###.#", "en_US");
  final formatter2 = new NumberFormat("#,###", "en_US");
  final notifierSecondsVideo = ValueNotifier(0);
  final notifierPointsGaneRoom = ValueNotifier("0");
  final notifierVideoLoaded = ValueNotifier(false);
  final notifierSeePlay = ValueNotifier(false);
  VideoPlayerController? controller;
  late Future<void> initializeVideoPlayerFuture;
  final notifierQuestionAds = ValueNotifier(<QuestionAds>[]);
  final notifierNotificationCount = ValueNotifier("0");
  final notifierValueXY = ValueNotifier([]);
  final notifierSecondsGames = ValueNotifier(0);
  final notifierHeightViewWinPoints = ValueNotifier(0.0);
  final notifierIsOffline = ValueNotifier(false);
  ResultGL item = ResultGL();
  ItemsN itemN = ItemsN();
  late NavigationHistoryObserver historyObserver;
  bool isOnNotificationView = false;
  final resultSIMCardNetworkID = ValueNotifier("0");
  final notifierChangeCity = ValueNotifier(0);
  final notifierCity = ValueNotifier("Bogotá");
  final notifierPointsByGame = ValueNotifier("0");
  final notifierUrlsByGame = ValueNotifier("");
  final notifierNumberReward = ValueNotifier(0);
  final notifierNumberRewardDigit = ValueNotifier("");
  final notifierNumberChange = ValueNotifier(false);

  var an = 0.0;
  var al = 0.0;

  var polities = "";
  var terms = "";
  var contactus = "";
  var about = "";
  var idPush = 0;

  var message = "";
  var imageGame = "";
  var codeUrl = "";




  late Timer timer;
  final notifierTimerText = ValueNotifier("");
  DateTime alert =  DateTime.now().add(Duration(seconds: 0));
  final notifierHeightHeaderGrid = ValueNotifier(90.0);
  final notifierHeightHeaderWallet = ValueNotifier(180.0);
  final notifierHeightHeaderWallet1 = ValueNotifier(180.0);//180=
  final notifierHeightPlanGane = ValueNotifier(100.0);
  final notifierHeightNoPlanGane = ValueNotifier(75.0);


  int CategoriesProfilePages = 1;
  int GaneRoomPages = 0;
  int Gane1RoomPages = 0;
  int CategoryId = 0;
  int CategoryIndex = 0;
  int GaneRoomIndex = 0;
  int UserPointsPages = 0;
  int UserNotiPages = 0;
  int AnswersRoomPages = 0;
  int GamesRoomPages = 0;
  int planesPages = 0;
  int HallRoomPages = 0;
  var secuenceOne = [];
  var secuenceTwo = [];
  var secuenceThree = [];
  var format = 1;
  var urls = [];
  int idAds = 0;
  int idSecuence = 0;
  var valuenotifierOffsetTapCategory = [];
  var valuenotifierOffsetInitialTapCategory = [];
  bool isIOS = false;
  var itemSelected = -1;

  ResultSL itemSequence = ResultSL();


  permi.PermissionStatus permissionStatus = permi.PermissionStatus.denied;
  permi.Permission permission = permi.Permission.phone;

  var AddPointUser = 0;

  String modelName = "";
  String manufacturer = "";

  static const platformChannel = MethodChannel('test.flutter.methodchannel/iOS');
  Timer? timer1;
  int idPlan = 0;
  String plan = "";
  String planvalue = "";

  final ImagePicker picker = ImagePicker();

  var codeReferral = "";
  var state = "";
  var city = "";
  var colonia = "";
  var zipcode = "";
  var tokenTC = "";

  var name = "";
  var lastname = "";
  var telf = "";
  var email = "";
  var address = "";
  var exterior = "";
  var interior = "";
  var addressreference = "";


  var homeOrAnswer = "home";

  var emailPideChip = "";
  var fullnamePideCHip = "";

}