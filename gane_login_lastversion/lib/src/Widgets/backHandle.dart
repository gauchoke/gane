import 'package:gane/src/Utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';


class _BackHandle {
  int _counter = 1;
  static const timeout = const Duration(seconds: 1);
  static const ms = const Duration(milliseconds: 1);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Singleton singleton = Singleton();

  final _opendrawerStreamController = StreamController<String>.broadcast();
  Stream<String> get opendraw => _opendrawerStreamController.stream;


  Future<bool> callToast() async {
    startTimeout();
    if (_counter == 2) {
      SystemNavigator.pop();
      //_opendrawerStreamController.sink.add("open");
      return true;

    } else if (_counter == 1) {
      Fluttertoast.showToast(
        msg: "Doble clic para salir",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 13.0,
      );
      _counter++;
      return false;
    }
    return true;
  }

  Future<bool> backNoInternet() async {
    //startTimeout();
    print("singleton.isOffline: "+singleton.isOffline.toString());

    if(singleton.isOffline == false){
      return false;
    }else {
      return true;
    }
  }

  /*Future<bool> callToast1() async {
    startTimeout();
    if (_counter == 2) {
      //SystemNavigator.pop();
      _scaffoldKey.currentState.openDrawer();

    } else if (_counter == 1) {
      Fluttertoast.showToast(
        msg: "Doble clic para salir",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 13.0,
      );
      _counter++;
      return false;
    }
  }*/

  startTimeout([int? milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return new Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    _counter = 1;
  }



}

final backHandle = new _BackHandle();
