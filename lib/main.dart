import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'config/theme/theme.dart';
import 'feature/prediction_weather/data/datasources/forecast_datasources.dart';
import 'feature/prediction_weather/data/repository/forecast_repository_impl.dart';
import 'feature/prediction_weather/domain/usecases/forecast_usecases.dart';
import 'feature/prediction_weather/presentation/bloc/forecast/forecast_bloc.dart';
import 'feature/prediction_weather/presentation/pages/forecast_screen.dart';

void main() {
  initializeDateFormatting('id_ID', null);
  final dio = Dio();
  final weatherDataSource = WeatherDataSourceImpl(
    dio: dio,
    url: 'https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-JawaTengah.xml',
  );
  final weatherRepository = WeatherRepositoryImpl(dataSource: weatherDataSource);
  final getForecastData = GetForecastData(weatherRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider<GetForecastData>(
          create: (_) => getForecastData,
        ),
        BlocProvider<ForecastBloc>(
          create: (context) => ForecastBloc(context.read<GetForecastData>()),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: WeatherTheme.themeData,
          home: ForecastScreen(),
        );
      }
    );
  }
}
