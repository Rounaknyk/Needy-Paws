
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as animation;
import 'package:needy_paw/Models/Ltlg.dart';

 class LocateScreen extends StatefulWidget {

   LocateScreen({required this.ltlg});
   late Ltlg ltlg;

  @override
  State<LocateScreen> createState() => _LocateScreenState();
}

class _LocateScreenState extends State<LocateScreen> {

   List<Marker> destination = [];
   bool isNormal = true;
   LocationData? currentLocation;
   List<LatLng> polyCoords = [];

   setMarkers() {
      setState(() {
        destination.add(
          Marker(
            markerId: MarkerId("destintaion"),
            position: LatLng(widget.ltlg.lat, widget.ltlg.lng),
          ),
        );
      });
    }

    void getPolylinePoints() async {

     PolylinePoints points = PolylinePoints();
     PolylineResult res = await points.getRouteBetweenCoordinates(
         "AIzaSyDwniEM6ZWWq5cz3dr7MRWzogib9fNnQ6g", PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!), PointLatLng(widget.ltlg.lat, widget.ltlg.lng));

     if(res.points.isNotEmpty){
       res.points.forEach((PointLatLng point) {
        polyCoords.add(LatLng(point.latitude, point.longitude));
       });
       setState(() {

       });
     }

   }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    setMarkers();
    // getPolylinePoints();
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
                 target: LatLng(
                     widget.ltlg.lat, widget.ltlg.lng
                 ),
                 zoom: 15),
             markers: {
               destination[0],
             },
             mapType: isNormal ? MapType.normal : MapType.satellite,
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
