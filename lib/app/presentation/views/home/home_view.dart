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
        title: Text(
          "Bienvenid@, ${userLoaderState.value?.firstName ?? "User"}",
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      endDrawer: const DrawerMenu(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: Icon(Icons.map,
                              color: Theme.of(context).iconTheme.color),
                          title: Text(
                            "Mis Colonias",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onTap: () {
                            context.go('/home/colonia');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.maps_home_work,
                                color: Theme.of(context).iconTheme.color),
                            title: Text(
                              "Administrar Colonias",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
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
                          leading: Icon(Icons.pets,
                              color: Theme.of(context).iconTheme.color),
                          title: Text(
                            "Gatos",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onTap: () {
                            context.go('/home/catView');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.pets_rounded,
                                color: Theme.of(context).iconTheme.color),
                            title: Text(
                              "Administrar Gatos",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
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
                          leading: Icon(Icons.favorite,
                              color: Theme.of(context).iconTheme.color),
                          title: Text(
                            "Donaciones",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onTap: () {
                            //todavía no existe la implementación
                            // context.go('/home/donaciones');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.favorite_border,
                                color: Theme.of(context).iconTheme.color),
                            title: Text(
                              "Administrar Donaciones",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
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
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: const MapaColonias(),
              ),
            ),
            //if (!kIsWeb) //ponerlo al final, para seguir viendo el estilo movil.
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
