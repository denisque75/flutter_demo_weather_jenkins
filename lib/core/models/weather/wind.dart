import 'dart:convert';

import 'package:flutter_weather/utils/json_reader.dart';

class Wind {
  double speed;
  int deg;

  Wind({
    required this.speed,
    required this.deg,
  });

  Wind copyWith({
    double? speed,
    int? deg,
  }) {
    return Wind(
      speed: speed ?? this.speed,
      deg: deg ?? this.deg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'speed': speed,
      'deg': deg,
    };
  }

  factory Wind.fromMap(Map<String, dynamic> map) {
    JsonReader json = JsonReader(map);

    return Wind(
      speed: json['speed'].asDouble(),
      deg: json['deg'].asInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Wind.fromJson(String source) => Wind.fromMap(json.decode(source));

  @override
  String toString() => 'Wind(speed: $speed, deg: $deg)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Wind && other.speed == speed && other.deg == deg;
  }

  @override
  int get hashCode => speed.hashCode ^ deg.hashCode;
}
