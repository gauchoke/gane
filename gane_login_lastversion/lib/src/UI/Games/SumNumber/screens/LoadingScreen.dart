import 'dart:async';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:gane/src/UI/Games/SumNumber/utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:gane/src/UI/Games/webgames.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/strings.dart';
import 'package:page_transition/page_transition.dart';
import 'package:transition/transition.dart';

class LoadingScreen extends StatefulWidget {
  // This widget is the root of your application.

  final from;
  final VoidCallback relaunch;
   LoadingScreen({this.from,required this.relaunch});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  Color _color = Colors.green;
  int _startCounter = 3;
  late Timer _timer;
  Random random = Random();
  final singleton = Singleton();

  @override
  void initState() {
    super.initState();
    this.runCounter();
  }

  void runCounter() {
    _timer = Timer.periodic(Duration(seconds: 1), loadTimer);
  }

  loadTimer(Timer timer) {
    setState(() {
      this.loadGameWhenReady(timer);
      this.continueLoader();
    });
  }

  void continueLoader() {
    //_color = Common.getRandomColor();
    _startCounter--;
  }

  void loadGameWhenReady(Timer timer) {
    if (_startCounter > 1) {
      return;
    }

    timer.cancel();

    if(widget.from == "pop"){ /// Bubbles pop
      //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: Bubbles(relaunch: widget.relaunch,) ));
    }else if(widget.from == "run"){ /// Run
      //Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 350), child: RunGame(relaunch: widget.relaunch,) ));
    }else{ /// Online games
      Navigator.push(context, Transition(child: WebGames(url: singleton.codeUrl, title: Strings.tyc1,relaunch: widget.relaunch,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT));
    }


  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(

          children: [

            /// Background
            Container(
              child: Image.asset(
                "assets/images/back_time.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height ,
                fit: BoxFit.cover,
              ),
            ),

            /// 3,2,1
            Center(
              child: Container(
                alignment: Alignment(0.0, 0.0),
                child: Stack(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


                    Center(
                      child: SvgPicture.asset(
                        'assets/images/backnumber.svg',
                        fit: BoxFit.cover,
                      )
                    ),

                    Center(
                      child: Text(
                        _startCounter.toString(),
                        style: TextStyle(
                            fontFamily: Strings.font_bold,
                            fontSize:90,
                            color: CustomColors.blueBack),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],

        )
      );
  }
}
