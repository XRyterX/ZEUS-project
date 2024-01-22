import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spons/menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKeySignUp = GlobalKey<FormBuilderState>();
  final _formKeySignin = GlobalKey<FormBuilderState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _imageUrl;

  void someFunction() async {
    await Future.delayed(Duration(seconds: 4));
    if (mounted) {
      print(context.widget);
    }
  }

  String? Function(String?)? emailValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  };

  String? Function(String?)? passwordValidator = (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  };

  Future<String> uploadUserPhoto(String filePath, String userId) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child('users/$userId');
    await fileRef.putFile(File(filePath));

    // Get the download URL of the uploaded photo
    final photoUrl = await fileRef.getDownloadURL();

    return photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    var validator;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Login'),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            // Login form
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FormBuilder(
                key: _formKeySignin,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: emailValidator,
                    ),
                    SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'password',
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: passwordValidator,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: Text("Sign In"),
                      onPressed: () async {
                        _formKeySignin.currentState?.save();
                        if (_formKeySignin.currentState?.validate() == true) {
                          try {
                            // ignore: unused_local_variable
                            UserCredential userCredential =
                                await _auth.signInWithEmailAndPassword(
                              email: _formKeySignin
                                  .currentState?.fields['email']?.value,
                              password: _formKeySignin
                                  .currentState?.fields['password']?.value,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWidget()),
                            );
                          } on FirebaseAuthException catch (e) {
                            String errorMessage =
                                'alamat email atau password tidak benar';
                            if (e.code == 'user-not-found') {
                              errorMessage = 'alamat email tidak tersedia';
                            } else if (e.code == 'wrong-password') {
                              errorMessage = 'password tidak benar';
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                              ),
                            );
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            // Sign up for
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: FormBuilder(
                  key: _formKeySignUp,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: ListView(
                    children: <Widget>[
                      FormBuilderTextField(
                        name: 'realName',
                        decoration: InputDecoration(
                          labelText: 'Real Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: validator,
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: validator,
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'password',
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: validator,
                      ),
                      SizedBox(height: 10),
                      Card(
                        child: Column(
                          children: <Widget>[
                            (_image != null)
                                ? CircleAvatar(
                                    radius: 70.0,
                                    backgroundImage:
                                        FileImage(File(_image!.path)),
                                  )
                                : Image.asset(
                                    'assets/profile_vector.jpg',
                                    width: 100,
                                  ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.photo_camera),
                              label: Text('Take Photo'),
                              onPressed: () async {
                                if (await _requestPermissions(
                                    Permission.camera, 'Camera', context)) {
                                  final XFile? photo = await _picker.pickImage(
                                      source: ImageSource.camera);
                                  if (photo == null) {
                                    return;
                                  }
                                  final filePath = photo.path;
                                  final compressedImage =
                                      await FlutterImageCompress
                                          .compressAndGetFile(
                                    filePath,
                                    filePath + '_compressed.jpg',
                                    quality: 15,
                                  );
                                  setState(() {
                                    _image = XFile(compressedImage!.path);
                                    _imageUrl = compressedImage.path;
                                  });
                                }
                              },
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.photo_library),
                              label: Text('Select Photo'),
                              onPressed: () async {
                                final XFile? photo = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (photo == null) {
                                  return;
                                }
                                final filePath = photo.path;

                                final compressedImage =
                                    await FlutterImageCompress
                                        .compressAndGetFile(
                                  filePath,
                                  filePath + '_compressed.jpg',
                                  quality: 10,
                                );
                                setState(() {
                                  _image = XFile(compressedImage!.path);
                                  _imageUrl = compressedImage.path;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        name: 'bio',
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          border: OutlineInputBorder(),
                        ),
                        validator: validator,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text("Sign Up"),
                        onPressed: () async {
                          _formKeySignUp.currentState?.save();
                          if (_formKeySignUp.currentState?.validate() == true) {
                            try {
                              // Sign up the user
                              UserCredential userCredential =
                                  await _auth.createUserWithEmailAndPassword(
                                email: _formKeySignUp
                                    .currentState?.fields['email']?.value,
                                password: _formKeySignUp
                                    .currentState?.fields['password']?.value,
                              );
                              final photoUrl = await uploadUserPhoto(
                                  _imageUrl!, userCredential.user!.uid);

                              DatabaseReference dbRef = FirebaseDatabase
                                  .instance
                                  .reference()
                                  .child('users')
                                  .child(userCredential.user!.uid);

                              print(
                                  'Real Name: ${_formKeySignUp.currentState?.fields['realName']?.value}');
                              print(
                                  'Bio: ${_formKeySignUp.currentState?.fields['bio']?.value}');

                              await dbRef.set(
                                {
                                  'realName': _formKeySignUp.currentState
                                          ?.fields['realName']?.value ??
                                      "No name provided",
                                  'photoProfile': photoUrl,
                                  'bio': _formKeySignUp
                                          .currentState?.fields['bio']?.value ??
                                      "No bio provided",
                                },
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyWidget()),
                              );
                            } catch (e) {
                              // Handle sign up error
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'An error occurred while signing up.'),
                                ),
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _denyCount = 0;
Future<bool> _requestPermissions(
    Permission permission, String permissionName, BuildContext context) async {
  if (await permission.status.isGranted) {
    return true;
  } else {
    if (_denyCount >= 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text(
                'You have denied permission $_denyCount times. Go to settings to enable permissions.'),
            actions: <Widget>[
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                },
              ),
            ],
          );
        },
      );
      return false;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Required'),
            content: Text(
                'This app requires the $permissionName permission to function properly.'),
            actions: <Widget>[
              TextButton(
                child: Text('Reject'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _denyCount++;
                },
              ),
              TextButton(
                child: Text('Agree'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var status = await permission.request();
                  if (status.isGranted) {
                    _navigate(permissionName, context);
                  } else if (status.isPermanentlyDenied) {
                    openAppSettings();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }
  return false;
}

void _navigate(String permissionName, BuildContext context) async {
  final ImagePicker _picker = ImagePicker();
  if (permissionName == 'Camera') {
    if (await _requestPermissions(Permission.camera, 'Camera', context)) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        print('Camera accessed: ${photo.path}');
      }
      final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        print('Camera accessed: ${video.path}');
      }
    }
  }
}
