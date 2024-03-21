import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/storage/prefs.dart';
import 'screen/map_view.dart';
import 'viewmodel/map_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: MaterialApp(
        title: 'Location App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MapView(),
      ),
    );
  }
}
