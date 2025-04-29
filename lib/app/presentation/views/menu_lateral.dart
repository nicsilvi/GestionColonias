import 'package:autentification/app/core/constants/colors.dart';
import 'package:autentification/app/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/theme_controller.dart';

class DrawerMenu extends ConsumerWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeService = ref.watch(
        themeControllerProvider); // es watch pq se reconstruye este mismo widget

    return Drawer(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Menú",
                        style: TextStyle(
                            color: themeService
                                ? Theme.of(context).colorScheme.onPrimary
                                : AppColors.accent,
                            fontSize: 20)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.person,
                    color: Theme.of(context).iconTheme.color),
                title: Text("Mi Perfil",
                    style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  //ir al profileview
                  context.pop();
                  context.goNamed("/profile");
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.settings,
                    color: Theme.of(context).iconTheme.color),
                title: Text("Settings",
                    style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  context.pop();
                  //ir a la vista de settings
                  print("settings button");
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(themeService ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).iconTheme.color),
                title: Text(themeService ? "Modo claro" : "Modo oscuro",
                    style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  context.pop();
                  ref.read(themeControllerProvider.notifier).updateTheme();
                  print("thema ahora es: ${ref.read(themeControllerProvider)}");
                },
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              ListTile(
                leading: Icon(Icons.logout,
                    color: Theme.of(context).iconTheme.color),
                title: Text("Cerrar sesión",
                    style: Theme.of(context).textTheme.bodyLarge),
                onTap: () async {
                  if (!context.mounted) return;
                  print("cerrar sesion");
                  await ref.read(authenticationRepositoryProvider).signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
