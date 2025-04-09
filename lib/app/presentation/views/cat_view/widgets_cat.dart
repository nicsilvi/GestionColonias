import 'package:autentification/app/domain/models/cat_model.dart';
import 'package:flutter/material.dart';

class GatoCard extends StatelessWidget {
  final CatModel catModel;

  const GatoCard({super.key, required this.catModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _mostrarDetallesGato(
            context, catModel); // Al hacer clic se muestran los detalles
      },
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    catModel.profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //const SizedBox(height: 8),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  catModel.name,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
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
                  // fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                catModel.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Edad: ${DateTime.now().year - catModel.age.year} años',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Colonia ID: ${catModel.coloniaId}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
