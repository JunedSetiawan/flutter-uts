import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/provider/user_list_provider.dart';
import 'package:myapp/utils/modal_bottom.dart';

class UserItem extends StatelessWidget {
  final User user;
  final modal = ModalBottomSheet();
  UserItem(this.user, {super.key});

  bool get hasLocalImage {
    bool hasLocalImage = File(user.imageUrl).existsSync();
    return hasLocalImage;
  }

  ImageProvider backgroundImage(bool hasLocalImage) {
    if (hasLocalImage) {
      var bytes = File(user.imageUrl).readAsBytesSync();
      return MemoryImage(bytes);
    } else {
      return NetworkImage(user.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserListProvider>(context, listen: false);
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 1,
            onPressed: (context) {
              modal.showModal(context, user);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            icon: Icons.edit,
            label: 'Edit',
          ),
          const SizedBox(width: 4.0),
          SlidableAction(
            onPressed: (context) {
              users.deleteUser(user.id!);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 10,
        color: Colors.primaries[user.id! % Colors.primaries.length].withOpacity(0.7), // Warna acak dari daftar warna primer
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40, // Membuat avatar lebih besar
                backgroundImage: backgroundImage(hasLocalImage),
              ),
              const SizedBox(height: 16.0),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}