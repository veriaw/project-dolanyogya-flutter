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
import 'package:project_tpm/screens/Cart.dart';

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
  bool _isTicketInCart = false;
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
    _checkCartStatus();
  }

  void _initData() async {
    final profile = await userManager.getUserProfile();
    if (profile != null) {
      setState(() {
        id = profile['id']; // key yang benar sesuai map dari UserProfileManager
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
    routePlace = await getRoute(
        LatLng(position.latitude, position.longitude),
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
          HiviModel(
              id: place.id,
              placeName: place.placeName,
              description: place.description,
              category: place.category,
              city: place.city,
              price: place.price,
              ratingAvg: place.ratingAvg,
              pictureUrl: place.pictureUrl,
              latitude: place.latitude,
              longitude: place.longitude,
              userId: id!
          )
      );
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  // Cek apakah tiket sudah ada di keranjang
  void _checkCartStatus() async {
    final inCart = await CartHelper.isInCart(widget.place.id);
    setState(() {
      _isTicketInCart = inCart;
    });
  }

  // Tambahkan ke keranjang
  void _addToCart() async {
    await CartHelper.addToCart(widget.place);
    setState(() {
      _isTicketInCart = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tiket ditambahkan ke keranjang!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final availableHeight = mediaHeight - kToolbarHeight;

    return Stack(
      children: [
        // ===== Background Decoration =====
        Positioned(
          top: -40,
          left: -60,
          child: Opacity(
            opacity: 0.18,
            child: Image.asset(
              'assets/3.png',
              width: 180,
              height: 180,
            ),
          ),
        ),
        Positioned(
          top: 120,
          right: -40,
          child: Opacity(
            opacity: 0.13,
            child: Image.asset(
              'assets/4.png',
              width: 120,
              height: 120,
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: -30,
          child: Opacity(
            opacity: 0.12,
            child: Image.asset(
              'assets/5.png',
              width: 110,
              height: 110,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -40,
          child: Opacity(
            opacity: 0.13,
            child: Image.asset(
              'assets/6.png',
              width: 120,
              height: 120,
            ),
          ),
        ),
        Positioned(
          top: 320,
          left: 40,
          child: Opacity(
            opacity: 0.10,
            child: Image.asset(
              'assets/7.png',
              width: 90,
              height: 90,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 60,
          child: Opacity(
            opacity: 0.10,
            child: Image.asset(
              'assets/8.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 40,
          child: Opacity(
            opacity: 0.10,
            child: Image.asset(
              'assets/9.png',
              width: 90,
              height: 90,
            ),
          ),
        ),
        // ===== Main Content =====
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("Detail Place"),
            backgroundColor: secondaryColor,
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                tooltip: "Keranjang Tiket",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              // ===== Konten utama detail tempat =====
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar utama
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        widget.place.pictureUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 220,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, size: 60),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.place.placeName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: _isBookmarked ? Colors.orange : Colors.grey,
                              size: 28,
                            ),
                            tooltip: _isBookmarked ? "Hapus dari Bookmark" : "Tambah ke Bookmark",
                            onPressed: () => _toggleBookmark(widget.place),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 18),
                          SizedBox(width: 4),
                          Text(
                            widget.place.city,
                            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.category, color: Colors.blueGrey, size: 18),
                          SizedBox(width: 4),
                          Text(
                            widget.place.category,
                            style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 18),
                          SizedBox(width: 4),
                          Text(
                            widget.place.ratingAvg.toStringAsFixed(1),
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.attach_money, color: Colors.green, size: 18),
                          SizedBox(width: 4),
                          Text(
                            "Rp ${widget.place.price}",
                            style: TextStyle(fontSize: 15, color: Colors.green[700], fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text(
                        widget.place.description,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.shopping_cart),
                              label: Text(_isTicketInCart ? "Tiket sudah di keranjang" : "Beli Tiket"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isTicketInCart ? Colors.grey : Colors.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onPressed: _isTicketInCart ? null : _addToCart,
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: Icon(Icons.directions),
                            label: Text("Arahkan"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            ),
                            onPressed: currentPosition == null
                                ? null
                                : () => openGoogleMapsRoute(
                                      currentPosition!.latitude,
                                      currentPosition!.longitude,
                                      widget.place.latitude,
                                      widget.place.longitude,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    // Peta lokasi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Lokasi di Peta",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(widget.place.latitude, widget.place.longitude),
                              initialZoom: 14,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(widget.place.latitude, widget.place.longitude),
                                    width: 50,
                                    height: 50,
                                    child: Icon(Icons.location_on, color: Colors.red, size: 36),
                                  ),
                                  if (currentPosition != null)
                                    Marker(
                                      point: currentPosition!,
                                      width: 50,
                                      height: 50,
                                      child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 36),
                                    ),
                                ],
                              ),
                              if (routePlace != null && routePlace!.isNotEmpty)
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                      points: routePlace!,
                                      color: Colors.blue,
                                      strokeWidth: 4,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
