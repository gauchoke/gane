
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/image_picker_handler.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Widgets/dialog_notifiations.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/interface_permission_gallery.dart';

class DialogSelectPickerImage extends StatelessWidget { /// with InterfacePermissionGalleryClass

  final ImagePickerHandler listener;
  final AnimationController controller;
  final color;
  DialogSelectPickerImage({required this.listener, required this.controller, this.color});



  late BuildContext context;
  final singleton = Singleton();
  final prefs = SharePreference();



  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;

  //PermissionStatus permissionCamera = PermissionStatus.denied;
  //PermissionStatus permissionGallery = PermissionStatus.denied;


  Permission _permission = Permission.photos;
  Permission _permissionca = Permission.camera;
  PermissionStatus _permissionStatus = PermissionStatus.denied;



  void initState() {

    /*if(!singleton.isIOS){
      permissionCamera = PermissionStatus.undetermined;
      permissionGallery = PermissionStatus.undetermined;

    }*/

    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));


    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    _permissionStatus = status;
    print(_permissionStatus);


    final statusca = await _permissionca.status;

  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);

  }



  getImage(BuildContext context) {
    if (controller == null || _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    showDialog(
        context: context,
        builder: (BuildContext context) =>
        new SlideTransition(
          position: _drawerDetailsPosition,
          child: new FadeTransition(
            opacity: new ReverseAnimation(_drawerContentsOpacity),
            child: this,
          ),
        )
    );
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    controller.reverse();
    startTime();
  }

  _statePermissions() async {

    //permissionCamera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    //permissionGallery = await PermissionHandler().checkPermissionStatus(PermissionGroup.mediaLibrary);

  }

  _validateCamera() async {

    requestPermission(_permissionca);

    Future.delayed(const Duration(milliseconds: 300), () {

      //if(permissionCamera.value == 0 || permissionCamera.value == 1){
      //if(permissionCamera.isUndetermined || permissionCamera.isDenied || permissionCamera.isPermanentlyDenied){
      /*if(_permissionStatus.isPermanentlyDenied){

        dialogNotifications(context, Strings.wait, Strings.activateCamera, Strings.activate2, Strings.activate1, "camera");
      }else{*/

        if(singleton.isIOS == true){

          if( _permissionStatus.isDenied){
            dialogNotifications(context, Strings.wait, Strings.activateCamera, Strings.activate2, Strings.activate1, "camera");
          }else{

            if(singleton.opencamera == false){
              singleton.opencamera = true;
              listener.openCamera();
              Future.delayed(const Duration(seconds: 3), () {
                singleton.opencamera = false;
              });

            }
          }

        }else{

          if(_permissionStatus.isPermanentlyDenied){

            dialogNotifications(context, Strings.wait, Strings.activateCamera, Strings.activate2, Strings.activate1, "camera");
          }else if(singleton.opencamera == false){
            singleton.opencamera = true;
            listener.openCamera();
            Future.delayed(const Duration(seconds: 3), () {
              singleton.opencamera = false;
            });

          }

        }



      //}

    });




  }

  _validateGallery() async {

    requestPermission(_permission);


    Future.delayed(const Duration(milliseconds: 300), () async{


      /*if( _permissionStatus.isPermanentlyDenied){
        //openAppSettings();
        dialogNotifications(context, Strings.wait, Strings.activateGallery, Strings.activate2, Strings.activate1, "video");
      }else{*/

        if(singleton.isIOS == true){

          if( _permissionStatus.isDenied){
            dialogNotifications(context, Strings.wait, Strings.activateGallery, Strings.activate2, Strings.activate1, "video");
          }else{

            if(singleton.opengallery == false){
              singleton.opengallery = true;
              listener.openGallery(context,this as InterfacePermissionGalleryClass);
              Future.delayed(const Duration(seconds: 3), () {
                singleton.opengallery = false;
              });

            }

          }

        }else{

          if( _permissionStatus.isPermanentlyDenied){
            //openAppSettings();
            dialogNotifications(context, Strings.wait, Strings.activateGallery, Strings.activate2, Strings.activate1, "video");
          }else if(singleton.opengallery == false){
              singleton.opengallery = true;
              listener.openGallery(context,this as InterfacePermissionGalleryClass);
              Future.delayed(const Duration(seconds: 3), () {
                singleton.opengallery = false;
              });

            }

        }



      //}

    });


  }



  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: (){
            dismissDialog();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: new Opacity(
            opacity: 1.0,
            child: new Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              //margin: EdgeInsets.only(left: 35, right: 35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(left: 15,right: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(28),topLeft:  Radius.circular(28)),
                      ),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[

                          //Title
                          Container(
                            margin:  EdgeInsets.only(top: 30,bottom: 30),
                            child: Text(Strings.choosesource,style: TextStyle(letterSpacing: 0.5,fontFamily: Strings.font_bold, fontSize: 18, color: CustomColors.orangeswitch),textScaleFactor: 1.0,),

                          ),

                          //Camera
                          InkWell(
                            onTap: (){
                              _validateCamera();
                              //_listener.openCamera();
                            },
                            child: Container(

                              margin: EdgeInsets.only(left: 10,right: 10),

                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  //margin: EdgeInsets.only(top: 5,bottom: 5),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: <Widget>[


                                      Container(
                                        //margin: EdgeInsets.only(left: 40,top: 40),
                                        child: SvgPicture.asset(
                                          'assets/images/icono2.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),


                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(Strings.camera,
                                            style: TextStyle(
                                              fontFamily: Strings.font_medium,
                                              fontSize: 16,
                                              color: CustomColors.grayalert1,),
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.center),
                                      ),


                                    ],

                                  ),
                                ),
                              ),


                            ),
                          ),

                          //Video
                          InkWell(
                            onTap: (){
                              _validateGallery();
                              //_listener.openGallery();
                            },
                            child: Container(

                              margin: EdgeInsets.only(left: 10,right: 10, top: 20),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: CustomColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(top: 5,bottom: 5),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: <Widget>[


                                      Container(
                                        //margin: EdgeInsets.only(left: 40,top: 40),
                                        child: SvgPicture.asset(
                                          'assets/images/icono12.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),


                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(Strings.gallery,
                                            style: TextStyle(
                                              fontFamily: Strings.font_medium,
                                              fontSize: 16,
                                              color: CustomColors.grayalert1,),
                                            textScaleFactor: 1.0,
                                            textAlign: TextAlign.start),
                                      ),


                                    ],

                                  ),
                                ),
                              ),


                            ),
                          ),

                          SizedBox(height: 20,)
                          //Cancel
                          /*Container(
                              margin: EdgeInsets.only(left: 30, right: 30, top: 35, bottom: 30),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                //color: _stateLogin && _stateContinue ? CustomColors.blueorders : Colors.transparent,
                                //border: _stateLogin && _stateContinue ? Border.all(color: CustomColors.transparent, width: 1) : Border.all(color: CustomColors.grayborder, width: 1),
                                  color: CustomColors.blueback,
                                  borderRadius: BorderRadius.all(const Radius.circular(20.0))),
                              child: Builder(builder: (BuildContext context) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Visibility(
                                        child: Container(
                                          width: double.infinity,
                                          child: TextButton(
                                              key: Key('btnContinueLogin'),
                                              onPressed: () {
                                                dismissDialog();
                                                //Navigator.of(context).push(PageTransition(type: PageTransitionType.slideInLeft, duration: Duration(milliseconds: 200) , child: SocioNO()));

                                              },
                                              child: Text(Strings.cancel,
                                                  style: TextStyle(
                                                      letterSpacing: 0.5,
                                                      fontFamily: Strings.font_medium,
                                                      fontSize: 16,
                                                      color:  CustomColors.white)
                                              )),
                                        )),
                                  ],
                                );
                              })),*/


                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor, AssetImage logo, int index) {
    var loginBtn = new Container(
        margin: margin,
        padding: EdgeInsets.all(10.0),
        alignment: FractionalOffset.topLeft,
        decoration: new BoxDecoration(
            color: bgColor,
            borderRadius: index==1?BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)):BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0))
          //borderRadius: new BorderRadius.all(const Radius.circular(100.0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              child: Image(
                  height: 40,
                  width: 40,
                  image: logo),
            ),

            Text(
              buttonLabel,
              textAlign: TextAlign.left,
              style: new TextStyle(
                  color: textColor,
                  fontFamily: Strings.font_medium,
                  fontSize: 15.0
              ),
              textScaleFactor: 1.0,
            ),

          ],
        )
    );
    return loginBtn;
  }

  @override
  void funcOpenDialog(BuildContext context) {
    // TODO: implement funcOpenDialog

    if(prefs.permissionGallery != "0"){
      Future.delayed(const Duration(milliseconds: 200), () {
        print("abrir dialog");
        dialogNotifications(context, Strings.wait, Strings.activateGallery, Strings.activate2, Strings.activate1, "video");
      });

    }

  }

}


