import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  final String restaurantId;
  final List<Map<String, dynamic>> outlets;

  const MapPage({Key? key, required this.restaurantId, required this.outlets})
      : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLocation;
  LatLng? _selectedOutletLocation;
  Set<Marker> listMarkers = {};
  final Set<Polyline> _polylines = {};
  String? _selectedOutletId;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 14.0));

    _createMarkers();
  }

  void _createMarkers() {
    setState(() {
      listMarkers.clear();
      if (_currentLocation != null) {
        listMarkers.add(
          Marker(
            markerId: const MarkerId("user_location"),
            position: _currentLocation!,
            infoWindow: const InfoWindow(title: "Your Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }

      for (var outlet in widget.outlets) {
        try {
          final location = LatLng(
            double.parse(outlet['lat'].toString()),
            double.parse(outlet['lon'].toString()),
          );

          listMarkers.add(
            Marker(
              markerId: MarkerId(outlet['id'].toString()),
              position: location,
              infoWindow: InfoWindow(
                title: outlet['restaurantName'].toString(),
                snippet: outlet['address'].toString(),
              ),
            ),
          );
        } catch (e) {
          print("Error creating marker: $e for outlet: $outlet");
        }
      }
    });
  }

  void _onOutletSelected(String? outletId) {
    if (outletId == null) return;

    setState(() {
      _selectedOutletId = outletId;
      final selectedOutlet = widget.outlets.firstWhere((outlet) => outlet['id'] == outletId);
      _selectedOutletLocation = LatLng(
        double.parse(selectedOutlet['lat'].toString()),
        double.parse(selectedOutlet['lon'].toString()),
      );
      _moveCameraToLocation(_selectedOutletLocation!);
      _drawRoute();
    });
  }

  void _moveCameraToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(location, 14.0));
  }

  Future<void> _drawRoute() async {
    if (_currentLocation == null || _selectedOutletLocation == null) return;

    const String apiKey = "AIzaSyDI74kcJ9VbuKyl7M-gaOnPJvnUGnRq1p8"; 
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${_selectedOutletLocation!.latitude},${_selectedOutletLocation!.longitude}&mode=driving&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        List<LatLng> polylineCoordinates = _decodePolyline(data['routes'][0]['overview_polyline']['points']);

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    } else {
      print("Failed to fetch route: ${response.reasonPhrase}");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int shift = 0, result = 0, byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polylineCoordinates;
  }

  @override
  Widget build(BuildContext context) {
    String restaurantName = widget.outlets.isNotEmpty
        ? widget.outlets.first['restaurantName'] ?? 'Unknown Restaurant'
        : 'Restaurant';
        
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$restaurantName Outlets",
          style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 222, 173),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text("Select an outlet"),
            value: _selectedOutletId,
            onChanged: _onOutletSelected,
            items: widget.outlets.map((outlet) => DropdownMenuItem(
              value: outlet['id'].toString(),
              child: Text(outlet['address'].toString()),
            )).toList(),
          ),
          Expanded(
            child: GoogleMap(
              markers: listMarkers,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(target: _currentLocation ?? LatLng(1.3521, 103.8198), zoom: 14.0),
              onMapCreated: (controller) => _controller.complete(controller),
            ),
          ),
        ],
      ),
    );
  }
}
