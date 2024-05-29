import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/CalTrackerPage.dart';

// A stateless widget that shows calorie suggestions for a specific dog
class CalSuggestionPage extends StatelessWidget {
  final String dogId; // ID of the dog
  final String dogName; // Name of the dog
  final double requiredCalories; // Required calorie intake for the dog
  final String imageUrl; // URL of the dog's image

  CalSuggestionPage({
    required this.dogId,
    required this.dogName,
    required this.requiredCalories,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main container for the page
      body: Stack(
        children: [
          // Background color container
          Container(
            color: AppColor.darkBlue,
          ),
          // Main content centered in the screen
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Informational text
                  Text(
                    "You've successfully added",
                    style: GoogleFonts.ubuntu(
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),

                  // Dog's name in a larger, bold font
                  Text(
                    dogName,
                    style: GoogleFonts.rubik(
                      fontSize: 45,
                      fontWeight: FontWeight.w600,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Explanation of the calorie goal
                  Text(
                    "Based on the size and weight, the required calorie goal of your dog is:",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Display of the required calorie amount
                  Text(
                    requiredCalories.toString(),
                    style: GoogleFonts.rubik(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: AppColor.yellowGold,
                    ),
                  ),

                  // Label "Calories" below the calorie amount
                  Text(
                    "Calories",
                    style: GoogleFonts.ubuntu(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Continue button to navigate to the calorie tracker page
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalTrackerPage(
                          petId: dogId,
                          petName: dogName,
                          username: '', // Pass the username if needed
                          imageURL: imageUrl,
                        ),
                      ),
                    ),
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
