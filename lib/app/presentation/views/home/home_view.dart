import 'package:autentification/app/presentation/views/home/widgets_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/router_controller.dart';
import '../menu_lateral.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  static const String routeName = 'home';
  @override
  ConsumerState<HomeView> createState() => _HomeviewState();
}

class _HomeviewState extends ConsumerState<HomeView> {
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(Icons.map),
                          title: const Text("Mis Colonias"),
                          onTap: () {
                            context.go('/home/colonia');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: const Icon(Icons.maps_home_work),
                            title: const Text("Administrar Colonias"),
                            onTap: () {
                              context.go('/home/adminColonias');
                            },
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(Icons.pets),
                          title: const Text("Gatos"),
                          onTap: () {
                            context.go('/home/catView');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: const Icon(Icons.pets_rounded),
                            title: const Text("Administrar Gatos"),
                            onTap: () {
                              context.go('/home/adminGatos');
                            },
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(Icons.favorite),
                          title: const Text("Donaciones"),
                          onTap: () {
                            //todavía no existe la implementación
                            // context.go('/home/donaciones');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: const Icon(Icons.favorite_border),
                            title: const Text("Administrar Donaciones"),
                            onTap: () {
                              context.go('/home/adminDonaciones');
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const MapaColonias(),
              ),
            ),
            //if (!kIsWeb)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(23.0),
                      child: FloatingActionButton(
                        heroTag: "btnColony",
                        onPressed: () {
                          context.go('/home/colonia');
                        },
                        tooltip: "Ver Colonias",
                        child: const Icon(Icons.map),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(23.0),
                      child: FloatingActionButton(
                        heroTag: "btnCats",
                        onPressed: () {
                          context.go('/home/catView');
                        },
                        tooltip: "Ver Gatos",
                        child: const Icon(Icons.pets),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(23.0),
                      child: FloatingActionButton(
                        heroTag: "btnDonate",
                        onPressed: () {
                          //aqui se iria a la vista de donaciones.
                        },
                        tooltip: "Donar",
                        child: const Icon(Icons.favorite),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
