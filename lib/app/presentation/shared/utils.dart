import 'package:autentification/app/core/constants/assets.dart';
import 'package:autentification/app/presentation/controllers/router_controller.dart';
import 'package:autentification/app/presentation/shared/firebase_util.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<LatLng?> getCoordinatesFromAddress(String address) async {
  final String url =
      'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&addressdetails=1&limit=1';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'flutter_map_app', // Nominatim requiere un User-Agent
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final location = data[0];
        final double latitude = double.parse(location['lat']);
        final double longitude = double.parse(location['lon']);
        return LatLng(latitude, longitude);
      }
    }
  } catch (e) {
    print("Error al obtener las coordenadas: $e");
  }
  return null;
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

Future<void> pickAndSelectImage(
    BuildContext context, String userId, dynamic ref) async {
  try {
    await showDialog(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: AlertDialog(
            title: const Text("Selecciona una imagen de perfil"),
            content: SizedBox(
              height: MediaQuery.of(context).size.width * 0.3,
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      // Cuando el usuario selecciona una imagen
                      final selectedImage = images[index];
                      Navigator.of(context).pop();
                      try {
                        final userLoader = ref.read(userLoaderFutureProvider);
                        await manageImageInFirestore(
                            userId: userId, imageUrl: selectedImage);
                        if (context.mounted) {
                          print(
                              "despues de manageImageFirestore, ${userLoader.value?.profileImage}\n");
                        }

                        print("Imagen seleccionada: $selectedImage");
                      } catch (e) {
                        debugPrint("Error al seleccionar la imagen: $e");
                      }
                    },
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  } catch (e) {
    debugPrint("Error al seleccionar la imagen: $e");
  }
}

Future<String?> preSelectImageCat(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Seleccionar Imagen"),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Número de columnas
              crossAxisSpacing: 8.0, // Espaciado horizontal
              mainAxisSpacing: 8.0, // Espaciado vertical
            ),
            itemCount: preselectedImages.length,
            itemBuilder: (context, index) {
              final imagePath = preselectedImages[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(
                      context, imagePath); // Retornar la imagen seleccionada
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("Cancelar"),
          ),
        ],
      );
    },
  );
}
