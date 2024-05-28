import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/SummaryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SummaryTabContent extends StatefulWidget {
  final String petId;

  SummaryTabContent({required this.petId});

  @override
  _SummaryTabContentState createState() => _SummaryTabContentState();
}

class _SummaryTabContentState extends State<SummaryTabContent> {
  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(currentDate);

    // Hardcoded previous date (yesterday)
    DateTime previousDate = currentDate.subtract(Duration(days: 1));
    String formattedPreviousDate = DateFormat.yMMMd().format(previousDate);

    // List of dates to display summary cards for
    List<String> dates = [formattedPreviousDate, formattedDate];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the current date
            // Text(
            //   formattedDate,
            //   style: GoogleFonts.ubuntu(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w700,
            //     color: AppColor.darkBlue,
            //   ),
            // ),
            SizedBox(height: 20),
            // Render summary cards for each date in the list in reverse order
            for (String date in dates.reversed)
              FutureBuilder(
                future: fetchCaloriesFromFirestore(date),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Render summary card with fetched calorie data
                    return summaryCard(
                      context,
                      date,
                      snapshot.data.toString(),
                      SummaryPage(date: date),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<int> fetchCaloriesFromFirestore(String date) async {
    try {
      //This is for identifying the dog
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('dogs')
            .where('userId', isEqualTo: userId)
            // .where('name', isEqualTo: widget.petId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          int totalCalories = querySnapshot.docs.first['totalIntake'];
          return totalCalories;
        } else {
          return 0; // Return 0 if no data found for the date
        }
      } else {
        return 0;
      }
    } catch (error) {
      throw error;
    }
  }
}

Widget summaryCard(BuildContext context, String date, String calories,
    Widget destinationPage) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationPage),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                date,
                style: GoogleFonts.ubuntu(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColor.darkBlue,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.darkBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    calories,
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      color: AppColor.yellowGold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
