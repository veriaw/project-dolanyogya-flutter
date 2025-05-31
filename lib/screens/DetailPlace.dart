import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_tpm/models/place.dart';
import 'package:project_tpm/services/route_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPlace extends StatefulWidget {
  final PlaceModel place;
  const DetailPlace({super.key, required this.place});

  @override
  State<DetailPlace> createState() => _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> {
  LatLng? currentPosition;
  List<LatLng>? routePlace;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();
    routePlace = await getRoute(LatLng(position.latitude, position.longitude),
        LatLng(widget.place.latitude, widget.place.longitude));
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> openGoogleMapsRoute(
      double startLat, double startLng, double endLat, double endLng) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng&travelmode=driving',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  Future<List<LatLng>> getRoute(
      LatLng currentPostition, LatLng placePosition) async {
    final route = await getRoutePolyline(
        startLat: currentPostition.latitude,
        startLng: currentPostition.longitude,
        endLat: placePosition.latitude,
        endLng: placePosition.longitude);
    return route;
  }

  LatLng midpoint(LatLng point1, LatLng point2) {
    return LatLng(
      (point1.latitude + point2.latitude) / 2,
      (point1.longitude + point2.longitude) / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Place"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.bookmark_border))
        ],
      ),
      body: Column(
        children: [
          // Bagian gambar
          Image.network(
            widget.place.pictureUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          // Card naik ke atas gambar
          Transform.translate(
              offset: Offset(0, -20), // Naik 40px
              child: Column(
                children: [
                  DefaultTabController(
                    length: 2,
                    child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const TabBar(
                                labelColor: Colors.green,
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(text: "Overview"),
                                  Tab(text: "Maps Location"),
                                ]),
                            SizedBox(
                                height: 470,
                                child: TabBarView(children: [
                                  //Tab Overview
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.place.placeName,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 8),
                                          Text(widget.place.city),
                                          SizedBox(height: 8),
                                          Text(
                                            "Harga Tiket: ${widget.place.price.toString()}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            widget.place.description,
                                            textAlign: TextAlign.justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //Tab Maps Location
                                  Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 414,
                                            child: currentPosition == null
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : FlutterMap(
                                                    options: MapOptions(
                                                      initialCenter: midpoint(
                                                          currentPosition!,
                                                          LatLng(
                                                              widget.place
                                                                  .latitude,
                                                              widget.place
                                                                  .longitude)),
                                                      initialZoom: 13,
                                                    ),
                                                    children: [
                                                      TileLayer(
                                                        urlTemplate:
                                                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                        subdomains: [
                                                          'a',
                                                          'b',
                                                          'c'
                                                        ],
                                                        userAgentPackageName:
                                                            'com.example.app',
                                                      ),
                                                      PolylineLayer<Object>(
                                                          polylines:
                                                              routePlace != null
                                                                  ? [
                                                                      Polyline<
                                                                          Object>(
                                                                        points:
                                                                            routePlace!,
                                                                        strokeWidth:
                                                                            4.0,
                                                                        color: Colors
                                                                            .blue,
                                                                      )
                                                                    ]
                                                                  : []),
                                                      MarkerLayer(
                                                        markers: [
                                                          // Marker untuk tempat (place)
                                                          Marker(
                                                            point: LatLng(
                                                                widget.place
                                                                    .latitude,
                                                                widget.place
                                                                    .longitude),
                                                            width: 60,
                                                            height: 60,
                                                            child: Icon(
                                                                Icons
                                                                    .location_on,
                                                                color:
                                                                    Colors.red,
                                                                size: 40),
                                                          ),
                                                          // Marker untuk lokasi pengguna
                                                          Marker(
                                                            point:
                                                                currentPosition!,
                                                            width: 60,
                                                            height: 60,
                                                            child: Icon(
                                                                Icons
                                                                    .person_pin_circle,
                                                                color:
                                                                    Colors.blue,
                                                                size: 40),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .green, // Warna tombol
                                                  foregroundColor: Colors
                                                      .white, // Warna teks
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  elevation: 4,
                                                ),
                                                onPressed: () => {
                                                      if (currentPosition !=
                                                          null)
                                                        {
                                                          openGoogleMapsRoute(
                                                            currentPosition!
                                                                .latitude,
                                                            currentPosition!
                                                                .longitude,
                                                            widget
                                                                .place.latitude,
                                                            widget.place
                                                                .longitude,
                                                          )
                                                        }
                                                    },
                                                child: Text("Live Routing")),
                                          )
                                        ],
                                      ))
                                ]))
                          ],
                        )),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
