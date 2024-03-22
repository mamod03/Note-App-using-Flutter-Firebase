import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_3/components/CustomButtonUpload.dart';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/CustomButton.dart';
import 'package:flutter_application_3/components/customTextfieldadd.dart';
import 'package:flutter_application_3/note/view.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  File? file;
  String? url;

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagegallery =
        await picker.pickImage(source: ImageSource.gallery);

    if (imagegallery != null) {
      file = File(imagegallery.path);

      var imagename = basename(imagegallery.path);

      var refStorage = FirebaseStorage.instance.ref('images').child(imagename);
      isimg = true;
      setState(() {});
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
  }

  bool isimg = false;
  bool isLoading = false;
  Future<void> AddNote(context) {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection('note');
    isLoading = true;
    setState(() {});
    // Call the user's CollectionReference to add a new user
    return collectionnote
        .add({'note': note.text, 'url': url ?? "none"}).then((value) {
      print("User Added");

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => NoteView(categoryid: widget.docid)),
      );
    }).catchError((error) {
      print("Failed to add user: $error");
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Note'),
        ),
        body: Form(
          key: formstate,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: CustomTextFieldAdd(
                        mycontroller: note,
                        validator: (val) {
                          if (val == "") {
                            return "Name can't be empty";
                          }
                          return null;
                        },
                        hinttext: "Enter your note",
                      ),
                    ),
                    CustomButtonUpload(
                      title: 'Upload an Image',
                      onPressed: () async {
                        await getImage();
                      },
                      isSelected: url == null ? false : true,
                    ),
                    CustomButton(
                      title: "Add",
                      onPressed: () {
                        if (formstate.currentState!.validate()) {
                          AddNote(context);
                        } else {}
                      },
                    )
                  ],
                ),
        ));
  }
}
