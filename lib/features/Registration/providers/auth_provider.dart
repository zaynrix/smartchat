import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartchat/interceptors/di.dart';

import '../../../resources/all_resources.dart';
import '../../Chat/models/chat_user.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider(
      //     {
      //   required this.googleSignIn,
      //   required this.firebaseAuth,
      //   required this.firebaseFirestore,
      // }
      );
  final googleSignIn = sl<GoogleSignIn>();
  final firebaseAuth = sl<FirebaseAuth>();
  final firebaseFirestore = sl<FirebaseFirestore>();
  // final FirebaseAuth firebaseAuth;
  // final FirebaseFirestore firebaseFirestore;
  String? getFirebaseUserId() {
    return sl<SharedPreferences>().getString(FirestoreConstants.id);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await sl<GoogleSignIn>().isSignedIn();
    if (isLoggedIn &&
        sl<SharedPreferences>().getString(FirestoreConstants.id)?.isNotEmpty ==
            true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleGoogleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    final googleUser = await sl<GoogleSignIn>().signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser =
          (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            FirestoreConstants.displayName: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          User? currentUser = firebaseUser;
          await sl<SharedPreferences>()
              .setString(FirestoreConstants.id, currentUser.uid);
          await sl<SharedPreferences>().setString(
              FirestoreConstants.displayName, currentUser.displayName ?? "");
          await sl<SharedPreferences>().setString(
              FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await sl<SharedPreferences>().setString(
              FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
        } else {
          DocumentSnapshot documentSnapshot = document[0];
          ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
          await sl<SharedPreferences>()
              .setString(FirestoreConstants.id, userChat.id);
          await sl<SharedPreferences>()
              .setString(FirestoreConstants.displayName, userChat.displayName);
          await sl<SharedPreferences>()
              .setString(FirestoreConstants.aboutMe, userChat.aboutMe);
          await sl<SharedPreferences>()
              .setString(FirestoreConstants.phoneNumber, userChat.phoneNumber);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<void> googleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
