import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      // Form is validated, proceed to save
      String name = _nameController.text.trim();
      String age = _ageController.text.trim();
      String breed = _breedController.text.trim();
      String sex = _sexController.text.trim();
      String sizeOrWeight = _sizeOrWeightController.text.trim();
      // Save or upload data and image here

      // For demo, just show a snackbar with the data
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
        title: Text('Add Dog', 
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 22, 21, 86)
              ),),
        backgroundColor: Color.fromARGB(255, 255, 175, 37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: Text('Pick Image'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Dog Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Breed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the breed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sexController,
                decoration: InputDecoration(labelText: 'Sex'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the sex';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizeOrWeightController,
                decoration: InputDecoration(labelText: 'Size or Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the size or weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Dog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
