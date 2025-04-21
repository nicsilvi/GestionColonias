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
                Lottie.asset(
                  Assets.animationCat2,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),

                const Text(
                  '¿Todavía sin cuenta? 🐾 ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text("Regístrate gratis: ",
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 26),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
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
                  decoration: InputDecoration(
                    labelText: "Apellidos",
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
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
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
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
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
                      children: const [
                        TextSpan(
                          text: "Inicia sesión",
                          style: TextStyle(
                              color: Color.fromARGB(255, 61, 160, 112)),
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
