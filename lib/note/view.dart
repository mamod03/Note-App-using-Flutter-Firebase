import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/note/add.dart';
import 'package:flutter_application_3/note/edit.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NoteView extends StatefulWidget {
  final String categoryid;
  NoteView({super.key, required this.categoryid});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;
  Future getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection('note')
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNote(docid: widget.categoryid)));
            }),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.orange),
          title: const Text("NoteView"),
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
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('homepage', (route) => false);
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 200,
                    crossAxisCount: 2,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Warning',
                                desc: 'Sure you want to delete ?',
                                btnOkText: "Yes",
                                btnOkOnPress: () async {
                                  await FirebaseFirestore.instance
                                      .collection('categories')
                                      .doc(widget.categoryid)
                                      .collection('note')
                                      .doc(data[index].id)
                                      .delete();

                                  if (data[index]['url'] != 'none') {
                                    FirebaseStorage.instance
                                        .refFromURL(data[index]['url'])
                                        .delete();
                                  }
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => NoteView(
                                          categoryid: widget.categoryid)));
                                },
                                btnCancelText: "Cancel",
                                btnCancelOnPress: () async {})
                            .show();
                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNote(
                                categorydocid: widget.categoryid,
                                notedocid: data[index].id,
                                value: data[index]["note"])));
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                    height: 20,
                                    child: Text("${data[index]["note"]}")),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (data[index]['url'] != 'none')
                                Image.network(
                                  '${data[index]['url']}',
                                  height: 100,
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}
