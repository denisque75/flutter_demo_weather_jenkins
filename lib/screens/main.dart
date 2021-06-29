import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/core/app_exceptions.dart';
import 'package:flutter_weather/core/utils_repository/api_manager_impl.dart';
import 'package:flutter_weather/core/utils_repository/shared_preference_manager_impl.dart';
import 'package:flutter_weather/utils/popups.dart';

import 'app.dart';

class BlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
    if (error is BadRequestException ||
        error is FetchDataException ||
        error is UnauthorisedException) {
      showErrorPopup(error.toString());
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferenceManager prefs = SharedPreferenceManagerImpl()..init();
  Bloc.observer = BlocDelegate();
  ApiManagerImpl().init(
    prefs: prefs,
  );

  runApp(const App());
}
