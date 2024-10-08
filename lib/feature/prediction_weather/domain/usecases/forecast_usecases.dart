import '../../../../core/network/data_state.dart';
import '../entities/forecast_data.dart';
import '../repository/forecast_repository.dart';

class GetForecastData {
  final ForecastRepository repository;

  GetForecastData(this.repository);

  Future<DataState<ForecastData>> call(String url) async {
    repository.updateUrl(url);
    return await repository.getForecastData();
  }
}

