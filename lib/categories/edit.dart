import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/CustomButton.dart';
import 'package:flutter_application_3/components/customTextfieldadd.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  bool isLoading = false;
  EditCategory() async {
    isLoading = true;
    setState(() {});
    // Call the user's CollectionReference to add a new user
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.docid).update({"name": name.text});

        Navigator.of(context).pushNamedAndRemoveUntil(
          "homepage",
          (route) => false,
        );
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("$e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add category'),
        ),
        body: Form(
          key: formstate,
          child: isLoading
              ? const Center(
                  child: const CircularProgressIndicator(),
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
                      title: "Save",
                      onPressed: () {
                        if (formstate.currentState!.validate()) {
                          EditCategory();
                        } else {}
                      },
                    )
                  ],
                ),
        ));
  }
}
