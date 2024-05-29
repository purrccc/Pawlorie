import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/HomePage.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/components/SummaryTabPage.dart';
import 'package:pawlorie/components/PetInfoTabPage.dart';
import 'package:pawlorie/components/TrackerTab.dart';
import 'package:pawlorie/components/CustomTabIndicator.dart';
import 'package:pawlorie/user_auth/firebase_auth_services.dart';
import 'package:pawlorie/components/TrackerDogCard.dart';

class CalTrackerPage extends StatefulWidget {
  final String petId;
  final String petName;
  final String username;
  final String imageURL;

  CalTrackerPage({
    required this.petId,
    required this.petName,
    required this.username,
    required this.imageURL,
  });

  @override
  _CalTrackerState createState() => _CalTrackerState();
}

class _CalTrackerState extends State<CalTrackerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? petInfo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchPetInfo();
  }

  Future<void> _fetchPetInfo() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('dogs')
        .doc(widget.petId)
        .get();
    setState(() {
      petInfo = doc.data() as Map<String, dynamic>?;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.darkBlue),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          trackerDogCard(context, widget.petName, widget.imageURL),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.darkBlue,
                  borderRadius: BorderRadius.circular(10)),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tracker'),
                  Tab(text: 'Summary'),
                  Tab(text: 'Info'),
                ],
                labelColor: Colors.white,
                labelStyle: GoogleFonts.ubuntu(
                    fontSize: 18, fontWeight: FontWeight.w500),
                unselectedLabelColor: Colors.white,
                indicator: CustomTabIndicator(
                  indicatorWidth: 125,
                  color: AppColor.lightBlue,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TrackerTabContent(petInfo: petInfo, petId: widget.petId),
                SummaryTabContent(petId: widget.petId),
                PetInfoTabContent(petInfo: petInfo, petId: widget.petId)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
