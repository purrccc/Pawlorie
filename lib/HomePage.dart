import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlorie/AddDogPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(
                             'Hello, ',
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                            Text('User!',
                              style: TextStyle(
                                fontSize: 34,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w800,
                                color: Color.fromARGB(255, 222, 152, 32),
                              ),
                            ),
                         ],
                       ),
              
                      SizedBox(height: 8),
                      Text(
                        "Insert Date",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              
            ],
          ),
          const Positioned(
            top: 180, 
            left: 16,
            child: Text(
              'Your dogs',
              style: TextStyle(
                color: Color.fromARGB(255, 22, 21, 86),
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
                child: buildDogContainer( 
                "name","breed"),
              
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
        onPressed: () => Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (context) => AddDogPage())
                              ), // anonymous route
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 202, 27),
        padding: const EdgeInsets.all(20),
      ),
      child: const Text(
        'Add Dog', 
        style: TextStyle(
          color: Color.fromARGB(255, 22, 21, 86),
          fontSize: 18,
          fontWeight: FontWeight.w800, 
        ),
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}


// Function to display dogs
Widget buildDogContainer( String name, String breed) {
  return Container(
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
    child: Row(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,),
          
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column( 
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 31, 104, 239),
                ),
              ),
              Text(
                breed,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 22, 21, 86),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}