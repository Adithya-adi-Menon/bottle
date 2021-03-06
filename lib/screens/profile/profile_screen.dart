import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:capsule_map/models/Capsule.dart';
import 'package:capsule_map/screens/profile/addfriends_screen.dart';
import 'package:capsule_map/screens/profile/friendrequest_screen.dart';
import 'package:capsule_map/screens/profile/myfriends_screen.dart';
import 'package:capsule_map/services/auth_service.dart';
import 'package:capsule_map/services/database_service.dart';
import 'package:capsule_map/services/firebase_storage_service.dart';
import 'package:capsule_map/stores/mainStore/main_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    MainStore mainStore = Provider.of<MainStore>(context);

    // for (int i = 0; i < 2; i++) {
    //   Capsule newCapsule = Capsule(
    //     title: 'Check out these leaves!',
    //     description:
    //         'Was on a trek today, noticed that the trees over here all have suuuper pretty leaves. You can see them in the photo I posted; hope they\'re still around when you get here!',
    //     location: GeoPoint(
    //         29.75761342329656 + Random().nextDouble() * 0.02 - 0.01,
    //         -95.79107802832739 + Random().nextDouble() * 0.02 - 0.01),
    //     videoUrls: [],
    //     imageUrls: [
    //       'https://firebasestorage.googleapis.com/v0/b/capsulemap-42589.appspot.com/o/capsuleImages%2FcPSrxBOMxpY5ABjPV3Woy1fzV6v1%2Fmagnolia-trees-556718_1280.jpg?alt=media&token=9e39ce42-2f51-47a1-bbe3-695a8a4886e1',
    //       'https://firebasestorage.googleapis.com/v0/b/capsulemap-42589.appspot.com/o/capsuleImages%2FcPSrxBOMxpY5ABjPV3Woy1fzV6v1%2Ftree-99852_1280(1).jpg?alt=media&token=168b9565-9c9f-49e7-83c4-20bacab9a3f6'
    //     ],
    //   );
    //   DatabaseService.createCapsule(newCapsule, context);
    // }

    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: Color(0xFFFFF9EB), //Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 + 10,
                    ),
                    Container(
                      child: Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                    IconButton(
                        icon: Icon(
                          Icons.qr_code,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title:  Row( mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Share your QR', style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),
                                ],
                              ),
                              content: Container(
                                height: 200,
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    PrettyQr(
                                      image: AssetImage("images/logo.png"),
                                      size: 150,
                                      data:mainStore.userStore.user.username,
                                    roundEdges: true,

                                    )
                                  ]
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(); // dismisses only the dialog and returns nothing
                                  },
                                  child: new Text('SCAN QR', style: GoogleFonts.poppins(color: Colors.black),),
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                ),
                Divider(
                  height: 5.0,
                  thickness: 2.0,
                  color: Colors.black,
                  indent: 120.0,
                  endIndent: 120.0,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                GestureDetector(
                  onTap: () async {
                    ImageSource imageSource = await showDialog<ImageSource>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: height * 0.4,
                            width: width * 0.8,
                            child: SimpleDialog(
                              title: Text('Choose an Image'),
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera_alt_outlined),
                                  title: Text('Camera'),
                                  onTap: () {
                                    Navigator.pop(context, ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.photo),
                                  title: Text('Gallery'),
                                  onTap: () {
                                    Navigator.pop(context, ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                    if (imageSource != null) {
                      PickedFile image =
                          await ImagePicker().getImage(source: imageSource);
                      if (image != null) {
                        String url =
                            await FirebaseStorageService.uploadProfileUrl(
                                File(image.path));
                        DatabaseService.updateProfileUrl(url, context);
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color(0xFFF9E4A4).withOpacity(1),
                          spreadRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 90.0,
                      backgroundImage:
                          mainStore.userStore.user.profileUrl != null &&
                                  mainStore.userStore.user.profileUrl.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  mainStore.userStore.user.profileUrl)
                              : AssetImage('images/avatar.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                  child: Center(
                    child: Text(
                      mainStore.userStore.user.username,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              mainStore.userStore.user.capsules.length
                                  .toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: Color(0xFF030D56),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Text(
                              'Bottles dropped',
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              mainStore
                                  .userStore.user.friendCapsulesOpened.length
                                  .toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: Color(0xFF030D56),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Text(
                              'Bottles picked',
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyFriendsScreen()),
                    );
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'View Friends',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 40.0,
                            child: Icon(
                              Icons.chevron_right,
                              size: 35.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 30.0,
                  thickness: 1.0,
                  color: Color(0xFF030D56),
                  indent: 20,
                  endIndent: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddFriendsScreen()),
                    );
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add A Friend',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 40.0,
                            child: Icon(
                              Icons.chevron_right,
                              size: 35.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 30.0,
                  thickness: 1.0,
                  color: Color(0xFF030D56),
                  indent: 20,
                  endIndent: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FriendRequestScreen()),
                    );
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Friend Requests',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 40.0,
                            child: Icon(
                              Icons.chevron_right,
                              size: 35.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 30.0,
                  thickness: 1.0,
                  color: Color(0xFF030D56),
                  indent: 20,
                  endIndent: 20,
                ),
                GestureDetector(
                  onTap: () {
                    AuthService.signOut();
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Log Out',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 40.0,
                            child: Icon(
                              Icons.chevron_right,
                              size: 35.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
