import 'package:autentification/app/core/constants/assets.dart';
import 'package:autentification/app/presentation/shared/firebase_util.dart';
import 'package:flutter/material.dart';

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

Future<void> pickAndSelectImage(BuildContext context, String userId) async {
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
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      // Cuando el usuario selecciona una imagen
                      final selectedImage = images[index];
                      try {
                        await manageImageInFirestore(
                            userId: userId, imageUrl: selectedImage);
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
