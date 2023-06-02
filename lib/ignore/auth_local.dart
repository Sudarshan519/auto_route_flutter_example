import 'package:did_change_authlocal/did_change_authlocal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomwPage(),
    );
  }
}

class HomwPage extends StatefulWidget {
  const HomwPage({super.key});

  @override
  State<HomwPage> createState() => _HomwPageState();
}

class _HomwPageState extends State<HomwPage> with WidgetsBindingObserver {
  String _tokenBiometric = "";
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumeUpdateBiometric();
      // onGetTokenBiometric();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    onGetTokenBiometric();
    onResumeUpdateBiometric();
    super.initState();
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      onGetTokenBiometric();
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  //This function will compare previous and current token after the user create a new Face ID and clears Face ID
  void onResumeUpdateBiometric() async {
    await DidChangeAuthLocal.instance
        .onCheckBiometric(token: _tokenBiometric)
        .then((value) {
      print(value);
      if (value == AuthLocalStatus.changed) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Alert'),
                content: Text('The biometric data has been changed'),
              );
            });
      }
    });
  }

  //Just only for iOS
  //We need to save token (iOS)
  Future<void> onGetTokenBiometric() async {
    try {
      final tokenBiometric =
          await DidChangeAuthLocal.instance.getTokenBiometric();
      print(tokenBiometric);
      setState(() {
        _tokenBiometric = tokenBiometric;
      });
    } on PlatformException catch (_) {
      throw (_);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_tokenBiometric);             
    return Scaffold(
      appBar: AppBar(
        title: const Text('Did change Local Auth'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 30),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_supportState == _SupportState.unknown)
                const CircularProgressIndicator()
              else if (_supportState == _SupportState.supported)
                const Text('This device is supported')
              else
                const Text('This device is not supported'),
              const Divider(height: 100),
              Text('Can check biometrics: $_canCheckBiometrics\n'),
              ElevatedButton(
                onPressed: _checkBiometrics,
                child: const Text('Check biometrics'),
              ),
              const Divider(height: 100),
              Text('Available biometrics: $_availableBiometrics\n'),
              ElevatedButton(
                onPressed: _getAvailableBiometrics,
                child: const Text('Get available biometrics'),
              ),
              const Divider(height: 100),
              Text('Current State: $_authorized\n'),
              if (_isAuthenticating)
                ElevatedButton(
                  onPressed: _cancelAuthentication,
                  // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
                  // ignore: prefer_const_constructors
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('Cancel Authentication'),
                      Icon(Icons.cancel),
                    ],
                  ),
                )
              else
                Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _authenticate,
                      // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
                      // ignore: prefer_const_constructors
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Text('Authenticate'),
                          Icon(Icons.perm_device_information),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _authenticateWithBiometrics,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_isAuthenticating
                              ? 'Cancel'
                              : 'Authenticate: biometrics only'),
                          const Icon(Icons.fingerprint),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),

      // body: Center(child: Text(_tokenBiometric)),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
