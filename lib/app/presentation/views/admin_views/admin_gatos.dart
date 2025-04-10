import 'package:autentification/app/domain/models/cat_model.dart';
import 'package:autentification/app/presentation/views/admin_views/widgets_admin_cats.dart';
import 'package:autentification/app/presentation/views/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/cat_controller.dart';
import '../../controllers/colonia_controller.dart';

class AdminGatos extends ConsumerStatefulWidget {
  const AdminGatos({super.key});
  static String routeName = '/adminGatos';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AdminGatosState();
  }
}

class _AdminGatosState extends ConsumerState<AdminGatos> {
  @override
  Widget build(BuildContext context) {
    final catListAsync = ref.watch(catListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colonias de Gatos'),
      ),
      endDrawer: const DrawerMenu(),
      body: catListAsync.when(
        data: (catList) {
          if (catList.isEmpty) {
            return const Center(child: Text("No hay gatos disponibles"));
          }
          return ListView.builder(
            itemCount: catList.length,
            itemBuilder: (context, index) {
              final cat = catList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del gato
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            cat.profileImage,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 150);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Información del gato
                        Text(
                          cat.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Edad: ${DateTime.now().year - cat.age.year} años',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Colonia ID: ${cat.coloniaId}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Confirmar eliminación"),
                                      content: const Text(
                                          "¿Estás seguro de que deseas eliminar este gato?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Eliminar"),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  // Eliminar el gato
                                  final success = await ref
                                      .read(catRepositoryProvider)
                                      .deleteCat(cat.id);

                                  if (success) {
                                    // Si el gato pertenece a una colonia, actualizar la colonia
                                    if (cat.coloniaId != null) {
                                      await ref
                                          .read(coloniaRepositoryProvider)
                                          .removeCatFromColonia(
                                              cat.coloniaId!, cat.id);
                                      ref.invalidate(coloniaListProvider);
                                    }

                                    // Mostrar mensaje de éxito
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Gato eliminado exitosamente")),
                                    );
                                    ref.invalidate(catListProvider);
                                  } else {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Error al eliminar el gato")),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text("Borrar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Lógica para agregar información
                                //_addInfo(context, cat);
                              },
                              icon: const Icon(Icons.info),
                              label: const Text("Agregar Info"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Lógica para mover de colonia
                                // _moveCat(context, cat);
                              },
                              icon: const Icon(Icons.swap_horiz),
                              label: const Text("Mover de colonia"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text("Error al cargar los gatos: $error"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Mostrar el diálogo para agregar un nuevo gato
          final newCat = await showDialog<CatModel>(
            context: context,
            builder: (context) => const AddCatDialog(),
          );

          if (newCat != null) {
            final success =
                await ref.read(catRepositoryProvider).addCat(newCat);
            if (success) {
              // Si el gato tiene una colonia asociada, actualizar la colonia
              if (newCat.coloniaId != null) {
                await ref
                    .read(coloniaRepositoryProvider)
                    .addCatToColonia(newCat.coloniaId!, newCat.id);

                // Invalidar el proveedor de colonias para actualizar la lista
                ref.invalidate(coloniaListProvider);
              }

              // Mostrar mensaje de éxito
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gato agregado exitosamente")),
              );

              // Invalidar el proveedor de gatos para actualizar la lista
              ref.invalidate(catListProvider);
            } else {
              // Mostrar mensaje de error
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error al agregar el gato")),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
