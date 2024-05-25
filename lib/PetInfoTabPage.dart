import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';


class PetInfoTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.summarize,
            size: 100,
            color: Colors.black,
          ),
          SizedBox(height: 16),
          Text(
            'Info Tab Content',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
