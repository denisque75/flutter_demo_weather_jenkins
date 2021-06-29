import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:flutter_weather/utils/json_reader.dart';

import 'clouds.dart';
import 'coords.dart';
import 'main_forecast.dart';
import 'sys.dart';
import 'weather.dart';
import 'wind.dart';

class WeatherData {
  Coord coord;
  List<Weather> weather;
  String base;
  Main main;
  int visibility;
  Wind wind;
  Clouds clouds;
  DateTime dt;
  Sys sys;
  int timezone;
  int id;
  String name;
  int code;

  WeatherData({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.code,
  });

  WeatherData copyWith({
    Coord? coord,
    List<Weather>? weather,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Clouds? clouds,
    DateTime? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? code,
  }) {
    return WeatherData(
      coord: coord ?? this.coord,
      weather: weather ?? this.weather,
      base: base ?? this.base,
      main: main ?? this.main,
      visibility: visibility ?? this.visibility,
      wind: wind ?? this.wind,
      clouds: clouds ?? this.clouds,
      dt: dt ?? this.dt,
      sys: sys ?? this.sys,
      timezone: timezone ?? this.timezone,
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coord': coord.toMap(),
      'weather': weather.map((x) => x.toMap()).toList(),
      'base': base,
      'main': main.toMap(),
      'visibility': visibility,
      'wind': wind.toMap(),
      'clouds': clouds.toMap(),
      'dt': dt,
      'sys': sys.toMap(),
      'timezone': timezone,
      'id': id,
      'name': name,
      'code': code,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    final JsonReader json = JsonReader(map);

    return WeatherData(
      coord: Coord.fromMap(json['coord'].asMap()),
      weather: json['weather']
          .asListOf()
          .map((map) => Weather.fromMap(map))
          .toList(),
      base: json['base'].asString(),
      main: Main.fromMap(json['main'].asMap()),
      visibility: json['visibility'].asInt(),
      wind: Wind.fromMap(json['wind'].asMap()),
      clouds: Clouds.fromMap(json['clouds'].asMap()),
      dt: json['dt'].asDateTime(),
      sys: Sys.fromMap(json['sys'].asMap()),
      timezone: json['timezone'].asInt(),
      id: json['id'].asInt(),
      name: json['name'].asString(),
      code: json['code'].asInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherData.fromJson(String source) =>
      WeatherData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherData(coord: $coord, weather: $weather, base: $base, main: $main, visibility: $visibility, wind: $wind, clouds: $clouds, dt: $dt, sys: $sys, timezone: $timezone, id: $id, name: $name, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is WeatherData &&
        other.coord == coord &&
        listEquals(other.weather, weather) &&
        other.base == base &&
        other.main == main &&
        other.visibility == visibility &&
        other.wind == wind &&
        other.clouds == clouds &&
        other.dt == dt &&
        other.sys == sys &&
        other.timezone == timezone &&
        other.id == id &&
        other.name == name &&
        other.code == code;
  }

  @override
  int get hashCode {
    return coord.hashCode ^
        weather.hashCode ^
        base.hashCode ^
        main.hashCode ^
        visibility.hashCode ^
        wind.hashCode ^
        clouds.hashCode ^
        dt.hashCode ^
        sys.hashCode ^
        timezone.hashCode ^
        id.hashCode ^
        name.hashCode ^
        code.hashCode;
  }
}
