import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password)async {
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return true;
  }catch (e){
    log(e.toString());
    return false;
  }
}


Future<bool> register(String email, String password)async {
  try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return true;
  }on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      log('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
     log('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<bool?> addCoins(String id, String amount) async{
  try{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var value = double.parse(amount);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Coins')
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({'Amount':value});
        return true;
      }
      double newAmount = snapshot['Amount']+value;
      transaction.update(documentReference, {'Amount':newAmount});
      return true;
    });
  }catch(e){
    return false;
}
}

Future<bool> removeCoins(String id) async{
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance.collection('Users').doc(uid).collection('Coins').doc(id).delete();
  return true;
}
