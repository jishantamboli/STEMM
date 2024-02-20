import 'package:flutter/material.dart';

class Addtolist extends StatefulWidget {
  final List<String> myList;
  final List<String> mytempList;
  const Addtolist({super.key, required this.myList, required this.mytempList});

  @override
  State<Addtolist> createState() => _AddtolistState();
}

class _AddtolistState extends State<Addtolist> {
  // final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _wf.currentWeatherByCityName(widget.myList.toString()).then((w) {
  //     setState(() {
  //       _weather = w;
  //       fetchWeatherData(widget.myList.toString());
  //     });
  //   });
  // }

  // void fetchWeatherData(String cityname) {
  //   _wf.currentWeatherByCityName(cityname).then((w) {
  //     setState(() {
  //       _weather = w;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<String> weatherForecast = widget.myList;
    return Scaffold(
      body: ListView.builder(
        itemCount: weatherForecast.length,
        itemBuilder: (BuildContext context, int index) {
          List<String> temp = widget.mytempList;
          return ListTile(
            title: Text(weatherForecast[index]),
            subtitle: Text(
              temp[index],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            trailing: InkWell(
                onTap: () {
                  setState(() {
                    temp.remove(temp[index]);
                    weatherForecast.remove(weatherForecast[index]);
                  });
                },
                child: Icon(Icons.delete)),
          );
        },
      ),
    );
  }
}
