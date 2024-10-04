import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gane/src/UI/Home/RechargePlain/RechargePlainView.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spring_button/spring_button.dart';

void main() => runApp(new Nointernet());

class Nointernet extends StatefulWidget {
  @override
  _Nointernet createState() => _Nointernet();
}

class _Nointernet extends State<Nointernet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Stack(
          children: [

            /// Image background
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SvgPicture.asset(
                'assets/images/img_vector_background.svg',
                fit: BoxFit.cover,
              ),
            ),

            /// Texts and buttons
            Container(
              ///color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //SizedBox(height: MediaQuery.of(context).size.height/2-60,),

                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Center(
                      child: Container(
                        child: Text(
                          Strings.nointernet,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 78.0,
                            fontFamily: Strings.font_boldFe,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                    child: Center(
                      child: Container(
                        child: Text(
                          Strings.nointernet1,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 22.0,
                            fontFamily: Strings.font_boldFe,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  /// Reload now
                  /*Center(
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        margin: EdgeInsets.only(left: 80, right: 80),
                        height: 50,
                        decoration: BoxDecoration(
                            color: CustomColors.orangebtn,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(6))),
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/images/ic_phone_money_charge.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //color: Colors.blue,
                                  child: Text(
                                    Strings.reloadnow,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 16.0,
                                      fontFamily: Strings.font_semiboldFe,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                      ),
                      useCache: false,
                      onTap: () {
                        var time = 350;
                        if (singleton.isIOS == false) {
                          time = utils.ValueDuration();
                        }

                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: time),
                                child: RechargePlainView(),
                                reverseDuration: Duration(milliseconds: time)));
                      },
                    ),
                  ),*/
                  Center(
                    child: SpringButton(
                      SpringButtonType.OnlyScale,
                      Container(
                        margin: EdgeInsets.only(left: 80, right: 80),
                        height: 50,
                        decoration: BoxDecoration(
                            color: CustomColors.orangebtn,
                            borderRadius:
                            BorderRadius.all(const Radius.circular(6))),
                        child: Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/images/ic_update_white.svg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      //color: Colors.blue,
                                      child: Text(
                                        Strings.tryagain,
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                          color: CustomColors.white,
                                          fontSize: 16.0,
                                          fontFamily: Strings.font_semiboldFe,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      useCache: false,
                      onTap: () {
                        utils.check();
                      },
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 10),
                    child: Center(
                      child: Container(
                        child: Text(
                          Strings.nointernet2,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: CustomColors.white,
                            fontSize: 19.0,
                            fontFamily: Strings.font_mediumFe,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  /// Re try  and call
                  /*Container(
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 20,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: SpringButton(
                              SpringButtonType.OnlyScale,
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(6))),
                                child: Center(
                                    child: Container(
                                  //margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: SvgPicture.asset(
                                          'assets/images/ic_update_white.svg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            Strings.tryagain,
                                            textAlign: TextAlign.left,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 14.0,
                                              fontFamily:
                                                  Strings.font_semiboldFe,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              useCache: false,
                              onTap: () {
                                utils.check();
                              },
                            ),
                          ),
                        ),

                        SizedBox(width: 6,),

                        Expanded(
                          child: Container(
                            child: SpringButton(
                              SpringButtonType.OnlyScale,
                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                        const Radius.circular(6))),
                                child: Center(
                                    child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: SvgPicture.asset(
                                          'assets/images/ic_phone_request.svg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          //color: Colors.blue,
                                          child: Text(
                                            Strings.makecall1,
                                            textAlign: TextAlign.left,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                              color: CustomColors.white,
                                              fontSize: 14.0,
                                              fontFamily:
                                                  Strings.font_semiboldFe,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              useCache: false,
                              onTap: () {

                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),*/


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
