import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:argon_buttons_flutter_fix/argon_buttons_flutter.dart';
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
import 'package:gane/src/Models/segmentarion.dart';
import 'package:gane/src/Models/userpoints.dart';
import 'package:gane/src/UI/Home/completeprof.dart';

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
import 'package:gane/src/Widgets/dialog_loadimage.dart';
import 'package:image_picker/image_picker.dart';
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

/// All Games imports
/*import 'package:gane/src/UI/Games/TicTacToe/ai/ai.dart';
import 'package:gane/src/UI/Games/Colors/gamepage.dart';
import 'package:gane/src/UI/Games/Run/rungame.dart';
import 'package:gane/src/UI/Games/TapColors/scoreBoard.dart';
import 'package:gane/src/UI/Games/TicTacToe/single_player_game.dart';
import 'package:gane/src/UI/Games/Bird/birdgame.dart';
import 'package:gane/src/UI/Games/Holes/match_page.dart';
import 'package:gane/src/UI/Games/2048/game.dart';
import 'package:gane/src/UI/Games/Flip/data.dart';
import 'package:gane/src/UI/Games/Flip/flipcardgame.dart';
import 'package:gane/src/UI/Games/Holes/cpu.dart';
import 'package:gane/src/UI/Games/PacM/pacm.dart';
import 'package:gane/src/UI/Games/PopBubble/screen.dart';
import 'package:gane/src/UI/Games/SumNumber/screens/LoadingScreen.dart';
import 'package:gane/src/UI/Games/Hangman/screens/home_screen.dart';*/


class EditProfile extends StatefulWidget{

  final from;

  EditProfile({this.from});

  _stateEditProfile createState()=> _stateEditProfile();
}

class _stateEditProfile extends State<EditProfile> with  TickerProviderStateMixin, WidgetsBindingObserver{ /// ImagePickerListener

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
  var _controllerEmail = TextEditingController();

  /*late File _image;
  late AnimationController _controllerImage;
  late ImagePickerHandler imagePicker;*/
  List<XFile>? _imageFileList;

  late CircularSliderAppearance appearance01;
  late CircularSliderAppearance appearance02;


