// Tracker Tab COontent

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/components/FoodIntakeForm.dart';

class TrackerTabContent extends StatefulWidget {
  final Map<String, dynamic>? petInfo;
  final String petId;

  TrackerTabContent({this.petInfo, required this.petId});

  @override
  _TrackerTabContentState createState() => _TrackerTabContentState();
}

class _TrackerTabContentState extends State<TrackerTabContent> {
  double remainingCalories = 0;
  double totalIntake = 0;
  String? lastUpdateDate;

  @override
  void initState() {
    super.initState();
    fetchRemainingCalories();
  }

  // Function to get remaining calories
  Future<void> fetchRemainingCalories() async {

    // Get reference to the document for the dog
    final docRef = FirebaseFirestore.instance.collection('dogs').doc(widget.petId);
    final docSnapshot = await docRef.get();

    // Check if data exists
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          totalIntake = (data['totalIntake'] ?? 0).toDouble();
          remainingCalories = (data['remainingCalories'] ?? 0).toDouble();
          lastUpdateDate = data['lastUpdateDate'];
        });
        // Check if it is necessary to reset intake
        checkAndResetIntake();
      }
    } else {
      print('Document does not exist');
    }
  }

  // Function to check the date
  void checkAndResetIntake() {

    // Get date today
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Check if the last date that is updated is different from today
    if (lastUpdateDate != today) {
      // If new day, reset total intake and remaining calories
      setState(() {
        totalIntake = 0;
        remainingCalories = (widget.petInfo?['requiredCalories'] ?? 0).toDouble();
        lastUpdateDate = today;
      });
      // Update firestore with reset values and updated date
      FirebaseFirestore.instance.collection('dogs').doc(widget.petId).update({
        'totalIntake': 0,
        'remainingCalories': (widget.petInfo?['requiredCalories'] ?? 0).toDouble(),
        'lastUpdateDate': today,
      });
    }
  }

  // Function for Food Intake Submission
  void handleFoodIntakeSubmission(double calories, String foodName, TimeOfDay time) async {
   
    // Get today's date
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Update state with new intake
    setState(() {
      totalIntake += calories;
      remainingCalories = (widget.petInfo?['requiredCalories'] ?? 0).toDouble() - totalIntake;
      lastUpdateDate = today;
    });

    // Get required calories for the pet
    final double requiredCalories = (widget.petInfo?['requiredCalories'] ?? 0).toDouble();

    // Check if total intake exceeds or meets the required calories
    if (totalIntake >= requiredCalories) {
      // If
      setState(() {
        remainingCalories = 0;
      });

      // Show alert indicating limit has been reached
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  "Calorie Limit Reached",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: Text(
              "The maximum calorie intake for the day has been reached.",
              style: GoogleFonts.rubik(
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                SizedBox(width: 10),
                Text(
                  "Food added!",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content: Text(
              "Successfully added $foodName!",
              style: GoogleFonts.rubik(
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // Update firestore with new intake and remaining calories
    FirebaseFirestore.instance.collection('dogs').doc(widget.petId).update({
      'totalIntake': totalIntake,
      'remainingCalories': remainingCalories == 0 ? 0 : remainingCalories,
      'lastUpdateDate': today,
    });

    // Save details to the firebase
    await FirebaseFirestore.instance.collection('food_intake').add({
      'petID': widget.petId,
      'name': foodName,
      'calories': calories,
      'date': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      'time': time.format(context),
    });
  }

  @override
  Widget build(BuildContext context) {
    final double requiredCalories = (widget.petInfo?['requiredCalories'] ?? 0).toDouble();

    // Initial state
    if (totalIntake == 0) {
      remainingCalories = requiredCalories;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Today",
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.darkBlue,
              ),
            ),
            Padding(  // Container to display the calories
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Intake",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blue,
                              ),
                            ),
                            Text(
                              "Remaining",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColor.darkBlue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              totalIntake.toString(),
                              textAlign: TextAlign.left,
                              style: GoogleFonts.rubik(
                                fontSize: 30,
                                color: AppColor.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              remainingCalories == double.infinity ? "Max Reached" : remainingCalories.toString(),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.rubik(
                                fontSize: 30,
                                color: AppColor.darkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Goal",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                color: AppColor.darkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              requiredCalories.toString(),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                color: AppColor.darkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            FoodIntakeForm(         // Display
              petId: widget.petId,
              onSubmit: handleFoodIntakeSubmission,
            ),
          ],
        ),
      ),
    );
  }
}
