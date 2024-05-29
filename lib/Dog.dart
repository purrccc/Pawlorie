import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawlorie/user_auth/firebase_auth_services.dart';

// Model class for representing a Dog
class Dog {
  final String name;   // Name of the dog
  final String breed;  // Breed of the dog
  final int age;       // Age of the dog
  final String sex;    // Sex of the dog
  final double weight; // Weight of the dog

  // Constructor for initializing the Dog object
  Dog({
    required this.name,
    required this.breed,
    required this.age,
    required this.sex,
    required this.weight,
  });

  // Factory constructor for creating a Dog instance from a map
  factory Dog.fromMap(Map<String, dynamic> data) {
    return Dog(
      name: data['name'] ?? '',           // Retrieves the name, defaulting to an empty string if not present
      breed: data['breed'] ?? '',         // Retrieves the breed, defaulting to an empty string if not present
      age: data['age'] ?? 0,              // Retrieves the age, defaulting to 0 if not present
      sex: data['sex'] ?? '',             // Retrieves the sex, defaulting to an empty string if not present
      weight: data['sizeOrWeight'] ?? 0.0, // Retrieves the weight, defaulting to 0.0 if not present
    );
  }
}
