import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  final ref = FirebaseDatabase.instance.ref('users');
  User? user = FirebaseAuth.instance.currentUser;
  String? email = FirebaseAuth.instance.currentUser?.email;
  String? realName;
  String? photoProfile;
  String? bio;

  final _formKeySaved = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _uploadImage(String userId) async {
    if (_image != null) {
      final String filePath = _image!.path;
      final ref = FirebaseStorage.instance.ref('users').child(userId);
      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();
      if (mounted) {
        setState(() {
          photoProfile = url;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final String filePath = image.path;
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath,
          filePath + '_compressed.jpg',
          quality: 10,
        );
        if (mounted) {
          setState(() {
            _image = XFile(compressedImage!.path);
          });
          _uploadImage(user!.uid); // Call the upload function here
        }
      }
    } catch (e, s) {
      print('Error picking image: $e');
      print('Stack trace: $s');
      // You can also show a dialog or a snackbar to inform the user about the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profiles'),
        ),
        body: FutureBuilder<DataSnapshot>(
          future: ref.child(user!.uid).once().then((event) => event.snapshot),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              Map<dynamic, dynamic> values =
                  snapshot.data!.value as Map<dynamic, dynamic>;
              realName = values['realName'];
              photoProfile = values['photoProfile'];
              bio = values['bio'];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Form(
                    key: _formKeySaved,
                    child: ListView(
                      children: [
                        Card(
                          child: Column(
                            children: <Widget>[
                              (_image != null)
                                  ? CircleAvatar(
                                      radius: 80.0,
                                      backgroundImage:
                                          FileImage(File(_image!.path)),
                                    )
                                  : CircleAvatar(
                                      radius: 80,
                                      backgroundImage:
                                          NetworkImage(photoProfile!),
                                    ),
                              ElevatedButton.icon(
                                icon: Icon(Icons.photo_library),
                                label: Text('Select Photo'),
                                onPressed: _pickImage,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Your mail: $email'),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: realName,
                          decoration: InputDecoration(labelText: 'Name'),
                          onChanged: (value) {
                            realName = value;
                          },
                        ),
                        TextFormField(
                          initialValue: bio,
                          decoration: InputDecoration(labelText: 'Bio'),
                          onChanged: (value) {
                            bio = value;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKeySaved.currentState!.validate()) {
                              // Save the changes to the database
                              await ref.child(user!.uid).update({
                                'realName': realName,
                                'bio': bio,
                                'photoProfile': photoProfile,
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Informasi telah di perbaharui'),
                                ),
                              );
                            }
                          },
                          child: Text('Save Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
