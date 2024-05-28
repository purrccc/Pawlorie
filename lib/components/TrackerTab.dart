import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackerTabContent extends StatefulWidget {
  final Map<String, dynamic>? petInfo;
  final String petId;

  TrackerTabContent({this.petInfo, required this.petId});

  @override
  _TrackerTabContentState createState() => _TrackerTabContentState();
}

class _TrackerTabContentState extends State<TrackerTabContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  int remainingCalories = 0;

  @override
  void dispose() {
    _caloriesController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchRemainingCalories();
  }

  Future<void> fetchRemainingCalories() async {
    final docRef = FirebaseFirestore.instance.collection('dogs').doc(widget.petId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      setState(() {
        remainingCalories = docSnapshot.data()?['remainingCalories'] ?? 0;
      });
    } else {
      print('Document does not exist');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int requiredCalories = widget.petInfo?['requiredCalories'] ?? 0;

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
                              "0", 
                              textAlign: TextAlign.left,
                              style: GoogleFonts.rubik(
                                fontSize: 35,
                                color: AppColor.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              requiredCalories.toString(),
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Add Food Intake",
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(color: AppColor.darkBlue),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _caloriesController,
                              decoration: InputDecoration(
                                hintText: 'Amount of Calories',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter amount of calories';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Time',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onTap: () => _selectTime(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Handle the form submission here
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.yellowGold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Add',
                              style: GoogleFonts.ubuntu(
                                color: AppColor.darkBlue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
