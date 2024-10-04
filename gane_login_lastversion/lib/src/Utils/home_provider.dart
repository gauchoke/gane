import 'package:flutter/material.dart';
import 'package:gane/src/Models/roomlook.dart';


class HomeProvider with ChangeNotifier {

  /// Vector Gane Room
  Roomlook _notifierLookRoomss = Roomlook(code: 1,message: "No hay nada", status: false, );

  Roomlook get notifierLookRoomss => this._notifierLookRoomss;
  set notifierLookRoomss(Roomlook value) {
    this._notifierLookRoomss  = value;
    notifyListeners();
  }

  /// Internet validator
  var _isOffline = false;
  get isOffline => this._isOffline;
  set notifierisOffline(bool value) {
    this._isOffline  = value;
    notifyListeners();
  }

  var _isViewRechargeAccount = false;
  get isViewRechargeAccount => _isViewRechargeAccount;
  set changeViewRechargeAccount(value) {
    _isViewRechargeAccount = value;
    notifyListeners();
  }
}