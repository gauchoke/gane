import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:spring_button/spring_button.dart';


/// Esto es nuevo

void main() => runApp(new ErrorView());

class ErrorView extends StatefulWidget {
  @override
  _ErrorView createState() => _ErrorView();
}

class _ErrorView extends State<ErrorView>{
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: CustomColors.bluebackerror,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            ///Image
            Center(
              child: Container(
                height: 364,
                width: 179,
                child: Image.asset('assets/images/Componenteerror.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// Text
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 15,right: 15),
              child: Center(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10,bottom: 15,),

                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 15.0,
                          //color: Colors.black,
                        ),
                        children: <TextSpan>[

                          new TextSpan(text: Strings.errorview,
                              style: TextStyle(
                                fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 13.0,
                                decorationColor: CustomColors.orangeback,
                              ),
                          ),

                          new TextSpan(text: Strings.errorview1,
                            style: TextStyle(
                              fontFamily: Strings.font_bold, color: CustomColors.white, fontSize: 13.0,
                              decorationColor: CustomColors.orangeback,
                            ),
                          ),

                          new TextSpan(text: Strings.errorview2,
                            style: TextStyle(
                              fontFamily: Strings.font_medium, color: CustomColors.white, fontSize: 13.0,
                              decorationColor: CustomColors.orangeback,
                            ),
                          ),

                        ],
                      ),
                    ),

                  ),
                ),
              ),
            ),

            SizedBox(height: 30,),

            ///Btn Back
            Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              child: SpringButton(
                SpringButtonType.OnlyScale,
                Container(
                  width: 120,
                  height: 45,
                  decoration: BoxDecoration(
                    color: CustomColors.orangeback,
                    borderRadius: BorderRadius.all(const Radius.circular(23)),
                    border: Border.all(
                      width: 1,
                      color: CustomColors.orangeback,
                    ),
                  ),
                  child: Container(
                    //margin: EdgeInsets.only(top: 15,bottom: 15),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: <Widget>[

                          /// languaje
                          Expanded(
                            child: Container(
                              child: AutoSizeText(
                                Strings.goback,
                                textAlign: TextAlign.center,
                                //maxLines: 1,
                                style: TextStyle(fontFamily: Strings.font_semibold, color: CustomColors.white, fontSize: 14.0,),
                                //maxLines: 1,
                              ),
                            ),
                          ),


                        ],

                      ),
                    ),
                  ),
                ),
                useCache: false,
                onTap: (){
                  Navigator.pop(context);
                },

                //onTapDown: (_) => decrementCounter(),

              ),
            ),

            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }


}