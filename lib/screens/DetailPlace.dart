import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_tpm/models/place.dart';
import 'package:project_tpm/models/place_hivi.dart';
import 'package:project_tpm/services/bookmark_service.dart';
import 'package:project_tpm/services/route_service.dart';
import 'package:project_tpm/shared/color_palette.dart';
import 'package:project_tpm/utils/user_manager.dart';
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
  bool _isBookmarked = false;
  final userManager = UserProfileManager();
  String username = "";
  String gender = "";
  DateTime? birthOfDate;
  int? id;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initData();
    _checkBookmarkStatus();
  }

  void _initData() async {

  final profile = await userManager.getUserProfile();
  if (profile != null) {
    setState(() {
      id = profile['id'];           // key yang benar sesuai map dari UserProfileManager
      username = profile['username'];
      birthOfDate = profile['birthdate'];
      gender = profile['gender'];
    });
  }
}

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();
    routePlace = await getRoute(LatLng(position.latitude, position.longitude),
        LatLng(widget.place.latitude, widget.place.longitude));
        if (!mounted) return;
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

  void _checkBookmarkStatus() async {
    bool status = await BookmarkService.isBookmarked(widget.place.id);
    setState(() {
      _isBookmarked = status;
    });
  }

  void _toggleBookmark(PlaceModel place) async {
    if (_isBookmarked) {
      await BookmarkService.removeBookmark(widget.place.id);
    } else {
      await BookmarkService.addBookmark(
        HiviModel(id: place.id, placeName: place.placeName, description: place.description, category: place.category, city: place.city, price: place.price, ratingAvg: place.ratingAvg, pictureUrl: place.pictureUrl, latitude: place.latitude, longitude: place.longitude, userId: id! )
      );
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final availableHeight = mediaHeight - kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Place"),
        backgroundColor: secondaryColor,
        actions: [
          IconButton(onPressed: () {
            if (widget.place != null) {
                  _toggleBookmark(widget.place);
                }
          }, icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border)),
        ],
      ),
      body: Column(
        children: [
          Image.network(
            widget.place.pictureUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          // Gunakan Expanded agar card tidak overflow
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "Overview"),
                          Tab(text: "Maps Location"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Overview tab
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.place.placeName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text(widget.place.city),
                                  SizedBox(height: 8),
                                  Text(
                                    "Harga Tiket: Rp${widget.place.price.toStringAsFixed(0)}",
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

                            // Maps tab
                            Column(
                              children: [
                                Expanded(
                                  child: currentPosition == null
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : FlutterMap(
                                          options: MapOptions(
                                            initialCenter: midpoint(
                                              currentPosition!,
                                              LatLng(widget.place.latitude,
                                                  widget.place.longitude),
                                            ),
                                            initialZoom: 13,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                              subdomains: ['a', 'b', 'c'],
                                              userAgentPackageName:
                                                  'com.example.app',
                                            ),
                                            if (routePlace != null)
                                              PolylineLayer(
                                                polylines: [
                                                  Polyline(
                                                    points: routePlace!,
                                                    strokeWidth: 4.0,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                            MarkerLayer(
                                              markers: [
                                                Marker(
                                                  point: LatLng(
                                                    widget.place.latitude,
                                                    widget.place.longitude,
                                                  ),
                                                  width: 60,
                                                  height: 60,
                                                  child: Icon(Icons.location_on,
                                                      color: Colors.red,
                                                      size: 40),
                                                ),
                                                Marker(
                                                  point: currentPosition!,
                                                  width: 60,
                                                  height: 60,
                                                  child: Icon(
                                                      Icons.person_pin_circle,
                                                      color: Colors.blue,
                                                      size: 40),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (currentPosition != null) {
                                        openGoogleMapsRoute(
                                          currentPosition!.latitude,
                                          currentPosition!.longitude,
                                          widget.place.latitude,
                                          widget.place.longitude,
                                        );
                                      }
                                    },
                                    child: Text("Live Routing"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
