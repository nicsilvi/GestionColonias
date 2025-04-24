import 'package:autentification/app/presentation/controllers/router_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/colonia_controller.dart';
import '../menu_lateral.dart';
import 'widgets_colonia.dart';

class ColoniaDetails extends ConsumerWidget {
  static String routeName = '/colonia';

  const ColoniaDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userLoaderFutureProvider);

    return Scaffold(
      appBar: AppBar(),
      endDrawer: const DrawerMenu(),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text("Error al recuperar el user",
                  style: Theme.of(context).textTheme.bodyLarge),
            );
          }

          // Escuchar la lista de colonias
          final coloniaListAsync = ref.watch(coloniaListProvider);

          return coloniaListAsync.when(
            data: (colonias) {
              // Filtrar las colonias asignadas al usuario
              final userColonias = colonias.where((colonia) {
                return user.coloniaIds?.contains(colonia.id) ?? false;
              }).toList();

              if (userColonias.isEmpty) {
                return Center(
                  child: Text("No tienes colonias asignadas",
                      style: Theme.of(context).textTheme.bodyLarge),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Colonias Asignadas",
                            style: Theme.of(context).textTheme.headlineMedium),
                        const Spacer(),
                        Text("Añadir Visita ",
                            style: Theme.of(context).textTheme.headlineMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userColonias.length,
                      itemBuilder: (context, index) {
                        final colonia = userColonias[index];
                        return Card(
                            color: Theme.of(context).cardColor,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(colonia.id,
                                  style: Theme.of(context).textTheme.bodyLarge),
                              subtitle: Text(
                                  "Número de gatos: ${colonia.cats.length}\n"
                                  "Última visita: ${colonia.lastVisit ?? "Sin visitas"}\n"
                                  "Último comentario: ${colonia.comments?.isNotEmpty == true ? colonia.comments?.last : "Sin comentarios"}",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              trailing: IconButton(
                                icon: Icon(Icons.assignment_turned_in_outlined,
                                    size: 30,
                                    color: Theme.of(context).iconTheme.color),
                                tooltip: "Marcar colonia visitada",
                                onPressed: () async {
                                  colonia.lastVisit = DateTime.now();
                                  final comment = await showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      String? newComment;
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .dialogTheme
                                            .backgroundColor,
                                        title: Text(
                                            "¿Quieres agregar un comentario?",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                        content: SingleChildScrollView(
                                          child: TextField(
                                            onChanged: (value) {
                                              newComment = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText: "¿Cómo fue tu visita?",
                                              hintStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color, // Color del hintText
                                              ),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, "sin comentario"),
                                            child: Text("Visita sin comentario",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ),
                                          const SizedBox(height: 8),
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, newComment),
                                            child: Text("Agregar comentario",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ),
                                          const SizedBox(height: 8),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context, null),
                                            child: const Text("Cancelar"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (comment == null) {
                                    return;
                                  } else {
                                    final visitSuccess = await ref
                                        .read(coloniaRepositoryProvider)
                                        .markColoniaVisited(
                                            colonia.id, DateTime.now());

                                    if (!visitSuccess) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Error al registrar la visita")),
                                        );
                                      }
                                    } else {
                                      // Invalidar el estado para recargar la lista de colonias
                                      ref.invalidate(coloniaListProvider);

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Visita registrada exitosamente"),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                  if (comment.isNotEmpty &&
                                      comment != "sin comentario") {
                                    final success = await ref
                                        .read(coloniaRepositoryProvider)
                                        .addCommentToColonia(
                                            colonia.id, comment);
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Comentario agregado exitosamente")),
                                      );
                                      ref.invalidate(coloniaListProvider);
                                    } else if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Error al agregar el comentario")),
                                      );
                                    }
                                  }
                                },
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text("Error al cargar las colonias: $error"),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text("Error al cargar el usuario: $error"),
        ),
      ),
      floatingActionButton: userAsync.when(
        data: (user) {
          if (user == null) {
            return const SizedBox
                .shrink(); // No mostrar el botón si no hay usuario
          }
          return ColoniaFloatingButtons(user: user, ref: ref);
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => const SizedBox.shrink(),
      ),
    );
  }
}
