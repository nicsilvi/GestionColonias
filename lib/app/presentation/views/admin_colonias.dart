import 'package:autentification/app/presentation/implements/colonia_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/colonia_controller.dart';
import '../controllers/router_controller.dart';
import 'menu_lateral.dart';

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
                    "Número de gatos actualmente: ${colonia.cats.length}\nÚltimo comentario añadido: ${colonia.comments ?? "Sin comentarios"}"),
                onTap: () {
                  ref.read(selectedColoniaProvider.notifier).state = colonia;
                  // borrar colonia
                },
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Colonia agregada")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Error al agregar la colonia")),
                  );
                }
              }
            },
            child: const Icon(Icons.add),
            tooltip: "Agregar Colonia",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btnDeleteColony",
            onPressed: () async {
              // Lógica para eliminar una colonia
              final success = await ref
                  .read(coloniaRepositoryProvider)
                  .removeCatFromColonia("coloniaId", "catId");
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Colonia eliminada")),
                );
              }
            },
            child: const Icon(Icons.delete),
            tooltip: "Eliminar Colonia",
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "btnViewColony",
            onPressed: () {
              // Lógica para visualizar colonias
            },
            child: const Icon(Icons.visibility),
            tooltip: "Visualizar Colonias",
          ),
        ],
      ),
    );
  }
}
