import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:sizer/sizer.dart';


import '../../domain/entities/forecast_data.dart';
import '../../domain/entities/path_images.dart';
import '../../domain/entities/provinces_data.dart';
import '../../domain/entities/wind_direction.dart';
import '../../domain/usecases/forecast_usecases.dart';
import '../bloc/forecast/forecast_bloc.dart';
import '../bloc/forecast/forecast_events.dart';
import '../bloc/forecast/forecast_state.dart';
import '../widgets/blurred_background.dart';
import '../widgets/custom_text_widget.dart';
import '../widgets/timestamp.dart';


class ForecastScreen extends StatefulWidget {
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> with TickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final int currentHour = DateTime.now().hour;
      final double totalFrames = 1.0;
      final double adjustedHour = (currentHour + 7) % 24;
      final double frame = (adjustedHour / 24.0 * totalFrames).toDouble();
      print(frame);
      _gifController.value = frame;
      _gifController.animateTo(
        frame,
        duration: Duration(milliseconds: 500),
      );
      _gifController.repeat(min: 0, max: totalFrames, period: Duration(hours: 24));

    });
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Gif(
              controller: _gifController,
              image: AssetImage("assets/anim/bgdaynigth.gif"),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              child: ForecastView()),
        ],
      ),
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
    final tomorrowIndex = 4;

    _scrollController.animateTo(
      tomorrowIndex * 100.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToDayAfterTomorrow() {
    final tomorrowIndex = 9;

    _scrollController.animateTo(
      tomorrowIndex * 100.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToToday() {
    final todayIndex = 0;

    _scrollController.animateTo(
      todayIndex * 100.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButton<Province>(
              value: selectedProvince,
              isExpanded: true, 
              underline: SizedBox(), 
              items: provinces.map((Province province) {
                return DropdownMenuItem<Province>(
                  value: province,
                  child: CustomTextWidget(
                    text: '${province.name}',
                    fontSize: 18,
                  ),
                );
              }).toList(),
              onChanged: (Province? newProvince) {
                setState(() {
                  selectedProvince = newProvince;
                  selectedArea = null;

                  context.read<ForecastBloc>().add(FetchForecastData(selectedProvince!));
                });
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Colors.black87.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 10,),
      
          BlocBuilder<ForecastBloc, ForecastState>(
            builder: (context, state) {
              if (state is ForecastLoading) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is ForecastLoaded) {
                final forecastData = state.forecastData;
                if (selectedArea == null || !forecastData.forecast.area.contains(selectedArea!)) {
                  selectedArea = forecastData.forecast.area.isNotEmpty
                      ? forecastData.forecast.area[0]
                      : null;
                }
                final weatherCode = int.parse(
                  selectedArea!.parameters[6].timeranges[0].values[0].content,
                );
                final imagePath = weatherCodeImages[weatherCode] ?? 'assets/images/5berawan.png';
      
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (selectedProvince != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButton<Area>(
      
                          value: selectedArea,
                          isExpanded: true,
                          underline: SizedBox(),
                          items: (context.read<ForecastBloc>().state as ForecastLoaded).forecastData.forecast.area
                              .map((Area area) {
                            return DropdownMenuItem<Area>(
                              value: area,
                              child: CustomTextWidget(
                                text: '${area.nameID}',
                                fontSize: 18,
                              ),
                            );
                          }).toList(),
                          onChanged: (Area? newArea) {
                            setState(() {
                              selectedArea = newArea;
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          dropdownColor: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                    SizedBox(height: 10,),
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
                    SizedBox(height: 20,),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      child: BackdropFilter(
                        filter:  ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 35),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      
                          ),
                          child:Column(
                            children: [
                              SizedBox(height: 5,),
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
                                color: Colors.white,
                              ),
                              Container(
                                height: 26.0.h,
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
                                      child: BlurredBackground(
                                        backgroundColor: Colors.blue,
                                        blurSigma: 1.0,
                                        child:
                                        screenWidth > 600 ?
                                        Column(
                                          children: [
                                            CustomTextWidget(
                                              text: formatTimestampContent(forecastData.forecast.area[0].parameters[5].timeranges[index].datetime),
                                              fontSize: 18,
                                            ),
                                            Image.asset(imagePath, scale: 10.0,),
                                            Row(
                                              children: [
                                                CustomTextWidget(
                                                  text: 'Temperature  :  ',
                                                  fontSize: 18,
                                                ),
                                                CustomTextWidget(
                                                  text: '${selectedArea?.parameters[5].timeranges[index].values[0].content}°C',
                                                  fontSize: 18,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                CustomTextWidget(
                                                  text: 'Arah Angin : ',
                                                  fontSize: 18,
                                                ),
                                                CustomTextWidget(
                                                  text: '${selectedArea?.parameters[7].timeranges[index].values[1].content} - ${description}',
                                                  fontSize: 18,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                CustomTextWidget(
                                                  text: 'Kelembapan : ',
                                                  fontSize: 18,
                                                ),
                                                CustomTextWidget(
                                                  text: '${selectedArea?.parameters[0].timeranges[index].values[0].content}%',
                                                  fontSize: 18,
                                                ),
                                              ],
                                            ),

                                          ]
                                        )
                                        : Column(
                                            children: [
                                              CustomTextWidget(
                                                text: formatTimestampContent(forecastData.forecast.area[0].parameters[5].timeranges[index].datetime),
                                                fontSize: 18,
                                              ),
                                              Image.asset(imagePath, scale: 10.0,),
                                              CustomTextWidget(
                                                text: '${selectedArea?.parameters[5].timeranges[index].values[0].content}°C',
                                                fontSize: 18,
                                              ),
                                              CustomTextWidget(
                                                text: '${selectedArea?.parameters[7].timeranges[index].values[1].content}',
                                                fontSize: 18,
                                              ),
                                              CustomTextWidget(
                                                text: '${selectedArea?.parameters[0].timeranges[index].values[0].content}%',
                                                fontSize: 18,
                                              ),
                                            ]
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else if (state is ForecastError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return Center(child: Text('Please select an action'));
            },
          ),
        ]
      ),
    );
  }
}



