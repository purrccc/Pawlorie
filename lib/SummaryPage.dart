import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// A stateless widget that displays the summary of food intake for a specific date and pet
class SummaryPage extends StatelessWidget {
  final String date; // Date for which the summary is displayed
  final String petId; // ID of the pet

  SummaryPage({required this.date, required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main container for the page content
      body: Stack(
        children: [
          Column(
            children: [
              // Header section
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 21, 86),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Back button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20.0, top: 30.0),
                          child: IconButton(
                            icon:
                                Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),

                    // Display the formatted date with the day of the week
                    Text(
                      _formatDateWithDay(date),
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Summary title
                    Text(
                      'Summary',
                      style: GoogleFonts.rubik(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColor.yellowGold,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content area
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      200, // Constrained height
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // StreamBuilder to fetch food intake data from Firestore
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('food_intake')
                              .where('date', isEqualTo: date)
                              .where('petID', isEqualTo: petId)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            // Get and sort the food intake documents by time
                            List<DocumentSnapshot> foodIntakeDocs =
                                snapshot.data!.docs;
                            foodIntakeDocs
                                .sort((a, b) => a['time'].compareTo(b['time']));

                            // Build the list of food intake summaries
                            return ListView.builder(
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevents nested scrolling
                              shrinkWrap:
                                  true, // Ensures the ListView takes up only necessary space
                              itemCount: foodIntakeDocs.length,
                              itemBuilder: (context, index) {
                                var foodIntake = foodIntakeDocs[index].data()
                                    as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: summaryFoodContainer(
                                    foodIntake['name']
                                        .toString()
                                        .toUpperCase(), // Convert to uppercase
                                    '${foodIntake['calories']} calories',
                                    foodIntake['time'],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to format the date to the desired format with the day of the week
  String _formatDateWithDay(String date) {
    DateTime parsedDate = DateFormat('MMMM d, yyyy').parse(date);
    String formattedDate = DateFormat('EEEE, MMMM d').format(parsedDate);
    return formattedDate;
  }
}

// Function to display food intake summary
Widget summaryFoodContainer(String food, String calorie, String time) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 227, 225, 225),
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
    child: Row(
      children: [
        // Time container
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

        // Food and calorie details
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food,
                style: GoogleFonts.rubik(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darkBlue,
                ),
              ),
              Text(
                calorie,
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
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
