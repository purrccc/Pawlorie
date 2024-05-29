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

  @override
  void initState() {
    super.initState();
    fetchRemainingCalories();
  }

  Future<void> fetchRemainingCalories() async {
    final docRef =
        FirebaseFirestore.instance.collection('dogs').doc(widget.petId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          totalIntake = (data['totalIntake'] ?? 0).toDouble();
          remainingCalories = (data['remainingCalories'] ?? 0).toDouble();
        });
      }
    } else {
      print('Document does not exist');
    }
  }

  void _handleFoodIntakeSubmission(
      int calories, String foodName, TimeOfDay time) async {
    setState(() {
      totalIntake += calories;
      remainingCalories =
          (widget.petInfo?['requiredCalories'] ?? 0).toDouble() - totalIntake;
    });

    FirebaseFirestore.instance.collection('dogs').doc(widget.petId).update({
      'totalIntake': totalIntake,
      'remainingCalories': remainingCalories,
    });

    // Save food intake details
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
    final double requiredCalories =
        (widget.petInfo?['requiredCalories'] ?? 0).toDouble();

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
            Padding(
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
                                fontSize: 35,
                                color: AppColor.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              remainingCalories.toString(),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.rubik(
                                fontSize: 35,
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
            FoodIntakeForm(
              petId: widget.petId,
              onSubmit: _handleFoodIntakeSubmission,
            ),
          ],
        ),
      ),
    );
  }
}
