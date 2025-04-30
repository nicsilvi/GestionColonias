import 'package:autentification/app/presentation/controllers/colonia_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/cat_model.dart';
import '../../controllers/cat_controller.dart';

void dialogoComentario(BuildContext context, CatModel catModel, WidgetRef ref) {
  final TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Agregar comentario"),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: "Escribe tu comentario aquí",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el diálogo sin guardar
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final comment = commentController.text.trim();
              if (comment.isNotEmpty) {
                // Llamar al método del repositorio para agregar el comentario
                final success = await ref
                    .read(catRepositoryProvider)
                    .addCatComment(catModel.id, comment);

                if (context.mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Comentario agregado")),
                    );

                    ref.invalidate(coloniaListProvider);
                    ref.invalidate(catListProvider);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Error al agregar el comentario")),
                    );
                  }
                }
              }
            },
            child: const Text("Agregar"),
          ),
        ],
      );
    },
  );
}
