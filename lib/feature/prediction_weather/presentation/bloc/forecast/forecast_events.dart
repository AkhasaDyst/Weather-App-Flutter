import 'package:equatable/equatable.dart';

import '../../../domain/entities/provinces_data.dart';

abstract class ForecastEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchForecastData extends ForecastEvent {
  final Province province;

  FetchForecastData(this.province);

  @override
  List<Object> get props => [province];
}
