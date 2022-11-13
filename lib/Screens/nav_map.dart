import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/post_model.dart';
import '../Models/Ltlg.dart';

class NavScreen extends StatefulWidget {
  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  List<Marker> marker = [];
  late Ltlg ltlg;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isInfected = false;
  List<Circle> circles = [];

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
          uid: mark["uid"]);
      isInfected = (pm.infection == "none") ? false : true;


      marker.add(
        Marker(
          infoWindow: InfoWindow(
              snippet: "getAddress(pm.ltlg)", title: "Infection: ${pm.infection}",),
          icon: isInfected
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
          markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()),
          position: LatLng(pm.ltlg.lat, pm.ltlg.lng),
        ),
      );

      circles.add(
        Circle(
          circleId: CircleId(pm.time),
          radius: 500,
          center: LatLng(pm.ltlg.lat, pm.ltlg.lng),
          fillColor: isInfected ? Colors.red.shade100.withOpacity(0.5) : Colors.blue.shade100.withOpacity(0.5),
          strokeColor: isInfected ? Colors.red.shade100.withOpacity(0.1) : Colors.blue.shade100.withOpacity(0.1),
        ),
      );
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        circles: Set.from(circles),
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(15.2993, 74.1240), zoom: 14),
        markers: Set.from(marker),
        onTap: null,
      ),
    );
  }
}
