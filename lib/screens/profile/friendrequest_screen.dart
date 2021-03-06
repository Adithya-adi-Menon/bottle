import 'package:capsule_map/screens/profile/friend_request_widget.dart';
import 'package:capsule_map/stores/mainStore/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FriendRequestScreen extends StatefulWidget {
  @override
  _FriendRequestScreenState createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    MainStore mainStore = Provider.of<MainStore>(context);
    print(mainStore.friendRequestsStore.friendRequests);

    return Observer(
      builder: (_) => Scaffold(
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
              'Friend Requests',
              style: TextStyle(
                color: Color(0xFF030D56),
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: ListView.builder(
                  itemCount:
                      mainStore.friendRequestsStore.friendRequests != null
                          ? mainStore.friendRequestsStore.friendRequests.length
                          : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        FriendRequestWidget(
                          friendRequest: mainStore
                              .friendRequestsStore.friendRequests[index],
                        ),
                        SizedBox(height: 15),
                        Divider(
                          height: 20,
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ],
                    );
                  }),
            ),
          )),
    );
  }
}
