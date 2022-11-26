import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:needy_paw/Models/clinic_model.dart';
import 'package:needy_paw/Screens/map_screen2.dart';
import 'package:needy_paw/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ClinicScreen extends StatefulWidget {
  ClinicScreen({required this.cm});
  ClinicModel cm;

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  bool isNormal = true;

  List<Marker> mark = [];
  List<ClinicModel> cList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cList.add(widget.cm);
    mark.add(
      Marker(
          markerId: MarkerId("12345678"),
          position: LatLng(widget.cm.ltlg.lat, widget.cm.ltlg.lng),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MapScreen2(cList: cList)));
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
            IconButton(icon: Icon(Icons.location_on, color: Colors.black,), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen2(cList: cList)));
            }),
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
                        widget.cm.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              widget.cm.cname,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.cm.vname,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.cm.manual_address,
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
                                  widget.cm.phoneNumber,
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
                                        text: widget.cm.phoneNumber));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: IconButton(
                            icon: Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              callNumber(widget.cm.phoneNumber);
                            },
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
                                      MapScreen2(cList: cList)));
                        },
                        onMapCreated: (controller) {
                          // setPolylines();
                        },
                        // polylines: Set.from(polylines),
                        mapType: isNormal ? MapType.normal : MapType.satellite,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target:
                                LatLng(widget.cm.ltlg.lat, widget.cm.ltlg.lng),
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
