import 'package:flutter/material.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

Widget trackerDogCard(BuildContext context, String petName, String imageUrl) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.yellowGold,
      ),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(16),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              petName,
              style: GoogleFonts.rubik(
                color: AppColor.darkBlue,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
