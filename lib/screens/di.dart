import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/core/repository/forecast_repository.dart';
import 'package:flutter_weather/core/utils_repository/api_manager_impl.dart';
import 'package:flutter_weather/core/utils_repository/location_manager.dart';
import 'package:flutter_weather/core/utils_repository/shared_preference_manager_impl.dart';

class DI extends StatelessWidget {
  final Widget child;

  const DI({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiManager>(
          create: (BuildContext context) => ApiManagerImpl(),
        ),
        RepositoryProvider<SharedPreferenceManager>(
          create: (BuildContext context) => SharedPreferenceManagerImpl(),
        ),
        RepositoryProvider<LocationManager>(
          create: (BuildContext context) => LocationManagerImpl(),
        ),
        RepositoryProvider<ForecastRepository>(
          create: (BuildContext context) => ForecastRepositoryImpl(
            apiManager: ApiManager.of(context),
          ),
        ),
      ],
      child: child,
    );
  }
}
