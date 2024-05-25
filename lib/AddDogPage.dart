import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:flutter/services.dart';

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

  Future<List<Dog>>? futureDogs;
  List<String> dogBreedSuggestions = [];
  String selectedDogBreed = "";
  Dog? selectedDogData;

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
      int age = int.parse(_ageController.text.trim());
      String breed = _breedController.text.trim();
      String sex = _sexController.text.trim().toLowerCase();
      double sizeOrWeight = double.parse(_sizeOrWeightController.text.trim());
      
      double minWeight;
      double maxWeight;

      if (selectedDogData != null) {
        if (sex == 'male') {
          minWeight = selectedDogData!.minWeightMale;
          maxWeight = selectedDogData!.maxWeightMale;
        } else {
          minWeight = selectedDogData!.minWeightFemale;
          maxWeight = selectedDogData!.maxWeightFemale;
        }

        // Log details to the console
      print('Dog Details:');
      print('Name: $name');
      print('Age: $age');
      print('Breed: $breed');
      print('Sex: $sex');
      print('Size or Weight: $sizeOrWeight');
      print('Min Weight: $minWeight');
      print('Max Weight: $maxWeight');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Dog Details: \nName: $name\nAge: $age\nBreed: $breed\nSex: $sex\nSize or Weight: $sizeOrWeight\nMin Weight: $minWeight\nMax Weight: $maxWeight',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Could not fetch breed data. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _breedController.dispose();
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
          icon: Icon(Icons.arrow_back_ios, color: AppColor.darkBlue),
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
      children: [Container(
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
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  style: TextStyle(color: AppColor.darkBlue),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the sex';
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
                    hintText: 'Size or Weight',
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
                    child: Text(
                      'Add Dog',
                      style: TextStyle(
                        color: AppColor.darkBlue,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
