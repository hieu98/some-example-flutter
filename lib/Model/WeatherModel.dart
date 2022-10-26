import 'dart:convert';


Weather1 weatherFromJson(String str){
  final jsonData = json.decode(str);
  return Weather1.fromMap(jsonData);
}

String weatherToJson(Weather1 data){
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Weather1 {
  int? id;
  int? temperature;
  int? tempFeelsLike;
  String? country;
  String? areaName;
  String? date;
  String? weatherIcon;
  String? weatherMain;
  double? windSpeed;
  double? humidity;
  double? timeNow;

  Weather1({
    this.id,
    this.temperature,
    this.country,
    this.tempFeelsLike,
    this.areaName,
    this.date,
    this.weatherIcon,
    this.weatherMain,
    this.windSpeed,
    this.humidity,
    this.timeNow
  });

  factory Weather1.fromMap(Map<String, dynamic> json) => Weather1(
      id: json['id'],
      temperature: json['temperature'],
      tempFeelsLike: json['temp_feels_like'],
      country: json['country'],
      areaName: json['area_name'],
      date: json['date'],
      weatherIcon: json['weather_icon'],
      weatherMain: json['weather_main'],
      windSpeed: json['wind_speed'],
      humidity: json['humidity'],
      timeNow: json['time_now']
  );

  Map<String, dynamic> toMap() => {
    'id' : id,
    'temperature': temperature,
    'temp_feels_like' : tempFeelsLike,
    'country' : country,
    'area_name': areaName,
    'date' : date,
    'weather_icon' : weatherIcon,
    'weather_main': weatherMain,
    'wind_speed' : windSpeed,
    'humidity' : humidity,
    'time_now' : timeNow
  };
}