// Food Intake Form

import 'package:flutter/material.dart';
import 'package:pawlorie/constants/colors.dart';    
import 'package:google_fonts/google_fonts.dart';

class FoodIntakeForm extends StatefulWidget {
  final String petId;
  final Function(double, String, TimeOfDay) onSubmit;

  FoodIntakeForm({required this.petId, required this.onSubmit});

  @override
  _FoodIntakeFormState createState() => _FoodIntakeFormState();
}

class _FoodIntakeFormState extends State<FoodIntakeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed
    _nameController.dispose();
    _caloriesController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Function show time picker 
  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,  // Initial time
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;    // Update if user picked a new time
        _timeController.text = picked.format(context);
      });
    }
  }

  // Function to submit form
  void submitForm() {
    if (_formKey.currentState!.validate()) {          // validate form fields
      final calories = double.parse(_caloriesController.text.trim());
      final foodName = _nameController.text.trim();   // get foodname input
      final time = selectedTime;                      // get input for time

      widget.onSubmit(calories, foodName, time);

      // Clear form fields
      _nameController.clear();
      _caloriesController.clear();
      _timeController.clear();
      selectedTime = TimeOfDay.now(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColor.blue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(                      // Add food intake label
                  "Add Food Intake",
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16),             // Food name input field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(color: AppColor.darkBlue),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(              // Calories input field
                      controller: _caloriesController,
                      decoration: InputDecoration(
                        hintText: 'Amount of Calories',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount of calories';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(            // Time Input Field
                      controller: _timeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Time',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onTap: () => selectTime(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a time';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Center(                             // Submit Button
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.yellowGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add',
                      style: GoogleFonts.ubuntu(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
