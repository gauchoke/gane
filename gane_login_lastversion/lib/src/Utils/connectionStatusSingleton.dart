import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gane/src/Utils/inter.dart';
import 'package:gane/src/Utils/singleton.dart';
//import 'package:connectivity/connectivity.dart';

class ConnectionStatusSingleton {
    //This creates the single instance by calling the `_internal` constructor specified below
    static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
    ConnectionStatusSingleton._internal();
    final singleton = Singleton();

    //This is what's used to retrieve the instance through the app
    static ConnectionStatusSingleton getInstance() => _singleton;

    //This tracks the current connection status
    bool hasConnection = false;

    //This is how we'll allow subscribing to connection changes
    StreamController connectionChangeController = new StreamController.broadcast();

    //flutter_connectivity
    //final Connectivity _connectivity = Connectivity();
    final MyConnectivity _connectivity = MyConnectivity.instance;

    //Hook into flutter_connectivity's Stream to listen for changes
    //And check the connection status out of the gate
    void initialize() {
        //_connectivity.onConnectivityChanged.listen(_connectionChange);
        _connectivity.initialise();
        checkConnection();
    }

    Stream get connectionChange => connectionChangeController.stream;

    //A clean up method to close our StreamController
    //   Because this is meant to exist through the entire application life cycle this isn't
    //   really an issue
    void dispose() {
        connectionChangeController.close();
    }

    //flutter_connectivity's listener
    //void _connectionChange(ConnectivityResult result) {
    void _connectionChange(ConnectivityResult result) {
        checkConnection();
    }

    //The test to actually see if there is a connection
    Future<bool> checkConnection() async {
        bool previousConnection = hasConnection;

        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                hasConnection = true;
                singleton.isOffline = false;
                print("imprime false porque hay internet");
            } else {
                hasConnection = false;
                singleton.isOffline = true;
                print("imprime true porque no hay internet");
            }
        } on SocketException catch(_) {
            hasConnection = false;
            singleton.isOffline = true;
            print("imprime catch error internet");
            connectionChangeController.add(hasConnection);
        }

        //The connection status changed send out an update to all listeners
        if (previousConnection != hasConnection) {
            connectionChangeController.add(hasConnection);
        }

        return hasConnection;
    }
}