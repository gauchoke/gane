import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Models/accesstok.dart';
import 'package:gane/src/Models/altanplan.dart';
import 'package:gane/src/Models/altanplane1.dart';
import 'package:gane/src/Models/answers_res.dart';
import 'package:gane/src/Models/bannerWall.dart';
import 'package:gane/src/Models/buyplan.dart';
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
import 'package:gane/src/Models/sitemodel.dart';
import 'package:gane/src/Models/totalpoint_profile_categories.dart';
import 'package:gane/src/Models/useraltam.dart';
import 'package:gane/src/Models/userpointlist.dart';
import 'package:gane/src/Models/userpointlist1.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/Models/validatecodemail.dart';
import 'package:gane/src/Models/validatesims.dart';
import 'package:gane/src/Models/verifyphone.dart';
import 'package:gane/src/Models/verifyphonenumber.dart';
import 'package:gane/src/UI/Campaigns/WinCanje.dart';
import 'package:gane/src/UI/Campaigns/ganecampaignsdetail.dart';
import 'package:gane/src/Models/states.dart';
import 'package:gane/src/Models/citieslist.dart';
import 'package:gane/src/Models/colinieslist.dart';
import 'package:gane/src/UI/Games/SumNumber/screens/LoadingScreen.dart';
import 'package:gane/src/UI/Games/webgames.dart';
import 'package:gane/src/UI/Home/RechargePlain/buyplan.dart';
import 'package:gane/src/UI/Home/RechargePlain/paymethods.dart';
import 'package:gane/src/UI/Onboarding/createaccount.dart';
import 'package:gane/src/UI/Onboarding/loginphone.dart';
import 'package:gane/src/UI/Onboarding/onboarding_provider.dart';
import 'package:gane/src/UI/Onboarding/tyc1.dart';
import 'package:gane/src/UI/principalcontainer.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:gane/src/Widgets/dialog_noregister.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:transition/transition.dart';
import 'singleton.dart';
import 'share_preferences.dart';
import 'package:gane/src/Utils/strings.dart';



Singleton singleton = Singleton();
final prefs = SharePreference();

class servicesManager {


  /// Call Endpoint AccessToken
  Future<AccessToken> fetchAccessToken(BuildContext context) async {
    try{

      var url = Uri.parse(Strings.urlBase+"gn/generate-access-token/");

      Map<String,String> headers = {'Content-Type':'application/json'};

      var response = await http.get(url, headers: headers);
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierAccessToken.value = AccessToken.fromJson(decodeJSON);

    }catch (err){
      print('Error: $err');
      return singleton.notifierAccessToken.value;
    }
    return singleton.notifierAccessToken.value;
  }

  ///Call Endpoint Countries List
  Future<Countries> fetchCountriesList(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());
      print(singleton.notifierAccessToken.value.data.accessToken);

      var url = Uri.parse(Strings.urlBase+"location-country/all");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      singleton.notifierCountriesList.value = Countries.fromJson(decodeJSON);
      singleton.notifierCountriesListSearch.value = Countries.fromJson(decodeJSON);

      print(singleton.notifierCountriesList.value.data![0]!.callingCode);

