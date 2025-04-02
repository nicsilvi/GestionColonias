import 'package:autentification/app/core/constants/assets.dart';
import 'package:autentification/app/presentation/controllers/auth_controller.dart';
import 'package:autentification/app/presentation/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/router_controller.dart';
import 'menu_lateral.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});
  static const String routeName = '/profile';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView>
    with SingleTickerProviderStateMixin {
  late final authRepository = ref.watch(authenticationRepositoryProvider);

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userLoaderState = ref.watch(userLoaderFutureProvider);
    Image img = Image.asset(Assets.userIcon1);

    if (userLoaderState.value?.profileImage != null) {
      img = Image.asset(userLoaderState.value!.profileImage!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      endDrawer: const DrawerMenu(),
      body: Column(
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 5,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      await pickAndSelectImage(
                          context, userLoaderState.value!.id);
                    },
                    child: CircleAvatar(radius: 60, backgroundImage: img.image),
                  ),
                  const SizedBox(height: 16),
                  Text(
                      "${userLoaderState.value?.firstName ?? "User"} ${userLoaderState.value?.lastName ?? ""}",
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text(
                    "Photographer & Digital Artist",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "Basic"),
                      Tab(text: "Advanced"),
                      Tab(text: "Special Effects"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        const Center(child: Text("Basic")),
                        const Center(child: Text("Advanced")),
                        const Center(child: Text("Special Effects")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
