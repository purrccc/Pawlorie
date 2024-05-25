import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';


class PetInfoTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
  primary: false,
  padding: const EdgeInsets.all(30),
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  crossAxisCount: 2,
  children: <Widget>[
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.darkBlue,
      ),
      padding: const EdgeInsets.all(8),
     
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("12",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold
            
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("Age",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 25,
            
            )),
          ),]
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.blue,
      ),
      padding: const EdgeInsets.all(8),
     
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("Male",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold
            
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("Sex",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 25,
            
            )),
          ),]
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 92, 184, 255),
      ),
      padding: const EdgeInsets.all(8),
     
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("40 kg",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold
            
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("Size or Weight",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 20,
            
            )),
          ),]
      ),
    ),
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.yellowGold,
      ),
      padding: const EdgeInsets.all(8),
     
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("Shih Tzu",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold
            
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Text("Breed",
            style:GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 25,
            
            )),
          ),]
      ),
    ),
  ],
)
    );
  }
}
