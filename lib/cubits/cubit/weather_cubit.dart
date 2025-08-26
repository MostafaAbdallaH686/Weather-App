import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather_cubit/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/network/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this.service) : super(WeatherInitialState());
  WeatherService service;
  WeatherModel? weatherModel;
  void getWeather({required String cityName}) async {
    emit(LoadingState());
    weatherModel = await service.getWeather(cityName: cityName);
    try {
      emit(SucessState());
    } on Exception {
      emit(FailureState());
    }
  }

  void getWeatherByLocation() async {
    emit(LoadingState());
    weatherModel = await service.getWeatherByLocation();
    try {
      emit(SucessState());
    } on Exception {
      emit(FailureState());
    }
  }
}
