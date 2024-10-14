class Weather {
  
  final double latitude;
  final double longitude;
  final int date;
  final String type;

  const Weather({
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.type,
  });

  static Weather fromMap(Map map)=>Weather(
    latitude: map['latitude'],
    longitude: map['longitude'],
    date: map['date'],
    type: map['type'],
  );

  Map toMap(){
    return <String,dynamic>{
      'latitude': this.latitude,
      'longitude': this.longitude,
      'date': this.date,
      'type': this.type,
    };
  }

}