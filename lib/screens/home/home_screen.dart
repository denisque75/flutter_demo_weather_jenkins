import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/core/repository/forecast_repository.dart';
import 'package:flutter_weather/core/utils_repository/location_manager.dart';
import 'package:flutter_weather/screens/home/cubit/home_cubit.dart';
import 'package:flutter_weather/utils/colors.dart';
import 'package:flutter_weather/utils/popups.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeCubit _cubit;

  @override
  void initState() {
    _cubit = HomeCubit(
      repository: ForecastRepository.of(context),
      locationManager: LocationManager.of(context),
    );
    _cubit.fetchCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: BlocConsumer<HomeCubit, HomeState>(
                  bloc: _cubit,
                  listener: (context, state) {
                    if (state.isError &&
                        state.errorMessage != null &&
                        state.errorMessage!.isNotEmpty) {
                      showErrorPopup(state.errorMessage!);
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildMainDataInfoWidget(context, state),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainDataInfoWidget(BuildContext context, HomeState state) {
    if (state.isLoading) {
      return _buildNoDataWidget(
        context,
      );
    }
    if (!state.isLoading && (state.isError || state.weather == null)) {
      return _buildErrorWidget(
        context,
        state,
      );
    }
    return Center(
      child: Column(
        children: [
          Text(
            '${state.weather?.name ?? ''}, ${state.weather?.sys.country ?? ''}',
            style: TextStyle(fontSize: 40, color: ProjectColors.titleColor),
          ),
          const SizedBox(
            height: 40,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '${state.weather?.main.temp.toInt() ?? ''}',
                  style:
                      TextStyle(fontSize: 140, color: ProjectColors.titleColor),
                ),
              ),
              Positioned(
                top: 0,
                right: -25,
                child: Text(
                  '〇',
                  style: TextStyle(
                    fontSize: 40,
                    color: ProjectColors.titleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Data is loading. Please wait for it',
              style: TextStyle(fontSize: 34),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, HomeState state) {
    return Center(
      child: Column(
        children: [
          Text(
            'Data couldn\'t be loaded. ${state.errorMessage?.isNotEmpty ?? false ? state.errorMessage : 'Data cannot be loaded do to unknown reasons ;('}',
            style: TextStyle(fontSize: 34),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
