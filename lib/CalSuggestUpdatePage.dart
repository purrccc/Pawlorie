import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

// Stateless widget for the Calorie Suggestion Update Page
class CalSuggestUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background container with a dark blue color
          Container(
            color: AppColor.darkBlue,
          ),
          
          // Centered content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer for layout adjustment
                  const SizedBox(height: 10),
                  // Text displaying calorie goal message
                  Text(
                    "Based on the size and weight, the daily minimum calorie goal of your dog is:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  
                  // Spacer for layout adjustment
                  const SizedBox(height: 30),
                  
                  // Text displaying the calorie value
                  Text(
                    "1234",
                    style: GoogleFonts.rubik(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: AppColor.yellowGold,
                    ),
                  ),
                  // Text displaying the word "Calories"
                  Text(
                    "Calories",
                    style: GoogleFonts.ubuntu(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  // Spacer for layout adjustment
                  const SizedBox(height: 30),
                  
                  // Continue button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellowGold,
                      padding: const EdgeInsets.all(20),
                    ),
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
