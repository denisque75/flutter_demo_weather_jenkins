import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/screens/home/home_screen.dart';
import 'package:flutter_weather/ui/widgets/route_observer_provider.dart';

import 'di.dart';
part 'routes.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  void initState() {
    super.initState();
    try {
      final value = Platform.localeName.split('_')[0];
      value == 'sk' ? 'sk' : 'en';
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return RouteObserverProvider(
      routeObserver: routeObserver,
      child: DI(
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          navigatorObservers: [routeObserver],
          onGenerateRoute: _generateRoute,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: botToastBuilder(context, child),
          ), //1. call BotToastInit
          home: HomeScreen(),
        ),
      ),
    );
  }
}
