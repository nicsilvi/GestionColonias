import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text("Mapa de Colonias"),
                    onTap: () {
                      Navigator.pushNamed(context, '/mapa');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.pets),
                    title: Text("Gatos"),
                    onTap: () {
                      Navigator.pushNamed(context, '/gatos');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text("Donaciones"),
                    onTap: () {
                      Navigator.pushNamed(context, '/donaciones');
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              child: MapaColonias(),
            ),
            Column(
              children: [
                FloatingActionButton(
                  heroTag: "btnColony",
                  onPressed: () {
                    Navigator.pushNamed(context, '/colonias');
                  },
                  child: Icon(Icons.map),
                  tooltip: "Ver Colonias",
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btnCats",
                  onPressed: () {
                    Navigator.pushNamed(context, '/gatos');
                  },
                  child: Icon(Icons.pets),
                  tooltip: "Ver Gatos",
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "btnDonate",
                  onPressed: () {
                    Navigator.pushNamed(context, '/donaciones');
                  },
                  child: Icon(Icons.favorite),
                  tooltip: "Donar",
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
    return FlutterMap(
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
    );
  }
}
