import 'dart:async';

import 'package:capsule_map/screens/createcapsule_screen.dart';
import 'package:capsule_map/stores/mainStore/main_store.dart';
import 'package:capsule_map/stores/positionStore/position_store.dart';
import 'package:capsule_map/utils/MapHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    MainStore mainStore = Provider.of<MainStore>(context);
    PositionStore positionStore = Provider.of<PositionStore>(context);

    return FutureBuilder(
      future: BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(12, 12)),
          'images/current_location_dot.png'),
      builder:
          (BuildContext context, AsyncSnapshot<BitmapDescriptor> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
              ),
            ),
          );
        } else {
          return Observer(builder: (_) {
            return positionStore.positionStream != null &&
                    positionStore.positionStream.value != null
                ? Scaffold(
                    drawer: Drawer(
                    child: Container(
                      color: Color(0xFFFFF9EB),
                      child: ListView(
                        padding: EdgeInsets.all(10),
                        children: [
                          // Sidebar uwu
                          SizedBox(height: 20,),
                          Container(height: 90, width: 50,child: Image.asset('images/bottle.png', fit: BoxFit.cover)),
                          SizedBox(height: 30),
                          ListTile(leading: Icon(Icons.person),
                          title: Text("My Profile"),
                          ),
                          ListTile(leading: Icon(Icons.search),
                          title: Text("Find Friends"),
                          ),
                          ListTile(leading: Icon(Icons.history),
                          title: Text("Bottle History"),
                          ),
                          ListTile(leading: Icon(Icons.help),
                          title: Text("How to use"),
                          )
                      ],)
                    ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateCapsuleScreen()),
                        );
                      },
                    ),
                    backgroundColor: Color(0xFFFFF9EB),
                    appBar: AppBar(
                      iconTheme: IconThemeData(color: Colors.black),
                      foregroundColor: Color(0xFFFFF9EB),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.message,
                              color: Colors.black,
                            ),
                            onPressed: null)
                      ],
                      title: Container(height: 50,child: Image.asset('images/logo.png', fit: BoxFit.cover)),
                      centerTitle: true,
                      backgroundColor: Color(0xFFFFF9EB),
                      elevation: 0,
                    ),
                    body: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, -2),
                              blurRadius: 4.0,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Theme(
                          data: ThemeData(
                            canvasColor: Colors.transparent,
                          ),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                positionStore.positionStream.value.latitude,
                                positionStore.positionStream.value.longitude,
                              ),
                              zoom: 14.0,
                            ),
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            myLocationButtonEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              // _controller.complete(controller);
                            },
                            markers: MapHelper.getMarkers(
                                context,
                                mainStore.friendCapsulesStore.friendCapsules ??
                                    [],
                                snapshot.data),
                          ),
                        ),
                      ),
                    ))
                : Center(
                    child: CircularProgressIndicator(),
                  );
          });
        }
      },
    );
  }
}
