import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_plan_diary/data/models/user.dart';

class UserRepository
{void saveUserToFirestore(UserModel user) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set(user.toMap());
}

Future<UserModel?> getUserFromFirestore(String uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (doc.exists) {
    return UserModel.fromDocument(doc);
  }
  return null;
}

}