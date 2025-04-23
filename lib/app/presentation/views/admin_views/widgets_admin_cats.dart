import 'package:autentification/app/presentation/controllers/colonia_controller.dart';
import 'package:autentification/app/presentation/shared/utils.dart'
    show capitalize, preSelectImageCat;
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
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      title: Text(
        "Agregar Nuevo Gato",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              decoration: InputDecoration(
                labelText: "Nombre",
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ageController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              decoration: InputDecoration(
                labelText: "Edad",
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedSexo,
              hint: Text(
                "Sexo",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              dropdownColor: Theme.of(context).textTheme.bodySmall?.color,
              items: [
                DropdownMenuItem(
                    value: "Macho",
                    child: Text(
                      "Macho",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )),
                DropdownMenuItem(
                    value: "Hembra",
                    child: Text(
                      "Hembra",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )),
                DropdownMenuItem(
                    value: "No especificado",
                    child: Text(
                      "No especificado",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  selectedSexo = value;
                });
              },
            ),
            DropdownButton<String>(
              value: castrado == null ? null : (castrado == true ? "Sí" : "No"),
              hint: Text(
                "¿Está castrado?",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              dropdownColor: Theme.of(context).textTheme.bodySmall?.color,
              items: [
                DropdownMenuItem(
                    value: "Sí",
                    child: Text(
                      "Sí",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )),
                DropdownMenuItem(
                    value: "No",
                    child: Text(
                      "No",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )),
                DropdownMenuItem(
                    value: "No especificado",
                    child: Text(
                      "No especificado",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )),
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
              hint: Text(
                "¿Está vacunado?",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              dropdownColor: Theme.of(context).textTheme.bodySmall?.color,
              items: [
                DropdownMenuItem(
                  value: "Sí",
                  child: Text(
                    "Sí",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: "No",
                  child: Text(
                    "No",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                DropdownMenuItem(
                    value: "No especificado",
                    child: Text(
                      "No especificado",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    )),
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
                      hint: Text(
                        "¿Tiene colonia?",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      dropdownColor:
                          Theme.of(context).textTheme.bodySmall?.color,
                      items: [
                        // Opciones de colonias existentes
                        ...colonias.map((colonia) {
                          return DropdownMenuItem<String>(
                            value: colonia.id,
                            child: Text(
                              capitalize(colonia.id),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color),
                            ),
                          );
                        }),
                        // Opción para "Sin colonia"
                        DropdownMenuItem<String>(
                          value: "sin_colonia",
                          child: Text(
                            "Sin colonia",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedColoniaId = value;
                        });
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
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              decoration: InputDecoration(
                labelText: "Descripción",
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
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
              label: Text(
                "Seleccionar Imagen",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            "Cancelar",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
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
          child: Text(
            "Agregar",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
