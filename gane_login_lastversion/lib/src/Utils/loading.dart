import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class LoadingProgress extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.35),
        body: Center(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    child:  Container(
                      width: 120,
                      height: 120,
                      //alignment: Alignment.center,
                      child: Lottie.asset('assets/images/load3.json'),

                    ),
                  ),



                ]),
          ),
        ),
      ),
    );
  }
}
