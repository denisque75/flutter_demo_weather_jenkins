import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

abstract class LocationManager {
  static LocationManager of(BuildContext context) =>
      RepositoryProvider.of(context);

  get reasonOfNullableLocation => null;

  Future<LocationData?> getCurrentLocation();
}

class LocationManagerImpl implements LocationManager {
  late bool _serviceEnabled;
  late PermissionStatus _permissionStatus;
  late LocationData _locationData;

  String get reasonOfNullableLocation {
    if (!_serviceEnabled) {
      return 'Enable service before using the app.';
    }
    if (_permissionStatus == PermissionStatus.denied ||
        _permissionStatus == PermissionStatus.deniedForever) {
      return 'Enable location permission before using app.';
    }
    return 'Cannot fetch location due to unkown reasons. Sorry we are working on it.';
  }

  @override
  Future<LocationData?> getCurrentLocation() async {
    Location location = new Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }
}
