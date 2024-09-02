import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;

abstract class WeatherDataSource {
  Future<xml.XmlDocument> fetchWeatherData();
  String get url; // Add this getter
}

class WeatherDataSourceImpl implements WeatherDataSource {
  final Dio _dio;
  final String _url;

  WeatherDataSourceImpl({
    required Dio dio,
    required String url,
  })  : _dio = dio,
        _url = url;

  @override
  Future<xml.XmlDocument> fetchWeatherData() async {
    try {
      final response = await _dio.get(_url);
      if (response.statusCode == 200) {
        // Parse the response data as XML
        final xmlDocument = xml.XmlDocument.parse(response.data);
        return xmlDocument;
      } else {
        throw Exception('Failed to load data');
      }
    } on DioError catch (e) {
      // Handle DioError, such as network issues or response errors
      throw Exception('DioError: ${e.message}');
    } catch (e) {
      // Handle any other exceptions
      throw Exception('Exception: ${e.toString()}');
    }
  }

  @override
  String get url => _url; // Implement the getter
}
