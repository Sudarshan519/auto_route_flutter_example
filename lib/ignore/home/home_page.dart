import 'package:auto_route/auto_route.dart';
import 'package:autoroute_app/routes/app_router.gr.dart';
import 'package:flutter/material.dart';

class NavLink extends StatelessWidget {
  const NavLink({super.key, required this.label, required this.destination});
  final String label;
  final PageRouteInfo destination;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.router.replace(destination);
        },
        child: Text(label));
  }
}

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Column(
            children: [
              NavLink(label: 'Users', destination: const UsersRoute()),
              NavLink(label: 'Posts', destination: const PostsRoute()),
              NavLink(label: 'Settings', destination: const SettingsRoute()),
            ],
          ),
          Expanded(
            // nested routes will be rendered here
            child: AutoRouter(),
          )
        ],
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Text("HomePage")),
    );
  }
}

@RoutePage()
class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    print(context.router.stack);
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(child: Text("Users")),
    );
  }
}

@RoutePage()
class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(child: Text("Posts")),
    );
  }
}

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(child: InkWell(onTap: () {}, child: Text("Settings"))),
    );
  }
}