  @override
  void initState(){


    appearance01 = CircularSliderAppearance(
        customWidths: CustomSliderWidths(trackWidth: 2, progressBarWidth: 7, shadowWidth: 50),
        customColors: CustomSliderColors(
            dotColor: Colors.white.withOpacity(0.8),
            trackColor: CustomColors.orangeswitch.withOpacity(0.4),
            progressBarColors: [
              CustomColors.orangeswitch,
              CustomColors.orangeswitch,
              CustomColors.orangeswitch
            ],
            shadowColor: HexColor('#FFD7E2'),
            shadowMaxOpacity: 0.08),
        infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(fontSize: 10.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
            bottomLabelText: "Moni",
            bottomLabelStyle: TextStyle(fontSize: 10.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
            modifier: (double value) {
              final kcal = value.toInt();
              //return '$kcal días';
              return singleton.formatter.format(kcal);
            }
        ),
        startAngle: 180,
        angleRange: 180,
        size: 60.0);
    appearance02 = CircularSliderAppearance(
        customWidths: CustomSliderWidths(trackWidth: 2, progressBarWidth: 7, shadowWidth: 50),
        customColors: CustomSliderColors(
            dotColor: Colors.white.withOpacity(0.8),
            trackColor: CustomColors.orangeswitch.withOpacity(0.4),
            progressBarColors: [
              CustomColors.orangeswitch,
              CustomColors.orangeswitch,
              CustomColors.orangeswitch
            ],
            shadowColor: HexColor('#FFD7E2'),
            shadowMaxOpacity: 0.08),
        infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(fontSize: 10.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
            bottomLabelText: "días",
            bottomLabelStyle: TextStyle(fontSize: 10.0,fontFamily: Strings.font_bold, color: CustomColors.orangeswitch,),
            modifier: (double value) {
              final kcal = value.toInt();
              //return '$kcal días';
              return singleton.formatter.format(kcal);
            }
        ),
        startAngle: 180,
        angleRange: 180,
        size: 60.0);



    singleton.GaneOrMira = "gane";
    //provider = Provider.of<HomeProvider>(context, listen: false);
    print(singleton.secuenceOne);
    print(singleton.secuenceTwo);
    print(singleton.secuenceThree);

    /*_controllerImage = new AnimationController(vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this as ImagePickerListener, _controllerImage,"blue");
    imagePicker.init();*/


    WidgetsBinding.instance!.addPostFrameCallback((_){
      //notifierValueYButtons.value = MediaQuery.of(context).size.height ;
      utils.initUserLocation(context);
      Future.delayed(const Duration(milliseconds: 450), () {

        if(singleton.isOffline == false){
        }

      });


      print(MediaQuery.of(context).devicePixelRatio);
      print(MediaQuery.of(context).size.height);

      _controllerName.text = singleton.notifierUserProfile.value.data!.user!.fullname!;
      _controllerEmail.text = singleton.notifierUserProfile.value.data!.user!.email!;
      _controllerPhone.text = singleton.notifierUserProfile.value.data!.user!.phoneNumber!;




    });

    super.initState();
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
        padding: EdgeInsets.only(left: 15,right: 15),
        margin: EdgeInsets.only(top: 90),
        child: ValueListenableBuilder<Getprofile>(
            valueListenable: singleton.notifierUserProfile,
            builder: (context,value2,_){

              return SingleChildScrollView(

                child: Container(
                  margin: EdgeInsets.only(top: 20,bottom: 20),

                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: CustomColors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        SizedBox(height: 30,),

                        /// User image
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){
                              //imagePicker.showDialog(context);
                              dialogLoadImage(context, loadimage, loadGallery);
                            },
                            child: Stack(

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
                                  //alignment: Alignment.center,
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


                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ClipOval(
                                    child: SvgPicture.asset(
                                      'assets/images/ic_camera .svg',
                                      fit: BoxFit.cover,
                                      width: 27,
                                      height: 27,
                                    ),
                                  ),
                                ),

                              ],

                            ),
                          ),

                        ),

                        SizedBox(height: 30,),

                        /// Name
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 10,bottom: 10),
                          child: Text(Strings.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 15,),
                            textScaleFactor: 1.0,
                          ),
                        ),

                        _fieldName(),

                        SizedBox(height: 20,),

                        /// Email
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 10,bottom: 10),
                          child: Text(Strings.mail,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 15,),
                            textScaleFactor: 1.0,
                          ),
                        ),

                        _fieldMail(),

                        SizedBox(height: 20,),

                        /// Phone
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 10,bottom: 10),
                          child: Text(Strings.lineagane,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.orangesnack, fontSize: 15,),
                            textScaleFactor: 1.0,
                          ),
                        ),

                        _fieldPhone(),

                        SizedBox(height: 40,),

                        ///Continue
                        Container(
                          alignment: Alignment.center,
                          child: ArgonButton(
                            height: 45,
                            width: 150,
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
                                          Strings.updateapp2,
                                          textAlign: TextAlign.center,
                                          //maxLines: 1,
                                          style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 13.0,),
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
                                //notifierValueYButtons.value = 1.0;
                                //notifierCorrect.value = "0";
                                startLoading();
                                //textEditingController = TextEditingController();
                                WidgetsBinding.instance!.addPostFrameCallback((_){
                                  Future.delayed(const Duration(milliseconds:450), () {
                                    _validateform(context,stopLoading);
                                  });
                                });


                              }
                            },
                          ),
                        ),


                        ///Delete account
                        InkWell(
                          onTap: (){
                            dialogDisableAccount(context, launchFetchDisableAccount);
                          },
                          child: Container(
                            //color: Colors.red,
                            height: 30,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: Text.rich(
                              TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: Strings.deleteuser2,
                                      style: TextStyle(fontFamily: Strings.font_bold, color: CustomColors.grayplaceholder, fontSize: 11.0,

                                      )
                                  ),
                                  // can add more TextSpans here...
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30,),



                      ],

                    ),
                  ),

                ),

              );

            }

        ),

      ),

    );

  }


  void launchFetchDisableAccount()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');

        singleton.notifierValueYButtons.value = 0;
        utils.openProgress(context);
        servicemanager.fetchDisableAccount(context);

      }
    } on SocketException catch (_) {
      print('not connected');
      singleton.isOffline = true;
      //Navigator.pop(context);
      ConnectionStatusSingleton.getInstance().checkConnection();
    }

  }


  ///Create telf field
  Widget _fieldName() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.white,
          border: Border.all(color: CustomColors.greyborderprofile, width: 1),
        ),

        child: Row(
          children: <Widget>[

            Container(
              //color: Colors.yellow,
              margin: EdgeInsets.only(left: 10),
              child: SvgPicture.asset(
                'assets/images/ic_name .svg',
                fit: BoxFit.contain,
                width: 18,
                height: 18,
              ),
            ),

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
                                  fontFamily: Strings.font_regular,
                                  fontSize: 15,
                                  color: CustomColors.orangesnack),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.name,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.orangesnack)

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

  ///Create telf field
  Widget _fieldMail() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.white,
          border: Border.all(color: CustomColors.greyborderprofile, width: 1),
        ),

        child: Row(
          children: <Widget>[

            Container(
              //color: Colors.yellow,
              margin: EdgeInsets.only(left: 10),
              child: SvgPicture.asset(
                'assets/images/ic_mail .svg',
                fit: BoxFit.contain,
                width: 15,
                height: 15,
              ),
            ),

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
                              //enableSuggestions: false,
                              controller: _controllerEmail,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontFamily: Strings.font_regular,
                                  fontSize: 15,
                                  color: CustomColors.orangesnack),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10,),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.email,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.orangesnack)

                              ),
                              maxLines: 1,
                              onChanged: (value){

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

  ///Create telf field
  Widget _fieldPhone() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(const Radius.circular(14)),
          color: CustomColors.white,
          border: Border.all(color: CustomColors.greyborderprofile, width: 1),
        ),

        child: Row(
          children: <Widget>[

            Container(
              //color: Colors.yellow,
              margin: EdgeInsets.only(left: 10),
              child: SvgPicture.asset(
                'assets/images/ic_phone .svg',
                fit: BoxFit.contain,
                width: 18,
                height: 18,
              ),
            ),


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
                              maxLength: 13,
                              enabled: false,
                              //enableSuggestions: false,
                              controller: _controllerPhone,
                              //focusNode: _focusNodeQuantity,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontFamily: Strings.font_regular,
                                  fontSize: 15,
                                  color: CustomColors.greyblock),
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  filled: true,
                                  contentPadding: EdgeInsets.only( top: 10, bottom: 10,left: 10),
                                  fillColor: Colors.transparent,
                                  hintText: Strings.lineagane,
                                  hintStyle: TextStyle(
                                      fontFamily: Strings.font_regular,
                                      fontSize: 15,
                                      color: CustomColors.greyblock)

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



  /// Load image from camera
  void loadimage(){
    utils.onImageButtonPressed(ImageSource.camera, _setImageFileListFromFile);
  }

  /// Load image from gallery
  void loadGallery(){
    utils.onImageButtonPressed(ImageSource.gallery, _setImageFileListFromFile);
  }


  ///Reload image from gallery or camera
  void _setImageFileListFromFile(XFile? value) {

    setState(() {
      _imageFileList = value == null ? null : <XFile>[value];
      print(_imageFileList.toString());
      _uploadPhoto(context);
    });

  }

  ///Upload user Photo
  void _uploadPhoto(BuildContext context) async{

    try {

      var request = http.MultipartRequest("POST", Uri.parse(Strings.urlBase + "onboarding/update-profile"));
      request.headers.addAll({'Content-Type':'multipart/form-data','X-GN-Auth-Token':prefs.authToken,});

      /*final mimeType = mime(_image.path)!.split("/");
      final multipartFile = await http.MultipartFile.fromPath('file', _image.path, contentType: MediaType(mimeType[0], mimeType[1]));
      request.files.add(multipartFile);*/

      final mimeType = mime(File(_imageFileList![0].path).path)!.split("/");
      final multipartFile = await http.MultipartFile.fromPath('photo', File(_imageFileList![0].path).path, contentType: MediaType(mimeType[0], mimeType[1]));
      request.files.add(multipartFile);

      final streamResponse = await request.send().timeout(Duration(seconds: 30)).catchError((value){
        Navigator.pop(context);
        //dialogTimeOut(context, utils.ReadLanguage("neterror"), utils.ReadLanguage("neterror1"), utils.ReadLanguage("accept"));

      });
      final response = await http.Response.fromStream(streamResponse)
          .timeout(const Duration(seconds: 30)).catchError((value){
        //utils.timeOut(context, bandRefresh, functionRefresh);
      });

      print(response.body.toString());
      var decodeJSON = jsonDecode(response.body.toString());
      Navigator.pop(context);

      if(decodeJSON["code"]==100){ /// OK
        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangeswitch,"error");
        servicemanager.fetchUserProfile(context);
      }else {

        utils.openSnackBarInfo(context, decodeJSON["message"]!, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

        if(decodeJSON["code"]==120){/// Token Expire
          prefs.authToken ="0";
          singleton.notifierVisibleButtoms.value = 1;
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(context, Transition(child: LoginPhone()) );
          });
        }

      }

      print(decodeJSON);

    } on SocketException catch (e) {
      print(e);
    }


  }

  @override
  userImage(File _images) {

    setState(() {
      //this._image = _images;
      utils.openProgress(context);
      _uploadPhoto(context);
    });

    return null;
  }

  ///Validate form
  _validateform(BuildContext context,Function function)async{

    FocusScope.of(context).requestFocus(new FocusNode());

    var number = _controllerPhone.text;

    //bool email = _controllerEmail.text.isValidEmail();

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
            utils.openSnackBarInfo(context, Strings.errorName, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerEmail.text.trim().isEmpty) {
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorMail, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (EmailValidator.validate(_controllerEmail.text.trim()) == false  ){
            Future.delayed(const Duration(milliseconds: 500), () {
              function();
            });
            utils.openSnackBarInfo(context, Strings.errorMail1, "assets/images/ic_sad.svg",CustomColors.orangesnack,"error");

          }else if (_controllerPhone.text.trim().isEmpty) {
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

            Future.delayed(const Duration(milliseconds: 50), () {
              var tel = _controllerPhone.text;
              tel = tel.replaceAll("-", "");
              //utils.openProgress(context);
              servicemanager.fetchUpdateUserProfile(_controllerName.text, _controllerEmail.text, context, function);

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
                    height: 90,
                    width: MediaQuery.of(context).size.width,

                    child: ValueListenableBuilder<SegmentationCustom>(
                        valueListenable: singleton.notifierValidateSegmentation,
                        builder: (context,value2,_){

                          return value2.code == 1 ? Image(
                            image: AssetImage("assets/images/headernew.png"),
                            fit: BoxFit.fill,
                          ) :
                          value2.code==100 ? Container(
                            color: value2.data!.styles!.colorHeader!.toColors(),
                          ) :
                          Image(
                            image: AssetImage("assets/images/headernew.png"),
                            fit: BoxFit.fill,
                          );

                        }

                    )
                  /*child: Image(
                    image: AssetImage("assets/images/headernew.png"),
                    fit: BoxFit.fill,
                  ),*/
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
                        padding: const EdgeInsets.only(top: 20, left: 10),
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
                    ),

                    ///Coins
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        padding: EdgeInsets.only(right: 10,left: 10,top: 20 ),
                        //color: Colors.red,
                        child: ValueListenableBuilder<Userpoints>(

                            valueListenable: singleton.notifierUserPoints,
                            builder: (context,value,_){

                              /*return Badge(
                                position: BadgePosition.topEnd(end: value.code == 1 || value.code == 102 ? -4 : int.parse(value.data!.result!) < 10 ? 0 : -10,),
                                toAnimate: true,
                                animationType: BadgeAnimationType.scale,
                                showBadge: value.code == 1 && value.code == 102 ? false :  true,
                                badgeColor: CustomColors.blueBack,

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
                                  /*child: SvgPicture.asset(
                                    'assets/images/coins.svg',
                                    fit: BoxFit.contain,
                                    width: 30,
                                    height: 30,
                                  ),*/

                                    child: Container(
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

                                          ValueListenableBuilder<SegmentationCustom>(
                                              valueListenable: singleton.notifierValidateSegmentation,
                                              builder: (context,valuese,_){

                                                /*return valuese.code == 1 ? SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                          ) : valuese.code==100 ?  Image(
                                            image: AssetImage("assets/images/monedaonline.png"),
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                            color: valuese.data!.styles!.colorHeader!.toColors(),
                                          ) :
                                          SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                          );*/

                                                return Stack(
                                                  alignment: Alignment.center,

                                                  children: [

                                                    Image(
                                                      image: AssetImage("assets/images/circuloonline.png"),
                                                      fit: BoxFit.contain,
                                                      width: 30,
                                                      height: 30,
                                                    ),

                                                    SvgPicture.asset(
                                                      'assets/images/pruebaonline.svg',
                                                      fit: BoxFit.contain,
                                                      width: 30,
                                                      height: 30,
                                                      color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                                                    )

                                                  ],

                                                );


                                              }

                                          )

                                        ],

                                      ),
                                    )


                                ),
                              );*/

                              return badges.Badge(
                                badgeContent: AnimatedFlipCounter(
                                  duration: Duration(milliseconds: 2000),
                                  value: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? int.parse(value.data!.result!) : ( double.parse(value.data!.result!) / 1000),
                                  fractionDigits: value.code == 1 || value.code == 102 ? 0 : int.parse(value.data!.result!) < 1000 ? 0 : int.parse(value.data!.result!) > 9999 ? 0 : 1, // decimal precision
                                  suffix: value.code == 1 || value.code == 102 ? "" : int.parse(value.data!.result!) < 1000 ? "" : "K",
                                  textStyle: TextStyle(fontSize: value.code == 1 || value.code == 102 ? 9.0 : int.parse(value.data!.result!) < 1000 ? 9.0 : 8.0,fontFamily: Strings.font_medium, color: CustomColors.white,),
                                ),
                                showBadge: value.code == 1 && value.code == 102 ? false :  true,
                                badgeStyle: badges.BadgeStyle(
                                  badgeColor: CustomColors.blueBack,
                                ),
                                position: BadgePosition.topEnd(end: value.code == 1 || value.code == 102 ? -4 : int.parse(value.data!.result!) < 10 ? 0 : -10,),
                                child: Container(
                                  /*child: SvgPicture.asset(
                                    'assets/images/coins.svg',
                                    fit: BoxFit.contain,
                                    width: 30,
                                    height: 30,
                                  ),*/

                                    child: Container(
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

                                          ValueListenableBuilder<SegmentationCustom>(
                                              valueListenable: singleton.notifierValidateSegmentation,
                                              builder: (context,valuese,_){

                                                /*return valuese.code == 1 ? SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                          ) : valuese.code==100 ?  Image(
                                            image: AssetImage("assets/images/monedaonline.png"),
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                            color: valuese.data!.styles!.colorHeader!.toColors(),
                                          ) :
                                          SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                          );*/

                                                return Stack(
                                                  alignment: Alignment.center,

                                                  children: [

                                                    Image(
                                                      image: AssetImage("assets/images/circuloonline.png"),
                                                      fit: BoxFit.contain,
                                                      width: 30,
                                                      height: 30,
                                                    ),

                                                    SvgPicture.asset(
                                                      'assets/images/pruebaonline.svg',
                                                      fit: BoxFit.contain,
                                                      width: 30,
                                                      height: 30,
                                                      color: valuese.code == 1 ? CustomColors.orangeborderpopup : valuese.code == 100 ? valuese.data!.styles!.colorHeader!.toColors() : CustomColors.orangeborderpopup,
                                                    )

                                                  ],

                                                );


                                              }

                                          )

                                        ],

                                      ),
                                    )


                                )
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

                    ),

                    ///Notifications
                    SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        padding: EdgeInsets.only(right: 15,top: 20),
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
                                  /*child: Image(
                                    width: 40,
                                    height: 40,
                                    image: AssetImage("assets/images/notifications.png"),
                                    fit: BoxFit.contain,
                                  ),*/
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
                )

              ],

            ),


          );

        }

    );

  }

}

extension EmailValidato on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}