import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/cat_model.dart';
import '../../controllers/cat_controller.dart';
import '../../controllers/colonia_controller.dart';

void moveCat(BuildContext context, CatModel cat, WidgetRef ref) async {
  // Mostrar un diálogo para seleccionar la colonia de destino
  final coloniaListAsync = ref.watch(coloniaListProvider);

  final toColoniaId = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: const Text("Seleccionar Colonia de Destino"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.8,
          child: coloniaListAsync.when(
            data: (colonias) {
              return ListView.builder(
                itemCount: colonias.length,
                itemBuilder: (context, index) {
                  final colonia = colonias[index];
                  return ListTile(
                    title: Text(colonia.id,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color)),
                    onTap: () {
                      Navigator.of(context).pop(colonia.id);
                    },
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text("Error al cargar colonias: $error"),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null), // Cancelar
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop("colonia_destino_id");
            },
            child: const Text("Aceptar"),
          ),
        ],
      );
    },
  );

  if (toColoniaId == null) {
    // El usuario canceló la selección
    return;
  }

  final success = await ref
      .read(catRepositoryProvider)
      .moveCatToAnotherColonia(cat.coloniaId, toColoniaId, cat);

  print("llegamos aqui?");
  print("Gato movido: $success");
  print("Gato: ${cat.toJson()}");
  print("Colonia de destino: $toColoniaId");
  print("Colonia de origen: ${cat.coloniaId}");

  if (success) {
    const SnackBar(content: Text("Gato movido exitosamente"));

    ref.invalidate(coloniaListProvider);
    ref.invalidate(catListProvider);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al mover el gato")),
      );
    }
  }
}
