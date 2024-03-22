import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/categories/edit.dart';
import 'package:flutter_application_3/note/view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class homePage extends StatefulWidget {
  homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  Future getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  myrequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    myrequestPermission();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("addCategory");
          }),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await FirebaseMessaging.instance.subscribeToTopic('weather');
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Subscriped!')));
              await sendMessageTopic("hi", 'holera', 'weather');
            },
            icon: Icon(Icons.subscriptions)),
        iconTheme: IconThemeData(color: Colors.orange),
        title: const Text("Homepage"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              await FirebaseAuth.instance.signOut();
              googleSignIn.signOut();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login', (route) => false);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 200,
                crossAxisCount: 2,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            NoteView(categoryid: data[index].id)));
                  },
                  onLongPress: () {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'What do you want to do ?',
                        btnOkText: "edit",
                        btnOkOnPress: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCategory(
                                  docid: data[index].id,
                                  oldname: data[index]["name"])));
                        },
                        btnCancelText: "delete",
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(data[index].id)
                              .delete();
                          Navigator.of(context)
                              .pushReplacementNamed('homepage');
                        }).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Image.asset(
                            'images/folder.png',
                            height: 140,
                          ),
                          Text("${data[index]["name"]}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

sendMessageTopic(title, message, topic) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAArt5PZik:APA91bHVO_yRsl5ECQmpauph3_-YoL8h9GXkNXvQMPYedGpqYjRCGF-BHJjQ22XI0IwfNDOuVYuo8imDiTCzlYmz1ShWRFX7tlxDYWKhC8EsA5hLSl1-2yFFxdpdXOd4YtUSAYU_71ev'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "/topics/$topic",
    "notification": {
      "title": title,
      "body": message,
    },
  };
  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
