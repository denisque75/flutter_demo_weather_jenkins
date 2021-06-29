import 'dart:convert';

import 'package:flutter_weather/utils/json_reader.dart';

class Coord {
  double lon;
  double lat;

  Coord({
    required this.lon,
    required this.lat,
  });

  Map<String, dynamic> toMap() {
    return {
      'lon': lon,
      'lat': lat,
    };
  }

  factory Coord.fromMap(Map<String, dynamic> map) {
    JsonReader json = JsonReader(map);
    return Coord(
      lon: json['lon'].asDouble(),
      lat: json['lat'].asDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Coord.fromJson(String source) => Coord.fromMap(json.decode(source));

  Coord copyWith({
    double? lon,
    double? lat,
  }) {
    return Coord(
      lon: lon ?? this.lon,
      lat: lat ?? this.lat,
    );
  }

  @override
  String toString() => 'Coord(lon: $lon, lat: $lat)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coord && other.lon == lon && other.lat == lat;
  }

  @override
  int get hashCode => lon.hashCode ^ lat.hashCode;
}
