import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather_cubit/weather_cubit.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (data) => _searchWeather(context, data),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 10,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffFFAD3B)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xffFFAD3B)),
                ),
                labelText: "Search",
                labelStyle: const TextStyle(color: Color(0xffFFAD3B)),
                hintText: "Enter City Name",
                focusColor: const Color(0xffFFAD3B),
                suffixIcon: InkWell(
                  onTap: () => _searchWeather(context, _controller.text),
                  child: const Icon(Icons.search),
                ),
              ),
              autocorrect: true,
            ),
          ],
        ),
      ),
    );
  }

  void _searchWeather(BuildContext context, String city) {
    if (city.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a city name')));
      return;
    }

    BlocProvider.of<WeatherCubit>(context).getWeather(cityName: city);

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
