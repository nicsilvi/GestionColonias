import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/cat_model.dart';
import '../implements/cats_impl.dart';

final catRepositoryProvider = Provider<CatRepositoryImpl>(
  (ref) => CatRepositoryImpl(),
);

final catListProvider = FutureProvider<List<CatModel>>((ref) async {
  final catRepository = ref.watch(catRepositoryProvider);
  return await catRepository.fetchCats();
});

final selectedCatProvider = StateProvider<CatModel?>((ref) => null);

class CatResponse {
  final CatModel? cat;
  final String? errorMessage;

  CatResponse({this.cat, this.errorMessage});
}

abstract class CatRepository {
  Future<List<CatModel>> fetchCats();
  Future<bool> addCat(CatModel cat);
  Future<bool> updateCat(CatModel cat);
  Future<bool> deleteCat(String catId);
  Future<bool> addCatComment(String catId, String comment);
  Future<CatModel?> getCatById(String catId);
  Future<bool> moveCatToAnotherColonia(
      String fromColoniaId, String toColoniaId, String catId);
}
