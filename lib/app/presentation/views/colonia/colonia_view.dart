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
      appBar: AppBar(
        title: const Text("Colonias Asignadas"),
      ),
      endDrawer: const DrawerMenu(),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text("Error al recuperar el user"),
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
                return const Center(
                  child: Text("No tienes colonias asignadas"),
                );
              }

              return ListView.builder(
                itemCount: userColonias.length,
                itemBuilder: (context, index) {
                  final colonia = userColonias[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Theme.of(context).primaryColorLight,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.pets,
                          color: Theme.of(context).iconTheme.color, size: 30),
                      title: Text(
                        "Colonia: ${colonia.id}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      subtitle: Text(
                        "Número de gatos: ${colonia.cats.length}",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.comment, color: Color(0xFFD81B60)),
                        tooltip: "Agregar comentario",
                        onPressed: () async {
                          final comment = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              String? newComment;
                              return AlertDialog(
                                title: const Text("Agregar Comentario"),
                                content: TextField(
                                  onChanged: (value) {
                                    newComment = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Escribe tu comentario aquí",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, null),
                                    child: const Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, newComment),
                                    child: const Text("Agregar"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (comment != null && comment.isNotEmpty) {
                            final success = await ref
                                .read(coloniaRepositoryProvider)
                                .addCommentToColonia(colonia.id, comment);
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Comentario agregado exitosamente")),
                              );
                              ref.invalidate(coloniaListProvider);
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Error al agregar el comentario")),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
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
