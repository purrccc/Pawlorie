import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';


class SummaryTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              summaryCard("May 19,2024", "1234"),        
          ],
        ),
      ),
    );
  }
}


Widget summaryCard(String date, String calories){
  return Padding(
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
            Container(
              child: Text(date,
                style: GoogleFonts.ubuntu(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColor.darkBlue
                ))
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.darkBlue,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(calories,
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  color: AppColor.yellowGold,
                  fontWeight: FontWeight.w700
        
                )),
              )
            )
          ],
        ),
      )
    
    
    
    
    
    
    
    ),
  );

}