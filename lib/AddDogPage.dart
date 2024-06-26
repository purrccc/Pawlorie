import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:pawlorie/CalSuggestionPage.dart';

enum Sex {
  Male,
  Female,
}
// Default Image URL
const String defaultImageUrl =
    'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/65761296352685.5eac4787a4720.jpg';

// fetch dog information from api 
Future<List<Dog>> fetchDogs(String dogBreed) async {
  final response = await http.get(
    Uri.parse('https://api.api-ninjas.com/v1/dogs?name=${dogBreed}'),
    headers: {'X-Api-Key': '8Q3MlktFjNQCoIEhVK7DRQ==yizU5MkNU9iKPuwu'},
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Dog.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load dogs');
  }
}

// fetch api for breed suggestions (while typing in form)
Future<List<String>> fetchDogBreeds(String query) async {
  final response = await http.get(
    Uri.parse('https://api.api-ninjas.com/v1/dogs?name=${query}'),
    headers: {'X-Api-Key': '8Q3MlktFjNQCoIEhVK7DRQ==yizU5MkNU9iKPuwu'},
  );

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    return body.map<String>((dynamic item) => item['name'] as String).toList();
  } else {
    throw Exception('Failed to load dog breeds');
  }
}

//dog class to store values from api
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

  // image picker
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      int age = int.parse(_ageController.text);
      String breed = _breedController.text;
      double sizeOrWeight = double.parse(_sizeOrWeightController.text);

      double minWeight;
      double maxWeight;
      double requiredCalories = pow(sizeOrWeight, 0.75) * 70; //formula for determining dog daily calorie intake
      double minCalories = requiredCalories * 0.8;

      String? userId = widget.userId;

      // determine min/max weight depending on breed and sex
      // weight is converted to kg from lbs (api provides weight in lbs)
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
          } else {
            imageUrl = defaultImageUrl;
          }

          // adding dog information to database
          DocumentReference docRef = await _firestore.collection('dogs').add({  
            'name': name,
            'age': age,
            'breed': breed,
            'sex': _selectedSex == Sex.Male ? 'Male' : 'Female',
            'sizeOrWeight': sizeOrWeight,
            'minWeight': minWeight,
            'maxWeight': maxWeight,
            'requiredCalories': requiredCalories.round().toDouble(),
            'minCalories': minCalories.round().toDouble(),
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
          clearForm();  // Clear form after adding dog

          //pop up navigator page after adding dog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalSuggestionPage(
                dogId: dogId,
                dogName: dogName,
                requiredCalories: requiredCal,
                imageUrl: imageURL,
                minCalories: minCalories,
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
            content:
                Text('Error: Could not fetch breed data. Please try again.'),
          ),
        );
      }
    }
  }

  // function to add image to database
  Future<String> _uploadImageToStorage(File imageFile) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      // Create a unique file name
      String fileName =
          'dogs/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
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
    _breedController.addListener(onSearchChanged); // add listener to breed controller to handle changes while user types dog breed (for search suggestions)
  }

  // function that displays dog breed suggestions depending on user input
  void onSearchChanged() {
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

  // fetch data of dog breed that has been selected by user
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.darkBlue,
          ),
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
          addDogForm(), // Display form 
        ],
      ),
    );
  }

  // Add Dog form
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
                          : NetworkImage(defaultImageUrl) as ImageProvider,
                      child: _imageFile == null
                          ? Icon(
                              Icons.add_a_photo,
                              color: AppColor.darkBlue,
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
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
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
                      onSearchChanged();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the breed';
                      }
                      return null;
                    },
                  ),
                  if (dogBreedSuggestions.isNotEmpty) // if condition for dog breed suggestions dropdown
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
                    onPressed: submitForm,
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
                            fontWeight: FontWeight.bold),
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


  // function to clear form after submission
  void clearForm() {
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
