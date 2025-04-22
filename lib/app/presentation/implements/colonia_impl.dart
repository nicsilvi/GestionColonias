import 'package:autentification/app/presentation/shared/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/models/colonia_model.dart';

class ColoniaRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ColoniaRepositoryImpl();

  /// Obtener todas las colonias
  Future<List<ColoniaModel>> fetchColonias() async {
    try {
      final snapshot = await _firestore.collection('colonias').get();
      print(
          "Datos obtenidos de Firebase: ${snapshot.docs.map((doc) => doc.data()).toList()}");
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ColoniaModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error al obtener las colonias: $e");
      return [];
    }
  }

  /// Agregar un nuevo gato a una colonia
  Future<bool> addCatToColonia(String coloniaId, String catId) async {
    try {
      final docRef = _firestore.collection('colonias').doc(coloniaId);
      await docRef.update({
        'catIds': FieldValue.arrayUnion([catId]),
        'numberOfCats': FieldValue.increment(1),
      });
      print("Gato $catId agregado a la colonia $coloniaId");
      return true;
    } catch (e) {
      print("Error al agregar el gato a la colonia: $e");
      return false;
    }
  }

  Future<bool> deleteColonia(String coloniaId) async {
    try {
      final coloniaRef = _firestore.collection('colonias').doc(coloniaId);
      final coloniaSnapshot = await coloniaRef.get();
      if (!coloniaSnapshot.exists) {
        print("La colonia no existe: $coloniaId");
        return false;
      }

      final List<String> catIds =
          List<String>.from(coloniaSnapshot.data()?['cats'] ?? []);

      // Actualizar los gatos para que pasen a "sin colonia"
      for (final catId in catIds) {
        final catRef = _firestore.collection('gatos').doc(catId);
        await catRef.update({'coloniaId': null});
      }
      await coloniaRef.delete();
      print("Colonia eliminada: $coloniaId");
      return true;
    } catch (e) {
      print("Error al eliminar la colonia: $e");
      return false;
    }
  }

  /// Borrar un gato de una colonia
  Future<bool> removeCatFromColonia(String coloniaId, String catId) async {
    try {
      final docRef = _firestore.collection('colonias').doc(coloniaId);
      await docRef.update({
        'catIds': FieldValue.arrayRemove([catId]),
        'numberOfCats': FieldValue.increment(-1),
      });
      print("Gato $catId eliminado de la colonia $coloniaId");
      return true;
    } catch (e) {
      print("Error al eliminar el gato de la colonia: $e");
      return false;
    }
  }

  /// Añadir un comentario a una colonia
  Future<bool> addCommentToColonia(String coloniaId, String comment) async {
    try {
      final docRef = _firestore.collection('colonias').doc(coloniaId);
      await docRef.update({
        'comments': FieldValue.arrayUnion([comment]),
      });
      print("Comentario agregado a la colonia $coloniaId");
      return true;
    } catch (e) {
      print("Error al agregar el comentario a la colonia: $e");
      return false;
    }
  }

  /// Añadir nueva colonia
  Future<bool> addNewColonia(ColoniaModel colonia) async {
    try {
      final docRef = _firestore.collection('colonias').doc(colonia.id);
      await docRef.set(colonia.toJson());
      print("Nueva colonia agregada: ${colonia.id}");
      return true;
    } catch (e) {
      print("Error al agregar la nueva colonia: $e");
      return false;
    }
  }

  Future<bool> assignColoniaToUser(String userId, String coloniaId) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.update({
        'coloniaIds':
            FieldValue.arrayUnion([coloniaId]), // Agregar el ID de la colonia
      });

      return true;
    } catch (e) {
      print("Error al asignar la colonia al usuario: $e");
      return false;
    }
  }

  Future<bool> removeColoniaToUser(String userId, String coloniaId) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.update({
        'coloniaIds': FieldValue.arrayRemove([coloniaId]),
      });

      return true;
    } catch (e) {
      print("Error al eliminar la colonia al usuario: $e");
      return false;
    }
  }

  /// Actualizar el número de gatos manualmente
  Future<bool> updateNumberOfCats(String coloniaId, int newNumber) async {
    try {
      final docRef = _firestore.collection('colonias').doc(coloniaId);
      await docRef.update({
        'numberOfCats': newNumber,
      });
      print("Número de gatos actualizado en la colonia $coloniaId");
      return true;
    } catch (e) {
      print("Error al actualizar el número de gatos: $e");
      return false;
    }
  }

  /// Obtener una colonia por ID
  Future<ColoniaModel?> getColoniaById(String coloniaId) async {
    try {
      final doc = await _firestore.collection('colonias').doc(coloniaId).get();
      if (!doc.exists) return null;
      return ColoniaModel.fromJson(doc.data()!);
    } catch (e) {
      print("Error al obtener la colonia: $e");
      return null;
    }
  }

  Future<bool> markColoniaVisited(String coloniaId, DateTime visitDate) async {
    try {
      final doc = _firestore.collection('colonias').doc(coloniaId);
      await doc.update({
        'lastVisit':
            Timestamp.fromDate(visitDate), // Guardar la fecha en formato ISO
      });
      print("Última visita registrada para la colonia $coloniaId");
      return true;
    } catch (e) {
      print("Error al registrar la última visita: $e");
      return false;
    }
  }
}

Future<ColoniaModel?> showAddColoniaDialog(BuildContext context) async {
  final idController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  return showDialog<ColoniaModel>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Agregar Nueva Colonia"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration:
                    const InputDecoration(labelText: "ID de la Colonia"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Dirección"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final id = idController.text.trim();
              final description = descriptionController.text.trim();
              final address = addressController.text.trim();
              //ToDo: address para obtener coordenadas o que directamente se pongan?

              if (id.isEmpty || description.isEmpty || address.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Por favor, completa todos los campos")),
                );
                return;
              }

              final coordinates = await getCoordinatesFromAddress(address);
              if (coordinates == null) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("No se pudo obtener la ubicación")),
                );
                return;
              }

              final newColonia = ColoniaModel(
                id: id,
                createdAt: DateTime.now(),
                description: description,
                address: address,
                location: GeoPoint(coordinates.latitude, coordinates.longitude),
                cats: [],
                comments: [],
              );
              if (!context.mounted) return;
              Navigator.pop(context, newColonia);
            },
            child: const Text("Agregar"),
          ),
        ],
      );
    },
  );
}
