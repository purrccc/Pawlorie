import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Box at the top with "Hello User!"
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
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
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Text(
                      'User!',
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 222, 152, 32),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Today is [Insert Date]',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          Container(
            
            child: Text("Your Dogs"),
          ),

          // Box at the bottom with an "Add" button
          Container(
            height: 120, // Adjust the height to ensure it fits the button
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none, // Ensure children can overflow
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 31, 104, 239),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  top: -20, // Adjust this value to control the overlap
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 202, 27),
                      padding: EdgeInsets.all(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Color.fromARGB(255, 22, 21, 86)),
                        SizedBox(width: 8),
                        Text(
                          'Add Dog',
                          style: TextStyle(
                            color: Color.fromARGB(255, 22, 21, 86),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,)
                        )
                      ]
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
