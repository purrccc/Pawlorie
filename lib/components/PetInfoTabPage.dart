import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PetInfoTabContent extends StatelessWidget {
  final Map<String, dynamic>? petInfo;

  PetInfoTabContent({this.petInfo});

  @override
  Widget build(BuildContext context) {
    return petInfo == null
      ? Center(child: CircularProgressIndicator())
      : GridView.count(
          primary: false,
          padding: const EdgeInsets.all(30),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 2,
          children: <Widget>[
            buildInfoCard('Age', petInfo!['age'].toString(), AppColor.darkBlue),
            buildInfoCard('Sex', petInfo!['sex'], AppColor.blue),
            buildInfoCard('Size or Weight', petInfo!['sizeOrWeight'].toString(), Color.fromARGB(255, 92, 184, 255)),
            buildInfoCard('Breed', petInfo!['breed'], AppColor.yellowGold),
          ],
        );
  }

  Widget buildInfoCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              title,
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
