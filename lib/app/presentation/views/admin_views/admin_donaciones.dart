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
        title: Text(
          "Bienvenido, ${userLoaderState.value?.firstName ?? "User"}",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
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
                  child: const Text("Gestión donaciones",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
    );
  }
}
