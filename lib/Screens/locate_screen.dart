import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/Ltlg.dart';

 class LocateScreen extends StatefulWidget {

   LocateScreen({required this.ltlg});
   late Ltlg ltlg;

  @override
  State<LocateScreen> createState() => _LocateScreenState();
}

class _LocateScreenState extends State<LocateScreen> {

   List<Marker> marker = [];
   bool isNormal = true;

  setMarkers() {
    setState(() {
      marker.add(
        Marker(
          markerId: MarkerId("${DateTime.now().millisecondsSinceEpoch}"),
          position: LatLng(widget.ltlg.lat, widget.ltlg.lng),
        ),
      );
    });
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
                 target: LatLng(widget.ltlg.lat, widget.ltlg.lng),
                 zoom: 10),
             markers: Set.from(marker),
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
