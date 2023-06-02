// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:autoroute_app/ignore/home/home_page.dart' as _i1;
import 'package:autoroute_app/ignore/login_page/login_page.dart' as _i2;
import 'package:autoroute_app/ignore/unknown_route/ml_vision.dart' as _i6;
import 'package:autoroute_app/ignore/unknown_route/render_backgorund.dart'
    as _i4;
import 'package:autoroute_app/ignore/unknown_route/text_recognition.dart'
    as _i3;
import 'package:autoroute_app/ignore/unknown_route/unknown_route.dart' as _i5;
import 'package:flutter/material.dart' as _i8;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    DashboardRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.DashboardPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    UsersRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.UsersPage(),
      );
    },
    PostsRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.PostsPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.SettingsPage(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.LoginPage(
          key: args.key,
          onLoginResult: args.onLoginResult,
          showBackButton: args.showBackButton,
        ),
      );
    },
    OCRTextRecognitionRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.OCRTextRecognitionPage(
          number: "",
        ),
      );
    },
    RenderWidgetBackgroundVisibleCenterGreyedOvalRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.RenderWidgetBackgroundVisibleCenterGreyedOvalPage(),
      );
    },
    UnknownRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.UnknownPage(),
      );
    },
    MlVisionRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.MlVisionPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.DashboardPage]
class DashboardRoute extends _i7.PageRouteInfo<void> {
  const DashboardRoute({List<_i7.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i1.UsersPage]
class UsersRoute extends _i7.PageRouteInfo<void> {
  const UsersRoute({List<_i7.PageRouteInfo>? children})
      : super(
          UsersRoute.name,
          initialChildren: children,
        );

  static const String name = 'UsersRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i1.PostsPage]
class PostsRoute extends _i7.PageRouteInfo<void> {
  const PostsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          PostsRoute.name,
          initialChildren: children,
        );

  static const String name = 'PostsRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i1.SettingsPage]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i7.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i8.Key? key,
    void Function(bool)? onLoginResult,
    bool showBackButton = true,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onLoginResult: onLoginResult,
            showBackButton: showBackButton,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i7.PageInfo<LoginRouteArgs> page =
      _i7.PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onLoginResult,
    this.showBackButton = true,
  });

  final _i8.Key? key;

  final void Function(bool)? onLoginResult;

  final bool showBackButton;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginResult: $onLoginResult, showBackButton: $showBackButton}';
  }
}

/// generated route for
/// [_i3.OCRTextRecognitionPage]
class OCRTextRecognitionRoute extends _i7.PageRouteInfo<void> {
  const OCRTextRecognitionRoute({List<_i7.PageRouteInfo>? children})
      : super(
          OCRTextRecognitionRoute.name,
          initialChildren: children,
        );

  static const String name = 'OCRTextRecognitionRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.RenderWidgetBackgroundVisibleCenterGreyedOvalPage]
class RenderWidgetBackgroundVisibleCenterGreyedOvalRoute
    extends _i7.PageRouteInfo<void> {
  const RenderWidgetBackgroundVisibleCenterGreyedOvalRoute(
      {List<_i7.PageRouteInfo>? children})
      : super(
          RenderWidgetBackgroundVisibleCenterGreyedOvalRoute.name,
          initialChildren: children,
        );

  static const String name =
      'RenderWidgetBackgroundVisibleCenterGreyedOvalRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.UnknownPage]
class UnknownRoute extends _i7.PageRouteInfo<void> {
  const UnknownRoute({List<_i7.PageRouteInfo>? children})
      : super(
          UnknownRoute.name,
          initialChildren: children,
        );

  static const String name = 'UnknownRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.MlVisionPage]
class MlVisionRoute extends _i7.PageRouteInfo<void> {
  const MlVisionRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MlVisionRoute.name,
          initialChildren: children,
        );

  static const String name = 'MlVisionRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
