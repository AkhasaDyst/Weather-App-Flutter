import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import '../../../../core/network/data_state.dart';
import '../../domain/entities/forecast_data.dart';

import '../../domain/repository/forecast_repository.dart';
import '../datasources/forecast_datasources.dart';
import '../models/forecast_data_model.dart';

class WeatherRepositoryImpl implements ForecastRepository {
  final WeatherDataSource dataSource;

  WeatherRepositoryImpl({required this.dataSource});

  @override
  Future<DataState<ForecastData>> getForecastData() async {
    try {
      final xmlDocument = await dataSource.fetchWeatherData();
      final forecastData = parseForecastData(xmlDocument);

      return DataSuccess(forecastData);
    } on DioError catch (dioError) {
      return DataFailed(dioError);
    } catch (e) {
      print('Unhandled exception: ${e.toString()}');
      return DataFailed(DioError(
        requestOptions: RequestOptions(path: dataSource.url),
        error: e,
      ));
    }
  }

  @override
  ForecastData parseForecastData(xml.XmlDocument document) {
    final forecastElement = document.findAllElements('data').first;
    final dataModel = ForecastDataModel.fromXml(forecastElement);
    return _mapToDomain(dataModel);
  }

  ForecastData _mapToDomain(ForecastDataModel model) {
    return ForecastData(
      source: model.source,
      productionCenter: model.productionCenter,
      forecast: Forecast(
        domain: model.forecast.domain,
        issue: Issue(
          timestamp: model.forecast.issue.timestamp,
          year: model.forecast.issue.year,
          month: model.forecast.issue.month,
          day: model.forecast.issue.day,
          hour: model.forecast.issue.hour,
          minute: model.forecast.issue.minute,
          second: model.forecast.issue.second,
        ),
        area: model.forecast.area.map((areaModel) => Area(
          id: areaModel.id,
          latitude: areaModel.latitude,
          longitude: areaModel.longitude,
          coordinate: areaModel.coordinate,
          type: areaModel.type,
          description: areaModel.description,
          domain: areaModel.domain,
          nameEN: areaModel.nameEN,
          nameID: areaModel.nameID,
          parameters: areaModel.parameters.map((param) => Parameter(
            id: param.id,
            description: param.description,
            type: param.type,
            timeranges: param.timeranges.map((tr) => TimeRange(
              type: tr.type,
              datetime: tr.datetime,
              hour: tr.hour,
              day: tr.day,
              values: tr.values.map((val) => Value(
                unit: val.unit,
                content: val.content,
              )).toList(),
            )).toList(),
          )).toList(),
        )).toList(),
      ),
    );
  }
}
