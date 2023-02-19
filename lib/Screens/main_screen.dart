import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:needy_paw/Models/user_model.dart';
import 'package:needy_paw/Screens/account_screen.dart';
import 'package:needy_paw/Screens/chat_menu.dart';
import 'package:needy_paw/Screens/home_screen.dart';
import 'package:needy_paw/Screens/map_screen.dart';
import 'package:needy_paw/Screens/more_screen.dart';
import 'package:needy_paw/Screens/nav_map.dart';
import 'package:needy_paw/Screens/rescuer_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/Ltlg.dart';
import '../Models/post_model.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();

  MainScreen({required this.data, this.screenNumber = 0});
  late UserModel data;
  int screenNumber = 0;
}

class _MainScreenState extends State<MainScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  late UserModel myData;
  late final screens;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<PostModel> pList = [];
  String userToken = "";

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.screenNumber;
    myData = widget.data;

    getAndSetToken();
    setupInteractedMessage();

    screens = [
      HomeScreen(myData: myData),
      NavScreen(pList: pList),
      ChatMenu(),
      MoreScreen(),
      AccountScreen(
        myData: myData,
      )
    ];

    checkPermission();
    loadMarkers();
  }

  Future<void> getAndSetToken() async {
    await FirebaseMessaging.instance.getToken().then((token)  {
        userToken = token!;
    });

    await FirebaseFirestore.instance.collection("Users").doc(widget.data.uid).set(
      {
        "token": userToken
      },
      SetOptions(merge: true),
    );
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(data: myData, screenNumber: 2)));
    }
  }

  loadMarkers() async {
    final markers = await firestore.collection("Posts").get();
    for (var mark in markers.docs) {
      PostModel pm = PostModel(
        url: mark["url"],
        des: mark["des"],
        ltlg: Ltlg(mark["lat"], mark["lng"]),
        time: mark["time"],
        manual_address: mark["manual_address"],
        infection: mark["infection"],
        name: mark["name"],
        uid: mark["uid"],
        pId: mark["pId"],
      );
      setState(() {
        pList.add(pm);
      });
    }
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getPermission() async {
    PermissionStatus status = await Permission.location.request();

    print(status);
    if (status == PermissionStatus.permanentlyDenied) {
      // openAppSettings();
    }
  }

  Future checkPermission() async {
    final status = await Permission.location.status;
    String nn = status.toString();
    if (status == PermissionStatus.denied) {
      showAlertDialog(context, nn);
    }
    if (status == PermissionStatus.granted) {}
  }

  showAlertDialog(BuildContext context, String nn) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Permit"),
      onPressed: () async {
        Navigator.pop(context);
        getPermission();
      },
    );

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Grant Location Permission"),
      content: Text(
          "This app requires location permission to display animal's location on google maps."),
      actions: [
        noButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_sharp),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined), label: "More"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
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
