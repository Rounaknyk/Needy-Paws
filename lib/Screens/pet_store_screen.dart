import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/Screens/locate_screen.dart';
import 'package:needy_paw/Screens/map_screen2.dart';
import 'package:needy_paw/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Models/store_model.dart';
import 'map_screen3.dart';

class PetStoreScreen extends StatefulWidget {
  PetStoreScreen({required this.sm});
  StoreModel sm;

  @override
  State<PetStoreScreen> createState() => _PetStoreScreenState();
}

class _PetStoreScreenState extends State<PetStoreScreen> {
  bool isNormal = true;

  List<Marker> mark = [];
  List<StoreModel> sList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sList.add(widget.sm);
    mark.add(
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          markerId: MarkerId("12345678"),
          position: LatLng(widget.sm.ltlg.lat, widget.sm.ltlg.lng),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapScreen3(sList: sList)));
          }),
    );
  }

  callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber("+91$number");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(child: SvgPicture.asset("svgs/location.svg", height: 24, width: 24,), onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen3(sList: sList),),);
              }, ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.sm.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                widget.sm.name,
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.sm.des,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[900]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.sm.manual_address,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[900]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.sm.phoneNumber,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.copy,
                                      size: 15,
                                    ),
                                    onTap: () async {
                                      Clipboard.setData(ClipboardData(
                                          text: widget.sm.phoneNumber));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text("Number Copied !"),),);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: IconButton(
                              icon: Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                callNumber(widget.sm.phoneNumber);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      child: GoogleMap(
                        onTap: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MapScreen3(sList: sList)));
                        },
                        onMapCreated: (controller) {
                          // setPolylines();
                        },
                        // polylines: Set.from(polylines),
                        mapType: isNormal ? MapType.normal : MapType.satellite,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target:
                                LatLng(widget.sm.ltlg.lat, widget.sm.ltlg.lng),
                            zoom: 15,
                            tilt: 50),
                        markers: Set.from(mark),
                        // circles: Set.from(circles),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                              color: isNormal ? Colors.white : Colors.blue,
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
        ));
  }
}
