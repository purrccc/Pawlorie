import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/CalTrackerPage.dart';

class CalSuggestionPage extends StatelessWidget {
  final String dogId;
  final String dogName;
  final double requiredCalories;

  CalSuggestionPage({this.dogId='', this.dogName="", required this.requiredCalories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColor.darkBlue,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You've successfully added",
                    style: GoogleFonts.ubuntu(
                        fontSize: 23,
                        color: Colors.white),
                  ),
                  Text(
                    dogName,
                    style: GoogleFonts.rubik(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Based on the size and weight, the daily minimum calorie goal of your dog is:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                        fontSize: 18,     
                        color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Text(
                     requiredCalories.toString(),
                    style: GoogleFonts.rubik(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: AppColor.yellowGold),
                  ),
                  Text(
                    "Calories",
                    style: GoogleFonts.ubuntu(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalTrackerPage(petId: dogId, petName: dogName),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.yellowGold,
                        padding: const EdgeInsets.all(20)),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 22, 21, 86),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
