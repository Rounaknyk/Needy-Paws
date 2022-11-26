import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/post_model.dart';
import '../Models/Ltlg.dart';

class NavScreen extends StatefulWidget {
  @override
  State<NavScreen> createState() => _NavScreenState();

  NavScreen({required this.pList});
  List<PostModel> pList;

}

class _NavScreenState extends State<NavScreen> {
  List<Marker> marker = [];
  late Ltlg ltlg;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isInfected = false;
  List<Circle> circles = [];
  bool isNormal = true;

  loadMarkers(){
    for (PostModel pm in widget.pList) {

      isInfected = (pm.infection == "none") ? false : true;

      marker.add(
        Marker(
          infoWindow: InfoWindow(
              snippet: "${pm.manual_address}", title: "Infection: ${pm.infection}",),
          markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()),
          position: LatLng(pm.ltlg.lat, pm.ltlg.lng),
          icon: isInfected ? BitmapDescriptor.defaultMarker : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen.toDouble()),
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
      body: Stack(
        children: [
          GoogleMap(
            indoorViewEnabled: true,
            circles: Set.from(circles),
            mapType: isNormal ? MapType.normal : MapType.satellite,
            initialCameraPosition:
                CameraPosition(target: LatLng(widget.pList[0].ltlg.lat, widget.pList[0].ltlg.lng), zoom: 10, tilt: 50),
            markers: Set.from(marker),
            onTap: null,
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
