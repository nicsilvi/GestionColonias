import 'package:autentification/app/presentation/controllers/colonia_controller.dart';
import 'package:autentification/app/presentation/shared/utils.dart'
    show preSelectImageCat;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autentification/app/domain/models/cat_model.dart';

class AddCatDialog extends ConsumerStatefulWidget {
  const AddCatDialog({super.key});

  @override
  ConsumerState<AddCatDialog> createState() => _AddCatDialogState();
}

class _AddCatDialogState extends ConsumerState<AddCatDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? imagePath;
  String? selectedColoniaId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Agregar Nuevo Gato"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nombre del Gato"),
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(labelText: "Edad del Gato"),
            keyboardType: TextInputType.number,
          ),
          Consumer(
            builder: (context, ref, child) {
              final coloniaListAsync = ref.watch(coloniaListProvider);
              return coloniaListAsync.when(
                data: (colonias) {
                  return DropdownButton<String>(
                    value: selectedColoniaId,
                    hint: const Text("Selecciona una colonia"),
                    items: [
                      // Opción para "Sin colonia"
                      const DropdownMenuItem<String>(
                        value: "sin_colonia",
                        child: Text("Sin colonia"),
                      ),
                      // Opciones de colonias existentes
                      ...colonias.map((colonia) {
                        return DropdownMenuItem<String>(
                          value: colonia.id,
                          child: Text(colonia.id),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      selectedColoniaId = value;
                    },
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text("Error: $error"),
              );
            },
          ),
          TextButton.icon(
            onPressed: () async {
              final selectedImage = await preSelectImageCat(context);
              if (selectedImage != null) {
                setState(() {
                  imagePath = selectedImage; // Guardar la imagen seleccionada
                });
              }
            },
            icon: const Icon(Icons.folder_open),
            label: const Text("Seleccionar Imagen"),
          ),
          if (imagePath != null)
            Image.asset(
              imagePath!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            final name = nameController.text.trim();
            final age = int.tryParse(ageController.text.trim()) ?? 0;

            if (name.isNotEmpty) {
              final newCat = CatModel(
                id: DateTime.now().toString(), // Generar un ID único
                name: name,
                coloniaId: selectedColoniaId == "sin_colonia"
                    ? null
                    : selectedColoniaId,
                age: DateTime(DateTime.now().year - age),
                profileImage: imagePath ?? '',
              );
              Navigator.pop(context, newCat);
            }
          },
          child: const Text("Agregar"),
        ),
      ],
    );
  }
}
