import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/Screens/map_screen.dart';

class MapScreen2 extends StatefulWidget {
  MapScreen2({required this.cList});
  List<ClinicModel> cList;

  @override
  State<MapScreen2> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  bool isNormal = true;
  List<Marker> markers = [];
  setMarkers() {
    for (ClinicModel cm in widget.cList) {
      markers.add(
        Marker(
          markerId: MarkerId("${DateTime.now().millisecondsSinceEpoch}"),
          position: LatLng(cm.ltlg.lat, cm.ltlg.lng),
          infoWindow: InfoWindow(
              title: cm.cname,
              snippet: "Vet: ${cm.vname}\nAddress: ${cm.manual_address}"),
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
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.cList[0].ltlg.lat, widget.cList[0].ltlg.lng),
                zoom: 10),
            markers: Set.from(markers),
            mapType: isNormal ? MapType.normal : MapType.hybrid,
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
                        "Hybrid",
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
