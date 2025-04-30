import 'package:autentification/app/presentation/controllers/colonia_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/router_controller.dart';

class MapaColonias extends ConsumerWidget {
  const MapaColonias({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coloniaListAsync = ref.watch(coloniaListProvider);
    final userLoaderState = ref.watch(userLoaderFutureProvider);

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
                child: GestureDetector(
                  onTap: () {
                    // Mostrar ventana emergente con detalles de la colonia
                    showDialog(
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Theme.of(context)
                                      .dialogTheme
                                      .backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .dialogTheme
                                          .backgroundColor,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Colonia: ${colonia.id}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "¿Quieres ser voluntario de esta colonia?",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context)
                                                    .pop(); // Cerrar el diálogo antes de realizar la acción

                                                // Obtener el usuario actual
                                                final user =
                                                    userLoaderState.whenOrNull(
                                                  data: (user) => user,
                                                );
                                                // Intentar asignar la colonia al usuario
                                                final success = await ref
                                                    .read(
                                                        coloniaRepositoryProvider)
                                                    .assignColoniaToUser(
                                                        user!.id, colonia.id);
                                                if (!context.mounted) return;
                                                print("success aqui");
                                                if (success) {
                                                  // Mostrar mensaje de éxito
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Colonia asignada exitosamente"),
                                                    ),
                                                  );
                                                  await ref
                                                      .read(
                                                          coloniaRepositoryProvider)
                                                      .assignColoniaToUser(
                                                          user.id, colonia.id);
                                                  ref.invalidate(
                                                      coloniaListProvider);
                                                  ref.invalidate(
                                                      userLoaderFutureProvider);
                                                } else {
                                                  // Mostrar mensaje de error
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Error al asignar la colonia"),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text("Aceptar"),
                                            ),
                                            const Spacer(),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancelar",
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).unselectedWidgetColor,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Colonia: ${colonia.id}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  const SizedBox(height: 2),
                                  Text(
                                    colonia.address,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Número de gatos: ${colonia.cats.length}",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Detalles: ${colonia.description}",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 243, 33, 33),
                    size: 30,
                  ),
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
                      "https://api.maptiler.com/maps/basic/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}",
                  subdomains: const ['a', 'b', 'c'],
                  additionalOptions: const {},
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    disableClusteringAtZoom:
                        12, // Desactivar clustering en zoom alto
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
