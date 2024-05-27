import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawlorie/user_auth/firebase_auth_services.dart';


class Dog {
  final String name;
  final String breed;
  final int age; 
  final String sex;
  final double weight;

  Dog({
    required this.name,
    required this.breed,
    required this.age,
    required this.sex,
    required this.weight,
  });

  factory Dog.fromMap(Map<String, dynamic> data) {
    return Dog(
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      age: data['age'] ?? 0,
      sex: data['sex'] ?? '',
      weight: data['sizeOrWeight'] ?? 0.0,
    );
  }
}

