import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/Screens/account_screen.dart';
import 'package:needy_paw/Screens/chat_menu.dart';
import 'package:needy_paw/Screens/home_screen.dart';
import 'package:needy_paw/Screens/map_screen.dart';
import 'package:needy_paw/Screens/more_screen.dart';
import 'package:needy_paw/Screens/nav_map.dart';
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();

  MainScreen({required this.data});
  late UserModel data;

}

class _MainScreenState extends State<MainScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  late UserModel myData;
  late final screens;

  @override
  void initState() {
    super.initState();
    // auth.signOut();
    myData = widget.data;

    screens = [
      HomeScreen(myData: myData),
      NavScreen(),
      ChatMenu(),
      MoreScreen(),
      AccountScreen()
    ];
    getPermission();
    getLiveLocation();
  }

  getLiveLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
  }

  _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  getPermission() async {
    PermissionStatus status = await Permission.location.request();

    print(status);
    if(status == PermissionStatus.permanentlyDenied){
      // openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wechat_sharp),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: "More"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
          ),
        ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey[900],
          onTap: _onItemTapped,
          elevation: 5,
      ),
    );
  }
}