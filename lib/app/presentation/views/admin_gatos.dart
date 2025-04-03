import 'package:autentification/app/domain/models/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cat_controller.dart';

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
                            fit: BoxFit.cover,
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
                              onPressed: () {
                                // Lógica para borrar el gato
                                _deleteCat(context, cat.id);
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
                                _addInfo(context, cat);
                              },
                              icon: const Icon(Icons.info),
                              label: const Text("Agregar Info"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Lógica para mover de colonia
                                _moveCat(context, cat);
                              },
                              icon: const Icon(Icons.swap_horiz),
                              label: const Text("Mover Colonia"),
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
        onPressed: () {
          // Lógica para agregar un nuevo gato
          Navigator.pushNamed(context, '/addCat');
        },
        child: const Icon(Icons.add),
        tooltip: "Agregar Gato",
      ),
    );
  }

  // Función para borrar un gato
  void _deleteCat(BuildContext context, String catId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Estás seguro de que deseas borrar este gato?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              // Aquí iría la lógica para borrar el gato de Firebase
              print("Gato con ID $catId borrado");
              Navigator.pop(context);
            },
            child: const Text("Borrar"),
          ),
        ],
      ),
    );
  }

  // Función para agregar información al gato
  void _addInfo(BuildContext context, CatModel cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar Información"),
        content: TextField(
          decoration: const InputDecoration(
            labelText: "Nueva información",
          ),
          onSubmitted: (value) {
            // Aquí iría la lógica para agregar información al gato en Firebase
            print("Información agregada al gato ${cat.name}: $value");
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  // Función para mover un gato de colonia
  void _moveCat(BuildContext context, CatModel cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mover de Colonia"),
        content: TextField(
          decoration: const InputDecoration(
            labelText: "Nueva Colonia ID",
          ),
          onSubmitted: (value) {
            // Aquí iría la lógica para mover el gato de colonia en Firebase
            print("Gato ${cat.name} movido a la colonia $value");
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }
}
