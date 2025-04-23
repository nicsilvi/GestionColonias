import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../core/constants/assets.dart';
import '../controllers/auth_controller.dart';

class Register extends ConsumerWidget {
  const Register({super.key});
  static var routeName = '/register';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final state = ref.watch(authenticationRepositoryProvider);
    final authNotifier = ref.read(authenticationRepositoryProvider);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController lastnameController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  0.1, // 10% del ancho de la pantalla
              vertical: MediaQuery.of(context).size.height *
                  0.1, // 10% del alto de la pantalla
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(animationList[1],
                    height: MediaQuery.of(context).size.height * 0.3),

                Text("¡Regístrate gratis! 😻",
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nameController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: lastnameController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    labelText: "Apellidos",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    prefixIcon: Icon(Icons.badge,
                        color: Theme.of(context).primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: emailController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    prefixIcon: Icon(Icons.email,
                        color: Theme.of(context).primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Campo de contraseña
                TextFormField(
                  controller: passwordController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    prefixIcon:
                        Icon(Icons.lock, color: Theme.of(context).primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await authNotifier.register(
                      email: emailController.text,
                      firstname: nameController.text,
                      lastname: lastnameController.text,
                      password: passwordController.text,
                      ref: ref,
                    );
                    if (context.mounted) {
                      context.go('/home');
                    }
                  },
                  child: const Text('Registrarse'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "¿Ya tienes cuenta?   ",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      children: [
                        TextSpan(
                          text: "Inicia sesión",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
