import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';

String baseUrl = "http://api.weatherapi.com/v1";
String apiKey = "952b5d680f7140a0bf6151650250705";

class WeatherService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: baseUrl, headers: {'Accept': 'application/json'}),
  );

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel?> getWeatherByLocation() async {
    try {
      Position position = await _determinePosition();
      final response = await _dio.get(
        "/forecast.json",
        queryParameters: {
          "key": apiKey,
          "q": "${position.latitude},${position.longitude}",
          "days": 7,
          "aqi": "no",
          "alerts": "no",
        },
      );
      return WeatherModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<WeatherModel?> getWeather({required String cityName}) async {
    try {
      final response = await _dio.get(
        "/forecast.json",
        queryParameters: {
          "key": apiKey,
          "q": cityName,
          "days": 7,
          "aqi": "no",
          "alerts": "no",
        },
      );
      return WeatherModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }
}
