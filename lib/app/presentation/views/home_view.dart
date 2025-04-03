import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/router_controller.dart';
import 'menu_lateral.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
                          leading: Icon(Icons.map),
                          title: Text("Mapa de Colonias"),
                          onTap: () {
                            Navigator.pushNamed(context, '/mapa');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.maps_home_work),
                            title: Text("Administrar Colonias"),
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
                          leading: Icon(Icons.pets),
                          title: Text("Gatos"),
                          onTap: () {
                            context.go('/home/catView');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.pets_rounded),
                            title: Text("Administrar Gatos"),
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
                          leading: Icon(Icons.favorite),
                          title: Text("Donaciones"),
                          onTap: () {
                            context.go('/home/donaciones');
                          },
                        ),
                      ),
                      if (userLoaderState.value?.role == 'admin')
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.favorite_border),
                            title: Text("Administrar Donaciones"),
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
              flex: 3, // Ajusta el espacio para el mapa
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: MapaColonias(),
                ),
              ),
            ),
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
                          Navigator.pushNamed(context, '/colonias');
                        },
                        child: Icon(Icons.map),
                        tooltip: "Ver Colonias",
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(23.0),
                      child: FloatingActionButton(
                        heroTag: "btnCats",
                        onPressed: () {
                          Navigator.pushNamed(context, '/gatos');
                        },
                        child: Icon(Icons.pets),
                        tooltip: "Ver Gatos",
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(23.0),
                      child: FloatingActionButton(
                        heroTag: "btnDonate",
                        onPressed: () {
                          Navigator.pushNamed(context, '/donaciones');
                        },
                        child: Icon(Icons.favorite),
                        tooltip: "Donar",
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

class MapaColonias extends StatelessWidget {
  const MapaColonias({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(41.5463, 2.1086),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(41.5463, 2.1086),
                  child: Icon(Icons.pets, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