      singleton.notifierCallingCode.value = (singleton.notifierCountriesList.value.data!.length > 0 ? singleton.notifierCountriesList.value.data![0]!.callingCode : "")!;
      print(singleton.notifierCallingCode.value);
      prefs.indiCountry = singleton.notifierCallingCode.value;
      prefs.countryCode = (singleton.notifierCountriesList.value.data!.length > 0 ? singleton.notifierCountriesList.value.data![0]!.id : "")!;
      print(prefs.countryCode);

    }catch (err){
      print('Error: $err');
      return singleton.notifierCountriesList.value;
    }

    return singleton.notifierCountriesList.value;
  }

  ///Call Endpoint Validate Phone number
  Future<Verifyphone1> fetchVerifyNumber(BuildContext context, String phoneNumber, Function stop) async {
    try{

      final msg = jsonEncode({
        'phoneNumber':phoneNumber,
        'phonePrefix':prefs.indiCountry,
      });

      var url = Uri.parse(Strings.urlBase4+"onboarding/verify-number");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken};

      var response = await http.post(url, headers: headers, body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      stop();
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierVerifyPhone.value = Verifyphone1.fromJson(decodeJSON);

      if(singleton.notifierVerifyPhone.value.code == 100){ /// OK

        /*print("VALIDATION CODE:  ${singleton.notifierVerifyPhone.value.codeValidate!.code!.toString()}");
        prefs.flagWinCanje = "0";
        singleton.codeSMS = singleton.notifierVerifyPhone.value.codeValidate!.code!;
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
        singleton.notifierVisibleButtoms.value = 2;
        prefs.imei = singleton.notifierVerifyPhone.value.data!.user!.imei!;
        print(prefs.imei);*/


        if(singleton.notifierVerifyPhone.value.data!.userExist! == "false"){
          dialogNoRegister(singleton.navigatorKey.currentContext!, goTO, decodeJSON["message"]);

        }else {
          utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
          singleton.notifierVisibleButtoms.value = 2;
          prefs.flagWinCanje = "0";
        }

      }else {


        //if(singleton.notifierVerifyPhone.value.code == 102){
          utils.openSnackBarInfo(context, singleton.notifierVerifyPhone.value.message!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

          if(singleton.notifierVerifyPhone.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          Future.delayed(const Duration(seconds: 1), () {

          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierVerifyPhone.value;
    }

    return singleton.notifierVerifyPhone.value; // 3344866716

  }

  ///Call Endpoint Re sent Code SMS
  Future<Verifyphone1> fetchReSendVerifyNumber(BuildContext context, String phoneNumber) async {
    try{

      final msg = jsonEncode({
        'phoneNumber':phoneNumber,
        'phonePrefix':prefs.indiCountry,
      });

      var url = Uri.parse(Strings.urlBase4+"onboarding/verify-number");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken};

      var response = await http.post(url, headers: headers, body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      singleton.notifierVerifyPhone.value = Verifyphone1.fromJson(decodeJSON);

      if(singleton.notifierVerifyPhone.value.code == 100){ /// OK
        //singleton.codeSMS = singleton.notifierVerifyPhone.value.codeValidate!.code!;
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

      }else {
        //singleton.codeSMS = singleton.notifierVerifyPhone.value.codeValidate!.code!;
        utils.openSnackBarInfo(context, singleton.notifierVerifyPhone.value.message!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

        if(singleton.notifierVerifyPhone.value.code == 102){
          utils.openSnackBarInfo(context, singleton.notifierVerifyPhone.value.message!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

        }else if(singleton.notifierVerifyPhone.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          Future.delayed(const Duration(seconds: 1), () {
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierVerifyPhone.value;
    }

    return singleton.notifierVerifyPhone.value;
  }

  ///Call Endpoint Validate Number
  Future<Verifyphone> fetchValidateNumber(BuildContext context, String phoneNumber, String code,Function stop, Function validate) async {
    try{
      var jsonIV = utils.encryptPwdIv(code);
      String version = singleton.packageInfo.version+"-"+singleton.packageInfo.buildNumber;
      bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      var platform = 'user_android';
      if (isIOS == true){
        platform = 'user_ios';
      }

      final msg = jsonEncode({
        'phoneNumber':phoneNumber,
        'phonePrefix':prefs.indiCountry,
        'iv': jsonIV['iv'],
        'code': jsonIV['encrypted'],
        "pushToken": "0",
        "version": version,
        "platform": platform,
      });

      var url = Uri.parse(Strings.urlBase4+"onboarding/validate-code");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken};

      var response = await http.post(url, headers: headers, body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      /*stop();
      Navigator.pop(context);*/

      var decodeJSON = jsonDecode(response.body);
      var dec = jsonEncode(decodeJSON);
      singleton.notifierVerifyPhones.value = Verifyphone.fromJson(decodeJSON);


      if(singleton.notifierVerifyPhones.value.code == 100){ /// OK
        //.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
        prefs.authToken = singleton.notifierVerifyPhones.value.data!.authToken!;
        print(decodeJSON["data"]["authToken"]);
        //prefs.authToken = decodeJSON["data"]["authToken"];
        validate();
        await Future.delayed(Duration(seconds: 3));

        Future.delayed(const Duration(milliseconds: 250), () {
          stop();
          Navigator.pop(context);
          Navigator.pushReplacement(context, Transition(child: PrincipalContainer()) );
        });

      }else {
        stop();
        Navigator.pop(context);
        //singleton.codeSMS = singleton.notifierVerifyPhone.value.codeValidate!.code!;
        singleton.notifierError.value = [false, "","RED"];
        utils.openSnackBarInfo(context, decodeJSON["message"], "assets/images/ic_sad.svg",CustomColors.orangeborderpopup,"success");

        if(singleton.notifierVerifyPhone.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          Future.delayed(const Duration(seconds: 1), () {
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierVerifyPhones.value;
    }

    return singleton.notifierVerifyPhones.value;
  }

  /// Go to create account
  void goTO(){

    var time = 350;
    if(singleton.isIOS == false){
      time = utils.ValueDuration();
    }

    Navigator.push(singleton.navigatorKey.currentContext!, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: CreateAccount(),
        reverseDuration: Duration(milliseconds: time)
    ));

  }

  ///Call Endpoint Create Account
  Future<Createuser> fetchCreateAccount(BuildContext context, String phoneNumber, String fullname, String email, Function stop, OnboardingProvider onboardingProvider, String pin, String portableNumber, String numberOrQRcode) async {
    try{

      String version = singleton.packageInfo.version+"-"+singleton.packageInfo.buildNumber;
      bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      var platform = 'user_android';
      if (isIOS == true){
        platform = 'user_ios';
      }


      var phoneNumberOrIcc = "";
      var phonePrefix = "";

      if(onboardingProvider.haveChip == 2){ /// YNO have chip

        phoneNumberOrIcc = phoneNumber;
        phonePrefix = prefs.indiCountry;

      }else{ //if(onboardingProvider.haveChip == 1 && onboardingProvider.keepNumber == 2){  /// Yes have chip and No keep number

        if(singleton.notifierValidateBarCode.value.code == 100){
          phoneNumberOrIcc = singleton.notifierValidateBarCode.value.data!.sim!.iCC!;
          phonePrefix = "";
        }else if(numberOrQRcode!=""){
          phoneNumberOrIcc = numberOrQRcode;
          phonePrefix = "";
        }

      }


      final msg = jsonEncode({
        "fullname": fullname,
        "phoneNumberOrIcc": phoneNumberOrIcc,
        "phoneTokeep": portableNumber,
        "phonePrefix": prefs.indiCountry,
        "ganeSim": onboardingProvider.haveChip == 1 ? true : false,
        "portability": onboardingProvider.keepNumber == 1 ? true : false,
        "pin": pin,
        "type": "lc",
        "pushToken": "0",
        "version": version,
        "platform": platform,
        "codeReferrals": email,
        //"systemCountry": prefs.countryCode,
      });

      var url = Uri.parse(Strings.urlBase4+"onboarding/create-account");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken};

      var response = await http.post(url, headers: headers, body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      stop();
      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierCreateAccount.value = Createuser.fromJson(decodeJSON);

      if(singleton.notifierCreateAccount.value.code == 100){ /// OK

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"success");
        prefs.authToken = singleton.notifierCreateAccount.value.data!.authToken!;
        singleton.notifierValueYButtons.value = 1.0;
        prefs.imei = singleton.notifierCreateAccount.value.data!.user!.imei!;
        //fetchValidateEmail(context, email);

        if(singleton.codeReferral != ""){
          fetchWinPointsReferrals(context, email);
        }else{
          Navigator.pushReplacement(context, Transition(child: PrincipalContainer()) );
        }

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierCreateAccount.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          Future.delayed(const Duration(seconds: 1), () {
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierCreateAccount.value;
    }

    return singleton.notifierCreateAccount.value;
  }

  ///Call Endpoint Validate email
  Future<Createuser> fetchValidateEmail(BuildContext context, String email) async {
    try{


      final msg = jsonEncode({
        "email": email,
      });

      var url = Uri.parse(Strings.urlBase+"onboarding/verify-email");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken};

      var response = await http.post(url, headers: headers, body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      //singleton.notifierCreateAccount.value = Createuser.fromJson(decodeJSON);

      if(decodeJSON["code"] == 100){ /// OK

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierCreateAccount.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          Future.delayed(const Duration(seconds: 1), () {
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierCreateAccount.value;
    }

    return singleton.notifierCreateAccount.value;
  }

  ///Call Endpoint Create Account
  Future<Validatecodemail> fetchCreateAccountValidateCode(BuildContext context, String code, Function stop) async {
    try{


      final msg = jsonEncode({
        "code": code,
      });

      var url = Uri.parse(Strings.urlBase+"onboarding/verify-code");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.post(url, headers: headers, body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      stop();
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierVerifyAccountCode.value = Validatecodemail.fromJson(decodeJSON);

      if(singleton.notifierVerifyAccountCode.value.code == 100){ /// OK
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(context, Transition(child: PrincipalContainer()) );
        });

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierVerifyAccountCode.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierVerifyAccountCode.value;
    }

    return singleton.notifierVerifyAccountCode.value;
  }

  ///Call Endpoint Points Profile Categories
  Future<TotalpointProfileCategories> fetchPointProfileCategories(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase4+"category/points-user");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));


      });

      var decodeJSON = jsonDecode(response.body);
      var enco = json.encode(decodeJSON);
      singleton.notifierPointsProfileCategories.value = TotalpointProfileCategories.fromJson(decodeJSON);

      if(singleton.notifierPointsProfileCategories.value.code == 100){ /// OK
        singleton.notifierPointsProfile.value = singleton.notifierPointsProfileCategories.value.data!.totalUser!.toDouble();
        print(singleton.notifierPointsProfile.value);
      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierPointsProfileCategories.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierPointsProfileCategories.value;
    }

    return singleton.notifierPointsProfileCategories.value;
  }

  ///Call Endpoint Categories Profile
  Future<Profilecategories> fetchCategoriesProfile(BuildContext context, String aob) async {
    try{

      print(prefs.authToken);

      final msg = jsonEncode({
        "limit": "20",
        "offset": singleton.CategoriesProfilePages.toString(),
      });

      var url = Uri.parse(Strings.urlBase4+"category/all");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers, body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
        print("caímos");
        singleton.notifierIsOffline.value = true;
      });
      var decodeJSON = jsonDecode(response.body);
      var enco = json.encode(decodeJSON);
      //singleton.notifierCategoriesProfile.value = Profilecategories.fromJson(decodeJSON);

      if(aob=="borrar"){
        //Navigator.pop(context);
        singleton.notifierCategoriesProfile.value = Profilecategories.fromJson(decodeJSON);
      }else{
        Profilecategories notifierProductsListPrevius = singleton.notifierCategoriesProfile.value;
        notifierProductsListPrevius.data!.result!.addAll(Profilecategories.fromJson(decodeJSON).data!.result!);
        singleton.notifierCategoriesProfile.value = Profilecategories(code: 1,message: "No hay nada", status: false, );
        singleton.notifierCategoriesProfile.value = notifierProductsListPrevius;
      }

      if(singleton.notifierCategoriesProfile.value.code == 100){ /// OK

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierCategoriesProfile.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierCategoriesProfile.value;
    }

    return singleton.notifierCategoriesProfile.value;
  }

  ///Call Endpoint SubCategories Profile
  Future<Profilesubcategories> fetchSubCategoriesProfile(BuildContext context, Function reload) async {
    try{

      print(prefs.authToken);

      var url = Uri.parse(Strings.urlBase4+"sub-category/all/"+singleton.CategoryId.toString());
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.get(url, headers: headers,).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierSubCategoriesProfile.value = Profilesubcategories.fromJson(decodeJSON);

      singleton.notifieriTemSubCategory.value = 0;
      singleton.notifieriTemQuestion.value = 0;

      if(singleton.notifierSubCategoriesProfile.value.code == 100){ /// OK

        if(singleton.notifierSubCategoriesProfile.value.data![0]!.questions![0]!.type!.id == 1){ /// Text Answer
          if(singleton.notifierSubCategoriesProfile.value.data![0]!.questions![0]!.answers![0]!.answersuser!.length > 0){
            var value = singleton.notifierSubCategoriesProfile.value.data![0]!.questions![0]!.answers![0]!.answersuser![0]!.answer;
            reload(value);
          }
        }

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierSubCategoriesProfile.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierSubCategoriesProfile.value;
    }

    return singleton.notifierSubCategoriesProfile.value;
  }

  ///Call Endpoint Send Answer
  Future<AnswersRes> fetchSendAnswer(BuildContext context, List question, int category, Function passAllAnswertoCompleted) async {
    try{

      print(prefs.authToken);
      List last = [];
      /// Erick dijo que eso esta bien, siempre enviar el true.
      if(singleton.notifierSubCategoriesProfile.value.data!.length -1 == singleton.notifieriTemSubCategory.value){
        last.add(true);
      }

      Map<String, dynamic> myObject = {
        "subcategory": category,
        "question": question,
        "lastsSubcategory": last,
      };

      /*List questions = [];
      for( int i = 0; i < vectordedatos.length; i++) {
          Map<String, dynamic> itemInterno = {
            "id": vectordedatos[i]["id"],
            "response": vectordedatos[i]["response"],
          };
          last.add(itemInterno);
      }

      Map<String, dynamic> creditInterno = {
        "systemCreditTypeId": 1,
        "questions": questions,
      };

      Map<String, dynamic> credit = {
        "credit": creditInterno,
      };

      final msg = jsonEncode(credit);*/


      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"sub-category/answers/check");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierAnswerResponse.value = AnswersRes.fromJson(decodeJSON);


      if(singleton.notifierAnswerResponse.value.code == 100){ /// OK

        /*if(type==1){ /// Text Answer
          ProfilesubcategoriesDataQuestionsAnswersAnswersuser item = ProfilesubcategoriesDataQuestionsAnswersAnswersuser(answer: answer,check: true,from: "End");
          Profilesubcategories pre = singleton.notifierSubCategoriesProfile.value;
          pre.data![singleton.notifieriTemSubCategory.value]!.questions![singleton.notifieriTemQuestion.value]!.answers![0]!.answersuser!.add(item);
          singleton.notifierSubCategoriesProfile.value = Profilesubcategories(code: 1,message: "No hay nada", status: false, );
          singleton.notifierSubCategoriesProfile.value = pre;

        }*/

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"complete");
        passAllAnswertoCompleted();

        print(singleton.notifierSubCategoriesProfile.value.data!.length -1);
        print(singleton.notifieriTemSubCategory.value);

        if(singleton.notifierSubCategoriesProfile.value.data!.length -1 == singleton.notifieriTemSubCategory.value){ /// The last Subcategory
          singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value;

          Profilecategories categories = singleton.notifierCategoriesProfile.value;
          Result categoryItem = categories.data!.result![singleton.CategoryIndex]!;
          categoryItem.categoryStatus = "completed";
          singleton.notifierCategoriesProfile.value = Profilecategories(code: 1,message: "No hay nada", status: false, );
          singleton.notifierCategoriesProfile.value = categories;
          singleton.notifierCompleteCategory.value = "YES";

          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);

          });

          // Navigator.pop(context);

        }else{
          singleton.notifieriTemSubCategory.value = singleton.notifieriTemSubCategory.value + 1;
          singleton.notifieriTemQuestion.value = 0;
        }


      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierAnswerResponse.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierAnswerResponse.value;
    }

    return singleton.notifierAnswerResponse.value;
  }

  ///Call Endpoint Mira Room
  Future<Roomlook> fetchMiraRoom(BuildContext context, String aob) async {
    try{


      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.GaneRoomPages,
        //"offset": 2,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"sequence-ads/getAll");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(aob=="borrar"){
        singleton.notifierLookRoom.value = Roomlook.fromJson(decodeJSON);
      }else{
        Roomlook notifierGaneRoom = singleton.notifierLookRoom.value;
        notifierGaneRoom.data!.result!.addAll(Roomlook.fromJson(decodeJSON).data!.result!);
        singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        singleton.notifierLookRoom.value = notifierGaneRoom;
      }


      if(singleton.notifierLookRoom.value.code == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(singleton.notifierLookRoom.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierLookRoom.value;
    }

    return singleton.notifierLookRoom.value;
  }

  ///Call Endpoint Update Coords Profile
  Future<Roomlook> fetchUpdateProfile(BuildContext context) async {
    try{

      print(prefs.authToken);
      Map<String, dynamic> myObject = {
        "latitude": singleton.lat,
        "longitude": singleton.lon,
        "pushToken" : prefs.token
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"onboarding/update-profile");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      //Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierLookRoom.value;
    }

    return singleton.notifierLookRoom.value;
  }

  ///Call Endpoint Obtain Points Look Room
  Future<Roomlook> fetchObtainPointsLookRoom(BuildContext context, Function showAlertWonPoints) async {
    try{


      Map<String, dynamic> myObject = {
        "ads": singleton.idAds,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"points/ads-create");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        showAlertWonPoints();
      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierLookRoom.value;
    }

    return singleton.notifierLookRoom.value;
  }

  ///Call Endpoint Gane Room
  Future<Roomlook> fetchGaneRoom(BuildContext context, String aob) async {
    //Roomlook result = Roomlook(code: 1,message: "No hay nada", status: false, );
    try{

      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.Gane1RoomPages,
        "latitude": singleton.lat,
        "longitude": singleton.lon,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase4+"sequence-ads/hall-gain-sequence");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
        print("caímos");
        utils.check();
        //singleton.notifierIsOffline.value = true;
      });

      var decodeJSON = jsonDecode(response.body);
      //result = Roomlook.fromJson(decodeJSON);
      var js = jsonEncode(decodeJSON);
      if(aob=="borrar"){
        singleton.notifierLookRoom.value = Roomlook.fromJson(decodeJSON);
      }else{
        Roomlook notifierGaneRoom = singleton.notifierLookRoom.value;
        notifierGaneRoom.data!.result!.addAll(Roomlook.fromJson(decodeJSON).data!.result!);
        singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        singleton.notifierLookRoom.value = notifierGaneRoom;

      }

      if(singleton.notifierLookRoom.value.code == 100){ /// OK
        ///if(result.code == 100){ /// OK

        /*Roomlook notifierGaneRoom = singleton.notifierLookRoom.value;
        notifierGaneRoom.code = 102;
        singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        singleton.notifierLookRoom.value = notifierGaneRoom;*/

      }else {

        if(singleton.notifierLookRoom.value.code == 120){/// Token Expire
          //if(result.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierLookRoom.value;
      //return result;
    }

    return singleton.notifierLookRoom.value;
    //return result;
  }

  ///Call Endpoint Send Answer
  Future<void> fetchSendAnswerGaneRoom(BuildContext context, List question, Function passAllAnswertoCompleted) async {
    try{


      Map<String, dynamic> myObject = {
        "ads": singleton.idAds,
        "questionAds": question,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"sequence-ads/question");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      //Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.greenbutton,"complete");
        //passAllAnswertoCompleted();
        fetchObtainPointsLookRoom(context, passAllAnswertoCompleted);

      }else {
        Navigator.pop(context);
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      //return singleton.notifierAnswerResponse.value;
    }

    //return singleton.notifierAnswerResponse.value;
  }

  ///Call Endpoint Click Secuence
  Future<void> fetchClickSequence(BuildContext context) async {
    try{


      Map<String, dynamic> myObject = {
        "sequenceId": singleton.idSecuence,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"sequence-ads/click");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      //Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint User Points
  Future<Userpoints> fetchPointUserPoints(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"points/points-user");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      var js = jsonEncode(decodeJSON);
      singleton.notifierUserPoints.value = Userpoints.fromJson(decodeJSON);

      if(singleton.notifierUserPoints.value.code == 100){ /// OK
        singleton.notifierPointsUser.value = double.parse(singleton.notifierUserPoints.value.data!.result!);
        print(singleton.notifierPointsUser.value);
      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierUserPoints.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierUserPoints.value;
    }

    return singleton.notifierUserPoints.value;
  }

  ///Call Endpoint List Points User
  Future<Userpointlist> fetchListPointsUser(BuildContext context, String aob) async {
    //Roomlook result = Roomlook(code: 1,message: "No hay nada", status: false, );
    try{

      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.UserPointsPages,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"points/total-all");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      //result = Roomlook.fromJson(decodeJSON);
      if(aob=="borrar"){
        singleton.notifierListUserPoints.value = Userpointlist.fromJson(decodeJSON);
      }else{
        Userpointlist notifierGaneRoom = singleton.notifierListUserPoints.value;
        notifierGaneRoom.data!.result!.addAll(Userpointlist.fromJson(decodeJSON).data!.result!);
        singleton.notifierListUserPoints.value = Userpointlist(code: 1,message: "No hay nada", status: false, );
        singleton.notifierListUserPoints.value = notifierGaneRoom;
      }

      if(singleton.notifierListUserPoints.value.code == 100){ /// OK
        ///if(result.code == 100){ /// OK

      }else {

        if(singleton.notifierListUserPoints.value.code == 120){/// Token Expire
          //if(result.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierListUserPoints.value;
      //return result;
    }

    return singleton.notifierListUserPoints.value;
    //return result;
  }

  ///Call Endpoint List Points User
  Future<Userpointlist> fetchListPointsUser1(BuildContext context, String aob) async {
    //Roomlook result = Roomlook(code: 1,message: "No hay nada", status: false, );
    try{

      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.UserPointsPages,
      };

      final msg = jsonEncode(myObject);


      var url = Uri.parse(Strings.urlBase+"points/total-all");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
        print("caímos");
        singleton.notifierIsOffline.value = true;
      });

      var decodeJSON = jsonDecode(response.body);
      if(aob=="borrar"){
        singleton.notifierListUserPoints1.value = Userpointlist1.fromJson(decodeJSON);
      }else{

        Userpointlist1 notifierGaneRoom = singleton.notifierListUserPoints1.value;
        notifierGaneRoom.data!.items!.addAll(Userpointlist1.fromJson(decodeJSON).data!.items!);
        singleton.notifierListUserPoints1.value = Userpointlist1(code: 1,message: "No hay nada", status: false, );
        singleton.notifierListUserPoints1.value = notifierGaneRoom;
      }

      if(singleton.notifierListUserPoints1.value.code == 100){ /// OK
        ///if(result.code == 100){ /// OK

      }else {

        if(singleton.notifierListUserPoints1.value.code == 120){/// Token Expire
          //if(result.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierListUserPoints.value;
      //return result;
    }

    return singleton.notifierListUserPoints.value;
    //return result;
  }

  ///Call Endpoint Settings
  Future<Settingsuser> fetchSettings(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"notification/setting");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      singleton.notifierSettingUser.value = Settingsuser.fromJson(decodeJSON);

      if(singleton.notifierSettingUser.value.code == 100){ /// OK

        for(int i=0 ; i<singleton.notifierSettingUser.value.data!.faq!.length; i++){

          if(singleton.notifierSettingUser.value.data!.faq![i].tag == "policies"){
            singleton.polities = singleton.notifierSettingUser.value.data!.faq![i].url!;

          }else if(singleton.notifierSettingUser.value.data!.faq![i].tag == "terms"){
            singleton.terms = singleton.notifierSettingUser.value.data!.faq![i].url!;

          }else if(singleton.notifierSettingUser.value.data!.faq![i].tag == "about"){
            singleton.about = singleton.notifierSettingUser.value.data!.faq![i].url!;

          }else{
            singleton.contactus = singleton.notifierSettingUser.value.data!.faq![i].url!;
          }

        }


      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierSettingUser.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierSettingUser.value;
    }

    return singleton.notifierSettingUser.value;
  }

  ///Call Endpoint Settings Notification change state
  Future<void> fetchSettingsNotifications(BuildContext context, int notificationStatus) async {
    try{

      Map<String, dynamic> myObject = {
        "notificationStatus": notificationStatus,
      };

      final msg = jsonEncode(myObject);

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"notification/setting");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.put(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        fetchSettings(context);

      }else {
        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Notification Count
  Future<void> fetchNotificationCount(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"notification/views");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        print(decodeJSON["data"][0]["count"]);
        singleton.notifierNotificationCount.value = decodeJSON["data"][0]["count"];
      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Notification go to Zero
  Future<void> fetchNotificationZero(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"notification/views");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.put(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        fetchNotificationCount(context);

      }else {
        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Notifications
  Future<Notificationslist> fetchListNotifications(BuildContext context, String aob, String type) async {
    try{

      var vectTypes = [];
      vectTypes.add(type);
      if(type=="GN"){
        vectTypes.add("ADSWEB");
      }

      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.UserNotiPages,
        "type": vectTypes,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"notification/all");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      if(aob=="borrar"){
        singleton.notifierListNotfications.value = Notificationslist.fromJson(decodeJSON);
      }else{
        Notificationslist notifierGaneRoom = singleton.notifierListNotfications.value;
        notifierGaneRoom.data!.result!.addAll(Notificationslist.fromJson(decodeJSON).data!.result!);
        singleton.notifierListNotfications.value = Notificationslist(code: 1,message: "No hay nada", status: false, );
        singleton.notifierListNotfications.value = notifierGaneRoom;
      }

      if(singleton.notifierListNotfications.value.code == 100){ /// OK
        ///if(result.code == 100){ /// OK

      }else {

        if(singleton.notifierListNotfications.value.code == 120){/// Token Expire
          //if(result.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierListNotfications.value;
      //return result;
    }

    return singleton.notifierListNotfications.value;
    //return result;
  }

  ///Call Endpoint Click General Notification
  Future<void> fetchClickGeneralNotification(int idSequence, String type, BuildContext context, Function launchOrNot) async {
    try{


      Map<String, dynamic> myObject = {
        "id": idSequence,
        "type": type,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"notification/one-gn");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      if(type == "ADSWEB"){
        Navigator.pop(context);
      }
      //
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        singleton.notifierGeneralnotification.value = Generalnotification.fromJson(decodeJSON);

        var url = singleton.notifierGeneralnotification.value.data!.url!;
        if(url!.contains("http")){
          singleton.notifierCallOrLink.value = Strings.visitgoweb;
        }else{
          singleton.notifierCallOrLink.value = Strings.makecall;
        }


        if(type!="GN"){
          //launchOrNot();
        }

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Click Sequence Notification
  Future<void> fetchClickSequenceNotification(int idSequence, String type, BuildContext context) async {
    try{


      Map<String, dynamic> myObject = {
        "id": idSequence,
        "type": type,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"notification/one-sequence");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        ResultSL sequence = ResultSL.fromJson(decodeJSON["data"]);

        singleton.itemSequence = sequence;

        //singleton.itemSelected = index;
        singleton.idSecuence = sequence.id!;
        singleton.idAds = sequence.ads![0]!.id!;
        singleton.format = sequence.ads![0]!.formatValue!;
        singleton.notifierPointsGaneRoom.value = sequence.ads![0]!.pointsAds!;

        if(sequence.ads![0]!.formatValue == 3){ /// Poll
          singleton.notifierQuestionAds.value = sequence.ads![0]!.questionAds!;
        }else{
          singleton.notifierQuestionAds.value = <QuestionAds>[];
        }

        ///Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: GaneCampaignDetail(item: sequence,relaunch: relaunch,) ));

        var time = 350;
        if(singleton.isIOS == false){
          time = utils.ValueDuration();
        }

        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: time), child: GaneCampaignDetail(item: sequence, relaunch: relaunch,),
            reverseDuration: Duration(milliseconds: time)
        ));



      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Click Sequence Notification1
  Future<void> fetchClickSequenceNotification1(int idSequence, String type, BuildContext context) async {
    try{


      Map<String, dynamic> myObject = {
        "id": idSequence,
        "type": type,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"notification/one-sequence");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        ResultSL sequence = ResultSL.fromJson(decodeJSON["data"]);

        //singleton.itemSelected = index;
        singleton.idSecuence = sequence.id!;
        singleton.idAds = sequence.ads![0]!.id!;
        singleton.format = sequence.ads![0]!.formatValue!;
        singleton.notifierPointsGaneRoom.value = sequence.ads![0]!.pointsAds!;

        if(sequence.ads![0]!.formatValue == 3){ /// Poll
          singleton.notifierQuestionAds.value = sequence.ads![0]!.questionAds!;
        }else{
          singleton.notifierQuestionAds.value = <QuestionAds>[];
        }

        //Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: GaneCampaignDetail(item: sequence,relaunch: relaunch,) ));
        //});



      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Delete Notification
  Future<void> fetchDeleteNotifications(BuildContext context, int idnoti, int idnoti1, String status, Function deleteNotificacion) async {
    try{

      Map<String, dynamic> myObject = {
        "id": idnoti,
        "notificationId": idnoti1,
        "status": status,
      };

      final msg = jsonEncode(myObject);

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"notification/delete");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.delete(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      int count = 2;
      Navigator.of(context).popUntil((_) => count-- <= 0);

      if(decodeJSON["code"] == 100){ /// OK
        deleteNotificacion();

      }else {
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Obtain Points Notifications link
  Future<Roomlook> fetchObtainPointsNotificationslink(BuildContext context, Function showAlertWonPoints) async {
    try{


      Map<String, dynamic> myObject = {
        "notification": singleton.notifierGeneralnotification.value.data!.id,
        "points": singleton.notifierGeneralnotification.value.data!.points,
        "prices": singleton.notifierGeneralnotification.value.data!.prices,
        "type": "LIKES",

      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"points/ads-create-likes");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        showAlertWonPoints();
      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierLookRoom.value;
    }

    return singleton.notifierLookRoom.value;
  }

  ///Call Endpoint Answers Room
  Future<Roomlook> fetchAnswersRoom(BuildContext context, String aob) async {
    try{


      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.AnswersRoomPages,
        //"offset": 2,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase4+"sequence-ads/hall-answer");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(aob=="borrar"){
        singleton.notifierAnswerRoom.value = Roomlook.fromJson(decodeJSON);
      }else{
        Roomlook notifierGaneRoom = singleton.notifierAnswerRoom.value;
        notifierGaneRoom.data!.result!.addAll(Roomlook.fromJson(decodeJSON).data!.result!);
        singleton.notifierAnswerRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        singleton.notifierAnswerRoom.value = notifierGaneRoom;
      }


      if(singleton.notifierAnswerRoom.value.code == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(singleton.notifierLookRoom.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierAnswerRoom.value;
    }

    return singleton.notifierAnswerRoom.value;
  }

  ///Call Endpoint Games Room
  Future<Gamelist> fetchGamesRoom1(BuildContext context, String aob) async {
    try{


      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.GamesRoomPages,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"sequence-ads/hall-gamer");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(aob=="borrar"){
        singleton.notifierGamesRoom.value = Gamelist.fromJson(decodeJSON);
      }else{
        Gamelist notifierGaneRoom = singleton.notifierGamesRoom.value;
        notifierGaneRoom.data!.result!.addAll(Gamelist.fromJson(decodeJSON).data!.result!);
        singleton.notifierGamesRoom.value = Gamelist(code: 1,message: "No hay nada", status: false, );
        singleton.notifierGamesRoom.value = notifierGaneRoom;
      }


      if(singleton.notifierGamesRoom.value.code == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(singleton.notifierGamesRoom.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierGamesRoom.value;
    }

    return singleton.notifierGamesRoom.value;
  }

  ///Call Endpoint Games Room
  Future<GamelistN> fetchGamesRoom(BuildContext context,) async {
    try{



      var url = Uri.parse(Strings.urlBase+"easypromo/list");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.get(url, headers: headers,).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      //Navigator.pop(context);

      singleton.notifierGamesRoomN.value = GamelistN.fromJson(decodeJSON);

      if(singleton.notifierGamesRoomN.value.code == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(singleton.notifierGamesRoom.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierGamesRoomN.value;
    }

    return singleton.notifierGamesRoomN.value;
  }

  ///Call Endpoint User Profile
  Future<Getprofile> fetchUserProfile(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"onboarding/get-profile");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
      });
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierUserProfile.value = Getprofile.fromJson(decodeJSON);

      if(singleton.notifierUserProfile.value.code == 100){ /// OK
        singleton.notifierPointsUser.value = double.parse(singleton.notifierUserPoints.value.data!.result!);
        print(singleton.notifierPointsUser.value);

        //prefs.authToken = singleton.notifierUserProfile.value.data!.authToken!;

        if(singleton.notifierUserProfile.value.data!.user!.userAltan! == true){ /// Call endpoint user data plan
          singleton.notifierUseraltanPlan.value = AltanPLane(code: 1,message: "No hay nada", status: false, data: DataAP(plan: Plan(missingDay: "0",gbAvailable: "0",gbUsed: "0",totalGd: "0"  ) ) );
          //fetchUserAltanPlan(context);
        }else{ /// Call endpoint banner
          singleton.notifierBannerAltan.value = BannerWallet(code: 1,message: "No hay nada", status: false, data: DataW(item: ItemW( callingCode: "", photoUrl: "", sms: "", whatsapp: "")) );
          servicemanager.fetchBannerAltan(context);
        }

        print(prefs.imei);
        print(singleton.notifierUserProfile.value.data!.user!.imei);

        /*if(prefs.imei != singleton.notifierUserProfile.value.data!.user!.imei){
          print(prefs.imei);
          print(singleton.notifierUserProfile.value.data!.user!.imei);
          utils.stopTimer();
          utils.goLogin();
        }*/


      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierUserProfile.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          prefs.imei = "0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierUserProfile.value;
    }

    return singleton.notifierUserProfile.value;
  }
  Future<Getprofile> fetchUserProfile1(BuildContext context) async {
    try{



      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"onboarding/get-profile");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));notifierUseraltanPlan
      });

      var decodeJSON = jsonDecode(response.body);
      singleton.notifierUserProfile.value = Getprofile.fromJson(decodeJSON);

      if(singleton.notifierUserProfile.value.code == 100){ /// OK
        singleton.notifierPointsUser.value = double.parse(singleton.notifierUserPoints.value.data!.result!);
        print(singleton.notifierPointsUser.value);

        //prefs.authToken = singleton.notifierUserProfile.value.data!.authToken!;

        if(singleton.notifierUserProfile.value.data!.user!.userAltan! == true){ /// Call endpoint user data plan
          singleton.notifierUseraltanPlan.value = AltanPLane(code: 1,message: "No hay nada", status: false, data: DataAP(plan: Plan(missingDay: "0",gbAvailable: "0",gbUsed: "0",totalGd: "0"  ) ) );
          fetchUserAltanPlan(context);
        }else{ /// Call endpoint banner
          singleton.notifierBannerAltan.value = BannerWallet(code: 1,message: "No hay nada", status: false, data: DataW(item: ItemW( callingCode: "", photoUrl: "", sms: "", whatsapp: "")) );
          servicemanager.fetchBannerAltan(context);
        }

        print(prefs.imei);
        print(singleton.notifierUserProfile.value.data!.user!.imei);

        /*if(prefs.imei != singleton.notifierUserProfile.value.data!.user!.imei){
          utils.stopTimer();
          utils.goLogin();
        }*/


      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierUserProfile.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          prefs.imei = "0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierUserProfile.value;
    }

    return singleton.notifierUserProfile.value;
  }

  ///Call Endpoint Update Coords Profile
  Future<void> fetchUpdateUserProfile(String fullname, String email, BuildContext context, Function stop) async {
    try{

      print(prefs.authToken);
      Map<String, dynamic> myObject = {
        "fullname": fullname,
        "email": email,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"profile/update");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.put(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      //Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);
      var js = jsonEncode(decodeJSON);
      stop();

      utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangeborderpopup,"error");
      if(decodeJSON["code"] == 100){ /// OK
        fetchUserProfile(context);
      }else {

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint User Logout
  Future<void> fetchLogout(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"onboarding/logout");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.post(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK

        prefs.flagWinCanje = "0";
        prefs.authToken ="0";
        prefs.imei = "0";
        singleton.notifierVisibleButtoms.value = 0; // 1
        prefs.helCategories = "";
        prefs.helCategories = "OK";
        Future.delayed(const Duration(milliseconds: 10), () {
          Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
        });

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  /// Relaunch Enpoints Home App
  void relaunch()async{
    try {
      BuildContext context = singleton.navigatorKey.currentContext!;

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        servicemanager.fetchPointProfileCategories(context);
        if(singleton.lat != 0.0){
          servicemanager.fetchUpdateProfile(context);
        }

        singleton.Gane1RoomPages = 0;
        singleton.notifierLookRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        servicemanager.fetchGaneRoom(context, "borrar");

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
    }

  }

  ///Call Endpoint User Altam
  Future<UserAltan> fetchUserAltam(BuildContext context) async {
    try{



      print(prefs.LanguageCode.toString().toLowerCase());
      print(prefs.authToken);

      var url = Uri.parse(Strings.urlBase+"points/altan-configuration");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      singleton.notifierUseraltan.value = UserAltan.fromJson(decodeJSON);
      var encode = jsonEncode(decodeJSON);

      if(singleton.notifierUseraltan.value.code == 100){ /// OK

        print("ExchangeDay: "+singleton.notifierUseraltan.value.data!.item!.exchangeDay!);
        print("flagWinCanje: "+prefs.flagWinCanje);
        if(singleton.notifierUseraltan.value.data!.item!.exchangeDay! != "7" && prefs.flagWinCanje =="Canjeo"){ /// did it Canje
          prefs.flagWinCanje = "0";
        }


      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierUseraltan.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }

      return  singleton.notifierUseraltan.value;

    }catch (err){
      print('Error: $err');
      return  singleton.notifierUseraltan.value;
    }

  }

  ///Call Endpoint Achange coins to Mb
  Future<void> fetchExchangeCoinsToMb(int altanId, BuildContext context) async {
    try{

      print(prefs.authToken);
      Map<String, dynamic> myObject = {
        "altanId": altanId,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"points/altan-plan-create");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);
      var js = jsonEncode(decodeJSON);


      if(decodeJSON["code"] == 100){ /// OK
        /*fetchUserProfile(context);
        fetchPointUserPoints(context);
        fetchUserAltam(context);
        singleton.UserPointsPages = 0;
        singleton.notifierListUserPoints1.value = Userpointlist1(code: 1,message: "No hay nada", status: false, );
        fetchListPointsUser1(context,"agregar");*/

        singleton.UserPointsPages = 0;
        singleton.notifierListUserPoints.value = Userpointlist(code: 1,message: "No hay nada", status: false, );
        fetchPointUserPoints(context);
        singleton.UserPointsPages = 0;
        singleton.notifierListUserPoints1.value = Userpointlist1(code: 1,message: "No hay nada", status: false, );
        fetchListPointsUser1(context, "borrar");
        fetchSettings(context);
        fetchUserProfile(context);
        fetchUserAltam(context);
        singleton.notifierBannerAltan.value = BannerWallet(code: 1,message: "No hay nada", status: false, data: DataW(item: ItemW( callingCode: "", photoUrl: "", sms: "", whatsapp: "")) );
        fetchBannerAltan(context);
        prefs.flagWinCanje = "Canjeo";

        utils.VibrateAndMusic();
        showCupertinoModalPopup(context: context, builder:
            (context) => WinsCanje()
        );

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangeborderpopup,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint User Altan Plan
  Future<void> fetchUserAltanPlan(BuildContext context) async {
    try{


      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase4+"profile/plan-consumption");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      var js = jsonEncode(decodeJSON);
      //singleton.notifierUseraltanPlan.value = AltanPLane.fromJson(decodeJSON);
      singleton.notifierUseraltanPlan1.value = AltanPLane1.fromJson(decodeJSON);

      if(singleton.notifierUseraltanPlan1.value.code == 100){ /// OK

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierUseraltanPlan1.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Banner Altan
  Future<void> fetchBannerAltan(BuildContext context) async {
    try{


      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase+"profile/altan-contact");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      singleton.notifierBannerAltan.value = BannerWallet.fromJson(decodeJSON);

      if(singleton.notifierBannerAltan.value.code == 100){ /// OK

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(singleton.notifierBannerAltan.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Disable Account
  Future<void> fetchDisableAccount(BuildContext context) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      Map<String, dynamic> myObject = {
        'status': "deleted",
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"onboarding/change-status");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.put(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK

        prefs.authToken ="0";
        prefs.imei = "0";
        singleton.notifierVisibleButtoms.value = 1;
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangeswitch,"error");

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
        });

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Planes
  Future<PlanesCompra> fetchPlanes(BuildContext context, String aob) async {
    try{


      Map<String, dynamic> myObject = {
        "limit": "100",
        "offset": singleton.planesPages,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"payment/get-all");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(aob=="borrar"){
        singleton.notifierlanesCompra.value = PlanesCompra.fromJson(decodeJSON);
      }else{
        PlanesCompra notifierGaneRoom = singleton.notifierlanesCompra.value;
        notifierGaneRoom.data!.items!.addAll(PlanesCompra.fromJson(decodeJSON).data!.items!);
        singleton.notifierlanesCompra.value = PlanesCompra(code: 1,message: "No hay nada", status: false, );
        singleton.notifierlanesCompra.value = notifierGaneRoom;
      }


      if(singleton.notifierlanesCompra.value.code == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(singleton.notifierlanesCompra.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierlanesCompra.value;
    }

    return singleton.notifierlanesCompra.value;
  }

  ///Call Endpoint Create Plan
  Future<void> fetchCreatePlan(BuildContext context, int idPlan) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      Map<String, dynamic> myObject = {
        'planGaneId': idPlan,
        'fullname': singleton.fullnamePideCHip,
        'email': singleton.emailPideChip,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"payment/create-cash");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierBuyPlan.value = BuyPlans.fromJson(decodeJSON);
      if(decodeJSON["code"] == 100){ /// OK
        singleton.emailPideChip = "";
        singleton.fullnamePideCHip = "";
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint New Vimeo Call Videos
  Future<List<SiteModel>> fetchVimeoNewVideos(BuildContext context, String video) async {

    var result = <SiteModel>[];
    //var parse = Parse();

    try{
      var url = "https://api.vimeo.com/videos/"+video;

      var token = Strings.keyvimeo;
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var decodeJSON = jsonDecode(response.body);
      var enco = jsonEncode(decodeJSON);
      print(enco);

      var progressive = decodeJSON['download'];


      /// list for each
      progressive.forEach((_progressive) {
        /// get quality
        var quality = _progressive['rendition'];

        /// get link
        var link = _progressive['link'];

        /// add data to result list
        result.add(SiteModel(quality: '$quality', link: '$link'));
      });

      /// result list sort by quality
     // result.sort((a, b) => parse.quality(a).compareTo(parse.quality(b)));
      result.sort((a, b) => a.quality!.compareTo(b.quality!) );


    }catch (err){
      print('Error: $err');
      return result;
    }

    return result;

  }

  ///Call Endpoint Create Credit card payment
  Future<void> fetchCreatePaymentCreditCard(BuildContext context, int idPlan, String tokenId) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      Map<String, dynamic> myObject = {
        'planGaneId': idPlan,
        'tokenId': tokenId,
      };

      final msg = jsonEncode(myObject);
      print("Datos de envio de pago con tarjeta: "+msg);

      var url = Uri.parse(Strings.urlBase+"payment/card");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(context);
      var decodeJSON = jsonDecode(response.body);
      final msg1 = jsonEncode(decodeJSON);
      print("Resultado del pago: "+msg1);
      //singleton.notifierBuyPlan.value = BuyPlans.fromJson(decodeJSON);
      if(decodeJSON["code"] == 100){ /// OK

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Obtain UrlGame
  Future<void> fetchObtainUrlGame(BuildContext context,) async {
    try{

      Map<String, dynamic> myObject = {
        "promotionId": singleton.idAds,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"easypromo/click-promotion");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK

        print(decodeJSON["data"]["url"]);
        singleton.codeUrl = decodeJSON["data"]["url"];
        singleton.notifierUrlsByGame.value = decodeJSON["data"]["url"];
        print("Url Games: "+singleton.notifierUrlsByGame.value);
        //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: LoadingScreen(from: "online",relaunch: (){},) ));
        //Navigator.push(context, Transition(child: WebGames(url: singleton.codeUrl, title: Strings.tyc1,relaunch: (){},), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Obtain Point by Game
  Future<Roomlook> fetchObtainPointsGame(BuildContext context,) async {
    try{

      var url = Uri.parse(Strings.urlBase+"points/points-game");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.get(url, headers: headers,).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        singleton.notifierPointsByGame.value = decodeJSON["data"]["points"].toString();

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierLookRoom.value;
    }

    return singleton.notifierLookRoom.value;
  }

  ///Call Endpoint Obtain CreditsCards
  Future<void> fetchCreditCardsList(BuildContext context,) async {
    try{

      Map<String, dynamic> myObject = {
        "limit": "100",
        "offset": 0,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"payment/card/get-all");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK
        singleton.notifierCreditCardList.value = TCList.fromJson(decodeJSON);
      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Save and create recarga with creditcard
  Future<int> fetchPaymentCreditCard(BuildContext context,int planGaneId,String name,String number,String month,String year,String cvc,bool save) async {
    int code = 0;
    try{

      Map<String, dynamic> myObject = {
        "planGaneId": planGaneId,
        "name": name,
        "number": number,
        "month": month,
        "year": year,
        "cvc": cvc,
        "save": save,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"payment/card/create");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);

      code = decodeJSON["code"];
      if(decodeJSON["code"] == 100){ /// OK
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return code;
    }

    return code;

  }

  ///Call Endpoint Delete credit card
  Future<void> fetchDeleteTC(BuildContext context,String idTC) async {
    try{

      var url = Uri.parse(Strings.urlBase+"payment/card/delete/"+ idTC);
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.delete(url, headers: headers,).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);

      if(decodeJSON["code"] == 100){ /// OK

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");
      }else {
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///create recarga with creditcard saved
  Future<int> fetchPaymentCreditCardSaved(BuildContext context,int planGaneId,int cardId) async {
    int code = 0;
    try{

      Map<String, dynamic> myObject = {
        "planGaneId": planGaneId,
        "cardId": cardId,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"payment/card/save");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);
      code = decodeJSON["code"];
      if(decodeJSON["code"] == 100){ /// OK

        //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: LoadingScreen(from: "online",relaunch: (){},) ));
        //Navigator.push(context, Transition(child: WebGames(url: singleton.codeUrl, title: Strings.tyc1,relaunch: (){},), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return code;
    }
    return code;
  }

  ///Call Endpoint Reffereal
  Future<void> fetchReffereal1(BuildContext context) async {
    try{

      print(prefs.authToken);

      var url = Uri.parse(Strings.urlBase+"referrals/get-information");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      var decodeJSON = jsonDecode(response.body);
      var ds = jsonDecode(decodeJSON);
      singleton.notifierReferralData.value = ReferralData.fromJson(decodeJSON);

    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Reffereal
  Future<void> fetchReffereal(BuildContext context) async {
    try{
      var url = Strings.urlBase+"referrals/get-information/";
      var token = prefs.authToken;

      final response = await http.get(Uri.parse(url), headers: {
        //'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'X-GN-Auth-Token': token,
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      Navigator.pop(context);
      singleton.notifierReferralData.value = ReferralData.fromJson(data);


    }catch (err){
      print('Error: $err');
    }

  }

  ///create recarga Win Points Referrals
  Future<int> fetchWinPointsReferrals(BuildContext context,String codeReferrals) async {
    int code = 0;
    try{

      Map<String, dynamic> myObject = {
        "codeReferrals": codeReferrals,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase+"referrals/win-points-referrals");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      //Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);
      code = decodeJSON["code"];

      Navigator.pushReplacement(context, Transition(child: PrincipalContainer()) );

      if(decodeJSON["code"] == 100){ /// OK
        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");


      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return code;
    }
    return code;
  }

  ///Call Endpoint Check Imei
  Future<void> fetchCheckImei(BuildContext context, String imei, Function stopLoading) async {
    try{
      var url = Strings.urlBase+"chip/imei-status/";
      var token = prefs.authToken;

      final response = await http.get(Uri.parse(url + imei), headers: {
        //'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'X-GN-Auth-Token': token,
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      //Navigator.pop(context);
      //singleton.notifierReferralData.value = ReferralData.fromJson(data);
      stopLoading();

      if(data["code"] == 100){ /// OK
        utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

      }else {

        utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(data["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Plan Chip
  Future<void> fetchPlanChip(BuildContext context) async {
    try{
      var url = Strings.urlBase+"chip/get-plan/";

      final response = await http.get(Uri.parse(url), headers: {
        'X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken,
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      Navigator.pop(context);
      singleton.notifierPlanChip.value = ChipPlans.fromJson(data);

      if(data["code"] == 100){ /// OK

      }else {

        utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(data["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint States
  Future<void> fetchStates(BuildContext context) async {
    try{
      var url = Strings.urlBase+"chip/get-states/";
      var token = prefs.authToken;

      final response = await http.get(Uri.parse(url), headers: {
        //'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken,
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      //Navigator.pop(context);
      singleton.notifierStatesList.value = statesList.fromJson(data);
      singleton.notifierStatesListSearch.value = statesList.fromJson(data);

      if(data["code"] == 100){ /// OK

      }else {

        utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(data["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Cities
  Future<void> fetchCities(BuildContext context, String state) async {
    try{
      var url = Strings.urlBase+"chip/get-cities/";

      Map<String, dynamic> myObject = {
        "state": state,
      };

      final msg = jsonEncode(myObject);

      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken,
      },body: msg);

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      //Navigator.pop(context);
      singleton.notifierCitiesList.value = cityList.fromJson(data);
      singleton.notifierCitiesListtSearch.value = cityList.fromJson(data);

      if(data["code"] == 100){ /// OK

      }else {
        utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(data["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }
      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Colonias
  Future<void> fetchColonias(BuildContext context, String state, String city) async {
    try{
      var url = Strings.urlBase+"chip/get-colonies/";

      Map<String, dynamic> myObject = {
        "state": state,
        "city": city,
      };

      final msg = jsonEncode(myObject);

      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken,
      },body: msg);

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      //Navigator.pop(context);
      singleton.notifierColiniesListSearch.value = colonList.fromJson(data);
      singleton.notifierColiniesList.value = colonList.fromJson(data);

      if(data["code"] == 100){ /// OK

      }else {
        utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(data["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }
      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Send Chip
  Future<BuyPlans> fetchSendChip(BuildContext context, String FirstName, String LastName, String ContactEmail, String ContactPhone, String Address, String ExternalNumber, String InternalNumber,String cashOTC) async {

    try{

      var token = prefs.authToken;
      var url = Strings.urlBase+"chip/buy/";

      Map<String, dynamic> myObject = {
        "firstName":FirstName,
        "lastName":LastName,
        "contactEmail":ContactEmail,
        "contactPhone":ContactPhone,
        "address":Address,
        "externalNumber":ExternalNumber,
        "internalNumber":InternalNumber,
        "postalCode":singleton.zipcode,
        "colony":singleton.colonia,
        "tokenId":singleton.tokenTC,
        "userId":singleton.notifierUserProfile.value.data!.user!.id,
        "reference":singleton.addressreference,
      };


      final msg = jsonEncode(myObject);

      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken,
      },body: msg);

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      singleton.notifierBuyPlan.value = BuyPlans.fromJson(data);
      Navigator.pop(context);

      if(data["code"] == 100){ /// OK
        //utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

        if(cashOTC== "cash"){
          singleton.notifierBuyPlan.value = BuyPlans.fromJson(data);
        }else{

          utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          //Future.delayed(const Duration(milliseconds: 3500), () {
            int count = 0;
            Navigator.of(singleton.navigatorKey.currentContext!).popUntil((_) => count++ >= 2);
          //});

        }


      }else {
        utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
        Future.delayed(const Duration(milliseconds: 1000), () {
        });

        if(data["code"] == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }
      }

    }catch (err){
      Navigator.pop(context);
      utils.openSnackBarInfo(context, err.toString(), "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
      print('Error: $err');
    }

    return singleton.notifierBuyPlan.value;

  }

  ///Call Endpoint Altan Plan Details
  Future<void> fetchAltanPlansDetails(BuildContext context,) async {
    try{
      var url = Strings.urlBase4+"profile/plan-consumption-detail/";
      var token = prefs.authToken;

      final response = await http.get(Uri.parse(url), headers: {
        //'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'X-GN-Auth-Token': token,
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      //singleton.notifierPlansDetailsAltan.value = PlansAltanDetails.fromJson(data);
      singleton.notifierPlansDetailsAltan1.value = PlansAltanDetails1.fromJson(data);

      if(data["code"] == 100){ /// OK

      }else {

        if(data["code"] == 120){/// Token Expire
          utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }
      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Validate SIM
  Future<void> fetchValidateSIM(BuildContext context, Function  validateSIM) async {
    try{
      var url = Strings.urlBase+"gn/check-sim/";
      var token = prefs.authToken;

      final response = await http.get(Uri.parse(url), headers: {
        //'X-GN-Auth-Token': token,
        'X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      singleton.notifierValidateSImCard.value = ValidatesSimsCard.fromJson(data);

      if(data["code"] == 100){ /// OK
        print(data["data"]["sim"]);
        if(data["data"]["sim"]== "true"){
          validateSIM();
        }

      }else {

        if(data["code"] == 120){/// Token Expire
          utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }
      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Validate SIM
  Future<void> fetchValidateVersion(BuildContext context, Function showUpdateAlert) async {
    try{
      var url = Strings.urlBase+"gn/get-version/";
      var token = prefs.authToken;

      String version = singleton.packageInfo.version;

      Map<String, dynamic> myObject = {
        "platform": "user_android",
        "version": version
      };

      final msg = jsonEncode(myObject);

      final response = await http.post(Uri.parse(url), body: msg, headers: {
        'Content-Type': 'application/json',
        'X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      singleton.notifierValidateSImCard.value = ValidatesSimsCard.fromJson(data);

      if(data["code"] == 100){ /// OK
        print(data ["data"]["version"]);
        if(data["data"]["version"]== true){
          showUpdateAlert(context);
        }

      }else {
        if(data["code"] == 120){/// Token Expire
          utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }
      }


    }catch (err){
      print('Error: $err');
    }

  }

  ///Call Endpoint Validate Segmentation
  Future<void> fetchValidateSegmentation(BuildContext context) async {
    try{
      var url = Strings.urlBase+"segmentation/user/";
      var token = prefs.authToken;


      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'X-GN-Auth-Token': token,
      });

      final bytes = response.bodyBytes;
      final data = jsonDecode(utf8.decode(bytes));
      var js = jsonEncode(data);
      singleton.notifierValidateSegmentation.value = SegmentationCustom.fromJson(data);

      if(data["code"] == 100){ /// OK
        prefs.imageOnline = singleton.notifierValidateSegmentation.value.data!.styles!.logoHeader!;
        prefs.splashOnline = singleton.notifierValidateSegmentation.value.data!.styles!.splash!;
        prefs.colorOnline = singleton.notifierValidateSegmentation.value.data!.styles!.colorHeader!;

      }else {

        prefs.imageOnline = "0";
        prefs.splashOnline = "0";
        prefs.imageOnline = "0";

        if(data["code"] == 120){/// Token Expire
          utils.openSnackBarInfo(context, data["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }
      }


    }catch (err){
      print('Error: $err');
    }

  }



  ///Call Endpoint Validate Barcode
  Future<BarCodeData> fetchValidateBarCode(BuildContext context, String code) async {
    try{

      print(prefs.LanguageCode.toString().toLowerCase());

      var url = Uri.parse(Strings.urlBase4+"onboarding/detail-sim/"+ code);
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Access-Token':singleton.notifierAccessToken.value.data.accessToken};

      var response = await http.get(url, headers: headers).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });


      Navigator.pop(singleton.navigatorKey.currentContext!);
      var decodeJSON = jsonDecode(response.body);
      singleton.notifierValidateBarCode.value = BarCodeData.fromJson(decodeJSON);
      print(prefs.countryCode);

    }catch (err){
      print('Error: $err');
      return singleton.notifierValidateBarCode.value;
    }

    return singleton.notifierValidateBarCode.value;
  }


  ///Call Endpoint Hall Room
  Future<Roomlook> fetchHallGain(BuildContext context, String aob) async {
    try{


      Map<String, dynamic> myObject = {
        "limit": "20",
        "offset": singleton.HallRoomPages,
        //"offset": 2,
      };

      final msg = jsonEncode(myObject);

      var url = Uri.parse(Strings.urlBase4+"sequence-ads/hall-answer");
      Map<String,String> headers = {'Content-Type':'application/json','X-GN-Auth-Token':prefs.authToken};
      var response = await http.post(url, headers: headers,body: msg).timeout(Duration(seconds: 30)).catchError((value){
        //Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));
      });

      // http://ganeapi.inkubo.co/v1/sequence-ads/hall-answer

      var decodeJSON = jsonDecode(response.body);

      if(aob=="borrar"){
        singleton.notifierHallRoom.value = Roomlook.fromJson(decodeJSON);
      }else{
        Roomlook notifierGaneRoom = singleton.notifierHallRoom.value;
        notifierGaneRoom.data!.result!.addAll(Roomlook.fromJson(decodeJSON).data!.result!);
        singleton.notifierHallRoom.value = Roomlook(code: 1,message: "No hay nada", status: false, );
        singleton.notifierHallRoom.value = notifierGaneRoom;
      }


      if(singleton.notifierHallRoom.value.code == 100){ /// OK

      }else {

        //utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_alert.png",CustomColors.white,"error");

        if(singleton.notifierHallRoom.value.code == 120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }


    }catch (err){
      print('Error: $err');
      return singleton.notifierHallRoom.value;
    }

    return singleton.notifierHallRoom.value;
  }

}