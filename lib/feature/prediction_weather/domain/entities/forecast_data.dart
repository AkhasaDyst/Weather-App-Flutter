import 'package:equatable/equatable.dart';

class ForecastData extends Equatable {
  final String source;
  final String productionCenter;
  final Forecast forecast;

  ForecastData({required this.source, required this.productionCenter, required this.forecast});

  @override
  List<Object?> get props => [source, productionCenter, forecast];
}

class Forecast extends Equatable {
  final String domain;
  final Issue issue;
  final List<Area> area;

  Forecast({required this.domain, required this.issue, required this.area});

  @override
  List<Object?> get props => [domain, issue, area];
}

class Issue extends Equatable {
  final String timestamp;
  final String year;
  final String month;
  final String day;
  final String hour;
  final String minute;
  final String second;

  Issue({
    required this.timestamp,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
  });

  @override
  List<Object?> get props => [timestamp, year, month, day, hour, minute, second];
}

class Area extends Equatable {
  final String id;
  final String latitude;
  final String longitude;
  final String coordinate;
  final String type;
  final String description;
  final String domain;
  final String nameEN;
  final String nameID;
  final List<Parameter> parameters;

  Area({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.coordinate,
    required this.type,
    required this.description,
    required this.domain,
    required this.nameEN,
    required this.nameID,
    required this.parameters,
  });

  @override
  List<Object?> get props => [
    id,
    latitude,
    longitude,
    coordinate,
    type,
    description,
    domain,
    nameEN,
    nameID,
    parameters,
  ];
}

class Parameter extends Equatable {
  final String id;
  final String description;
  final String type;
  final List<TimeRange> timeranges;

  Parameter({required this.id, required this.description, required this.type, required this.timeranges});

  @override
  List<Object?> get props => [id, description, type, timeranges];
}

class TimeRange extends Equatable {
  final String type;
  final String datetime;
  final String? hour;
  final String? day;
  final List<Value> values;

  TimeRange({required this.type, required this.datetime, this.hour, this.day, required this.values});

  @override
  List<Object?> get props => [type, datetime, hour, day, values];
}

class Value extends Equatable {
  final String unit;
  final String content;

  Value({required this.unit, required this.content});

  @override
  List<Object?> get props => [unit, content];
}
