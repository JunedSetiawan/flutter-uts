import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/provider/user_list_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class FormWidget extends StatefulWidget {
  final User user;

  const FormWidget(this.user, {super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final formKey = GlobalKey<FormState>();

  // controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  User newUser = User();

  @override
  void initState() {
    super.initState();

    newUser = widget.user;

    if (newUser.id != null) {
      _nameController.text = newUser.name;
      _emailController.text = newUser.email;
      temporaryImagePath = newUser.imageUrl;
    }
  }

  final _picker = ImagePicker();
  File? localImage;
  String? temporaryImagePath;

  Future<void> _pickImage(String source) async {
    ImageSource imageSource = source == "camera" ? ImageSource.camera : ImageSource.gallery;

    XFile? pickedImage = await _picker.pickImage(source: imageSource);

    if (pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();

      File myImage = File(pickedImage.path);

      // copy image to a permanent directory
      localImage = await myImage.copy("${directory.path}/${pickedImage.name}");

      setState(() {
        temporaryImagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserListProvider>(context, listen: false);

    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
          right: 10,
          bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          left: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (name) {
                if (name == null || name.isEmpty) {
                  return "Isi nama pengguna Anda.";
                } else {
                  return null;
                }
              },
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                label: Text("Nama Lengkap"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return "Isi email Anda.";
                } else if (!email.contains("@")) {
                  return "Ini tentu saja bukan email.";
                } else {
                  return null;
                }
              },
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                label: Text("Email"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18.0),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Dari mana Anda ingin menambahkan gambar?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _pickImage("camera");
                              },
                              child: const Text("Camera"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _pickImage("galeria");
                              },
                              child: const Text("Galeri"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: (temporaryImagePath != null && (!temporaryImagePath!.contains("https")))
                        ? FileImage(File(temporaryImagePath!))
                        : NetworkImage(newUser.imageUrl) as ImageProvider,
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(newUser.id != null ? "Sunting Gambar" : "Tambahkan gambar (opsional)")
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pop();

                      if (newUser.id != null) {
                        newUser = User(
                          id: newUser.id,
                          name: _nameController.text,
                          imageUrl: localImage != null ? localImage!.path : newUser.imageUrl,
                          email: _emailController.text,
                        );

                        users.updateUser(newUser);
                      } else {
                        newUser = User(
                          name: _nameController.text,
                          imageUrl: localImage != null ? localImage!.path : newUser.imageUrl,
                          email: _emailController.text,
                        );

                        users.addUser(newUser);
                      }
                    }
                  },
                  child: Text(
                    newUser.id != null ? "Edit" : "Simpan",
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}