import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/colonia_controller.dart';
import '../../controllers/router_controller.dart';
import '../../shared/utils.dart';

class ColoniaFloatingButtons extends StatelessWidget {
  final dynamic user; // El usuario actual
  final WidgetRef ref; // Referencia al proveedor

  const ColoniaFloatingButtons({
    super.key,
    required this.user,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "btnAssignColony",
          onPressed: () async {
            // Mostrar un diálogo para seleccionar una colonia
            final selectedColoniaId = await showDialog<String>(
              context: context,
              builder: (context) {
                return SizedBox(
                  width: 300,
                  height: 400,
                  child: AlertDialog(
                    title: const Text("¿Dónde quieres ser voluntario?"),
                    content: Consumer(
                      builder: (context, ref, child) {
                        final coloniaListAsync = ref.watch(coloniaListProvider);

                        return coloniaListAsync.when(
                          data: (colonias) {
                            final availableColonias = colonias.where((colonia) {
                              return !(user.coloniaIds?.contains(colonia.id) ??
                                  false);
                            }).toList();
                            if (availableColonias.isEmpty) {
                              return const Center(
                                child: Text(
                                    "No hay colonias disponibles para asignar"),
                              );
                            }
                            return SizedBox(
                              height: 300,
                              width: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: availableColonias.length,
                                itemBuilder: (context, index) {
                                  final colonia = availableColonias[index];
                                  return ListTile(
                                    title: Text(capitalize(colonia.id),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.color)),
                                    onTap: () {
                                      Navigator.pop(
                                          context,
                                          colonia
                                              .id); // Retornar el ID de la colonia seleccionada
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) =>
                              Text("Error al cargar colonias: $error"),
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: const Text("Cancelar"),
                      ),
                    ],
                  ),
                );
              },
            );

            if (selectedColoniaId != null) {
              // Asignar la colonia al usuario
              final success = await ref
                  .read(coloniaRepositoryProvider)
                  .assignColoniaToUser(user.id, selectedColoniaId);

              if (!context.mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Colonia asignada exitosamente")),
                );

                // Invalidar el proveedor para actualizar la lista de colonias del usuario
                ref.invalidate(coloniaListProvider);
                ref.invalidate(userLoaderFutureProvider);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error al asignar la colonia")),
                );
              }
            }
          },
          tooltip: "Asignar Colonia",
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: "btnDesasignarColony",
          onPressed: () async {
            final userColonias = ref
                .read(coloniaListProvider)
                .whenData((colonias) => colonias.where((colonia) {
                      return user.coloniaIds?.contains(colonia.id) ?? false;
                    }).toList());

            if (userColonias.value == null || userColonias.value!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text("No tienes colonias asignadas para desasignar")),
              );
              return;
            }
            final selectedColoniaId = await showDialog<String>(
              context: context,
              builder: (context) {
                return SizedBox(
                  width: 300,
                  height: 400,
                  child: AlertDialog(
                    title: const Text("Seleccionar Colonia"),
                    content: Consumer(
                      builder: (context, ref, child) {
                        final coloniaListAsync = ref.watch(coloniaListProvider);

                        return coloniaListAsync.when(
                          data: (colonias) {
                            return SizedBox(
                              height: 300,
                              width: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: userColonias.value!.length,
                                itemBuilder: (context, index) {
                                  final colonia = userColonias.value![index];
                                  return ListTile(
                                    title: Text(capitalize(colonia.id),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.color)),
                                    onTap: () {
                                      Navigator.pop(context, colonia.id);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) =>
                              Text("Error al cargar colonias: $error"),
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, null),
                        child: const Text("Cancelar"),
                      ),
                    ],
                  ),
                );
              },
            );

            if (selectedColoniaId != null) {
              final success = await ref
                  .read(coloniaRepositoryProvider)
                  .removeColoniaToUser(user.id, selectedColoniaId);

              if (!context.mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Colonia desasignada exitosamente")),
                );

                // Invalidar el proveedor para actualizar la lista de colonias del usuario
                ref.invalidate(coloniaListProvider);
                ref.invalidate(userLoaderFutureProvider);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Error al desasignar la colonia")),
                );
              }
            }
          },
          tooltip: "Desasignar Colonia",
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
