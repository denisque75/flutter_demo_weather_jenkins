part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final WeatherData? weather;
  final String? errorMessage;
  final bool isError;

  HomeState({
    this.isLoading = false,
    this.weather = null,
    this.errorMessage = null,
    this.isError = false,
  });

  HomeState copyWith({
    bool? isLoading,
    WeatherData? weather,
    String? errorMessage,
    bool? isError,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      weather: weather ?? this.weather,
      errorMessage: errorMessage,
      isError: isError ?? this.isError,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        isLoading,
        weather,
        errorMessage,
        isError,
      ];
}
