import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/colonia_model.dart';
import '../implements/colonia_impl.dart';

final coloniaRepositoryProvider = Provider<ColoniaRepositoryImpl>(
  (ref) => ColoniaRepositoryImpl(),
);

final coloniaListProvider = FutureProvider<List<ColoniaModel>>((ref) async {
  final coloniaRepository = ref.watch(coloniaRepositoryProvider);
  return await coloniaRepository.fetchColonias();
});

final selectedColoniaProvider = StateProvider<ColoniaModel?>((ref) => null);

class ColoniaResponse {
  final ColoniaModel? colonia;
  final String? errorMessage;

  ColoniaResponse({this.colonia, this.errorMessage});
}

abstract class ColoniaRepository {
  Future<List<ColoniaModel>> fetchColonias();
  Future<bool> addCatToColonia(String coloniaId, String catId);
  Future<bool> deleteColonia(String coloniaId);
  Future<bool> assignColoniaToUser(String userId, String coloniaId);
  Future<bool> removeCatFromColonia(String coloniaId, String catId);
  Future<bool> addCommentToColonia(String coloniaId, String comment);
  Future<bool> addNewColonia(String coloniaId, String? comment);
  Future<bool> markColoniaVisited(String coloniaId, DateTime visitDate);
  Future<bool> updateNumberOfCats(String coloniaId, int newNumber);
  Future<ColoniaModel?> getColoniaById(String coloniaId);
}
