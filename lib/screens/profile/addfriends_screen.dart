import 'package:capsule_map/screens/profile/profile_screen.dart';
import 'package:capsule_map/screens/root_screen.dart';
import 'package:capsule_map/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AddFriendsScreen extends StatefulWidget {
  @override
  _AddFriendsScreenState createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  TextEditingController _usernameInputController;

  @override
  void initState() {
    _usernameInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xFFFFF9EB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF030D56),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Add Friends',
            style: TextStyle(
              color: Color(0xFF030D56),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(children: [
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                height: height * 0.07,
                width: width * 1,
                child: Center(
                  child: TextFormField(
                    controller: _usernameInputController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(
                          bottom: height * 0.035, left: width * 0.04),
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        fontSize: 18.0,
                        //fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await DatabaseService.sendFriendRequest(
                      _usernameInputController.text.trim(), context);
                  await showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Request sent!'),
                      content: Container(
                        height: 300,
                        child: Column(
                          children: [
                            Lottie.asset("images/done.json")
                          ]
                      ),),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => RootScreen()));
                          },
                          child: new Text('BACK', style: GoogleFonts.poppins(color: Colors.black),),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Send Friend Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text("Nearby users",
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      // Nearby people cards
                      Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFF9E4A4),
                              Colors.yellow[300]
                            ]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                "images/avatar.jpg",
                              ),
                              radius: 40,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "@adithya",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "0.2 km away",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                      // Nearby people cards
                      SizedBox(width: 20),
                      Container(
                        height: 170,
                        width: 170,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFF9E4A4),
                              Colors.yellow[300]
                            ]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                "images/avatar.jpg",
                              ),
                              radius: 40,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "@sam",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "1.4 km away",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: height * 0.13,
              ),
            ]),
          ),
        )));
  }
}
