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
            width: 150,
            height: 150,
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
            child: imageUrl.isEmpty
                ? Icon(
                    Icons.add_a_photo,
                    color: Colors.grey[800],
                    size: 40,
                  )
                : null,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              petName,
              style: GoogleFonts.rubik(
                color: AppColor.darkBlue,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
