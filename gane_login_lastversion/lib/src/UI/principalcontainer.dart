
import 'package:flutter/material.dart';
import 'package:gane/src/UI/Home/completeprof.dart';
import 'package:gane/src/UI/Home/home.dart';
import 'package:gane/src/UI/Home/profileUserVIew.dart';
import 'package:gane/src/UI/Home/sharedata.dart';
import 'package:gane/src/UI/Wallet/mywallet.dart';
import 'package:gane/src/Utils/colors.dart';
import 'package:gane/src/Utils/my_flutter_app_icons.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';
import 'package:gane/src/Utils/utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:gane/src/UI/Nointernet/noInternet.dart';
import 'package:gane/src/Utils/managerService.dart';
import 'dart:async';
import 'package:gane/src/Utils/connectionStatusSingleton.dart';
import 'package:gane/src/Widgets/backHandle.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'Play/playlist.dart';

import 'package:badges/badges.dart' as badges;

enum _SelectedTab { home, profile, history }

class PrincipalContainer extends StatefulWidget{
  final selectedIndex;
  final relaunch;

  const PrincipalContainer({this.selectedIndex, this.relaunch}) : super();

  _statePrincipalContainer createState()=> _statePrincipalContainer();
}

class _statePrincipalContainer extends State<PrincipalContainer> {

  static final String menu = "home";
  final singleton = Singleton();
  final prefs = SharePreference();
  servicesManager servicemanager = servicesManager();
  //ProgressDialog pr;
  late StreamSubscription _connectionChangeStream;
  bool visibleTotalShopingCart = false;

  var imgCountry = "";
  var name = "";

  bool visibleUpdateApp = false;
  bool visibleOptionalUpdateApp = false;

  var _selectedTab = _SelectedTab.home;
  int _selectedIndex = 0;


  List<Widget> _widgetOptions = <Widget>[
    /*Home(),
    MyWallet(),
    PlayLists(),
    CProfile(),
    ShareData(),*/

    Home(),
    CProfile(),
    PlayLists(),
    ShareData(),
    ProfileUserView(),

  ];


  void seeToolTip(){
    utils.openSnackBarInfo(singleton.navigatorKey.currentContext!, "Video no disponible en el momento, intente nuevamente.", "assets/images/ic_happy.svg",CustomColors.orangeborderpopup,"success");

  }

  void versionapp() async{
    singleton.packageInfo = await PackageInfo.fromPlatform();

  }

