import 'package:auto_route/auto_route.dart';
import 'package:autoroute_app/route_gaurd/route_guard.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        //HomeScreen is generated as HomeRoute because
        //of the replaceInRouteName property
        // AutoRoute(path: '*', page: UnknownRoute.page),
        AutoRoute(page: HomeRoute.page, guards: [AuthGuard()]),
        AutoRoute(
          path: '/',
          guards: [AuthGuard()],
          page: DashboardRoute.page,
          children: [
            AutoRoute(path: '', page: UsersRoute.page),
            AutoRoute(path: 'posts', page: PostsRoute.page),
            AutoRoute(path: 'settings', page: SettingsRoute.page),
          ],
        ),
        AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
        // AutoRoute(page: LoginRoute.page, initial: true)
      ];
}
