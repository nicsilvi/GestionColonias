import 'package:autentification/app/domain/models/cat_model.dart';
import 'package:autentification/app/presentation/views/admin_views/widgets_admin_cats.dart';
import 'package:autentification/app/presentation/views/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/cat_controller.dart';
import '../../controllers/colonia_controller.dart';
import '../../shared/utils.dart';
import 'widgets2_admin_gatos.dart';

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
          title: Text(
        'Colonias de Gatos',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      )),
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Alinear el texto en la parte inferior
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              cat.profileImage,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    size: 150);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Theme.of(context).colorScheme.secondary),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              capitalize(cat.name),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.color,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Card(
                        elevation: 4,
                        color: Theme.of(context).colorScheme.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Información del gato
                              const Text(
                                "Ficha:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1, // Ocupa la mitad del espacio
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Edad: ${DateTime.now().year - cat.age.year} años',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Colonia ID: ${cat.coloniaId}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Sexo: ${cat.sexo}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 8),
                                        ]),
                                  ),
                                  Expanded(
                                    flex: 1, // Ocupa la otra mitad del espacio
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '¿Castrado?: ${cat.castrado == null ? "Sin especificar" : (cat.castrado! ? "Sí" : "No")}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '¿Vacunado?: ${cat.vacunado == null ? "Sin especificar" : (cat.vacunado! ? "Sí" : "No")}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Último comentario: ${cat.comments?.isNotEmpty == true ? cat.comments?.last : "Sin comentarios"}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Botones de acción
                              Wrap(
                                spacing:
                                    8.0, // Espaciado horizontal entre botones
                                runSpacing: 8.0,
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context)
                                                .dialogTheme
                                                .backgroundColor,
                                            title: Text("Confirmar eliminación",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge),
                                            content: const Text(
                                                "¿Estás seguro de que deseas eliminar este gato?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text(
                                                  "Cancelar",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text(
                                                  "Eliminar",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Gato eliminado exitosamente")),
                                          );
                                          ref.invalidate(catListProvider);
                                        } else {
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Error al eliminar el gato")),
                                          );
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.black),
                                    label: const Text(
                                      "Borrar",
                                      style: TextStyle(color: Colors.black),
                                    ),
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
                                      moveCat(context, cat, ref);
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
                    ),
                  ],
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