  @override
  void initState(){

    versionapp();

    if(widget.selectedIndex != null){
      _selectedIndex = widget.selectedIndex;
      if(_selectedIndex==1){
        _selectedTab = _SelectedTab.profile;
      }else if(_selectedIndex==2){
        _selectedTab = _SelectedTab.history;
      }else{
        _selectedTab = _SelectedTab.home;
      }

    }

    //ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    //_connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    WidgetsBinding.instance!.addPostFrameCallback((_){

      if(widget.selectedIndex != null){
        _selectedIndex = widget.selectedIndex;
      }

      if(widget.relaunch != null){
        seeToolTip();
      }


    });



    super.initState();
  }

  /*void connectionChanged(dynamic hasConnection) {
    setState(() {
      singleton.isOffline = !hasConnection;
    });
  }*/

  @override
  void dispose() {
    //singleton.indexBeforeSelectedMarker=0;
    ////pr.hide();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    singleton.contextGlobal = context;
    return ValueListenableBuilder<bool>(
        valueListenable: singleton.notifierIsOffline,
        builder: (contexts,value2,_){

          return value2 == true ? Nointernet() : OKToast(
              child: WillPopScope(
                onWillPop: backHandle.callToast,
                child:  SafeArea(
                  top: false,
                  bottom: false,
                  child: Scaffold(
                    backgroundColor: CustomColors.graybackhome,

                    /*bottomNavigationBar: StylishBottomBar(
                      items: [


                        AnimatedBarItems(
                          icon: Icon(
                            MyFlutterApp.ic_home_,
                          ),
                          selectedColor: CustomColors.orangenewdesign,
                          //selectedColor: "#00A86B".toColors(),
                          backgroundColor: CustomColors.greynewdesign,
                          title: Text('Home'),
                        ),
                        AnimatedBarItems(
                          icon: Icon(
                            MyFlutterApp.ic_pools,
                          ),
                          selectedColor: CustomColors.orangenewdesign,
                          backgroundColor: CustomColors.greynewdesign,
                          title: Text('Wallet'),
                        ),
                        AnimatedBarItems(
                          icon: Icon(
                            MyFlutterApp.ic_game,
                          ),
                          selectedColor: CustomColors.orangenewdesign,
                          backgroundColor: CustomColors.greynewdesign,
                          title: Text('Games'),
                        ),
                        AnimatedBarItems(
                          icon: Icon(
                            MyFlutterApp.ic_referrals,
                            //size: 30,
                          ),
                          selectedColor: CustomColors.orangenewdesign,
                          backgroundColor: CustomColors.greynewdesign,
                          title: Text('Profile'),
                        ),
                        AnimatedBarItems(
                          icon: Icon(
                            MyFlutterApp.ic_coingane,
                          ),
                          selectedColor: CustomColors.orangenewdesign,
                          backgroundColor: CustomColors.greynewdesign,
                          title: Text('Share'),
                        ),


                      ],
                      //fabLocation: StylishBarFabLocation.center,
                      //hasNotch: true,
                      iconSize: 22,
                      iconStyle: IconStyle.simple,
                      barAnimation: BarAnimation.fade,
                      //barAnimation: BarAnimation.blink,
                      //barAnimation: BarAnimation.transform3D
                      opacity: 0.3,
                      currentIndex: _selectedIndex ?? 0,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index!;
                        });
                      },

                    ),*/

                    /*bottomNavigationBar: Container(
                      width: MediaQuery.of(context).size.width,
                      child: StylishBottomBar(

                          option: DotBarOptions(
                            dotStyle: DotStyle.tile,
                          ),
                          items: [

                            BottomBarItem(
                              icon: Icon(
                                MyFlutterApp.ic_home_,color: CustomColors.orangenewdesign,
                              ),
                              selectedIcon: Icon(
                                MyFlutterApp.ic_home_, color: CustomColors.orangenewdesign,
                              ),
                              title: Text(''),
                              backgroundColor: CustomColors.greynewdesign,
                              selectedColor: CustomColors.orangenewdesign,
                              unSelectedColor: CustomColors.orangenewdesign,

                            ),
                            BottomBarItem(
                              icon: Icon(
                                MyFlutterApp.ic_pools,
                              ),
                              selectedIcon: Icon(
                                MyFlutterApp.ic_pools,
                              ),
                              title: Text(''),
                              backgroundColor: CustomColors.greynewdesign,
                              selectedColor: CustomColors.orangenewdesign,
                            ),
                            BottomBarItem(
                              icon: Icon(
                                MyFlutterApp.ic_game,
                              ),
                              selectedIcon: Icon(
                                MyFlutterApp.ic_game,
                              ),
                              title: Text(''),
                              backgroundColor: CustomColors.greynewdesign,
                              selectedColor: CustomColors.orangenewdesign,
                            ),
                            BottomBarItem(
                              icon: Icon(
                                MyFlutterApp.ic_referrals,
                              ),
                              selectedIcon: Icon(
                                MyFlutterApp.ic_referrals,
                              ),
                              title: Text(''),
                              backgroundColor: CustomColors.greynewdesign,
                              selectedColor: CustomColors.orangenewdesign,
                            ),
                            BottomBarItem(
                              icon: Icon(
                                MyFlutterApp.ic_coingane,
                              ),
                              selectedIcon: Icon(
                                MyFlutterApp.ic_coingane,
                              ),
                              title: Text(''),
                              backgroundColor: CustomColors.greynewdesign,
                              selectedColor: CustomColors.orangenewdesign,
                            ),

                          ],
                          fabLocation: StylishBarFabLocation.end,
                          currentIndex: _selectedIndex ?? 0,
                          onTap: (index) {
                            setState(() {
                              _selectedIndex = index!;
                            });
                          },
                        ),
                    ),*/

                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: _selectedIndex ?? 0,
                      elevation: 0,
                      type: BottomNavigationBarType.fixed,
                      //backgroundColor: ColorsApp.darkGrayTwo,
                      backgroundColor: CustomColors.white,
                      items: const <BottomNavigationBarItem>[

                        BottomNavigationBarItem(
                          activeIcon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_home_,
                            ),
                          ),
                          icon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_home_,
                            ),
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          activeIcon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_pools,
                            ),
                          ),
                          icon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_pools,
                            ),
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          activeIcon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_game,
                            ),
                          ),
                          icon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_game,
                            ),
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          activeIcon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_referrals,
                              //size: 30,
                            ),
                          ),
                          icon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_referrals,
                              //size: 30,
                            ),
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          activeIcon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_coingane,
                            ),
                          ),
                          icon: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              MyFlutterApp.ic_coingane,
                            ),
                          ),
                          label: "",
                        ),


                      ],
                      unselectedItemColor: CustomColors.greynewdesign,
                      selectedItemColor: CustomColors.orangenewdesign,

                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index!;
                        });
                      },
                    ),

                    //body: _widgetOptions.elementAt(_selectedIndex),
                    body: Container(
                      child: _widgetOptions.elementAt(_selectedIndex),
                    ),
                  ),
                ),
              )
          );

        }

    );

  }


  int onPressed (int i){
    return i;
  }

  /// Select Fence
  Widget selectFence(){

    return Container(

      child: Stack(

        children: <Widget>[

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: CustomColors.black.withOpacity(0.5),

          ),

        ],

      ),


    );

  }

  void _handleIndexChanged(int index){

    setState(() {
      _selectedTab = _SelectedTab.values[index];
      _selectedIndex  = index;
    });

  }


}