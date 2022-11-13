import 'package:flutter/material.dart';
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
    mark.add(Marker(markerId: MarkerId("12345678"), position: LatLng(widget.cm.ltlg.lat, widget.cm.ltlg.lng), onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen2(cList: cList)));
    }),);

  }

  callNumber() async {
    await FlutterPhoneDirectCaller.callNumber("919322942635");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(child: Icon(Icons.arrow_back_ios_new,), onTap: (){
                Navigator.pop(context);
              },),
              SizedBox(height: 10,),
              Center(
                child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/needy-paws.appspot.com/o/Clinics%2FWhatsApp%20Image%202022-11-12%20at%2010.53.38%20PM.jpeg?alt=media&token=a19921c3-686a-44b3-97d9-c651c2284670",
                  fit: BoxFit.cover,
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
                          height: 10,
                        ),
                        Text(
                          widget.cm.cname,
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.cm.vname,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.cm.manual_address,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(icon: Icon(Icons.call, color: Colors.white,), onPressed: () async {
                        callNumber();
                      },),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: GoogleMap(
                    onTap: (value){

                      Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen2(cList: cList)));
                    },
                    onMapCreated: (controller) {
                      // setPolylines();
                    },
                    // polylines: Set.from(polylines),
                    mapType:
                    isNormal ? MapType.normal : MapType.hybrid,
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            widget.cm.ltlg.lat, widget.cm.ltlg.lng),
                        zoom: 15),
                    markers: Set.from(mark),
                    // circles: Set.from(circles),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
