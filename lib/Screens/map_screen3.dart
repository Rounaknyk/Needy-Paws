import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/Screens/map_screen.dart';

import '../Models/store_model.dart';

class MapScreen3 extends StatefulWidget {
  MapScreen3({required this.sList});
  List<StoreModel> sList;

  @override
  State<MapScreen3> createState() => _MapScreen3State();
}

class _MapScreen3State extends State<MapScreen3> {
  bool isNormal = true;
  List<Marker> markers = [];
  setMarkers() {
    if(widget.sList.length != 0)
    for (StoreModel sm in widget.sList) {
      markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          markerId: MarkerId("${DateTime.now().millisecondsSinceEpoch}"),
          position: LatLng(sm.ltlg.lat, sm.ltlg.lng),
          infoWindow: InfoWindow(
              title: sm.name,
            snippet: sm.manual_address
        ),
      ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: (widget.sList.length == 0) ? Center(child: Text("No clinic's added for now")) : Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.sList[0].ltlg.lat, widget.sList[0].ltlg.lng),
                zoom: 15, tilt: 50),
            markers: Set.from(markers),
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
                    color: isNormal ? Colors.blue : Colors.white,
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
