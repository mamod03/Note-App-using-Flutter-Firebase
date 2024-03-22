import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilterUser extends StatefulWidget {
  const FilterUser({super.key});

  @override
  State<FilterUser> createState() => _FilterUserState();
}

class _FilterUserState extends State<FilterUser> {
  File? file;
  String? url;
  getImage() async {
    final ImagePicker picker = ImagePicker();
    // final XFile? imagegallery =
    //     await picker.pickImage(source: ImageSource.gallery);
    final XFile? imagecamera =
        await picker.pickImage(source: ImageSource.gallery);
    if (imagecamera != null) {
      file = File(imagecamera.path);

      var imagename = basename(imagecamera.path);
      var refStorage = FirebaseStorage.instance
          .ref(
            "images",
          )
          .child(imagename);

      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.orange),
          title: const Text("FilterUser"),
        ),
        body: Container(
          child: Column(
            children: [
              MaterialButton(
                onPressed: () async {
                  getImage();
                },
                child: const Text('get Image from carmera'),
              ),
              if (url != null)
                Image.network(
                  url!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
            ],
          ),
        ));
  }
}
