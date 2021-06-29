import 'package:flutter/material.dart';

class RouteObserverProvider extends InheritedWidget {
  final RouteObserver<PageRoute> routeObserver;
  const RouteObserverProvider({
    Key? key,
    required Widget child,
    required this.routeObserver,
  }) : super(key: key, child: child);

  static RouteObserverProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RouteObserverProvider>();
  }

  @override
  bool updateShouldNotify(RouteObserverProvider oldWidget) {
    return oldWidget.routeObserver != routeObserver;
  }
}
