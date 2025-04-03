import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/cat_model.dart';

class CatRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CatRepositoryImpl();

  /// Obtener todos los gatos
  Future<List<CatModel>> fetchCats() async {
    try {
      final snapshot = await _firestore.collection('gatos').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CatModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("Error al obtener los gatos: $e");
      return [];
    }
  }

  /// Agregar un nuevo gato
  Future<bool> addCat(CatModel cat) async {
    try {
      await _firestore.collection('gatos').doc(cat.id).set(cat.toJson());
      print("Gato agregado: ${cat.toJson()}");
      return true;
    } catch (e) {
      print("Error al agregar el gato: $e");
      return false;
    }
  }

  /// Actualizar un gato existente
  Future<bool> updateCat(CatModel cat) async {
    try {
      await _firestore.collection('gatos').doc(cat.id).update(cat.toJson());
      print("Gato actualizado: ${cat.toJson()}");
      return true;
    } catch (e) {
      print("Error al actualizar el gato: $e");
      return false;
    }
  }

  /// Eliminar un gato
  Future<bool> deleteCat(String catId) async {
    try {
      await _firestore.collection('gatos').doc(catId).delete();
      print("Gato eliminado: $catId");
      return true;
    } catch (e) {
      print("Error al eliminar el gato: $e");
      return false;
    }
  }

  /// Obtener un gato por ID
  Future<CatModel?> getCatById(String catId) async {
    try {
      final doc = await _firestore.collection('gatos').doc(catId).get();
      if (!doc.exists) return null;
      return CatModel.fromJson(doc.data()!);
    } catch (e) {
      print("Error al obtener el gato: $e");
      return null;
    }
  }
}
