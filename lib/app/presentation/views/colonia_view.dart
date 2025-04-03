import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/colonia_model.dart';
import '../controllers/colonia_controller.dart';

class ColoniaDetails extends ConsumerWidget {
  final ColoniaModel colonia;
  static String routeName = '/colonia';

  const ColoniaDetails({required this.colonia, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de ${colonia.id}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar la localización
            Text(
              "Localización:",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Latitud: ${colonia.location.latitude}, Longitud: ${colonia.location.longitude}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Mostrar la lista de gatos
            Text(
              "Lista de Gatos:",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (colonia.cats.isEmpty)
              const Text("No hay gatos en esta colonia actualmente."),
            if (colonia.cats.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: colonia.cats.length,
                  itemBuilder: (context, index) {
                    final catId = colonia.cats[index];
                    return ListTile(
                      leading: const Icon(Icons.pets),
                      title: Text("Gato ID: $catId"),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Mostrar comentarios antiguos
            Text(
              "Comentarios:",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (colonia.comments?.isEmpty ?? true)
              const Text("No hay comentarios para esta colonia."),
            if (colonia.comments?.isNotEmpty ?? false)
              Expanded(
                child: ListView.builder(
                  itemCount: colonia.comments?.length,
                  itemBuilder: (context, index) {
                    final comment = colonia.comments?[index] ?? '';
                    return ListTile(
                      leading: const Icon(Icons.comment),
                      title: Text(comment),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Botones para agregar/quitar gatos y agregar comentarios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // Lógica para agregar un gato
                    final newCatId = await _showAddCatDialog(context);
                    if (newCatId != null) {
                      final success = await ref
                          .read(coloniaRepositoryProvider)
                          .addCatToColonia(colonia.id, newCatId);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Gato agregado")),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar Gato"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Lógica para quitar un gato
                    final catIdToRemove = await _showRemoveCatDialog(context);
                    if (catIdToRemove != null) {
                      final success = await ref
                          .read(coloniaRepositoryProvider)
                          .removeCatFromColonia(colonia.id, catIdToRemove);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Gato eliminado")),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text("Quitar Gato"),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Lógica para agregar un comentario
                    final newComment = await _showAddCommentDialog(context);
                    if (newComment != null) {
                      final success = await ref
                          .read(coloniaRepositoryProvider)
                          .addCommentToColonia(colonia.id, newComment);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Comentario agregado")),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.comment),
                  label: const Text("Agregar Comentario"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showAddCatDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Gato"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "ID del Gato"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showRemoveCatDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Quitar Gato"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "ID del Gato"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text("Quitar"),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showAddCommentDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Comentario"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Comentario"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }
}
