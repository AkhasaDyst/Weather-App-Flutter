import 'package:equatable/equatable.dart';

abstract class ForecastEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchForecastData extends ForecastEvent {}
