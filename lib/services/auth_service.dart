import 'dart:io';
import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final userStream = StreamProvider.autoDispose
    .family((ref, String userId) => AuthService.getUserById(userId));
final usersStream =
    StreamProvider.autoDispose((ref) => FirebaseInstances.fireChat.users());

class AuthService {
  static CollectionReference userDb =
      FirebaseInstances.fireStore.collection('users');

  static Stream<types.User> getUserById(String userId) {
    return userDb.doc(userId).snapshots().map((event) {
      final json = event.data() as Map<String, dynamic>;
      return types.User(
          id: event.id,
          firstName: json['firstName'],
          imageUrl: json['imageUrl'],
          metadata: {
            'email': json['metadata']['email'],
            'token': json['metadata']['token']
          });
    });
  }

  static Future<Either<String, bool>> userSignUp(
      {required String email,
      required String password,
      required String username,
      required XFile image}) async {
    try {
      final token = await FirebaseInstances.fireMessage.getToken();
      final imageName = DateTime.now().toString();
      final ref =
          FirebaseInstances.fireStorage.ref().child('userImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      final credential = await FirebaseInstances.firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseInstances.fireChat.createUserInFirestore(
        types.User(
            firstName: username,
            id: credential.user!.uid,
            imageUrl: url,
            lastName: '',
            metadata: {'email': email, 'token': token}),
      );
      await FirebaseFirestore.instance.clearPersistence();
      return Right(true);
    } on FirebaseAuthException catch (err) {
      return Left('${err.message}');
    }
  }

  static Future<Either<String, bool>> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseInstances.firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final token = await FirebaseInstances.fireMessage.getToken();
      await userDb.doc(credential.user!.uid).update({
        'metadata': {'email': email, 'token': token}
      });
      return Right(true);
    } on FirebaseAuthException catch (err) {
      return Left('${err.message}');
    }
  }

  static Future<Either<String, bool>> userLogOut() async {
    try {
      final credential = await FirebaseInstances.firebaseAuth.signOut();
      return Right(true);
    } on FirebaseAuthException catch (err) {
      return Left('${err.message}');
    }
  }
}
