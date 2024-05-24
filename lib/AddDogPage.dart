import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlorie/constants/colors.dart'; 

class AddDogPage extends StatefulWidget {
  @override
  _AddDogPageState createState() => _AddDogPageState();
}

class _AddDogPageState extends State<AddDogPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _sizeOrWeightController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {

      String name = _nameController.text.trim();
      String age = _ageController.text.trim();
      String breed = _breedController.text.trim();
      String sex = _sexController.text.trim();
      String sizeOrWeight = _sizeOrWeightController.text.trim();
     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dog Details: \nName: $name\nAge: $age\nBreed: $breed\nSex: $sex\nSize or Weight: $sizeOrWeight',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.darkBlue),
          onPressed: (){
            Navigator.pop(context);
          },
        ),

        title: const Text('Add Dog', 
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColor.darkBlue
              ),),
        backgroundColor: AppColor.yellowGold,
      ),
      body: Stack(
        children: [
          Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50)
            ),
            color: AppColor.blue
            ),
            height: double.infinity,
            width: double.infinity,
            
            ),
            ),
            addDogForm()
        ]
          ),
        );
  }



Widget addDogForm(){
  return  Container(
    margin: const EdgeInsets.only(top: 10),
    child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : null,
                  child: _imageFile == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.grey[800],
                          size: 40,
                        )
                      : null,
                ),
              ),

                  SizedBox(height: 20,),

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.pets),
                      prefixIconColor: AppColor.darkBlue,
                      hintText: 'Name',
                      hintStyle: const TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25)
                      )
                      ),
                      style: TextStyle(color: AppColor.darkBlue),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.pets),
                      prefixIconColor: AppColor.darkBlue,
                      hintText: 'Breed',
                      hintStyle: const TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25)
                      )
                      ),
                      style: TextStyle(color: AppColor.darkBlue),
                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the age';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    controller: _breedController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.numbers),
                      prefixIconColor: AppColor.darkBlue,
                      hintText: 'Age',
                      hintStyle: const TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25)
                      )
                      ),
                      style: TextStyle(color: AppColor.darkBlue),
                      keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the breed';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _sexController,
                      decoration: InputDecoration(
                      prefixIcon: Icon(Icons.female),
                      prefixIconColor: AppColor.darkBlue,
                      hintText: 'Sex',
                      hintStyle: const TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25)
                      )
                      ),
                      style: TextStyle(color: AppColor.darkBlue),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the sex';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20,),

                  TextFormField(
                    controller: _sizeOrWeightController,
                      decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monitor_weight),
                      prefixIconColor: AppColor.darkBlue,
                      hintText: 'Size or Weight',
                      hintStyle: const TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25)
                      )
                      ),
                      style: TextStyle(color: AppColor.darkBlue),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the size or weight';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
              onPressed: _submitForm,
              
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.yellowGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Add Dog',
                        style: TextStyle(
                          color: AppColor.darkBlue,
                          fontSize: 15
                        )
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