import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/router_controller.dart';
import '../menu_lateral.dart';

class AdminDonaciones extends ConsumerStatefulWidget {
  const AdminDonaciones({super.key});

  static const String routeName = '/adminDonaciones';
  @override
  ConsumerState<AdminDonaciones> createState() => _AdminDonacionesState();
}

class _AdminDonacionesState extends ConsumerState<AdminDonaciones> {
  @override
  Widget build(BuildContext context) {
    final userLoaderState =
        ref.watch(userLoaderFutureProvider); // Define userLoaderState

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Bienvenido, ${userLoaderState.value?.firstName ?? "User"}"),
      ),
      endDrawer: const DrawerMenu(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 15),
                  alignment: Alignment.centerLeft,
                  child: const Text("Categories",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        onTap: (index) {},
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'kk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.featured_video),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
