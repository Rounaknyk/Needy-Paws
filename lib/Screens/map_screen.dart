import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as anim;
import 'package:permission_handler/permission_handler.dart' as permit;
import '../Models/Ltlg.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> marker = [];
  late Ltlg ltlg;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  LocationData? locationData;
  bool loaded = false;
  bool isNormal = true;

  _onTapHandle(LatLng latlng) {
    setState(() {
      ltlg = Ltlg(latlng.latitude, latlng.longitude);
      marker = [];
      marker
          .add(Marker(markerId: MarkerId(latlng.toString()), position: latlng));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marker = [];
    checkPermission();
    // widget.isMapPage! ? setMarkers() : null;
  }

  getPermission() async {
    permit.PermissionStatus status = await permit.Permission.location.request();

    print(status);
    if (status == permit.PermissionStatus.permanentlyDenied) {
      permit.openAppSettings();
    }
    if(status == permit.PermissionStatus.granted){
      getCurrentLocation();
    }
  }

  Future checkPermission() async {
    final status = await permit.Permission.location.status;
    String nn = status.toString();
    if (status == permit.PermissionStatus.denied) {
      showAlertDialog(context, nn);
    }
    if(status == permit.PermissionStatus.granted){
      getCurrentLocation();
    }
  }

  showAlertDialog(BuildContext context, String nn) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Permit"),
      onPressed: () async {
        Navigator.pop(context);
        getCurrentLocation();
      },
    );

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        loaded = true;
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
        okButton
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


  getCurrentLocation() async {
    Location loc = Location();
    await loc.getLocation().then((value) {
      locationData = value;
      if(locationData != null) {
        ltlg = Ltlg(locationData!.latitude!, locationData!.longitude!);
        marker.add(
          Marker(
            markerId: MarkerId("MarkerId"),
            position: LatLng(locationData!.latitude!, locationData!.longitude!),
            infoWindow: InfoWindow(title: "You are here"),
          ),
        );
      }
    });
    loaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, ltlg);
        },
        child: Icon(Icons.pets),
      ),
      body: (locationData == null)
          ? Center(
              child: anim.LottieBuilder.asset(
                "Animations/paw_loading.json",
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            )
          : Stack(
            children: [
              GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(locationData!.latitude!, locationData!.longitude!),
                      zoom: 15, tilt: 50),
                  markers: Set.from(marker),
                  onTap: _onTapHandle,
                mapType: isNormal ? MapType.normal : MapType.satellite,
                ),
              Positioned(
                bottom: 50,
                left: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isNormal = true;
                        });
                      },
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color:
                            isNormal ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Center(
                              child: Text(
                                "Normal",
                                style: TextStyle(
                                    color: isNormal
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isNormal = false;
                        });
                      },
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color:
                            isNormal ? Colors.white : Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Center(
                              child: Text(
                                "Satellite",
                                style: TextStyle(
                                    color: isNormal
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
