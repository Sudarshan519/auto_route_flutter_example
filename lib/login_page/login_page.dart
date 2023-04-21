import 'package:auto_route/auto_route.dart';
import 'package:autoroute_app/route_gaurd/route_guard.dart';
import 'package:flutter/material.dart';

get largespace => SizedBox(
      height: 40,
    );
get mediumSpace => SizedBox(
      height: 16,
    );
get smallspace => SizedBox(
      height: 10,
    );

@RoutePage()
class LoginPage extends StatelessWidget {
  final void Function(bool isLoggedIn)? onLoginResult;
  final bool showBackButton;
  const LoginPage({Key? key, this.onLoginResult, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          padding: const EdgeInsets.all(18.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                largespace,
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                largespace,
                Text(
                  "UserName",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                TextFormField(),
                largespace,
                Text(
                  "Password",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                TextFormField(),
                largespace,
                ElevatedButton(
                    onPressed: () {
                      // context.read<AuthService>().isAuthenticated = true;
                      onLoginResult?.call(true);
                    },
                    child: Text("Submit"))
              ]),
        ),
      ),
    );
  }
}
