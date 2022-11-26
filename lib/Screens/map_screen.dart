import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as anim;
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
    getCurrentLocation();
    // widget.isMapPage! ? setMarkers() : null;
  }

  getCurrentLocation() async {
    Location loc = Location();
    await loc.getLocation().then((value) {
      locationData = value;
      marker.add(
        Marker(
          markerId: MarkerId("MarkerId"),
          position: LatLng(locationData!.latitude!, locationData!.longitude!),
          infoWindow: InfoWindow(title: "You are here"),
        ),
      );
    });
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
        mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(locationData!.latitude!, locationData!.longitude!),
                      zoom: 15),
                  markers: Set.from(marker),
                  onTap: _onTapHandle,
                ),
              Positioned(
                bottom: 30,
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
