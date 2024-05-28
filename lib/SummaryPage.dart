import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/constants/colors.dart';

class SummaryPage extends StatelessWidget {
  final String date;
  SummaryPage({required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.darkBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Sunday, May 19',
          style: GoogleFonts.rubik(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          // textAlign: TextAlign.center,
        ),

        toolbarHeight: 44, // Adjust the height as needed
        titleSpacing: 75, // Adjust the spacing as needed
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 21, 86),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Summary",
                      style: GoogleFonts.ubuntu(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColor.yellowGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 100,
            left: 10,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: summaryFoodContainer(
                    "TopBreed Dog Food", "300 calories", "9:00 AM"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to display dogs
Widget summaryFoodContainer(String food, String calorie, String time) {
  return Container(
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
    // for time container
    child: Row(
      children: [
        Container(
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColor.yellowGold,
          ),
          child: Center(
            child: Text(
              time,
              style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.darkBlue,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food,
                style: GoogleFonts.rubik(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darkBlue,
                ),
              ),
              Text(
                calorie,
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.darkBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
