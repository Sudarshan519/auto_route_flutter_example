import 'package:auto_route/auto_route.dart';
import 'package:autoroute_app/ignore/app_router.gr.dart';
import 'package:flutter/material.dart';

bool authenticated = false;

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation

    if (authenticated) {
      authenticated = true;
      // we can't pop the bottom page in the navigator's stack
      // so we just remove it from our local stack
      router.markUrlStateForReplace();
      router.removeLast();
      resolver.next();
      // if user is authenticated we continue
      resolver.next(true);
    } else {
      // we redirect the user to our login page
      router.push(LoginRoute(onLoginResult: (success) {
        // if success == true the navigation will be resumed
        // else it will be aborted
        resolver.next(success);
      }));
    }
  }
}

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
}
