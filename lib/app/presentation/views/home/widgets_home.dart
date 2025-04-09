import 'package:autentification/app/presentation/controllers/colonia_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MapaColonias extends ConsumerWidget {
  const MapaColonias({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coloniaListAsync = ref.watch(coloniaListProvider);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: coloniaListAsync.when(
          data: (colonias) {
            final markers = colonias.map((colonia) {
              return Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(
                    colonia.location.latitude, colonia.location.longitude),
                child: const Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 243, 33, 33),
                  size: 30,
                ),
              );
            }).toList();

            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(41.5463, 2.1086),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    disableClusteringAtZoom:
                        16, // Desactivar clustering en zoom alto
                    size: const Size(40, 40),
                    markers: markers,
                    builder: (context, cluster) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          cluster.length
                              .toString(), // Número de marcadores en el cluster
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text("Error al cargar las colonias: $error"),
          ),
        ),
      ),
    );
  }
}
