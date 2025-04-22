import 'package:autentification/app/presentation/views/cat_view/widgets_cat.dart';
import 'package:autentification/app/presentation/views/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/cat_controller.dart';

class CatView extends ConsumerStatefulWidget {
  const CatView({super.key});
  static String routeName = '/catView';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CatView();
  }
}

class _CatView extends ConsumerState<CatView> {
  @override
  Widget build(BuildContext context) {
    final catListAsync = ref.watch(catListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gatos'),
      ),
      endDrawer: const DrawerMenu(),
      body: catListAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text("Error al cargar los gatos: $error"),
        ),
        data: (catList) {
          if (catList.isEmpty) {
            return const Center(
              child: Text("No hay gatos disponibles"),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Dos columnas
              crossAxisSpacing: 8.0, // Espacio entre columnas
              mainAxisSpacing: 8.0, // Espacio entre filas
            ),
            itemCount: catList.length,
            itemBuilder: (context, index) {
              return GatoCard(catModel: catList[index]);
            },
          );
        },
      ),
    );
  }
}
