import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/forecast_data.dart';
import '../../domain/entities/path_images.dart';
import '../../domain/entities/provinces_data.dart';
import '../../domain/entities/wind_direction.dart';
import '../../domain/usecases/forecast_usecases.dart';
import '../bloc/forecast/forecast_bloc.dart';
import '../bloc/forecast/forecast_events.dart';
import '../bloc/forecast/forecast_state.dart';
import '../widgets/custom_text_widget.dart';
import '../widgets/timestamp.dart';


class ForecastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
          child: ForecastView()),
    );
  }
}

class ForecastView extends StatefulWidget {
  @override
  State<ForecastView> createState() => _ForecastViewState();
}

class _ForecastViewState extends State<ForecastView> {
  Province? selectedProvince = provinces.first;
  Area? selectedArea;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ForecastBloc>().add(FetchForecastData(selectedProvince!));
  }

  void _scrollToTomorrow() {
    final tomorrowIndex = 4; // Example logic; adjust as needed

    _scrollController.animateTo(
      tomorrowIndex * 100.0, // Adjust based on item width
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToDayAfterTomorrow() {
    final tomorrowIndex = 10; // Example logic; adjust as needed

    _scrollController.animateTo(
      tomorrowIndex * 100.0, // Adjust based on item width
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToToday() {
    final todayIndex = 0;

    _scrollController.animateTo(
      todayIndex * 100.0, // Adjust based on item width
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40,),
        DropdownButton<Province>(
          value: selectedProvince,
          items: provinces.map((Province province) {
            return DropdownMenuItem<Province>(
              value: province,
              child: Text(province.name),
            );
          }).toList(),
          onChanged: (Province? newProvince) {
            setState(() {
              selectedProvince = newProvince;
              selectedArea = null;
              // Dispatch event to fetch data for the selected province
              context.read<ForecastBloc>().add(FetchForecastData(selectedProvince!));
            });
          },
        ),

        BlocBuilder<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ForecastLoaded) {
              final forecastData = state.forecastData;
              if (selectedArea == null || !forecastData.forecast.area.contains(selectedArea!)) {
                selectedArea = forecastData.forecast.area.isNotEmpty
                    ? forecastData.forecast.area[0]
                    : null;
              }
              final weatherCode = int.parse(
                selectedArea!.parameters[5].timeranges[0].values[0].content,
              );
              final imagePath = weatherCodeImages[weatherCode] ?? 'assets/images/5berawan.png';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (selectedProvince != null) ...[
                    DropdownButton<Area>(
                      value: selectedArea,
                      items: (context.read<ForecastBloc>().state as ForecastLoaded).forecastData.forecast.area
                          .map((Area area) {
                        return DropdownMenuItem<Area>(
                          value: area,
                          child: Text(area.nameID),
                        );
                      }).toList(),
                      onChanged: (Area? newArea) {
                        setState(() {
                          selectedArea = newArea;
                        });
                      },
                    ),
                  ],
                  CustomTextWidget(
                    text: '${selectedArea?.nameID}',
                    fontSize: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: '${selectedArea?.parameters[5].timeranges[0].values[0].content}',
                        fontSize: 105,
                      ),
                      Column(
                        children: [
                          SizedBox(height: 20,),
                          CustomTextWidget(
                            text: '°',
                            fontSize: 45,
                          ),
                        ],
                      )
                    ]
                  ),
                  CustomTextWidget(
                    text: formatTimestamp(forecastData.forecast.issue.timestamp),
                    fontSize: 18,
                  ),
                  SizedBox(height: 10,),
                  Image.asset(imagePath, scale: 4.0,),
                  SizedBox(height: 10,),
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 20),
                    child:Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            ElevatedButton(
                              onPressed: _scrollToToday,
                                child: CustomTextWidget(
                                  text: 'Hari ini',
                                  fontSize: 18,
                                ),),
                            SizedBox(width: 10,),
                            ElevatedButton(
                              onPressed: _scrollToTomorrow,
                              child: CustomTextWidget(
                                text: 'Besok',
                                fontSize: 18,
                              ),),
                            SizedBox(width: 10,),
                            ElevatedButton(
                              onPressed: _scrollToDayAfterTomorrow,
                              child: CustomTextWidget(
                                text: 'Lusa',
                                fontSize: 18,
                              ),)
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Container(
                          height: 150,
                          child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedArea?.parameters[5].timeranges.length,
                            itemBuilder: (BuildContext context, int index) {
                              final weatherCode = int.parse(
                                selectedArea!.parameters[6].timeranges[index].values[0].content,
                              );
                              final imagePath = weatherCodeImages[weatherCode] ?? 'assets/images/5berawan.png';
                              String directionCode = '${selectedArea?.parameters[7].timeranges[index].values[1].content}';
                              String description = windDirectionsMap[directionCode] ?? 'Unknown direction';
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                    children: [
                                      Image.asset(imagePath, scale: 10.0,),
                                      Text(formatTimestampContent(forecastData.forecast.area[0].parameters[5].timeranges[index].datetime)),
                                      Text('${selectedArea?.parameters[5].timeranges[index].values[0].content}°'),
                                      Text('${description}'),
                                    ]
                                ));
                            },
                          ),
                        )
                      ],
                    ),
                  )
                  // Add more widgets to display the forecast data as needed
                ],
              );
            } else if (state is ForecastError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(child: Text('Please select an action'));
          },
        ),
      ]
    );
  }
}



