import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../viewmodel/map_view_model.dart';

class MapView extends StatelessWidget {
  final TextEditingController ipController = TextEditingController();

  MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: Column(children: [
        TextField(
          controller: ipController,
          decoration: const InputDecoration(
            hintText: 'Enter IP address',
            contentPadding: EdgeInsets.all(10.0),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            mapViewModel.loadLocation(ipController.text);
          },
          child: const Text('Get Location'),
        ),
        if (mapViewModel.currentLocation != null)
          Expanded(
              child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                mapViewModel.currentLocation!.latitude,
                mapViewModel.currentLocation!.longitude,
              ),
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(
                      mapViewModel.currentLocation!.latitude,
                      mapViewModel.currentLocation!.longitude,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
            ],
          )),

      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mapViewModel.loadLocation(),
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
