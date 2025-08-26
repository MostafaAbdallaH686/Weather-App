import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather_cubit/weather_cubit.dart';
import 'package:weather_app/cubits/weather_cubit/weather_state.dart';
import 'package:weather_app/pages/search_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        final weatherData = BlocProvider.of<WeatherCubit>(context).weatherModel;
        final appBarColor = weatherData?.getThemeData() ?? Colors.blue;

        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              centerTitle: true,
              title: const Text(
                textAlign: TextAlign.center,
                "Weather App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            body: () {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SucessState) {
                if (weatherData == null) {
                  return const Center(
                    child: Text(
                      "No weather data available",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        weatherData.getThemeData(),
                        weatherData.getThemeData()[200]!,
                        weatherData.getThemeData()[100]!,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(flex: 3),
                      Image.asset(
                        weatherData.getImage(),
                        fit: BoxFit.scaleDown,
                        scale: 0.5,
                      ),
                      Text(
                        weatherData.country,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            overflow: TextOverflow.ellipsis,
                            weatherData.weatherState,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${weatherData.date.hour}:${weatherData.date.minute}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        "${weatherData.temp.toInt()} C",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Maximum: ${weatherData.maxTemp.toInt()}",
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        "Minmuim: ${weatherData.minTemp.toInt()}",
                        style: const TextStyle(fontSize: 24),
                      ),
                      SearchWidget(),
                    ],
                  ),
                );
              } else if (state is FailureState) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "There is Problem . please searching again.",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          onPressed: () {
                            BlocProvider.of<WeatherCubit>(
                              context,
                            ).getWeatherByLocation();
                          },
                          icon: Icon(Icons.location_on, size: 60),
                          color: Colors.blue,
                        ),
                        const Text(
                          "Searching again , now ",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchWidget(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.blue,
                            size: 60,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Use you current location.",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<WeatherCubit>(
                            context,
                          ).getWeatherByLocation();
                        },
                        icon: Icon(Icons.location_on, size: 60),
                        color: Colors.blue,
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        "Or start searching now ",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Icon(Icons.search, color: Colors.blue, size: 60),
                      SearchWidget(),
                    ],
                  ),
                );
              }
            }(),
          ),
        );
      },
    );
  }
}
