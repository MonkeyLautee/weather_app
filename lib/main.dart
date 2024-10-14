import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive code
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox<Map>('weathers');
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather app',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(13,186,242,1),
        colorScheme: const ColorScheme(
          primary: Color.fromRGBO(13,186,242,1),
          onPrimary: Colors.white,
          secondary: Color.fromRGBO(253,154,35,1),
          onSecondary: Colors.white,
          brightness: Brightness.light,
          error: Colors.red,
          onError: Colors.white,
          surface: Color.fromRGBO(223,236,238,1),
          onSurface: Colors.black,
        ),
        textTheme:const TextTheme(
          headlineMedium:TextStyle(
            color:Colors.black,
            fontWeight:FontWeight.bold,
            fontSize:18.0,
          ),
          bodyMedium:TextStyle(
            color:Colors.black,
            fontSize:15.0,
          ),
        ),
      ),
      home: const Home(),
    );
  }
}