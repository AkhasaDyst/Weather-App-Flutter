import 'package:equatable/equatable.dart';
import '../../../domain/entities/forecast_data.dart';

abstract class ForecastState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastLoaded extends ForecastState {
  final ForecastData forecastData;

  ForecastLoaded(this.forecastData);

  @override
  List<Object?> get props => [forecastData];
}

class ForecastError extends ForecastState {
  final String message;

  ForecastError(this.message);

  @override
  List<Object?> get props => [message];
}
