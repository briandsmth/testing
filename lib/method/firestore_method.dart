import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_app/utils/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream get taskList => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('task')
      .snapshots();

  void addTaskToDo(
      String taskName, String date, String startTime, String endTime) async {
    try {
      String taskId = const Uuid().v1();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('task')
          .doc(taskId)
          .set({
        'title': taskName,
        'createdAt': DateTime.now(),
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'taskId': taskId
      });
    } catch (e) {
      print(e);
    }
  }

  void updateTask(String taskName, String startTime, String endTime,
      String date, String taskId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('task')
          .doc(taskId)
          .update({
        'title': taskName,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
      });
    } catch (e) {
      print(e);
    }
  }

  void deleteTask(String taskId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('task')
          .doc(taskId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
