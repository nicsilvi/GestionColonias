import 'package:autentification/app/domain/models/user_model.dart';
import 'package:autentification/app/presentation/controllers/auth_controller.dart';
import 'package:autentification/app/presentation/views/login_view.dart';
import 'package:autentification/app/presentation/views/profile_view.dart';
import 'package:autentification/app/presentation/views/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../views/home_view.dart';

final userLoaderFutureProvider = StreamProvider<UserModel?>((ref) {
  final authRepository = ref.watch(authenticationRepositoryProvider);
  return authRepository.isUserLoggedIn();
});

final _navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final userLoaderState = ref.watch(userLoaderFutureProvider);
    //final userAuthState = ref.watch(sessionControllerProvider);
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
            ])
      ],
      redirect: (context, state) {
        //if (userLoaderState.isLoading) {
        //  if (state.uri.toString() != '/splash') return '/splash';
        // return null;
        //   }

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
