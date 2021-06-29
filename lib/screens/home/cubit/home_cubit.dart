import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_weather/core/app_exceptions.dart';
import 'package:flutter_weather/core/models/weather/weather_data.dart';
import 'package:flutter_weather/core/repository/forecast_repository.dart';
import 'package:flutter_weather/core/utils_repository/location_manager.dart';
import 'package:location/location.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ForecastRepository repository;
  final LocationManager locationManager;

  HomeCubit({
    required this.repository,
    required this.locationManager,
  }) : super(HomeState());

  Future<void> fetchCurrentWeather() async {
    emit(
      state.copyWith(
        isLoading: true,
        isError: false,
        errorMessage: null,
      ),
    );
    try {
      final LocationData? location = await locationManager.getCurrentLocation();
      if (location == null) {
        return emit(
          state.copyWith(
              isError: true,
              isLoading: false,
              errorMessage: locationManager.reasonOfNullableLocation),
        );
      }

      final WeatherData weatherData =
          await repository.fetchWeatherDataByLocation(
              location.longitude ?? 0, location.latitude ?? 0);
      emit(
        state.copyWith(
          isLoading: false,
          weather: weatherData,
        ),
      );
    } on BadRequestException catch (ex) {
      emit(
        state.copyWith(
          isError: true,
          isLoading: false,
          errorMessage: ex.errorMessage,
        ),
      );
      // } on Exception {
      //   emit(
      //     state.copyWith(
      //       isError: true,
      //       isLoading: false,
      //       errorMessage: 'Something went wrong.',
      //     ),
      //   );
    }
  }
}
