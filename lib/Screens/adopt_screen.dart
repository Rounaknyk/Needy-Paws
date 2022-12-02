import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/post_model.dart';
import 'package:needy_paw/MyWidgets/reusable_button.dart';
import 'package:needy_paw/MyWidgets/reusable_icon_text.dart';
import 'package:needy_paw/Screens/chat_screen.dart';
import 'package:needy_paw/Screens/locate_screen.dart';
import 'package:needy_paw/constants.dart';
import 'package:needy_paw/my_routes.dart';
import 'package:share/share.dart';

enum mapType { normal, hybrid }

class AdoptScreen extends StatefulWidget {
  @override
  State<AdoptScreen> createState() => _AdoptScreenState();

  AdoptScreen({required this.pm});
  late PostModel pm;
}

class _AdoptScreenState extends State<AdoptScreen> {
  List<Marker> marker = [];
  List<Circle> circles = [];
  List<Polyline> polylines = [];
  List<LatLng> list_latlng = [];
  late PolylinePoints polyPoints;
  bool isInfected = false;
  bool isNormal = true;
  var mpType;

  setPolylines() async {
    PolylineResult result = await polyPoints.getRouteBetweenCoordinates(
        "AIzaSyDwniEM6ZWWq5cz3dr7MRWzogib9fNnQ6g",
        PointLatLng(15.292759706426065, 74.11975152790546),
        PointLatLng(widget.pm.ltlg.lat, widget.pm.ltlg.lng));
    if (result.status == "OK") {
      print("OK");
      result.points.forEach((element) {
        list_latlng.add(LatLng(element.latitude, element.longitude));
      });
    } else {
      print(result.status);
    }

    setState(() {
      polylines.add(
        Polyline(
          polylineId: PolylineId("asda"),
          points: list_latlng,
          width: 10,
          color: Colors.blue,
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polyPoints = PolylinePoints();
    // list_latlng.add(LatLng(15.292759706426065, 74.11975152790546));
    // polylines.add(Polyline(polylineId: PolylineId("asda"), points: list_latlng));
    isInfected = (widget.pm.infection == "none") ? false : true;
    marker.add(
      Marker(
        markerId: MarkerId("${DateTime.now().millisecondsSinceEpoch}"),
        position: LatLng(widget.pm.ltlg.lat, widget.pm.ltlg.lng),
        icon: isInfected
            ? BitmapDescriptor.defaultMarker
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    circles.add(
      Circle(
        circleId: CircleId(widget.pm.time),
        radius: 500,
        center: LatLng(widget.pm.ltlg.lat, widget.pm.ltlg.lng),
        fillColor: isInfected
            ? Colors.red.shade100.withOpacity(0.5)
            : Colors.blue.shade100.withOpacity(0.5),
        strokeColor: isInfected
            ? Colors.red.shade100.withOpacity(0.1)
            : Colors.blue.shade100.withOpacity(0.1),
      ),
    );
  }

  Future<void> shareFile() async {
    String locationUrl = "google.com/maps/search/${widget.pm.ltlg.lat},+${widget.pm.ltlg.lng}/";
    Share.share("*This stray animal needs your help 👇*\n${widget.pm.url}\n\nlocation :\n${locationUrl}");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("${widget.pm.name}"), actions: [
        IconButton(onPressed: (){
          shareFile();
        }, icon: Icon(Icons.share))
      ],),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                    widget.pm.url
                ),
              ),
              backgroundColor: kBackgroundColor,
            ),
            SliverToBoxAdapter(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Column(
                        children: [
                          ReusableIconText(
                              text: widget.pm.des, icon: SvgPicture.asset("svgs/des.svg", height: 24, width: 24),),
                          SizedBox(
                            height: 10,
                          ),
                          ReusableIconText(
                              text: widget.pm.manual_address,
                              icon: SvgPicture.asset("svgs/location.svg", height: 24, width: 24,)),
                          SizedBox(
                            height: 10,
                          ),
                          ReusableIconText(
                            text: widget.pm.infection,
                            icon: SvgPicture.asset("svgs/coronavirus.svg", height: 24, width: 24, color: isInfected ? Colors.red : Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReusableButton(
                                text: "Chat",
                                func: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(senderUid: widget.pm.uid, senderName: widget.pm.name,)),
                                  );
                                },
                              ),
                              ReusableButton(
                                text: "Locate",
                                func: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LocateScreen(ltlg: widget.pm.ltlg)));
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 400,
                              width: double.infinity,
                              child: GoogleMap(
                                onMapCreated: (controller) {
                                  setPolylines();
                                },
                                polylines: Set.from(polylines),
                                mapType:
                                    isNormal ? MapType.normal : MapType.satellite,
                                myLocationButtonEnabled: false,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        widget.pm.ltlg.lat, widget.pm.ltlg.lng),
                                    zoom: 15, tilt: 50),
                                markers: Set.from(marker),
                                circles: Set.from(circles),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    /*
    Stack(
        children: [
          Hero(
            tag: "hero",
            child: Material(
              child: ClipRRect(
                child: Image.asset(
                  width: double.infinity,
                  "Assets/street_dog.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.6,
            initialChildSize: 0.6,
            maxChildSize: 0.8,
            builder: (context, controller) {
              return SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableIconText(
                              text: widget.pm.name, icon: Icons.person),
                          SizedBox(
                            height: 10,
                          ),
                          ReusableIconText(
                              text: widget.pm.des, icon: Icons.description),
                          SizedBox(
                            height: 10,
                          ),
                          ReusableIconText(
                              text: widget.pm.manual_address,
                              icon: Icons.location_on),
                          SizedBox(
                            height: 10,
                          ),
                          ReusableIconText(
                            text: widget.pm.infection,
                            icon: Icons.coronavirus,
                            color: isInfected ? Colors.red : Colors.black,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReusableButton(text: "Chat", func: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(pm: widget.pm)),);
                              },),
                              ReusableButton(text: "Locate", func: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(pm: widget.pm)),);
                              },),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 400,
                              width: double.infinity,
                              child: GoogleMap(
                                onMapCreated: (controller) {
                                  setPolylines();
                                },
                                polylines: Set.from(polylines),
                                mapType: isNormal ? MapType.normal : MapType.hybrid,
                                myLocationButtonEnabled: false,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        widget.pm.ltlg.lat, widget.pm.ltlg.lng),
                                    zoom: 15),
                                markers: Set.from(marker),
                                circles: Set.from(circles),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
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
                                          style: TextStyle(color: isNormal ? Colors.white : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
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
                                      color: isNormal ? Colors.white : Colors.blue,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Center(
                                        child: Text(
                                          "Hybrid",
                                          style: TextStyle(color: isNormal ? Colors.black : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 700,
                            width: double.infinity,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    size: 30,
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            alignment: AlignmentDirectional.topStart,
          ),
        ],
      ),
     */
  }
}
