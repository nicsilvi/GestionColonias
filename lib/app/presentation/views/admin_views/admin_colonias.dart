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
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final titleColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bienvenido, ${userLoaderState.value?.firstName ?? "User"}",
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      endDrawer: const DrawerMenu(),
      body: coloniaListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(
            "Error al cargar las colonias: $error",
            style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        data: (coloniaList) {
          if (coloniaList.isEmpty) {
            return Center(
              child: Text(
                "No hay colonias disponibles",
                style: TextStyle(color: textColor),
              ),
            );
          }
          return ListView.builder(
            itemCount: coloniaList.length,
            itemBuilder: (context, index) {
              final colonia = coloniaList[index];
              return Card(
                color: Theme.of(context).colorScheme.secondary,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .unselectedWidgetColor, //poner algo mas transparente?
                      child: Icon(
                        Icons.location_on,
                        size: 20,
                        color: Theme.of(context).iconTheme.color,
                      )),
                  title: Text(
                    "Colonia: ${colonia.id}",
                    style: TextStyle(
                        color: titleColor, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Número de gatos actualmente: ${colonia.cats.length}\nÚltimo comentario añadido: ${colonia.comments?.isNotEmpty == true ? colonia.comments?.last : "Sin comentarios"}",
                    style: TextStyle(color: textColor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: "Eliminar Colonia",
                    onPressed: () async {
                      final confirmDelete = await showDialog<bool>(
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
                      if (confirmDelete == true) {
                        // Llamar al repositorio para eliminar la colonia
                        final success = await ref
                            .read(coloniaRepositoryProvider)
                            .deleteColonia(colonia.id);
                        if (success) {
                          // Invalidar el estado de la lista de colonias para recargar
                          ref.invalidate(coloniaListProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Colonia eliminada exitosamente")),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Error al eliminar la colonia")),
                            );
                          }
                        }
                      }
                    },
                  ),
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
