import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/CustomButton.dart';
import 'package:flutter_application_3/components/customTextfieldadd.dart';
import 'package:flutter_application_3/note/view.dart';

class EditNote extends StatefulWidget {
  final String categorydocid;
  final String notedocid;
  final String value;
  const EditNote(
      {super.key,
      required this.categorydocid,
      required this.notedocid,
      required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isLoading = false;
  Future<void> EditNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categorydocid)
        .collection('note');
    isLoading = true;
    setState(() {});
    // Call the user's CollectionReference to add a new user
    await collectionnote.doc(widget.notedocid).update({
      'note': note.text,
    }).then((value) {
      print("User Added");

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => NoteView(categoryid: widget.categorydocid)),
      );
    }).catchError((error) {
      print("Failed to add user: $error");
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    note.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Note'),
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
                        hinttext: "Update your note",
                      ),
                    ),
                    CustomButton(
                      title: "Save",
                      onPressed: () {
                        if (formstate.currentState!.validate()) {
                          EditNote();
                        } else {}
                      },
                    )
                  ],
                ),
        ));
  }
}
