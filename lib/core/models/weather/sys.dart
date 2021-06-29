import 'dart:convert';

import 'package:flutter_weather/utils/json_reader.dart';

class Sys {
  int type;
  int id;
  double message;
  String country;
  DateTime sunrise;
  DateTime sunset;

  Sys({
    required this.type,
    required this.id,
    required this.message,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  Sys copyWith({
    int? type,
    int? id,
    double? message,
    String? country,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    return Sys(
      type: type ?? this.type,
      id: id ?? this.id,
      message: message ?? this.message,
      country: country ?? this.country,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'id': id,
      'message': message,
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }

  factory Sys.fromMap(Map<String, dynamic> map) {
    final JsonReader json = JsonReader(map);

    return Sys(
      type: json['type'].asInt(),
      id: json['id'].asInt(),
      message: json['message'].asDouble(),
      country: json['country'].asString(),
      sunrise: json['sunrise'].asDateTime(),
      sunset: json['sunset'].asDateTime(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Sys.fromJson(String source) => Sys.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Sys(type: $type, id: $id, message: $message, country: $country, sunrise: $sunrise, sunset: $sunset)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Sys &&
        other.type == type &&
        other.id == id &&
        other.message == message &&
        other.country == country &&
        other.sunrise == sunrise &&
        other.sunset == sunset;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        id.hashCode ^
        message.hashCode ^
        country.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode;
  }
}
