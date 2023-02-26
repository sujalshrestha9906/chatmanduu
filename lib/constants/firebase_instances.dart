import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class FirebaseInstances {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static FirebaseStorage fireStorage = FirebaseStorage.instance;
  static FirebaseMessaging fireMessage = FirebaseMessaging.instance;
  static FirebaseChatCore fireChat = FirebaseChatCore.instance;
}
