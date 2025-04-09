import 'package:autentification/app/presentation/implements/colonia_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/colonia_controller.dart';
import '../../controllers/router_controller.dart';
import '../menu_lateral.dart';

class AdminColonias extends ConsumerStatefulWidget {
  const AdminColonias({super.key});

  static const String routeName = '/adminColonias';
  @override
  ConsumerState<AdminColonias> createState() => _AdminColoniasState();
}

class _AdminColoniasState extends ConsumerState<AdminColonias> {
  @override
  Widget build(BuildContext context) {
    final userLoaderState =
        ref.watch(userLoaderFutureProvider); // Define userLoaderState
    final coloniaListAsync = ref.watch(coloniaListProvider);

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Bienvenido, ${userLoaderState.value?.firstName ?? "User"}"),
      ),
      endDrawer: const DrawerMenu(),
      body: coloniaListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text("Error al cargar las colonias: $error"),
        ),
        data: (coloniaList) {
          if (coloniaList.isEmpty) {
            return const Center(
              child: Text("No hay colonias disponibles"),
            );
          }
          return ListView.builder(
            itemCount: coloniaList.length,
            itemBuilder: (context, index) {
              final colonia = coloniaList[index];
              return ListTile(
                leading: CircleAvatar(
                    child: Icon(
                  Icons.location_on,
                  size: 20,
                  color: Theme.of(context).iconTheme.color,
                )),
                title: Text("Colonia: ${colonia.id}"),
                subtitle: Text(
                    "Número de gatos actualmente: ${colonia.cats.length}\nÚltimo comentario añadido: ${colonia.comments?.isNotEmpty == true ? colonia.comments?.last : "Sin comentarios"}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "Eliminar Colonia",
                  onPressed: () async {
                    await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Confirmar eliminación"),
                          content: const Text(
                              "¿Estás seguro de que deseas eliminar esta colonia?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Eliminar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnAddColony",
            onPressed: () async {
              final newColonia = await showAddColoniaDialog(context);
              if (newColonia != null) {
                final success = await ref
                    .read(coloniaRepositoryProvider)
                    .addNewColonia(newColonia);
                if (success) {
                  if (success) {
                    ref.invalidate(
                        coloniaListProvider); // Forzar la recarga de la lista de colonias
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Colonia agregada")),
                    );
                  }
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Error al agregar la colonia")),
                  );
                }
              }
            },
            tooltip: "Agregar Colonia",
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
