import 'package:capsule_map/screens/capsules/opened_capsules_list.dart';
import 'package:capsule_map/screens/capsules/sent_capsules_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CapsulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'My Bottles',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Color(0xFF030D56),
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFFF9E4A4),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('Picked Bottles',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF030D56),
                      )),
                ),
                Tab(
                  child: Text('Dropped Bottles',
                      style: GoogleFonts.poppins(color: Color(0xFF030D56), fontWeight: FontWeight.bold)),
                ),
              ],
              indicatorColor: Color(0xFF030D56),
            ),
            elevation: 1.0,
          ),
          backgroundColor: Color(0xFFFFF9EB),
          body: TabBarView(
            children: [
              OpenedCapsulesList(),
              SentCapsulesList(),
            ],
          )),
    );
  }
}
