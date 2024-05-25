import 'dart:async';
import 'dart:core'; 
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/AddDogPage.dart';
import 'package:pawlorie/CalTrackerPage.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/components/DogCard.dart';
import 'package:intl/intl.dart'; 

class HomePage extends StatefulWidget {
  final String username;

  HomePage({this.username = ''});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _currentDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {
        _currentDate = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('MMMM');
    String formattedMonth = formatter.format(_currentDate);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 21, 86),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hello, ',
                          style: GoogleFonts.ubuntu(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.username}!',
                          style: GoogleFonts.rubik(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColor.yellowGold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Today is $formattedMonth ${_currentDate.day}, ${_currentDate.year}",
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 180,
            left: 16,
            child: Text(
              'Your dogs',
              style: GoogleFonts.rubik(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColor.darkBlue,
              ),
            ),
          ),
          Positioned(
            top: 230,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: DogCard(context, 'Una', 'Shih Tzu', CalTrackerPage()),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 31, 104, 239),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDogPage()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 202, 27),
                  padding: const EdgeInsets.all(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 22, 21, 86),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Dog',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 22, 21, 86),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
