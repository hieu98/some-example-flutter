import 'package:flutter/material.dart';
import 'package:flutter_app/Database/DBWeather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../Model/WeatherModel.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String key = 'c0983de2a29d8bd714ab82986e54354c';
  late WeatherFactory ws;
  List<Weather> _data = [];
  double? lat, lon;

  Position? _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ws = new WeatherFactory(key);
    _getCurrentLocation();
  }

  Future<List<Weather>> queryForecast() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat!, lon!);
    setState(() {
      _data = forecasts;
    });
    return forecasts;
  }

  void queryWeather() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
    });

    Weather weather = await ws.currentWeatherByLocation(lat!, lon!);
    await DBWeather.db.newWeather(Weather1(
        temperature: weather.temperature?.celsius?.toInt(),
        country: weather.country,
        tempFeelsLike: weather.tempFeelsLike?.celsius?.toInt(),
        areaName: weather.areaName,
        date: weather.date.toString(),
        humidity: weather.humidity,
        weatherIcon: weather.weatherIcon,
        weatherMain: weather.weatherMain,
        windSpeed: weather.windSpeed,
        timeNow: DateTime.now().millisecondsSinceEpoch.toDouble()));
    setState(() {
      _data = [weather];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: _data.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    //TODO: Location, time
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 30, left: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _data[0].country == 'VN'
                                ? 'VIET NAM,'
                                : '${_data[0].country},',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            textScaleFactor: 1,
                          ),
                          Text(
                            '${_data[0].areaName}',
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat.MMMEd().format(_data[0].date!),
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    //TODO: Weather
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.blue[300],
                        borderOnForeground: true,
                        elevation: 10,
                        shadowColor: Colors.blueAccent[200],
                        child: Row(
                          children: [
                            //TODO : Icon, weather and session
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 20, bottom: 20, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      'http://openweathermap.org/img/w/${_data[0].weatherIcon}.png',
                                      scale: 0.5,
                                    ),
                                    Text('${_data[0].weatherMain}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            //TODO : Count weather
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 20, bottom: 20, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${_data[0].temperature?.celsius?.toInt()}°',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 70,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'Feels like ${_data[0].tempFeelsLike?.celsius?.toInt()}°',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //TODO: Humidity, WindSpeed
                    Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 50),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //TODO: % rain
                            Column(
                              children: [
                                Card(
                                  color: Colors.grey[100],
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Image.asset(
                                        'assets/rain.png',
                                        height: 50,
                                        width: 50,
                                      )),
                                ),
                                Text(
                                  '28%',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                            //TODO: wind speed
                            Column(
                              children: [
                                Card(
                                  color: Colors.grey[100],
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Image.asset(
                                        'assets/wind.png',
                                        height: 50,
                                        width: 50,
                                      )),
                                ),
                                Text(
                                  '${_data[0].windSpeed} m/s',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                            //TODO: humidity
                            Column(
                              children: [
                                Card(
                                  color: Colors.grey[100],
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Image.asset(
                                        'assets/drop.png',
                                        height: 50,
                                        width: 50,
                                      )),
                                ),
                                Text(
                                  '${_data[0].humidity?.toInt()} %',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        )),
                    //TODO: Forecast
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 80),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                        fontSize: 26, fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      //TODO : go to screen next 7 day
                                    },
                                    child: Text(
                                      'Next 7 Days >',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //TODO: List next
                            Expanded(
                              flex: 4,
                              child: FutureBuilder<List<Weather>>(
                                future: queryForecast(),
                                builder: (context,
                                    AsyncSnapshot<List<Weather>> snapshot) {
                                  if (snapshot.hasData) {
                                    print(snapshot.data);
                                    return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) {
                                          return ItemListView(
                                              weather: snapshot.data![index]);
                                        });
                                  } else {
                                    return Center();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((value) {
      setState(() {
        _currentPosition = value;
        if (_currentPosition != null) {
          lat = _currentPosition!.latitude;
          lon = _currentPosition!.longitude;
          queryWeather();
        }
      });
    }).catchError((e) {
      print(e);
    });
  }
}

class ItemListView extends StatefulWidget {
  final Weather weather;

  const ItemListView({Key? key, required this.weather}) : super(key: key);

  @override
  State<ItemListView> createState() => _ItemListViewState(weather);
}

class _ItemListViewState extends State<ItemListView> {
  final Weather weather;

  _ItemListViewState(this.weather);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.purple[300],
        shadowColor: Colors.grey,
        margin: EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${weather.date?.hour.toString()}:00', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Image.network(
                'http://openweathermap.org/img/w/${weather.weatherIcon}.png'),
            Text('${weather.temperature?.celsius?.toInt()}°', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
