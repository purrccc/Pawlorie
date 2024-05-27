import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawlorie/Dog.dart' as dog_model;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new document for the user with the provided name
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        // You can add more fields here as needed
      });

      return userCredential.user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<UserWithUsername?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? username = await _getUsername(userCredential.user!);

      return UserWithUsername(user: userCredential.user, username: username);
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> _getUsername(User user) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        print('Document does not exist');
        return null; // Return null if the document does not exist
      }

      return userDoc.get('name'); // Access 'name' field directly
    } catch (e) {
      print("Error getting username: $e");
      return null;
    }
  }
}


class UserWithUsername {
  final User? user;
  final String? username;

  UserWithUsername({required this.user, required this.username});
}


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<dog_model.Dog>> getDogs() {
    return _firestore.collection('dogs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => dog_model.Dog.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }
}

class Dog {
  final String name;
  final String breed;

  Dog({required this.name, required this.breed});

  factory Dog.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Dog(
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
    );
  }
}