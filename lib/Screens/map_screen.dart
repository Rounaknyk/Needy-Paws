import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Models/Ltlg.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();

}

class _MapScreenState extends State<MapScreen> {
  List<Marker> marker = [];
  late Ltlg ltlg;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _onTapHandle(LatLng latlng) {
    setState(() {
      ltlg = Ltlg(latlng.latitude, latlng.longitude);
      marker = [];
      marker.add(
        Marker(markerId: MarkerId(latlng.toString()), position: latlng)
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marker = [] ;
    // widget.isMapPage! ? setMarkers() : null;
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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(15.2993, 74.1240), zoom: 15),
        markers: Set.from(marker),
        onTap: _onTapHandle,
      ),
    );
  }
}
