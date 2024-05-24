import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlorie/constants/colors.dart'; 

class CalSuggestionPage extends StatelessWidget {
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
                  const Text(
                    "You've successfully added",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const Text(
                    "Pet Name",
                    style: TextStyle(
                      color: AppColor.lightBlue,
                      fontSize: 50,
                    ),
                  ),
                  const Text(
                    "Based on the size and weight, the daily minimum calorie goal of your dog is:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "1234",
                    style: TextStyle(
                      color: AppColor.yellowGold,
                      fontSize: 60,
                    ),
                  ),
                  const Text(
                    "Calories",
                    style: TextStyle(
                      color: AppColor.lightBlue,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                    
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellowGold,
                      padding: const EdgeInsets.all(20)
                    ),
                    child: const Text('Continue',
                     style: TextStyle(
                      color: Color.fromARGB(255, 22, 21, 86),
                      fontSize: 18,
                      fontWeight: FontWeight.w800, 
                    ),),
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