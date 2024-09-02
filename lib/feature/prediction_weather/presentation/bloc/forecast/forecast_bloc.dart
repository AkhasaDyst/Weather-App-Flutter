import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/data_state.dart';
import '../../../domain/entities/forecast_data.dart';
import '../../../domain/usecases/forecast_usecases.dart';
import 'forecast_events.dart';
import 'forecast_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/forecast_usecases.dart';
import 'forecast_events.dart';
import 'forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final GetForecastData getForecastData;

  ForecastBloc(this.getForecastData) : super(ForecastInitial()) {
    on<FetchForecastData>(_onFetchForecastData);
  }

  Future<void> _onFetchForecastData(
      FetchForecastData event, Emitter<ForecastState> emit) async {
    emit(ForecastLoading());
    try {
      final updatedUrl = 'https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/${event.province.file}';
      final result = await getForecastData(updatedUrl);
      emit(result is DataSuccess<ForecastData>
          ? ForecastLoaded(result.data!)
          : ForecastError(result.error?.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(ForecastError('An unknown error occurred: ${e.toString()}'));
    }
  }
}

