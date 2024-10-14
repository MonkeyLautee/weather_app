import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/helper.dart';
import '../services/hive_helper.dart';
import '../services/weather_api.dart';
import '../models/weather.dart';
import 'history.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final double _standardZoom = 14.0;
  final MapController _map = MapController();

  void _getWeatherOfCurrentLocation()async{
    latLng.LatLng coords = _map.camera.center;
    // Check if data is in cache
    List<Weather> weathers = getSavedWeathers();
    int? cacheIndex;
    for(int i=0; i < weathers.length; i++){
      double distance = Geolocator.distanceBetween(
        coords.latitude,
        coords.longitude,
        weathers[i].latitude,
        weathers[i].longitude,
      );
      final DateTime now = DateTime.now();
      DateTime weatherDate = DateTime.fromMillisecondsSinceEpoch(weathers[i].date);
      int distanceInTime = now.difference(weatherDate).inMinutes;
      if(distanceInTime < 60 && distance < 32168.88){
        cacheIndex = i;
        break;
      }
    }
    if(cacheIndex!=null){
      Weather weather = weathers[cacheIndex];
      await alert(context,'Weather:\n${weather.type}');
      return;
    }
    doLoad(context);
    try {
      Weather? weather = await WeatherAPI.getWeatherFromCoordinates(
        coords.latitude,
        coords.longitude,
      );
      if(weather==null)throw 'Null weather';
      await saveWeatherInCache(weather);
      await alert(context,'Weather:\n${weather.type}');
      return;
    } catch(e) {
      await alert(context,'An error happened');
    } finally {
      Navigator.pop(context);
    }
  }

  void _searchLocationByString()async{
    String? address = await prompt(context,text:'Address:');
    if(address==null)return;
    latLng.LatLng? coordinates = await _turnAdressIntoCoordinates(address);
    if(coordinates==null)return;
    _map.move(coordinates,_standardZoom);
  }

  Future<latLng.LatLng?> _turnAdressIntoCoordinates(String address)async{
    List<Location> locations = await locationFromAddress(address);
    if(locations.isEmpty)return null;
    return latLng.LatLng(locations.first.latitude,locations.first.longitude);
  }

  Future<void> _centerInMyLocation()async{
    doLoad(context);
    try{
      latLng.LatLng? coordinates = await _getCurrentLocation();
      if(coordinates==null)return;
      _map.move(coordinates,_standardZoom);
    } catch(e) {
      await alert(context,'Ocurrió un error');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<latLng.LatLng?> _getCurrentLocation() async {
    if (await Permission.location.request().isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return latLng.LatLng(position.latitude,position.longitude);
    } else {
      alert(context,'Permission is not granted');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Weather app'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: ()=>launchUrl(Uri.parse('https://monkey-lautee.web.app')),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchLocationByString,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerInMyLocation,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: ()=>goTo(context, const History()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getWeatherOfCurrentLocation,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.cloudy_snowing,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      body: FlutterMap(
        mapController: _map,
        options: MapOptions(
          initialCenter: const latLng.LatLng(40.71, -74.00),
          initialZoom: _standardZoom,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a','b','c'],
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
              size: 55,
            ),
          ),
        ],
      ),
    );
  }
}