import 'package:autentification/app/domain/models/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/cat_controller.dart';

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
        title: const Text('Colonias de Gatos'),
      ),
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
              crossAxisCount: 2, // Dos columnas
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

class GatoCard extends StatelessWidget {
  final CatModel catModel;

  GatoCard({required this.catModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _mostrarDetallesGato(
            context, catModel); // Al hacer clic se muestran los detalles
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                catModel.profileImage,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              catModel.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Función para mostrar los detalles del gato
  void _mostrarDetallesGato(BuildContext context, CatModel catModel) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  catModel.profileImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                catModel.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Edad: ${DateTime.now().year - catModel.age.year} años',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Colonia ID: ${catModel.coloniaId}',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
