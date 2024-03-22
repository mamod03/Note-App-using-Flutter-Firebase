import 'dart:convert';
import 'package:flutter_application_3/chat.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("==============================");
    print(mytoken);
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
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == 'alert') {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Chat()));
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('==========================');

        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        print('==========================');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${message.notification!.body}')));
      }
    });

    myrequestPermission();
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: MaterialButton(
              onPressed: () async {
// subscribe to topic on each app start-up
                await FirebaseMessaging.instance.subscribeToTopic('weather');
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Subscriped!')));
              },
              child: Text('subscribe'),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              // subscribe to topic on each app start-up
              await FirebaseMessaging.instance.unsubscribeFromTopic('weather');
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Unsubscriped!')));
            },
            child: Text('unsubscribe'),
          ),
          MaterialButton(
            onPressed: () async {
              await sendMessageTopic('send', 'TOPICC', 'weather');
            },
            child: Text('send message topic'),
          ),
        ],
      )),
    );
  }
}

sendMessage(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAArt5PZik:APA91bHVO_yRsl5ECQmpauph3_-YoL8h9GXkNXvQMPYedGpqYjRCGF-BHJjQ22XI0IwfNDOuVYuo8imDiTCzlYmz1ShWRFX7tlxDYWKhC8EsA5hLSl1-2yFFxdpdXOd4YtUSAYU_71ev'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "fZOuDjwbSKaD5ZXW4HEYDB:APA91bFui2quRwStDchEWl9ZaWQBzGG-SCEOHmWXo8JqubFx_94CJOie2DniaPa146ImTt2OmSxytbBVvgnNm_38cG9_2y4auhUAyX9-5fCQbsGSXd2PEd9-NbmSp47h6mO3q7di4yu7",
    "notification": {
      "title": title,
      "body": message,
    },
    "data": {"id": "12", "type": "alert"}
  };
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
