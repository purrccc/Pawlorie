import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:pawlorie/CalSuggestionPage.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pawlorie/user_auth/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pawlorie/utils.dart';

enum Sex {
  Male,
  Female,
}

Future<List<Dog>> fetchDogs(String dogBreed) async {
  final response = await http.get(
    Uri.parse('https://api.api-ninjas.com/v1/dogs?name=${dogBreed}'),
    headers: {
      'X-Api-Key': '8Q3MlktFjNQCoIEhVK7DRQ==yizU5MkNU9iKPuwu'
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Dog.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load dogs');
  }
}

Future<List<String>> fetchDogBreeds(String query) async {
  final response = await http.get(
    Uri.parse('https://api.api-ninjas.com/v1/dogs?name=${query}'),
    headers: {
      'X-Api-Key': '8Q3MlktFjNQCoIEhVK7DRQ==yizU5MkNU9iKPuwu'
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map<String>((dynamic item) => item['name'] as String).toList();
  } else {
    throw Exception('Failed to load dog breeds');
  }
}

class Dog {
  final double maxWeightMale;
  final double maxWeightFemale;
  final double minWeightMale;
  final double minWeightFemale;
  final String dogBreed;

  const Dog({
    required this.maxWeightMale,
    required this.maxWeightFemale,
    required this.minWeightMale,
    required this.minWeightFemale,
    required this.dogBreed,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      maxWeightMale: json['max_weight_male']?.toDouble() ?? 0.0,
      maxWeightFemale: json['max_weight_female']?.toDouble() ?? 0.0,
      minWeightMale: json['min_weight_male']?.toDouble() ?? 0.0,
      minWeightFemale: json['min_weight_female']?.toDouble() ?? 0.0,
      dogBreed: json['name'] ?? 'Unknown',
    );
  }
}

class AddDogPage extends StatefulWidget {
  final String? userId;

  AddDogPage({this.userId});

  @override
  _AddDogPageState createState() => _AddDogPageState();
}

class _AddDogPageState extends State<AddDogPage> {
  final _formKey = GlobalKey<FormState>();
  Sex? _selectedSex;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _sizeOrWeightController = TextEditingController();
  File? _imageFile;



  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Dog>>? futureDogs;
  List<String> dogBreedSuggestions = [];
  String selectedDogBreed = "";
  Dog? selectedDogData;

  final ImagePicker _picker = ImagePicker();


  Future<void> _pickImage(ImageSource source) async {
  final pickedFile = await _picker.pickImage(source: source);
  if (pickedFile != null) {
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    String name = _nameController.text.trim();
    int age = int.parse(_ageController.text.trim());
    String breed = _breedController.text.trim();
    double sizeOrWeight = double.parse(_sizeOrWeightController.text.trim());

    double minWeight;
    double maxWeight;
    double requiredCalories = pow(sizeOrWeight, 0.75) * 70;

    String? userId = widget.userId;

    if (selectedDogData != null) {
      if (_selectedSex == Sex.Male) {
        minWeight = selectedDogData!.minWeightMale * 0.45359237;
        maxWeight = selectedDogData!.maxWeightMale * 0.45359237;
      } else {
        minWeight = selectedDogData!.minWeightFemale * 0.45359237;
        maxWeight = selectedDogData!.maxWeightFemale * 0.45359237;
      }

      try {
        String? imageUrl;
        if (_imageFile != null) {
          imageUrl = await _uploadImageToStorage(_imageFile!);
        }

        DocumentReference docRef = await _firestore.collection('dogs').add({
          'name': name,
          'age': age,
          'breed': breed,
          'sex': _selectedSex == Sex.Male ? 'Male' : 'Female',
          'sizeOrWeight': sizeOrWeight,
          'minWeight': minWeight,
          'maxWeight': maxWeight,
          'requiredCalories': requiredCalories.round().toDouble(),
          'userId': userId,
          'imageUrl': imageUrl,
        });

        // Fetching the added dog's data
        DocumentSnapshot doc = await docRef.get();
        String dogId = doc.id;
        String dogName = doc['name'];
        double requiredCal = doc['requiredCalories'];
        String imageURL = doc['imageUrl'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dog added successfully'),
          ),
        );
        _clearForm();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalSuggestionPage(
              dogId: dogId,
              dogName: dogName,
              requiredCalories: requiredCal,
              imageUrl: imageURL,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add dog: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Could not fetch breed data. Please try again.'),
        ),
      );
    }
  }
}


Future<String> _uploadImageToStorage(File imageFile) async {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  try {
    // Create a unique file name
    String fileName = 'dogs/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    firebase_storage.Reference ref = storage.ref().child(fileName);

    // Upload the file to Firebase Storage
    await ref.putFile(imageFile);

    // Get the download URL
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Failed to upload image: $e');
    throw Exception('Failed to upload image');
  }
}


 @override
void dispose() {
  _nameController.dispose();
  _ageController.dispose();
  _breedController.dispose();
  _sizeOrWeightController.dispose();
  super.dispose();
}



  @override
  void initState() {
    super.initState();
    _breedController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_breedController.text.isNotEmpty) {
      fetchDogBreeds(_breedController.text).then((suggestions) {
        setState(() {
          dogBreedSuggestions = suggestions;
        });
      }).catchError((error) {
        print("Error fetching dog breeds: $error");
        setState(() {
          dogBreedSuggestions = [];
        });
      });
    } else {
      setState(() {
        dogBreedSuggestions = [];
      });
    }
  }

  void fetchDogData() {
    fetchDogs(selectedDogBreed).then((dogs) {
      setState(() {
        if (dogs.isNotEmpty) {
          selectedDogData = dogs.first;
        }
      });
    }).catchError((error) {
      print("Error fetching dog data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.darkBlue,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Add Dog',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColor.darkBlue,
          ),
        ),
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
                  topRight: Radius.circular(50),
                ),
                color: AppColor.blue,
              ),
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          addDogForm(),
        ],
      ),
    );
  }

  Widget addDogForm() {
    return ListView(
      children: [
        Container(
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
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.pets),
                      prefixIconColor:  AppColor.darkBlue,
                      hintText: 'Name',
                      hintStyle: const TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    style: TextStyle(color:AppColor.darkBlue),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
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
                        borderRadius: BorderRadius.circular(25),
                      ),
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
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    style: TextStyle(color: AppColor.darkBlue),
                    onChanged: (value) {
                      _onSearchChanged();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the breed';
                      }
                      return null;
                    },
                  ),
                  if (dogBreedSuggestions.isNotEmpty)
                    Container(
                      constraints: BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dogBreedSuggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(dogBreedSuggestions[index]),
                            onTap: () {
                              setState(() {
                                selectedDogBreed = dogBreedSuggestions[index];
                                _breedController.text = selectedDogBreed;
                                dogBreedSuggestions = [];
                                fetchDogData();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<Sex>(
                    value: _selectedSex,
                    items: Sex.values.map((sex) {
                      return DropdownMenuItem<Sex>(
                        value: sex,
                        child: Text(sex == Sex.Male ? "Male" : "Female"),
                      );
                    }).toList(),
                    onChanged: (Sex? sex) {
                      setState(() {
                        _selectedSex = sex;
                      });
                    },
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
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select the sex';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _sizeOrWeightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monitor_weight),
                      prefixIconColor: AppColor.darkBlue,
                      hintText: 'Weight (in kg)',
                      hintStyle: const TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    style: TextStyle(color: AppColor.darkBlue),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellowGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Add Dog',
                        style: GoogleFonts.ubuntu(
                          color: AppColor.darkBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
void _clearForm() {
  _nameController.clear();
  _ageController.clear();
  _breedController.clear();
  _sizeOrWeightController.clear();
  setState(() {
    _selectedSex = null;
    _imageFile = null;
    selectedDogBreed = '';
    selectedDogData = null;
    dogBreedSuggestions = [];
  });
}
}