dialogSelectPickerImage(BuildContext context) async {


  /*return showAnimatedDialog(
    barrierDismissible: false,
    context: context,
    animationType: DialogTransitionType.slideFromBottom,
    curve: Curves.easeOutQuad,
    duration: Duration(milliseconds: 600),
    builder: (BuildContext context) {
      return Builder(
          builder: (context) => /*WillPopScope(
              /*onWillPop: () {
                return false;
              },*/

              child:*/
              Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 30, left: 30),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Column(children: <Widget>[
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Image(
                                  height: 45,
                                  width: 45,
                                  image:
                                  AssetImage('assets/images/ic_close.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Image(
                                height: 150,
                                width: 150,
                                image:
                                AssetImage('assets/images/img_restore_pwd.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.center,
                                child: Text('Revisa tu correo y activa tu cuenta.',
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        height: 1.3,
                                        fontFamily: Strings.font_medium,
                                        fontSize: 16,
                                        color: CustomColors.graytext))),
                            SizedBox(
                              height: 15,
                            ),
                          ])),
                      Container(
                        margin: EdgeInsets.only(right: 30, left: 30),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: CustomColors.red,
                                    ),
                                    child: Builder(builder: (BuildContext context) {
                                      return Container(
                                        width: double.infinity,
                                        child: TextButton(
                                            key: Key('btnButtonAccept'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            //child: Text(utils.ReadLanguage("accept"),
                                      child: Text("Aceptar",
                                          textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontFamily:
                                                    Strings.font_medium,
                                                    fontSize: 15,
                                                    color: CustomColors.white))),
                                      );
                                    }))
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              )
          //)
      );
    },
  );*/

   showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => Builder(
          builder: (context) => /*WillPopScope(
              /*onWillPop: () {
                return false;
              },*/

              child:*/
          Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 30, left: 30),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Image(
                              height: 45,
                              width: 45,
                              image:
                              AssetImage('assets/images/ic_close.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image(
                            height: 150,
                            width: 150,
                            image:
                            AssetImage('assets/images/img_restore_pwd.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            child: Text('Revisa tu correo y activa tu cuenta.',
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    height: 1.3,
                                    fontFamily: Strings.font_medium,
                                    fontSize: 16,
                                    color: CustomColors.graytext))),
                        SizedBox(
                          height: 15,
                        ),
                      ])),
                  Container(
                    margin: EdgeInsets.only(right: 30, left: 30),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: CustomColors.red,
                                ),
                                child: Builder(builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    child: TextButton(
                                        key: Key('btnButtonAccept'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        //child: Text(utils.ReadLanguage("accept"),
                                        child: Text("Aceptar",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontFamily:
                                                Strings.font_medium,
                                                fontSize: 15,
                                                color: CustomColors.white))),
                                  );
                                }))
                        ),
                      ],
                    ),
                  )
                ],
              )
          )
        //)
      )
  );


}
