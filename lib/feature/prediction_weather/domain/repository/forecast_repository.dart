import '../../../../core/network/data_state.dart';
import '../entities/forecast_data.dart';

abstract class ForecastRepository {
  Future<DataState<ForecastData>> getForecastData();
  void updateUrl(String newUrl);
}


