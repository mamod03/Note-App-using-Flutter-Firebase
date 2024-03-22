import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/CustomButton.dart';
import 'package:flutter_application_3/components/customTextfieldadd.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;
  Future<void> AddCategory() {
    isLoading = true;
    setState(() {});
    // Call the user's CollectionReference to add a new user
    return categories.add({
      'name': name.text,
      'id': FirebaseAuth.instance.currentUser!.uid,
    }).then((value) {
      print("User Added");

      Navigator.of(context).pushNamedAndRemoveUntil(
        "homepage",
        (route) => false,
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
          title: Text('Add category'),
        ),
        body: Form(
          key: formstate,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 25),
                      child: CustomTextFieldAdd(
                        mycontroller: name,
                        validator: (val) {
                          if (val == "") {
                            return "Name can't be empty";
                          }
                          return null;
                        },
                        hinttext: "Enter a name",
                      ),
                    ),
                    CustomButton(
                      title: "Add",
                      onPressed: () {
                        if (formstate.currentState!.validate()) {
                          AddCategory();
                        } else {}
                      },
                    )
                  ],
                ),
        ));
  }
}
