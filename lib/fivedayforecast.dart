import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/const.dart';

class FiveDayForecast extends StatefulWidget {
  final String city;
  const FiveDayForecast({super.key, required this.city});

  @override
  State<FiveDayForecast> createState() => _FiveDayForecastState();
}

class _FiveDayForecastState extends State<FiveDayForecast> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHERFIVEDAYS_API_KEY);
  late List<Weather?> _weather = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      _wf.fiveDayForecastByCityName(widget.city).then((w) {
        setState(() {
          _weather = w;
        });
      });
    } catch (e) {
      Center(
        child: Text("Wait your data is loading.."),
      );
    }
  }

  void fetchWeatherData(String cityName) {
    try {
      _wf.fiveDayForecastByCityName(cityName).then((w) {
        setState(() {
          _weather = w;
        });
      });
    } catch (e) {
      Center(
        child: Text("Wait your data is loading.."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("5 Days weather data"),
      ),
      body: data(),
    );
  }

  Widget data() {
    if (_weather.isEmpty) {
      const Center(
        child: Text("Wait your data is loading.."),
      );
    }
    return _buildUi();
  }

  Widget _buildUi() {
    if (_weather.isEmpty) {
      const Center(
        child: Text("Wait your data is loading.."),
      );
    }
    return ListView.builder(
        itemCount: _weather.length,
        itemBuilder: (context, index) {
          var Data = _weather[index];
          DateTime now = Data!.date!;
          return _weather.isEmpty
              ? const CircularProgressIndicator()
              : ListTile(
                  title: Text(Data.areaName.toString()),
                  subtitle: Text(DateFormat("EEEE").format(now).toString() +
                      " at " +
                      DateFormat(" h:mm a ").format(now) +
                      Data.weatherDescription.toString()),
                  trailing: Image.network(
                      "https://openweathermap.org/img/wn/${Data.weatherIcon}@4x.png"),
                );
        });
  }
}
