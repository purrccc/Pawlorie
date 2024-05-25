import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/HomePage.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pawlorie/components/SummaryTabPage.dart';
import 'package:pawlorie/components/PetInfoTabPage.dart';
import 'package:pawlorie/components/TrackerTab.dart';
import 'package:pawlorie/components/CustomTabIndicator.dart';




class CalTrackerPage extends StatefulWidget {
  @override
  _CalTrackerState createState() => _CalTrackerState();
}

class _CalTrackerState extends State<CalTrackerPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()))
        ),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.yellowGold,
              ),
              width: double.infinity,
              child:  Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/pet_image.jpg'), // Replace with your pet image asset
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Pet Name',
                      style: GoogleFonts.rubik(
                        color: AppColor.darkBlue,
                        fontSize: 35,
                        fontWeight: FontWeight.bold
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.darkBlue, 
                  borderRadius: BorderRadius.circular(10)
              ),
             // Set the background color of the TabBar
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tracker',),
                  Tab(text: 'Summary'),
                  Tab(text: 'Info'),
                ],
                labelColor: Colors.white,
                labelStyle: GoogleFonts.ubuntu(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ), // Color of the selected tab text
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
                TrackerTabContent(),
                 SummaryTabContent(),
                PetInfoTabContent()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
