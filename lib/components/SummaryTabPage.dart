import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/SummaryPage.dart';

class SummaryTabContent extends StatefulWidget {
  final String petId;

  SummaryTabContent({required this.petId});

  @override
  _SummaryTabContentState createState() => _SummaryTabContentState();
}

class _SummaryTabContentState extends State<SummaryTabContent> {
  Future<Map<String, double>> _fetchData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('food_intake')
        .where('petID', isEqualTo: widget.petId)
        .get();

    final Map<String, double> intakeData = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final date = data['date'];
      final calories = (data['calories'] as num).toDouble();

      if (intakeData.containsKey(date)) {
        intakeData[date] = intakeData[date]! + calories;
      } else {
        intakeData[date] = calories;
      }
    }

    return intakeData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Map<String, double>>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data available');
                } else {
                  final Map<String, double> data = snapshot.data!;
                  final List<Widget> summaryCards = data.entries.map((entry) {
                    final date = entry.key;
                    final intake = entry.value.toString();
                    return summaryCard(
                      context,
                      date,
                      intake,
                      SummaryPage(
                        date: date,
                        petId: widget.petId,
                      ),
                    );
                  }).toList();
            
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: summaryCards,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
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
