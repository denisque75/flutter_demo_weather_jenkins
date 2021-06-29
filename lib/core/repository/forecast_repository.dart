import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/core/models/weather/weather_data.dart';
import 'package:flutter_weather/core/request_model/get_request.dart';
import 'package:flutter_weather/core/utils_repository/api_manager_impl.dart';
import 'package:flutter_weather/utils/json_reader.dart';

abstract class ForecastRepository {
  static ForecastRepository of(BuildContext context) =>
      RepositoryProvider.of(context);

  Future<WeatherData> fetchWeatherDataByLocation(double lon, double lat);
}

class ForecastRepositoryImpl implements ForecastRepository {
  static const forecastApiKey = '66df92ccb57303aeaf5132533ad507d3';

  final ApiManager apiManager;

  ForecastRepositoryImpl({required this.apiManager});

  @override
  Future<WeatherData> fetchWeatherDataByLocation(double lon, double lat) async {
    final dynamic response = await apiManager.callApiRequest(
      GetRequest(
        urlSuffix:
            'weather?lat=$lat&lon=$lon&appid=$forecastApiKey&units=metric',
      ),
    );
    final JsonReader jsonReader = JsonReader(response);

    return WeatherData.fromMap(jsonReader.asMap());
  }
}
