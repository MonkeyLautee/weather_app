import 'package:flutter/material.dart';
import '../services/helper.dart';
import '../services/hive_helper.dart';
import '../models/weather.dart';

class History extends StatefulWidget {
  const History({super.key});
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

	List<Weather> _savedWeathers = [];

  @override
  void initState() {
    super.initState();
    _savedWeathers = getSavedWeathers();
  }

  Future<void> _clearCache()async{
  	bool? answer = await confirm(context, 'Clear cache?');
  	if(answer == true){
  		doLoad(context);
  		try {
  			await deleteWeathers();
  			await alert(context, 'Cache was successfuly deleted');
  			Navigator.pop(context);
  			Navigator.pop(context);
  		} catch(e) {
  			await alert(context,'An error happened');
  			Navigator.pop(context);
  		}
  	}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    	backgroundColor:Theme.of(context).colorScheme.surface,
    	appBar: AppBar(
    		title: Text('Cache'),
    		actions: [
    			IconButton(
    				icon: Icon(Icons.delete_forever),
    				onPressed: _clearCache,
    			),
    		],
    	),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
        	Text(
        		'My cache',
        		style: TextStyle(
        			fontWeight: FontWeight.bold,
        			fontSize: 19.0,
        			color: Theme.of(context).primaryColor,
        		),
        		textAlign: TextAlign.center,
        	),
        	const SizedBox(height: 16.0),
        	..._savedWeathers.map<Widget>((Weather weather)=>Card(
        		elevation: 4.7,
        		color: Theme.of(context).colorScheme.surface,
        		child: ListTile(
        			leading: Icon(
        				Icons.cloudy_snowing,
        				color: Theme.of(context).colorScheme.secondary,
        			),
        			title: Text(weather.type),
        			subtitle: Text(DateTime.fromMillisecondsSinceEpoch(weather.date).toString()),
        		),
        	)),
        	const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}