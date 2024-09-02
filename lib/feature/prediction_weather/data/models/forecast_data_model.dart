import 'package:xml/xml.dart';

class ForecastDataModel {
  final String source;
  final String productionCenter;
  final ForecastModel forecast;

  ForecastDataModel({
    required this.source,
    required this.productionCenter,
    required this.forecast,
  });

  factory ForecastDataModel.fromXml(XmlElement element) {
    return ForecastDataModel(
      source: element.getAttribute('source')!,
      productionCenter: element.getAttribute('productioncenter')!,
      forecast: ForecastModel.fromXml(element.findElements('forecast').first),
    );
  }

  Map<String, dynamic> toJson() => {
    'source': source,
    'productionCenter': productionCenter,
    'forecast': forecast.toJson(),
  };
}

class ForecastModel {
  final String domain;
  final IssueModel issue;
  final List<AreaModel> area;

  ForecastModel({
    required this.domain,
    required this.issue,
    required this.area,
  });

  factory ForecastModel.fromXml(XmlElement element) {
    return ForecastModel(
      domain: element.getAttribute('domain')!,
      issue: IssueModel.fromXml(element.findElements('issue').first),
      area: element.findElements('area').map((areaElement) => AreaModel.fromXml(areaElement)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'domain': domain,
    'issue': issue.toJson(),
    'area': area.map((areaModel) => areaModel.toJson()).toList(),
  };
}

class IssueModel {
  final String timestamp;
  final String year;
  final String month;
  final String day;
  final String hour;
  final String minute;
  final String second;

  IssueModel({
    required this.timestamp,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
  });

  factory IssueModel.fromXml(XmlElement element) {
    return IssueModel(
      timestamp: element.findElements('timestamp').first.text,
      year: element.findElements('year').first.text,
      month: element.findElements('month').first.text,
      day: element.findElements('day').first.text,
      hour: element.findElements('hour').first.text,
      minute: element.findElements('minute').first.text,
      second: element.findElements('second').first.text,
    );
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'year': year,
    'month': month,
    'day': day,
    'hour': hour,
    'minute': minute,
    'second': second,
  };
}

class AreaModel {
  final String id;
  final String latitude;
  final String longitude;
  final String coordinate;
  final String type;
  final String description;
  final String domain;
  final String nameEN;
  final String nameID;
  final List<ParameterModel> parameters;

  AreaModel({
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

  factory AreaModel.fromXml(XmlElement element) {
    return AreaModel(
      id: element.getAttribute('id')!,
      latitude: element.getAttribute('latitude')!,
      longitude: element.getAttribute('longitude')!,
      coordinate: element.getAttribute('coordinate')!,
      type: element.getAttribute('type')!,
      description: element.getAttribute('description')!,
      domain: element.getAttribute('domain')!,
      nameEN: element.findElements('name').firstWhere((el) => el.getAttribute('xml:lang') == 'en_US').text,
      nameID: element.findElements('name').firstWhere((el) => el.getAttribute('xml:lang') == 'id_ID').text,
      parameters: element.findElements('parameter').map((param) => ParameterModel.fromXml(param)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'latitude': latitude,
    'longitude': longitude,
    'coordinate': coordinate,
    'type': type,
    'description': description,
    'domain': domain,
    'nameEN': nameEN,
    'nameID': nameID,
    'parameters': parameters.map((param) => param.toJson()).toList(),
  };
}

class ParameterModel {
  final String id;
  final String description;
  final String type;
  final List<TimeRangeModel> timeranges;

  ParameterModel({
    required this.id,
    required this.description,
    required this.type,
    required this.timeranges,
  });

  factory ParameterModel.fromXml(XmlElement element) {
    return ParameterModel(
      id: element.getAttribute('id')!,
      description: element.getAttribute('description')!,
      type: element.getAttribute('type')!,
      timeranges: element.findElements('timerange').map((tr) => TimeRangeModel.fromXml(tr)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'type': type,
    'timeranges': timeranges.map((tr) => tr.toJson()).toList(),
  };
}

class TimeRangeModel {
  final String type;
  final String datetime;
  final String? hour;
  final String? day;
  final List<ValueModel> values;

  TimeRangeModel({
    required this.type,
    required this.datetime,
    this.hour,
    this.day,
    required this.values,
  });

  factory TimeRangeModel.fromXml(XmlElement element) {
    return TimeRangeModel(
      type: element.getAttribute('type')!,
      datetime: element.getAttribute('datetime')!,
      hour: element.getAttribute('h'),
      day: element.getAttribute('day'),
      values: element.findElements('value').map((val) => ValueModel.fromXml(val)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'datetime': datetime,
    'hour': hour,
    'day': day,
    'values': values.map((val) => val.toJson()).toList(),
  };
}

class ValueModel {
  final String unit;
  final String content;

  ValueModel({required this.unit, required this.content});

  factory ValueModel.fromXml(XmlElement element) {
    return ValueModel(
      unit: element.getAttribute('unit')!,
      content: element.text,
    );
  }

  Map<String, dynamic> toJson() => {
    'unit': unit,
    'content': content,
  };
}
