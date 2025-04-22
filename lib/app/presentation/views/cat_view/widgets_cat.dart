import 'package:autentification/app/domain/models/cat_model.dart';
import 'package:autentification/app/presentation/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:autentification/app/presentation/views/cat_view/widgets2_cat.dart';

class GatoCard extends ConsumerWidget {
  final CatModel catModel;

  const GatoCard({super.key, required this.catModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTap: () {
          _mostrarDetallesGato(
              context, catModel); // Al hacer clic se muestran los detalles
        },
        child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Card(
              color: Theme.of(context).colorScheme.primary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Espaciado entre los elementos
                      children: [
                        Expanded(
                          child: Text(
                            capitalize(catModel.name),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogoComentario(context, catModel, ref);
                          },
                          icon: const Icon(Icons.comment),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  // Función para mostrar los detalles del gato
  void _mostrarDetallesGato(BuildContext context, CatModel catModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
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
                  capitalize(catModel.name),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900),
                ),
                Text(
                  catModel.descripcion ?? "",
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
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
                const SizedBox(height: 8),
                Text(
                  'Sexo: ${catModel.sexo}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Castrado?: ${catModel.castrado == null ? "Sin especificar" : (catModel.castrado! ? "Sí" : "No")}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '¿Vacunado?: ${catModel.vacunado == null ? "Sin especificar" : (catModel.vacunado! ? "Sí" : "No")}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Último comentario: ${catModel.comments?.isNotEmpty == true ? catModel.comments?.last : "Sin comentarios"}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
