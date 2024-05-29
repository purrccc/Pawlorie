import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class PetInfoTabContent extends StatefulWidget {
  final Map<String, dynamic>? petInfo;
  final String? petId;

  PetInfoTabContent({this.petInfo, this.petId});

  @override
  _PetInfoTabContentState createState() => _PetInfoTabContentState();
}

class _PetInfoTabContentState extends State<PetInfoTabContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _sizeOrWeightController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text editing controllers with current values
    _nameController.text = widget.petInfo?['name'] ?? '';
    _ageController.text = widget.petInfo?['age'].toString() ?? '';
    _sexController.text = widget.petInfo?['sex'] ?? '';
    _sizeOrWeightController.text =
        widget.petInfo?['sizeOrWeight'].toString() ?? '';
    _breedController.text = widget.petInfo?['breed'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return widget.petInfo == null
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: 400,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    children: <Widget>[
                      buildInfoCard('Age', widget.petInfo!['age'].toString(),
                          AppColor.darkBlue),
                      buildInfoCard(
                          'Sex', widget.petInfo!['sex'], AppColor.blue),
                      buildInfoCard(
                          'Size or Weight',
                          widget.petInfo!['sizeOrWeight'].toString(),
                          Color.fromARGB(255, 35, 156, 255)),
                      buildInfoCard('Breed', widget.petInfo!['breed'],
                          AppColor.yellowGold),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      child: SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.blue,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Edit Information'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _nameController,
                                        decoration:
                                            InputDecoration(labelText: 'Name'),
                                      ),
                                      TextField(
                                        controller: _ageController,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecoration(labelText: 'Age'),
                                      ),
                                      TextField(
                                        controller: _sexController,
                                        decoration:
                                            InputDecoration(labelText: 'Sex'),
                                      ),
                                      TextField(
                                        controller: _sizeOrWeightController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: 'Size or Weight'),
                                      ),
                                      TextField(
                                        controller: _breedController,
                                        decoration:
                                            InputDecoration(labelText: 'Breed'),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Update information in Firestore
                                        updatePetInfo(widget.petId!, {
                                          'name': _nameController.text,
                                          'age': _ageController.text,
                                          'sex': _sexController.text,
                                          'sizeOrWeight':
                                              _sizeOrWeightController.text,
                                          'breed': _breedController.text,
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Edit",
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            deletePet(widget.petId!);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Delete",
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget buildInfoCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to update pet information in Firestore
  Future<void> updatePetInfo(String dogId, Map<String, dynamic> newData) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the existing data of the dog from Firestore
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('dogs').doc(dogId).get();

      // Merge the existing data with the new data
      Map<String, dynamic> currentData =
          documentSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> mergedData = {...currentData, ...newData};

      // Update the document in the "dogs" collection with the merged data
      await FirebaseFirestore.instance
          .collection('dogs')
          .doc(dogId)
          .update(mergedData);
    }
  }

  Future<void> deletePet(String dogId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Delete the document in the "dogs" collection
      await FirebaseFirestore.instance.collection('dogs').doc(dogId).delete();
      // Optionally, you can show a confirmation or redirect the user after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pet deleted successfully')),
      );
      // Navigate back or update the state to remove the pet info
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    _sizeOrWeightController.dispose();
    _breedController.dispose();
    super.dispose();
  }
}
