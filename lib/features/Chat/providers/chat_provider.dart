import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartchat/features/Chat/models/chat_messages.dart';
import 'package:smartchat/interceptors/di.dart';

import '../../../resources/all_resources.dart';

class ChatProvider {
  // final SharedPreferences prefs;
  // final FirebaseFirestore firebaseFirestore;
  // final FirebaseStorage firebaseStorage;
  final prefs = sl<SharedPreferences>();
  final firebaseFirestore = sl<FirebaseFirestore>();
  final firebaseStorage = sl<FirebaseStorage>();

  // ChatProvider(
  //     {required this.prefs,
  //     required this.firebaseStorage,
  //     required this.firebaseFirestore});

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatMessageChats(int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        // .doc(groupChatId)
        // .collection(groupChatId)
        // .orderBy(FirestoreConstants.timestamp, descending: true)
        // .limit(limit)
        .snapshots();
  }

  Stream<dynamic> getChatMessageSeen(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .snapshots();
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId, bool seen) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        seen: seen,
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
  static const audio = 3;
}
