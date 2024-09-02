import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

class ForecastView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dispatch the FetchForecastData event to start loading data
    context.read<ForecastBloc>().add(FetchForecastData());
    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ForecastLoaded) {
          final forecastData = state.forecastData;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              CustomTextWidget(
                text: '${forecastData.forecast.area[0].domain}',
                fontSize: 18,
              ),
              CustomTextWidget(
                text: '${forecastData.forecast.area[0].nameID}',
                fontSize: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: '${forecastData.forecast.area[0].parameters[5].timeranges[0].values[0].content}',
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
              SizedBox(height: 200,),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 20),
                child:Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: (){},
                            child: CustomTextWidget(
                              text: 'Hari ini',
                              fontSize: 18,
                            ),),
                        SizedBox(width: 10,),
                        ElevatedButton(
                          onPressed: (){},
                          child: CustomTextWidget(
                            text: 'Besok',
                            fontSize: 18,
                          ),)
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: forecastData.forecast.area[0].parameters[5].timeranges.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                                children: [
                                  Text(formatTimestampContent(forecastData.forecast.area[0].parameters[5].timeranges[index].datetime)),
                                  Text('${forecastData.forecast.area[0].parameters[5].timeranges[index].values[0].content}'),
                                  Text('${forecastData.forecast.area[0].parameters[6].timeranges[index].values[0].content}'),
                                  Text('${forecastData.forecast.area[0].parameters[7].timeranges[index].values[1].content}'),

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
    );
  }
}



