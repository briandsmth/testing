import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_app/method/firestore_method.dart';
import 'package:mini_app/screens/edit_task.dart';
import 'package:mini_app/utils/snackbar.dart';
import 'package:mini_app/widgets/tasktile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userData = {};
  bool isLoading = false;
  int taskLength = 2;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  // void getTask() async {
  //   try {
  //     var taskSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('task')
  //         .snapshots()
  //         .length;
  //     setState(() {
  //       taskLength = taskSnap;
  //     });
  //     print(taskSnap);
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(userData['profilePic']),
                          radius: 40,
                        ),
                        Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, ${userData['username']}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'You Have $taskLength Task',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(DateTime.now()),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: DatePicker(
                    DateTime.now(),
                    height: 100,
                    width: 80,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.blue,
                    selectedTextColor: Colors.white,
                    dateTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirestoreMethods().taskList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailTaskScreen(
                                          title: (snapshot.data! as dynamic)
                                              .docs[index]['title'],
                                          date: (snapshot.data! as dynamic)
                                              .docs[index]['date'],
                                          startTime: (snapshot.data! as dynamic)
                                              .docs[index]['startTime'],
                                          endTime: (snapshot.data! as dynamic)
                                              .docs[index]['endTime'],
                                          taskId: (snapshot.data! as dynamic)
                                              .docs[index]['taskId']),
                                    ),
                                  );
                                },
                                child: TaskTile(
                                  title: (snapshot.data! as dynamic).docs[index]
                                      ['title'],
                                  startTime: (snapshot.data! as dynamic)
                                      .docs[index]['startTime'],
                                  endTime: (snapshot.data! as dynamic)
                                      .docs[index]['endTime'],
                                  taskId: (snapshot.data! as dynamic)
                                      .docs[index]['taskId'],
                                ),
                              ));
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
