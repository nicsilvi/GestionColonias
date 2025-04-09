import 'package:autentification/app/domain/models/user_model.dart';
import 'package:autentification/app/presentation/controllers/auth_controller.dart';
import 'package:autentification/app/presentation/views/admin_views/admin_colonias.dart';
import 'package:autentification/app/presentation/views/login_view.dart';
import 'package:autentification/app/presentation/views/profile_view.dart';
import 'package:autentification/app/presentation/views/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../views/admin_views/admin_donaciones.dart';
import '../views/admin_views/admin_gatos.dart';
import '../views/cat_view/cat_view.dart';
import '../views/colonia/colonia_view.dart';
import '../views/home/home_view.dart';

final userLoaderFutureProvider = StreamProvider<UserModel?>((ref) {
  final authRepository = ref.watch(authenticationRepositoryProvider);
  return authRepository.isUserLoggedIn();
});

final _navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final userLoaderState = ref.watch(userLoaderFutureProvider);
    //final userAuthState = ref.watch(sessionControllerProvider);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      print("Estado del usuario desde authStateChanges: $user");
    });
    return GoRouter(
      initialLocation: '/',
      navigatorKey: _navigatorKey,
      routes: [
        GoRoute(
          name: LoginPage.routeName,
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: Register.routeName,
          path: '/register',
          builder: (context, state) => const Register(),
        ),
        GoRoute(
            name: HomeView.routeName,
            path: '/home',
            builder: (context, state) => const HomeView(),
            routes: [
              GoRoute(
                name: ProfileView.routeName,
                path: '/profile',
                builder: (context, state) => const ProfileView(),
              ),
              GoRoute(
                name: AdminColonias.routeName,
                path: '/adminColonias',
                builder: (context, state) => const AdminColonias(),
              ),
              GoRoute(
                name: AdminGatos.routeName,
                path: '/adminGatos',
                builder: (context, state) => const AdminGatos(),
              ),
              GoRoute(
                name: AdminDonaciones.routeName,
                path: '/adminDonaciones',
                builder: (context, state) => const AdminDonaciones(),
              ),
              GoRoute(
                name: CatView.routeName,
                path: '/catView',
                builder: (context, state) => const CatView(),
              ),
              GoRoute(
                name: ColoniaDetails.routeName,
                path: '/colonia',
                builder: (context, state) => const ColoniaDetails(),
              ),
              /*GoRoute(
                name: Donaciones.routeName,
                path: '/donaciones',
                builder: (context, state) => const Donaciones(),
              ),*/
            ])
      ],
      redirect: (context, state) {
        print("Estado del usuario: ${userLoaderState.value}");
        print("Ubicación actual: ${state.uri.toString()}");
        if (userLoaderState.value == null) {
          if (state.uri.toString() == '/' ||
              state.uri.toString() == '/register') {
            return null;
          }
          return '/';
        }
        if (state.uri.toString() == '/' ||
            state.uri.toString() == '/register') {
          return '/home';
        }
        return null;
      },
    );
  },
);
