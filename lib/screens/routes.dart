part of 'app.dart';

Route<dynamic> _generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
    case HomeScreen.routeName:
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (BuildContext context) => HomeScreen(),
      );
    default:
      throw ArgumentError.value(
          settings.name, 'settings.name', 'Unsupported route');
  }
}
