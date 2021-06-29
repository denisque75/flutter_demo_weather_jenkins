import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferenceManager {
  factory SharedPreferenceManager() => SharedPreferenceManagerImpl._singleton;

  static SharedPreferenceManager of(BuildContext context) =>
      RepositoryProvider.of(context);
}

class SharedPreferenceManagerImpl implements SharedPreferenceManager {
  static const int DEFAULT_LANG_ID = 1;

  static const String FIRST_START = 'FIRST_START';
  static const String USER_LANG_ID = 'USER_LANG_ID';
  static const String USER_TOKEN = 'TOKEN';
  static const String ONE_SIGNAL_PLAYER_ID = 'ONE_SIGNAL_PLAYER_ID';
  static const String TOOL_TIP_SHOWN = 'TOOL_TIP_SHOWN';

  SharedPreferences? prefs;
  static final SharedPreferenceManagerImpl _singleton =
      SharedPreferenceManagerImpl._internal();

  factory SharedPreferenceManagerImpl() {
    return _singleton;
  }

  SharedPreferenceManagerImpl._internal();

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}
