import 'package:autentification/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/core/constants/global.dart';
import 'app/presentation/controllers/router_controller.dart';
import 'app/presentation/controllers/theme_controller.dart';
import 'app/presentation/shared/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyAppConfig(),
    ),
  );
}

class MyAppConfig extends ConsumerWidget {
  const MyAppConfig({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: Global.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(ref.watch(themeControllerProvider)),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
