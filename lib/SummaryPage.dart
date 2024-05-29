import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SummaryPage extends StatelessWidget {
  final String date;
  final String petId;

  SummaryPage({required this.date, required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: AppBar(
            backgroundColor: AppColor.darkBlue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDateWithDay(date),
                    style: GoogleFonts.rubik(
                      fontSize: 18, // Slightly smaller font size for the date
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Summary',
                    style: GoogleFonts.rubik(
                      fontSize: 34, // Increased font size for "Summary"
                      fontWeight: FontWeight.bold,
                      color: AppColor.yellowGold,
                    ),
                  ),
                ],
              ),
            ),
            toolbarHeight: 140, // Increased app bar height
            titleSpacing: 2,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('food_intake')
            .where('date', isEqualTo: date)
            .where('petID', isEqualTo: petId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> foodIntakeDocs = snapshot.data!.docs;
          foodIntakeDocs
              .sort((a, b) => a['time'].compareTo(b['time'])); // Sort by time

          return ListView.builder(
            itemCount: foodIntakeDocs.length,
            itemBuilder: (context, index) {
              var foodIntake =
                  foodIntakeDocs[index].data() as Map<String, dynamic>;
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
    );
  }

  // Function to format the date to the desired format with the day of the week
  String _formatDateWithDay(String date) {
    DateTime parsedDate = DateFormat('MMMM d, yyyy').parse(date);
    String formattedDate = DateFormat('EEEE, MMMM d').format(parsedDate);
    return formattedDate;
  }
}

// Custom clipper to create soft rounded corners for the AppBar
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20); // Adjust height for subtle rounding
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
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
