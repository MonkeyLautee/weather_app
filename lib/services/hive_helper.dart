import 'package:hive/hive.dart';
import '../models/weather.dart';

final Box<Map> weathers = Hive.box<Map>('weathers');

List<Weather> getSavedWeathers(){
	return weathers.values.map<Weather>((Map map)=>Weather.fromMap(map)).toList();
}

Future<void> saveWeatherInCache(Weather weather)async{
	await weathers.add(weather.toMap());
}

Future<void> deleteWeathers()async{
	await weathers.clear();
}