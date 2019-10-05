import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:medium_reader/splash_screen.dart';
import 'package:medium_reader/reader_screen.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  static final nk = GlobalKey<NavigatorState>();
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      if (initialLink == null) {
        return App.nk.currentState.pushReplacementNamed('/error');
      } else {
        return App.nk.currentState
            .pushReplacementNamed('/reader', arguments: initialLink);
      }
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.nk,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/reader':
        return MaterialPageRoute(
          builder: (_) => ReaderScreen(
            url: (settings.arguments as String),
          ),
        );
      case '/error':
        return MaterialPageRoute(
          builder: (_) => ErrorScreen(),
        );
    }
    return MaterialPageRoute(builder: (_) => ErrorScreen());
  }
}
