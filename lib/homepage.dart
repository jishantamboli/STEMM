import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/const.dart';
import 'package:weather_app/fivedayforecast.dart';
import 'package:weather_app/list.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  int err = WeatherFactory.STATUS_OK;
  Weather? _weather;
  TextEditingController search = TextEditingController();
  String cityName = 'Pune';
  String city = 'Pune';
  List<String> weatherForecast = [];
  List<String> addtolist = [];
  List<String> addtolisttemp = [];
  // late var _connectivityResult;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  void fetchWeatherData(String cityName) {
    try {
      _wf.currentWeatherByCityName(cityName).then((w) {
        setState(() {
          _weather = w;
        });
      });
    } catch (e) {
      const Center(
        child: Text("Something went wrong.."),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      _wf.currentWeatherByCityName(cityName).then((w) {
        setState(() {
          // _checkConnectivity();
          _weather = w;
        });
      });
    } catch (e) {
     const Center(
        child: Text("Something went wrong.."),
      );
    }
  }

  _showNetworkDialog() async {
    return showDialog<void>(
      context: context,

      barrierDismissible: false, // Dismiss dialog on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('No Internet Connection'),
          content:const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please check your internet connection and try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.hasData) {
            ConnectivityResult? result = snapshot.data;
            if (result == ConnectivityResult.mobile ||
                result == ConnectivityResult.wifi) {
              return forecast();
            } else {
              return _showNetworkDialog();
            }
          } else {
            return const Center(child: Text("Wait your data is loading.."));
          }
        },
      ),
    );
  }

  Widget forecast() {
    return _buildUi();
  }

  Widget _buildUi() {
    if (_weather == null) {
      return const Center(
        child: Text("Wait your data is loading.."),
      );
    } 
    return SingleChildScrollView(
      child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.08,
                ),
                _searchbox(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    fetchWeatherData(search.text);
                    city = search.text;
                    search.clear();
                  },
                  child: const Text('Get Weather'),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                _locationheader(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.0,
                ),
                // _dateTimeInfo(),
                // SizedBox(
                //   height: MediaQuery.sizeOf(context).height * 0.05,
                // ),
                _weatherIcon(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                _currentTemp(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                _extraInfo(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.04,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FiveDayForecast(
                                      city: city,
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.50,
                        height: 50,
                        color: Colors.white,
                        child: const Center(
                            child: Text(
                          "5 Days forecast",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          addtolist.add(cityName);
                          addtolisttemp.add(_weather!.temperature.toString());
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Addtolist(
                                      myList: addtolist,
                                      mytempList: addtolisttemp,
                                    )));
                        fetchWeatherData(addtolist.toString());
                      },
                      child: Container(
                        color: Colors.deepPurpleAccent,
                        width: MediaQuery.sizeOf(context).width * 0.50,
                        height: 50,
                        child: const Center(
                            child: Text(
                          "Add to list",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        )),
                      ),
                    )
                  ],
                )
              ])),
    );
  }

  Widget _locationheader() {
    return Text(
      city,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              " ${DateFormat("d-MM-y").format(now)} ",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }

  Widget _searchbox() {
    return  Container(
      height: 50,
      width: MediaQuery.sizeOf(context).width * 0.90,
      child: TextField(
        controller: search,
        onChanged: (value) {
          setState(() {
            cityName = value;
          });
        },
        autofocus: false,
        decoration: InputDecoration(
            hintText: "Search here..",
            contentPadding: EdgeInsets.only(left: 16),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(24))),
      ),
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}\u2103",
      style: const TextStyle(
          color: Colors.black, fontSize: 90, fontWeight: FontWeight.w500),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max : ${_weather?.tempMax?.celsius?.toStringAsFixed(0)} \u2103",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Min : ${_weather?.tempMin?.celsius?.toStringAsFixed(0)} \u2103",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind : ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Humidity : ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
