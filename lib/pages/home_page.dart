import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/provider/user_list_provider.dart';
import 'package:myapp/utils/modal_bottom.dart';
import 'package:myapp/widgets/user_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final modal = ModalBottomSheet();

  @override
  Widget build(BuildContext context) {
    Future<List<User>> getUserList() async {
      List<User> userList = await Provider.of<UserListProvider>(context).getUserList();
      return userList;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Daftar Pengguna"),
      ),
      body: FutureBuilder<List<User>>(
        future: getUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else {
            final List<User> list = snapshot.data!;
            return list.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Anda belum mendaftarkan pengguna!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0), // Menambahkan padding untuk memberikan jarak dari tepi
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0, // Mengubah jarak horizontal antar card
                      mainAxisSpacing: 16.0, // Mengubah jarak vertikal antar card
                      childAspectRatio: 0.7, // Mengubah rasio aspek card untuk membuat lebih besar
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) => UserItem(list[index]),
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modal.showModal(context, User());
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}