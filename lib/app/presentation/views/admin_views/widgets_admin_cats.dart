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
  final TextEditingController descripcionController = TextEditingController();
  String? selectedSexo;
  bool? castrado;
  bool? vacunado;
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
            decoration: const InputDecoration(labelText: "Nombre"),
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(labelText: "Edad"),
            keyboardType: TextInputType.number,
          ),
          DropdownButton<String>(
            value: selectedSexo,
            hint: const Text("Sexo"),
            items: const [
              DropdownMenuItem(value: "Macho", child: Text("Macho")),
              DropdownMenuItem(value: "Hembra", child: Text("Hembra")),
              DropdownMenuItem(
                  value: "No especificado", child: Text("No especificado")),
            ],
            onChanged: (value) {
              setState(() {
                selectedSexo = value;
              });
            },
          ),
          DropdownButton<String>(
            value: castrado == null ? null : (castrado == true ? "Sí" : "No"),
            hint: const Text("¿Está castrado?"),
            items: const [
              DropdownMenuItem(value: "Sí", child: Text("Sí")),
              DropdownMenuItem(value: "No", child: Text("No")),
              DropdownMenuItem(
                  value: "No especificado", child: Text("No especificado")),
            ],
            onChanged: (value) {
              setState(() {
                if (value == "Sí") {
                  castrado = true;
                } else if (value == "No") {
                  castrado = false;
                } else {
                  castrado = null;
                }
              });
            },
          ),
          DropdownButton<String>(
            value: vacunado == null ? null : (vacunado == true ? "Sí" : "No"),
            hint: const Text("¿Está vacunado?"),
            items: const [
              DropdownMenuItem(value: "Sí", child: Text("Sí")),
              DropdownMenuItem(value: "No", child: Text("No")),
              DropdownMenuItem(
                  value: "No especificado", child: Text("No especificado")),
            ],
            onChanged: (value) {
              setState(() {
                if (value == "Sí") {
                  vacunado = true;
                } else if (value == "No") {
                  vacunado = false;
                } else {
                  vacunado = null;
                }
              });
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final coloniaListAsync = ref.watch(coloniaListProvider);
              return coloniaListAsync.when(
                data: (colonias) {
                  return DropdownButton<String>(
                    value: selectedColoniaId,
                    hint: const Text("¿Tiene colonia?"),
                    items: [
                      // Opciones de colonias existentes
                      ...colonias.map((colonia) {
                        return DropdownMenuItem<String>(
                          value: colonia.id,
                          child: Text(colonia.id),
                        );
                      }),
                      // Opción para "Sin colonia"
                      const DropdownMenuItem<String>(
                        value: "sin_colonia",
                        child: Text("Sin colonia"),
                      ),
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
          TextField(
            controller: descripcionController,
            decoration: const InputDecoration(labelText: "Descripción"),
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
            final descripcion = descripcionController.text.trim();

            if (name.isNotEmpty) {
              final newCat = CatModel(
                id: DateTime.now().toString(), // Generar un ID único
                name: name,
                coloniaId: selectedColoniaId == "sin_colonia"
                    ? null
                    : selectedColoniaId,
                castrado: castrado,
                vacunado: vacunado,
                sexo: selectedSexo ?? "Macho",
                descripcion: descripcion.isNotEmpty ? descripcion : null,
                age: DateTime(DateTime.now().year - age),
                comments: [],
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
